#!/bin/bash
set -e

echo "=== Initializing Databases ==="

# Wait for services to be ready
echo "Waiting for OpenSearch..."
until curl -s http://localhost:9200/_cluster/health | grep -q '"status":"green"\|"status":"yellow"'; do
    sleep 2
done
echo "OpenSearch is ready!"

echo "Waiting for PostgreSQL..."
until docker exec mike-co-postgresql-1 pg_isready -U rag -d rag > /dev/null 2>&1; do
    sleep 2
done
echo "PostgreSQL is ready!"

# Create OpenSearch k-NN index for document embeddings
echo ""
echo "=== Creating OpenSearch k-NN Index ==="

# Delete existing index if it exists
curl -s -X DELETE "http://localhost:9200/documents" > /dev/null 2>&1 || true

# Create the k-NN index with proper settings
curl -s -X PUT "http://localhost:9200/documents" -H "Content-Type: application/json" -d '{
  "settings": {
    "index": {
      "knn": true,
      "knn.algo_param.ef_search": 100,
      "number_of_shards": 1,
      "number_of_replicas": 0
    }
  },
  "mappings": {
    "properties": {
      "document_id": {
        "type": "keyword"
      },
      "chunk_id": {
        "type": "keyword"
      },
      "chunk_index": {
        "type": "integer"
      },
      "content": {
        "type": "text",
        "analyzer": "standard"
      },
      "embedding": {
        "type": "knn_vector",
        "dimension": 384,
        "method": {
          "name": "hnsw",
          "space_type": "cosinesimil",
          "engine": "lucene",
          "parameters": {
            "ef_construction": 128,
            "m": 24
          }
        }
      },
      "metadata": {
        "type": "object",
        "properties": {
          "filename": { "type": "keyword" },
          "file_type": { "type": "keyword" },
          "page_number": { "type": "integer" },
          "section": { "type": "text" }
        }
      },
      "created_at": {
        "type": "date"
      }
    }
  }
}' | python3 -c "import sys,json; r=json.load(sys.stdin); print('✓ Index created' if r.get('acknowledged') else f'✗ Error: {r}')"

# Create PostgreSQL schema for document metadata
echo ""
echo "=== Creating PostgreSQL Schema ==="

docker exec mike-co-postgresql-1 psql -U rag -d rag << 'EOF'
-- Documents table: stores document metadata
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    file_size BIGINT NOT NULL,
    mime_type VARCHAR(100),
    status VARCHAR(50) DEFAULT 'pending',
    chunk_count INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP WITH TIME ZONE
);

-- Document chunks table: tracks individual chunks
CREATE TABLE IF NOT EXISTS document_chunks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    chunk_index INTEGER NOT NULL,
    content TEXT NOT NULL,
    char_start INTEGER,
    char_end INTEGER,
    opensearch_id VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(document_id, chunk_index)
);

-- Conversations table: stores chat conversations
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Messages table: stores chat messages
CREATE TABLE IF NOT EXISTS messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL CHECK (role IN ('user', 'assistant', 'system')),
    content TEXT NOT NULL,
    sources JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_documents_status ON documents(status);
CREATE INDEX IF NOT EXISTS idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_document_chunks_document_id ON document_chunks(document_id);
CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updated_at
DROP TRIGGER IF EXISTS update_documents_updated_at ON documents;
CREATE TRIGGER update_documents_updated_at
    BEFORE UPDATE ON documents
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_conversations_updated_at ON conversations;
CREATE TRIGGER update_conversations_updated_at
    BEFORE UPDATE ON conversations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

\echo '✓ PostgreSQL schema created successfully'
EOF

# Verify the setup
echo ""
echo "=== Verification ==="

echo "OpenSearch index:"
curl -s "http://localhost:9200/documents/_mapping" | python3 -c "import sys,json; m=json.load(sys.stdin); props=m.get('documents',{}).get('mappings',{}).get('properties',{}); print(f'  Fields: {list(props.keys())}')"

echo ""
echo "PostgreSQL tables:"
docker exec mike-co-postgresql-1 psql -U rag -d rag -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;" | grep -E '^\s\w' | sed 's/^/  /'

echo ""
echo "=== Database Initialization Complete ==="
