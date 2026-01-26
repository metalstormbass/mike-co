# RAG Knowledge Base

A Retrieval-Augmented Generation (RAG) knowledge base application that allows users to upload documents, process them into embeddings, and query them using a large language model.

[![Security Scans](https://img.shields.io/badge/Security%20Scans-View%20Results-blue)](./docs/security-scans/README.md)

> 📋 **Security Scan Results**: View vulnerability scan reports for all container images in [docs/security-scans/](./docs/security-scans/README.md)

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

### Custom Images (Built from Source)

| Service | Base Image | Version | GHCR Image |
|---------|------------|---------|------------|
| nginx | `nginx:bookworm` | Debian Bookworm | `ghcr.io/metalstormbass/mike-co/nginx` |
| frontend | `node:20-bookworm-slim` / `nginx:bookworm` | Node 20 / Debian Bookworm | `ghcr.io/metalstormbass/mike-co/frontend` |
| api-gateway | `node:20-bookworm-slim` | Node 20 | `ghcr.io/metalstormbass/mike-co/api-gateway` |
| document-processor | `python:3.11-slim-bookworm` | Python 3.11 | `ghcr.io/metalstormbass/mike-co/document-processor` |
| embedding-service | `pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime` | PyTorch 2.1.0 / CUDA 12.1 | `ghcr.io/metalstormbass/mike-co/embedding-service` |
| llm-service | `pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime` | PyTorch 2.1.0 / CUDA 12.1 | `ghcr.io/metalstormbass/mike-co/llm-service` |

### Pre-built Images (External)

| Service | Image | Version | Security |
|---------|-------|---------|----------|
| OpenSearch | `cgr.dev/chainguard-private/opensearch` | 2 | Chainguard hardened image |
| PostgreSQL | `cgr.dev/chainguard-private/postgres` | 16 | Chainguard hardened image |
| Redis | `cgr.dev/chainguard-private/redis` | 7 | Chainguard hardened image |
| Ollama | `ollama/ollama` | latest | - |

### Chainguard Images

This project uses [Chainguard Images](https://www.chainguard.dev/) for OpenSearch, PostgreSQL, and Redis. Chainguard Images provide:

- **Minimal attack surface**: Distroless containers with only essential components
- **Zero CVEs**: Regularly rebuilt images with minimal to zero known vulnerabilities
- **Enhanced security**: SLSA Level 3 compliance with signed SBOMs
- **Up-to-date packages**: Latest security patches and updates

To use Chainguard private images, authenticate with:
```bash
chainctl auth login
```

## LLM Configuration

The RAG system supports multiple LLM backends:

### Ollama (Default - Local)
Runs locally using the Mistral model. No API key required.

```yaml
# docker-compose.yaml
environment:
  - USE_OLLAMA=true
  - OLLAMA_URL=http://ollama:11434
  - OLLAMA_MODEL=mistral  # or llama3, codellama, etc.
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
