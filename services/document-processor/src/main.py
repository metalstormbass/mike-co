"""
Document Processing Service
Handles document parsing, chunking, and indexing pipeline
"""

from fastapi import FastAPI, UploadFile, File, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
import asyncio
import aiohttp
import os
import uuid
import json
from datetime import datetime

# Database clients
import asyncpg
from opensearchpy import AsyncOpenSearch

# Local modules
from src.parsers.document_parser import get_parser, supported_extensions
from src.chunkers.text_chunker import get_chunker

app = FastAPI(
    title="Document Processor",
    description="Parse, chunk, and index documents for RAG"
)

# Configuration from environment
EMBEDDING_SERVICE_URL = os.getenv("EMBEDDING_SERVICE_URL", "http://embedding-service:8000")
OPENSEARCH_URL = os.getenv("OPENSEARCH_URL", "http://opensearch:9200")
POSTGRES_URL = os.getenv("POSTGRES_URL", "postgresql://rag:rag@postgresql:5432/rag")
REDIS_URL = os.getenv("REDIS_URL", "redis://redis:6379")

# Parse OpenSearch URL
opensearch_host = OPENSEARCH_URL.replace("http://", "").replace("https://", "")
opensearch_parts = opensearch_host.split(":")
OPENSEARCH_HOST = opensearch_parts[0]
OPENSEARCH_PORT = int(opensearch_parts[1]) if len(opensearch_parts) > 1 else 9200

# Global clients (initialized on startup)
pg_pool = None
opensearch_client = None


class ProcessRequest(BaseModel):
    """Request to process a document by ID"""
    document_id: str
    chunk_size: int = 1000
    chunk_overlap: int = 200


class ProcessResponse(BaseModel):
    """Response from document processing"""
    document_id: str
    status: str
    chunks_created: int = 0
    message: Optional[str] = None


class DocumentStatus(BaseModel):
    """Document processing status"""
    document_id: str
    filename: str
    status: str
    chunk_count: int
    error_message: Optional[str] = None
    created_at: str
    processed_at: Optional[str] = None


@app.on_event("startup")
async def startup():
    """Initialize database connections"""
    global pg_pool, opensearch_client
    
    # Initialize PostgreSQL connection pool
    try:
        # Parse postgres URL
        pg_url = POSTGRES_URL.replace("postgresql://", "")
        user_pass, host_db = pg_url.split("@")
        user, password = user_pass.split(":")
        host_port, db = host_db.split("/")
        host = host_port.split(":")[0]
        port = int(host_port.split(":")[1]) if ":" in host_port else 5432
        
        pg_pool = await asyncpg.create_pool(
            user=user,
            password=password,
            database=db,
            host=host,
            port=port,
            min_size=2,
            max_size=10
        )
        print(f"Connected to PostgreSQL at {host}:{port}")
    except Exception as e:
        print(f"Warning: Could not connect to PostgreSQL: {e}")
    
    # Initialize OpenSearch client
    try:
        opensearch_client = AsyncOpenSearch(
            hosts=[{"host": OPENSEARCH_HOST, "port": OPENSEARCH_PORT}],
            http_compress=True,
            use_ssl=False,
            verify_certs=False,
            ssl_show_warn=False
        )
        # Test connection
        info = await opensearch_client.info()
        print(f"Connected to OpenSearch: {info.get('cluster_name', 'unknown')}")

        # Ensure documents index exists with proper k-NN mapping
        await ensure_documents_index()
    except Exception as e:
        print(f"Warning: Could not connect to OpenSearch: {e}")


async def ensure_documents_index():
    """Ensure the documents index exists with proper k-NN vector mapping"""
    if not opensearch_client:
        return

    try:
        # Check if index exists
        exists = await opensearch_client.indices.exists(index="documents")

        if not exists:
            print("Creating 'documents' index with k-NN vector mapping...")
            index_body = {
                "settings": {
                    "index": {
                        "knn": True,
                        "knn.space_type": "cosinesimil"
                    }
                },
                "mappings": {
                    "properties": {
                        "document_id": {"type": "keyword"},
                        "chunk_id": {"type": "keyword"},
                        "chunk_index": {"type": "integer"},
                        "content": {"type": "text"},
                        "embedding": {
                            "type": "knn_vector",
                            "dimension": 384,
                            "method": {
                                "name": "hnsw",
                                "space_type": "cosinesimil",
                                "engine": "nmslib"
                            }
                        },
                        "metadata": {"type": "object"},
                        "created_at": {"type": "date"}
                    }
                }
            }
            await opensearch_client.indices.create(index="documents", body=index_body)
            print("Successfully created 'documents' index")
        else:
            print("Documents index already exists")
    except Exception as e:
        print(f"Warning: Could not create documents index: {e}")


@app.on_event("shutdown")
async def shutdown():
    """Close database connections"""
    global pg_pool, opensearch_client

    if pg_pool:
        await pg_pool.close()
    if opensearch_client:
        await opensearch_client.close()


@app.get("/health")
async def health():
    """Health check endpoint"""
    health_status = {
        "status": "healthy",
        "postgresql": "unknown",
        "opensearch": "unknown"
    }
    
    # Check PostgreSQL
    if pg_pool:
        try:
            async with pg_pool.acquire() as conn:
                await conn.fetchval("SELECT 1")
            health_status["postgresql"] = "connected"
        except:
            health_status["postgresql"] = "disconnected"
            health_status["status"] = "degraded"
    
    # Check OpenSearch
    if opensearch_client:
        try:
            await opensearch_client.ping()
            health_status["opensearch"] = "connected"
        except:
            health_status["opensearch"] = "disconnected"
            health_status["status"] = "degraded"
    
    return health_status


@app.get("/supported-formats")
async def get_supported_formats():
    """Get list of supported document formats"""
    return {
        "extensions": supported_extensions(),
        "mime_types": [
            "text/plain",
            "text/markdown",
            "application/pdf",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "text/html"
        ]
    }


@app.post("/process", response_model=ProcessResponse)
async def process_document(
    file: UploadFile = File(...),
    background_tasks: BackgroundTasks = None,
    chunk_size: int = 1000,
    chunk_overlap: int = 200
):
    """
    Process uploaded document through the pipeline:
    1. Parse document
    2. Chunk text
    3. Generate embeddings
    4. Index in OpenSearch
    5. Store metadata in PostgreSQL
    """
    # Validate file type
    parser = get_parser(file.filename)
    if not parser:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported file type. Supported: {supported_extensions()}"
        )
    
    # Read file content
    content = await file.read()
    file_size = len(content)
    
    # Generate document ID
    document_id = str(uuid.uuid4())
    
    # Determine file type
    ext = os.path.splitext(file.filename)[1].lower()
    mime_type = file.content_type or "application/octet-stream"
    
    # Create document record in PostgreSQL
    if pg_pool:
        try:
            async with pg_pool.acquire() as conn:
                await conn.execute("""
                    INSERT INTO documents (id, filename, original_filename, file_type, file_size, mime_type, status)
                    VALUES ($1, $2, $3, $4, $5, $6, 'processing')
                """, uuid.UUID(document_id), document_id + ext, file.filename, ext, file_size, mime_type)
        except Exception as e:
            print(f"Error creating document record: {e}")
    
    # Process document
    try:
        # Step 1: Parse document
        print(f"Parsing document: {file.filename}")
        parsed = await parser.parse(content, file.filename)
        text = parsed["text"]
        doc_metadata = parsed.get("metadata", {})
        
        if not text or not text.strip():
            raise HTTPException(status_code=400, detail="Document contains no extractable text")
        
        # Step 2: Chunk text
        print(f"Chunking document: {len(text)} characters")
        chunker = get_chunker("recursive", chunk_size=chunk_size, chunk_overlap=chunk_overlap)
        chunks = chunker.chunk(text, metadata={"filename": file.filename, **doc_metadata})
        
        if not chunks:
            raise HTTPException(status_code=400, detail="Document could not be chunked")
        
        print(f"Created {len(chunks)} chunks")
        
        # Step 3: Generate embeddings (batch)
        print("Generating embeddings...")
        chunk_texts = [c.content for c in chunks]
        embeddings = await get_embeddings_batch(chunk_texts)
        
        if len(embeddings) != len(chunks):
            raise HTTPException(status_code=500, detail="Embedding count mismatch")
        
        # Step 4: Index in OpenSearch
        print("Indexing in OpenSearch...")
        indexed_count = 0
        for i, (chunk, embedding) in enumerate(zip(chunks, embeddings)):
            chunk_id = f"{document_id}_{i}"
            
            doc = {
                "document_id": document_id,
                "chunk_id": chunk_id,
                "chunk_index": i,
                "content": chunk.content,
                "embedding": embedding,
                "metadata": {
                    "filename": file.filename,
                    "file_type": ext,
                    **chunk.metadata
                },
                "created_at": datetime.utcnow().isoformat()
            }
            
            try:
                await opensearch_client.index(
                    index="documents",
                    id=chunk_id,
                    body=doc,
                    refresh=True  # Make immediately searchable
                )
                indexed_count += 1
                
                # Store chunk reference in PostgreSQL
                if pg_pool:
                    async with pg_pool.acquire() as conn:
                        await conn.execute("""
                            INSERT INTO document_chunks (document_id, chunk_index, content, char_start, char_end, opensearch_id)
                            VALUES ($1, $2, $3, $4, $5, $6)
                        """, uuid.UUID(document_id), i, chunk.content, chunk.char_start, chunk.char_end, chunk_id)
                
            except Exception as e:
                print(f"Error indexing chunk {i}: {e}")
        
        # Step 5: Update document status
        if pg_pool:
            async with pg_pool.acquire() as conn:
                await conn.execute("""
                    UPDATE documents 
                    SET status = 'indexed', chunk_count = $2, processed_at = NOW()
                    WHERE id = $1
                """, uuid.UUID(document_id), indexed_count)
        
        print(f"Successfully indexed {indexed_count} chunks for document {document_id}")
        
        return ProcessResponse(
            document_id=document_id,
            status="indexed",
            chunks_created=indexed_count,
            message=f"Successfully processed and indexed {file.filename}"
        )
        
    except HTTPException:
        raise
    except Exception as e:
        # Update document status on error
        if pg_pool:
            try:
                async with pg_pool.acquire() as conn:
                    await conn.execute("""
                        UPDATE documents 
                        SET status = 'error', error_message = $2
                        WHERE id = $1
                    """, uuid.UUID(document_id), str(e))
            except:
                pass
        
        print(f"Error processing document: {e}")
        raise HTTPException(status_code=500, detail=f"Processing failed: {str(e)}")


async def get_embeddings_batch(texts: List[str]) -> List[List[float]]:
    """Get embeddings for multiple texts from embedding service"""
    async with aiohttp.ClientSession() as session:
        try:
            async with session.post(
                f"{EMBEDDING_SERVICE_URL}/embed/batch",
                json={"texts": texts},
                timeout=aiohttp.ClientTimeout(total=120)
            ) as response:
                if response.status != 200:
                    error = await response.text()
                    raise Exception(f"Embedding service error: {error}")
                
                data = await response.json()
                return data["embeddings"]
        except aiohttp.ClientError as e:
            raise Exception(f"Could not reach embedding service: {e}")


@app.get("/status/{document_id}", response_model=DocumentStatus)
async def get_document_status(document_id: str):
    """Get processing status for a document"""
    if not pg_pool:
        raise HTTPException(status_code=503, detail="Database not available")
    
    try:
        async with pg_pool.acquire() as conn:
            row = await conn.fetchrow("""
                SELECT id, original_filename, status, chunk_count, error_message, created_at, processed_at
                FROM documents
                WHERE id = $1
            """, uuid.UUID(document_id))
            
            if not row:
                raise HTTPException(status_code=404, detail="Document not found")
            
            return DocumentStatus(
                document_id=str(row["id"]),
                filename=row["original_filename"],
                status=row["status"],
                chunk_count=row["chunk_count"] or 0,
                error_message=row["error_message"],
                created_at=row["created_at"].isoformat() if row["created_at"] else None,
                processed_at=row["processed_at"].isoformat() if row["processed_at"] else None
            )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/document/{document_id}")
async def delete_document(document_id: str):
    """Delete a document and all its chunks"""
    try:
        doc_uuid = uuid.UUID(document_id)
    except:
        raise HTTPException(status_code=400, detail="Invalid document ID")
    
    deleted_chunks = 0
    
    # Delete from OpenSearch
    if opensearch_client:
        try:
            # Delete all chunks for this document
            response = await opensearch_client.delete_by_query(
                index="documents",
                body={
                    "query": {
                        "term": {"document_id": document_id}
                    }
                },
                refresh=True
            )
            deleted_chunks = response.get("deleted", 0)
        except Exception as e:
            print(f"Error deleting from OpenSearch: {e}")
    
    # Delete from PostgreSQL (cascades to chunks)
    if pg_pool:
        try:
            async with pg_pool.acquire() as conn:
                result = await conn.execute("""
                    DELETE FROM documents WHERE id = $1
                """, doc_uuid)
        except Exception as e:
            print(f"Error deleting from PostgreSQL: {e}")
    
    return {
        "document_id": document_id,
        "deleted": True,
        "chunks_removed": deleted_chunks
    }


@app.post("/reindex/{document_id}")
async def reindex_document(document_id: str):
    """Re-index a document that exists in PostgreSQL but not in OpenSearch"""
    try:
        doc_uuid = uuid.UUID(document_id)
    except:
        raise HTTPException(status_code=400, detail="Invalid document ID")

    if not pg_pool or not opensearch_client:
        raise HTTPException(status_code=500, detail="Database connections not available")

    try:
        # Get document metadata from PostgreSQL
        async with pg_pool.acquire() as conn:
            doc_row = await conn.fetchrow("""
                SELECT id, filename, original_filename, file_type
                FROM documents
                WHERE id = $1
            """, doc_uuid)

            if not doc_row:
                raise HTTPException(status_code=404, detail="Document not found")

            # Get all chunks for this document
            chunk_rows = await conn.fetch("""
                SELECT chunk_index, content
                FROM document_chunks
                WHERE document_id = $1
                ORDER BY chunk_index
            """, doc_uuid)

            if not chunk_rows:
                raise HTTPException(status_code=404, detail="No chunks found for document")

        # Generate embeddings for all chunks
        chunk_texts = [row["content"] for row in chunk_rows]
        embeddings = await get_embeddings_batch(chunk_texts)

        if len(embeddings) != len(chunk_rows):
            raise HTTPException(status_code=500, detail="Embedding count mismatch")

        # Index each chunk in OpenSearch
        indexed_count = 0
        for i, (chunk_row, embedding) in enumerate(zip(chunk_rows, embeddings)):
            chunk_id = f"{document_id}_{i}"

            doc = {
                "document_id": document_id,
                "chunk_id": chunk_id,
                "chunk_index": i,
                "content": chunk_row["content"],
                "embedding": embedding,
                "metadata": {
                    "filename": doc_row["original_filename"],
                    "file_type": doc_row["file_type"]
                },
                "created_at": datetime.utcnow().isoformat()
            }

            try:
                await opensearch_client.index(
                    index="documents",
                    id=chunk_id,
                    body=doc,
                    refresh=True
                )
                indexed_count += 1
            except Exception as e:
                print(f"Error indexing chunk {i}: {e}")

        return {
            "document_id": document_id,
            "filename": doc_row["original_filename"],
            "chunks_reindexed": indexed_count,
            "status": "success"
        }

    except HTTPException:
        raise
    except Exception as e:
        print(f"Re-indexing error: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/documents")
async def list_documents(
    status: Optional[str] = None,
    limit: int = 100,
    offset: int = 0
):
    """List all documents with optional status filter"""
    if not pg_pool:
        raise HTTPException(status_code=503, detail="Database not available")
    
    try:
        async with pg_pool.acquire() as conn:
            if status:
                rows = await conn.fetch("""
                    SELECT id, original_filename, file_type, file_size, status, chunk_count, created_at, processed_at
                    FROM documents
                    WHERE status = $1
                    ORDER BY created_at DESC
                    LIMIT $2 OFFSET $3
                """, status, limit, offset)
            else:
                rows = await conn.fetch("""
                    SELECT id, original_filename, file_type, file_size, status, chunk_count, created_at, processed_at
                    FROM documents
                    ORDER BY created_at DESC
                    LIMIT $1 OFFSET $2
                """, limit, offset)
            
            return {
                "documents": [
                    {
                        "id": str(row["id"]),
                        "filename": row["original_filename"],
                        "file_type": row["file_type"],
                        "file_size": row["file_size"],
                        "status": row["status"],
                        "chunk_count": row["chunk_count"] or 0,
                        "created_at": row["created_at"].isoformat() if row["created_at"] else None,
                        "processed_at": row["processed_at"].isoformat() if row["processed_at"] else None
                    }
                    for row in rows
                ],
                "total": len(rows),
                "limit": limit,
                "offset": offset
            }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)
