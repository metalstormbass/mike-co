"""
LLM Service for RAG
Handles context retrieval from OpenSearch and response generation
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from contextlib import asynccontextmanager
import aiohttp
import os
import json

# Database clients
from opensearchpy import AsyncOpenSearch

# Configuration
EMBEDDING_SERVICE_URL = os.getenv("EMBEDDING_SERVICE_URL", "http://embedding-service:8000")
OPENSEARCH_URL = os.getenv("OPENSEARCH_URL", "http://opensearch:9200")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "")
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-3.5-turbo")
USE_OPENAI = os.getenv("USE_OPENAI", "false").lower() == "true"
USE_OLLAMA = os.getenv("USE_OLLAMA", "false").lower() == "true"
OLLAMA_URL = os.getenv("OLLAMA_URL", "http://ollama:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "mistral")

# Parse OpenSearch URL
opensearch_host = OPENSEARCH_URL.replace("http://", "").replace("https://", "")
opensearch_parts = opensearch_host.split(":")
OPENSEARCH_HOST = opensearch_parts[0]
OPENSEARCH_PORT = int(opensearch_parts[1]) if len(opensearch_parts) > 1 else 9200

# Global clients
opensearch_client = None


class QueryRequest(BaseModel):
    """Request for RAG query"""
    query: str
    conversation_id: Optional[str] = None
    top_k: int = 5
    min_score: float = 0.5


class QueryResponse(BaseModel):
    """Response from RAG query"""
    response: str
    sources: List[Dict[str, Any]]
    query: str


class ChatRequest(BaseModel):
    """Request for chat"""
    message: str
    conversation_id: Optional[str] = None
    history: Optional[List[Dict[str, str]]] = None


class SearchRequest(BaseModel):
    """Request for semantic search only"""
    query: str
    top_k: int = 5
    min_score: float = 0.3


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize connections on startup"""
    global opensearch_client
    
    # Initialize OpenSearch client
    try:
        opensearch_client = AsyncOpenSearch(
            hosts=[{"host": OPENSEARCH_HOST, "port": OPENSEARCH_PORT}],
            http_compress=True,
            use_ssl=False,
            verify_certs=False,
            ssl_show_warn=False
        )
        info = await opensearch_client.info()
        print(f"Connected to OpenSearch: {info.get('cluster_name', 'unknown')}")
    except Exception as e:
        print(f"Warning: Could not connect to OpenSearch: {e}")
    
    print(f"LLM Service started (OpenAI: {'enabled' if USE_OPENAI and OPENAI_API_KEY else 'disabled'}, Ollama: {'enabled' if USE_OLLAMA else 'disabled'})")
    
    # If using Ollama, ensure model is available
    if USE_OLLAMA:
        try:
            async with aiohttp.ClientSession() as session:
                # Pull the model if needed (this ensures it's available)
                async with session.post(
                    f"{OLLAMA_URL}/api/pull",
                    json={"name": OLLAMA_MODEL},
                    timeout=aiohttp.ClientTimeout(total=300)  # 5 min timeout for model download
                ) as response:
                    if response.status == 200:
                        print(f"Ollama model '{OLLAMA_MODEL}' is ready")
                    else:
                        print(f"Warning: Could not pull Ollama model: {await response.text()}")
        except Exception as e:
            print(f"Warning: Could not connect to Ollama: {e}")
    
    yield
    
    # Cleanup
    if opensearch_client:
        await opensearch_client.close()
    print("LLM Service shut down")


app = FastAPI(
    title="RAG LLM Service",
    description="Generate responses using retrieved context",
    lifespan=lifespan
)


async def get_embedding(text: str) -> List[float]:
    """Get embedding for text from embedding service"""
    async with aiohttp.ClientSession() as session:
        async with session.post(
            f"{EMBEDDING_SERVICE_URL}/embed",
            json={"text": text},
            timeout=aiohttp.ClientTimeout(total=30)
        ) as response:
            if response.status != 200:
                raise Exception(f"Embedding service error: {await response.text()}")
            data = await response.json()
            return data["embedding"]


async def search_similar_chunks(
    query_embedding: List[float],
    top_k: int = 5,
    min_score: float = 0.3
) -> List[Dict[str, Any]]:
    """Search OpenSearch for similar document chunks"""
    if not opensearch_client:
        return []
    
    try:
        # k-NN search query
        search_body = {
            "size": top_k,
            "query": {
                "knn": {
                    "embedding": {
                        "vector": query_embedding,
                        "k": top_k
                    }
                }
            },
            "_source": ["document_id", "chunk_id", "chunk_index", "content", "metadata"]
        }
        
        response = await opensearch_client.search(
            index="documents",
            body=search_body
        )
        
        results = []
        for hit in response["hits"]["hits"]:
            score = hit.get("_score", 0)
            if score >= min_score:
                source = hit["_source"]
                results.append({
                    "document_id": source.get("document_id"),
                    "chunk_id": source.get("chunk_id"),
                    "chunk_index": source.get("chunk_index"),
                    "content": source.get("content"),
                    "metadata": source.get("metadata", {}),
                    "score": score
                })
        
        return results
    except Exception as e:
        print(f"Search error: {e}")
        return []


def build_context_prompt(query: str, chunks: List[Dict[str, Any]]) -> str:
    """Build a prompt with retrieved context"""
    if not chunks:
        return f"""You are a helpful AI assistant. The user asked: "{query}"

Unfortunately, I don't have any relevant documents in my knowledge base to answer this question. 
Please let the user know that they should upload relevant documents first, or ask a different question."""

    context_parts = []
    for i, chunk in enumerate(chunks, 1):
        filename = chunk.get("metadata", {}).get("filename", "Unknown")
        content = chunk.get("content", "")
        context_parts.append(f"[Source {i}: {filename}]\n{content}")
    
    context = "\n\n---\n\n".join(context_parts)
    
    return f"""You are a helpful AI assistant answering questions based on the provided context.

CONTEXT FROM KNOWLEDGE BASE:
{context}

---

USER QUESTION: {query}

INSTRUCTIONS:
- Answer the question based ONLY on the provided context
- If the context doesn't contain enough information, say so
- Be concise but comprehensive
- Reference which source(s) you used when relevant

ANSWER:"""


async def generate_response_openai(prompt: str) -> str:
    """Generate response using OpenAI API"""
    async with aiohttp.ClientSession() as session:
        async with session.post(
            "https://api.openai.com/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {OPENAI_API_KEY}",
                "Content-Type": "application/json"
            },
            json={
                "model": OPENAI_MODEL,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": 0.7,
                "max_tokens": 1000
            },
            timeout=aiohttp.ClientTimeout(total=60)
        ) as response:
            if response.status != 200:
                error = await response.text()
                raise Exception(f"OpenAI API error: {error}")
            data = await response.json()
            return data["choices"][0]["message"]["content"]


async def generate_response_ollama(prompt: str) -> str:
    """Generate response using Ollama (local LLM)"""
    async with aiohttp.ClientSession() as session:
        async with session.post(
            f"{OLLAMA_URL}/api/generate",
            json={
                "model": OLLAMA_MODEL,
                "prompt": prompt,
                "stream": False,
                "options": {
                    "temperature": 0.7,
                    "num_predict": 1000
                }
            },
            timeout=aiohttp.ClientTimeout(total=300)  # Longer timeout for local inference with phi model
        ) as response:
            if response.status != 200:
                error = await response.text()
                raise Exception(f"Ollama API error: {error}")
            data = await response.json()
            return data.get("response", "")


def generate_response_simple(query: str, chunks: List[Dict[str, Any]]) -> str:
    """Generate a simple response without an LLM (for testing)"""
    if not chunks:
        return f"I don't have any relevant documents in my knowledge base to answer your question about: \"{query}\"\n\nPlease upload some documents first, then I'll be able to help!"
    
    # Build a simple response from the retrieved chunks
    response_parts = [
        f"Based on the documents in my knowledge base, here's what I found relevant to your question:\n"
    ]
    
    for i, chunk in enumerate(chunks[:3], 1):  # Limit to top 3
        filename = chunk.get("metadata", {}).get("filename", "Unknown")
        content = chunk.get("content", "")[:500]  # Limit content length
        score = chunk.get("score", 0)
        response_parts.append(f"\n**From {filename}** (relevance: {score:.0%}):\n> {content}...")
    
    response_parts.append(f"\n\n*Found {len(chunks)} relevant chunk(s) in the knowledge base.*")
    
    return "\n".join(response_parts)


@app.get("/health")
async def health():
    """Health check endpoint"""
    health_status = {
        "status": "healthy",
        "opensearch": "unknown",
        "openai_enabled": USE_OPENAI and bool(OPENAI_API_KEY),
        "ollama_enabled": USE_OLLAMA,
        "ollama_model": OLLAMA_MODEL if USE_OLLAMA else None
    }
    
    if opensearch_client:
        try:
            await opensearch_client.ping()
            health_status["opensearch"] = "connected"
        except:
            health_status["opensearch"] = "disconnected"
            health_status["status"] = "degraded"
    
    return health_status


@app.post("/search", response_model=List[Dict[str, Any]])
async def semantic_search(request: SearchRequest):
    """Perform semantic search without generating a response"""
    try:
        # Get query embedding
        query_embedding = await get_embedding(request.query)
        
        # Search for similar chunks
        results = await search_similar_chunks(
            query_embedding,
            top_k=request.top_k,
            min_score=request.min_score
        )
        
        return results
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/query", response_model=QueryResponse)
async def rag_query(request: QueryRequest):
    """RAG query: retrieve context and generate response"""
    try:
        # Get query embedding
        query_embedding = await get_embedding(request.query)
        
        # Search for similar chunks
        chunks = await search_similar_chunks(
            query_embedding,
            top_k=request.top_k,
            min_score=request.min_score
        )
        
        # Generate response
        if USE_OPENAI and OPENAI_API_KEY:
            prompt = build_context_prompt(request.query, chunks)
            response_text = await generate_response_openai(prompt)
        elif USE_OLLAMA:
            prompt = build_context_prompt(request.query, chunks)
            response_text = await generate_response_ollama(prompt)
        else:
            response_text = generate_response_simple(request.query, chunks)
        
        # Format sources for response
        sources = [
            {
                "document_id": chunk.get("document_id"),
                "filename": chunk.get("metadata", {}).get("filename", "Unknown"),
                "content_preview": chunk.get("content", "")[:200] + "...",
                "score": chunk.get("score", 0)
            }
            for chunk in chunks
        ]
        
        return QueryResponse(
            response=response_text,
            sources=sources,
            query=request.query
        )
    except Exception as e:
        import traceback
        print(f"Query error: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/chat")
async def chat(request: ChatRequest):
    """Chat endpoint - wrapper around RAG query"""
    query_request = QueryRequest(
        query=request.message,
        conversation_id=request.conversation_id
    )
    return await rag_query(query_request)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
