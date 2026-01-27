# RAG Knowledge Base

A Retrieval-Augmented Generation (RAG) knowledge base application that allows users to upload documents, process them into embeddings, and query them using a large language model.

📊 **[View Live Security Scan Results →](https://metalstormbass.github.io/mike-co/)**

Automated vulnerability scans run on every push and weekly, comparing this implementation against Chainguard hardened images.

## Architecture

```
                                    ┌───────────────────┐
                                    │       User        │
                                    └─────────┬─────────┘
                                              │
                                              ▼
                                    ┌───────────────────┐
                                    │      nginx        │
                                    │    (Port 80)      │
                                    └─────────┬─────────┘
                                              │
                        ┌─────────────────────┴─────────────────────┐
                        ▼                                           ▼
                ┌───────────────────┐                   ┌───────────────────┐
                │     frontend      │                   │    api-gateway    │
                │   (React/Vite)    │                   │     (Node.js)     │
                └───────────────────┘                   └─────────┬─────────┘
                                                                  │
                ┌─────────────────────┬───────────────────────────┼───────────────────┐
                ▼                     ▼                           ▼                   ▼
        ┌───────────────┐     ┌───────────────┐           ┌───────────────┐   ┌───────────────┐
        │   document-   │     │   embedding-  │           │  llm-service  │   │  opensearch   │
        │   processor   │     │    service    │           │   (FastAPI)   │   │  (Port 9200)  │
        │   (FastAPI)   │     │   (PyTorch)   │           │  (Port 8001)  │   │   (Vectors)   │
        │  (Port 8002)  │     │  (Port 8000)  │           └───────┬───────┘   └───────────────┘
        └───────┬───────┘     └───────────────┘                   │
                │                     ▲                           │
                │                     │                           ▼
                │                     │                   ┌───────────────┐
                └─────────────────────┘                   │    ollama     │
                                                          │   (Mistral)   │
                                                          │ (Port 11434)  │
                                                          └───────────────┘

        ┌───────────────┐   ┌───────────────┐
        │  postgresql   │   │     redis     │
        │  (Port 5432)  │   │  (Port 6379)  │
        │  (Metadata)   │   │    (Cache)    │
        └───────────────┘   └───────────────┘
```

### Data Flow

1. **Document Upload**: User uploads document → nginx → api-gateway → document-processor → embedding-service → OpenSearch (vector storage) + PostgreSQL (metadata)

2. **Query/Chat**: User asks question → nginx → api-gateway → llm-service → embedding-service (query embedding) → OpenSearch (k-NN search) → Ollama (response generation) → User

## Features

### 💬 Conversational AI Chat
- Ask questions about your uploaded documents
- Get intelligent answers powered by RAG (Retrieval-Augmented Generation)
- Automatic source citations with relevance scores
- Context-aware responses using semantic search

### 🔍 Semantic Search
- Search your knowledge base without LLM processing
- View raw document chunks matching your query
- Relevance scoring (0-100%) for each result
- Fast exploration of document contents
- Filter results by document and metadata

### 📄 Document Management
- Support for PDF, DOCX, TXT, MD, and HTML files
- Automatic text extraction and chunking
- Real-time processing status tracking
- Vector embeddings for semantic search (384-dimensional)
- Metadata storage for filtering and organization

### 🎯 Key Capabilities
- **Two Search Modes**: Chat with LLM or direct semantic search
- **Source Transparency**: See exactly which documents informed each answer
- **Flexible LLM Backends**: Choose between local (Ollama) or cloud (OpenAI)
- **Real-time Updates**: Track document processing status
- **Modern UI**: Dark mode interface with gradient accents

## Services

| Service | Description | Port |
|---------|-------------|------|
| **NGINX** | Reverse proxy routing traffic to frontend and API | 80 |
| **Frontend** | React/Vite web application | - |
| **API Gateway** | Node.js REST API handling requests | 3000 (internal) |
| **Document Processor** | FastAPI service for parsing and chunking documents | 8002 |
| **Embedding Service** | PyTorch service generating vector embeddings (all-MiniLM-L6-v2) | 8000 |
| **LLM Service** | FastAPI service orchestrating RAG queries | 8001 |
| **Ollama** | Local LLM inference server running Mistral | 11434 |
| **OpenSearch** | Vector database for document embeddings (k-NN) | 9200 |
| **PostgreSQL** | Relational database for document metadata | 5432 |
| **Redis** | Caching layer | 6379 |

## Container Images

This implementation uses standard Docker Hub base images for all services.

### Application Services (Custom Built)

Custom-built services using standard base images:

| Service | Base Image | Description |
|---------|------------|-------------|
| nginx | `nginx:bookworm` | Official NGINX web server |
| frontend | `node:20-bookworm-slim` + `nginx:bookworm` | Node.js build, NGINX runtime |
| api-gateway | `node:20-bookworm-slim` | Official Node.js 20 (slim) |
| document-processor | `python:3.11-slim-bookworm` | Official Python 3.11 (slim) |
| embedding-service | `pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime` | Official PyTorch with CUDA |
| llm-service | `python:3.11-slim-bookworm` | Official Python 3.11 (slim) |

### Infrastructure Services (Pre-built Images)

Official images used directly from Docker Hub:

| Service | Image | Version |
|---------|-------|---------|
| OpenSearch | `opensearchproject/opensearch` | 2.11.0 |
| PostgreSQL | `postgres` | 16-bookworm |
| Redis | `redis` | 7-bookworm |
| Ollama | `ollama/ollama` | latest |

### Security Comparison

📊 **[View Live Security Scan Results →](https://metalstormbass.github.io/mike-co/)**

Automated vulnerability scans run on every push and weekly. The security scan results page compares this implementation against a parallel implementation using [Chainguard](https://www.chainguard.dev/) hardened base images, demonstrating the security benefits of hardened container images.

## LLM Configuration

The RAG system supports multiple LLM backends:

### Ollama (Default - Local)
Runs locally using the Mistral 7B model. No API key required.

```yaml
# docker-compose.yaml
environment:
  - USE_OLLAMA=true
  - OLLAMA_URL=http://ollama:11434
  - OLLAMA_MODEL=mistral  # or phi, tinyllama, llama3, etc.
```

### OpenAI (Cloud)
Use OpenAI's API for higher quality responses.

```yaml
# docker-compose.yaml
environment:
  - USE_OPENAI=true
  - OPENAI_API_KEY=your-api-key-here
  - OPENAI_MODEL=gpt-3.5-turbo  # or gpt-4
```

## Prerequisites

- Docker and Docker Compose

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mike-co
   ```

2. **Build all services**
   ```bash
   make build
   ```

3. **Start the application**
   ```bash
   make up
   ```

4. **Access the application**
   - Open your browser and navigate to `http://localhost`

5. **View logs**
   ```bash
   make logs
   ```

6. **Stop the application**
   ```bash
   make down
   ```

### Available Make Commands

```bash
make help          # Show all available commands
make build         # Build all Docker images
make up            # Start all services
make down          # Stop all services
make logs          # View logs from all services
make clean         # Stop services and remove volumes/images
```
