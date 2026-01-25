# RAG Knowledge Base

A Retrieval-Augmented Generation (RAG) knowledge base application that allows users to upload documents, process them into embeddings, and query them using a large language model.

[![Security Scans](https://img.shields.io/badge/Security%20Scans-View%20Results-blue)](./docs/security-scans/README.md)

> 📋 **Security Scan Results**: View vulnerability scan reports for all container images in [docs/security-scans/](./docs/security-scans/README.md)

## Architecture

```
                                    ┌───────────────────┐
                                    │       User        │
                                    └───────────────────┘
                                            │
                                            ▼
                                    ┌───────────────────┐
                                    │      nginx        │
                                    │    (Port 80)      │
                                    └───────────────────┘
                                            │
                        ┌───────────────────┴───────────────────┐
                        ▼                                       ▼
                ┌───────────────────┐               ┌───────────────────┐
                │     frontend      │               │    api-gateway    │
                │   (React/Vite)    │               │     (Node.js)     │
                └───────────────────┘               └───────────────────┘
                                                            │
                ┌───────────────────┬───────────────────────┼───────────────────┐
                ▼                   ▼                       ▼                   ▼
        ┌───────────────┐   ┌───────────────┐       ┌───────────────┐   ┌───────────────┐
        │   document-   │   │   embedding-  │       │  llm-service  │   │  opensearch   │
        │   processor   │   │    service    │       │   (PyTorch)   │   │  (Port 9200)  │
        │   (Python)    │   │   (PyTorch)   │       │   Mistral-7B  │   └───────────────┘
        │  (Port 8002)  │   │  (Port 8000)  │       │  (Port 8001)  │           │
        └───────────────┘   └───────────────┘       └───────────────┘           │
                │                   │                                           │
                └─────────┬─────────┘                                           │
                          ▼                                                     │
                  ┌───────────────┐                                             │
                  │  opensearch   │◄────────────────────────────────────────────┘
                  │  (Vectors)    │
                  └───────────────┘

        ┌───────────────┐   ┌───────────────┐
        │  postgresql   │   │     redis     │
        │  (Port 5432)  │   │  (Port 6379)  │
        │  (Metadata)   │   │    (Cache)    │
        └───────────────┘   └───────────────┘
```

## Services

| Service | Description | Port |
|---------|-------------|------|
| **NGINX** | Reverse proxy routing traffic to frontend and API | 80 |
| **Frontend** | React/Vite web application | - |
| **API Gateway** | Node.js REST API handling requests | - |
| **Document Processor** | Python service for parsing and chunking documents | 8002 |
| **Embedding Service** | PyTorch service generating vector embeddings | 8000 |
| **LLM Service** | PyTorch service running Mistral-7B for responses | 8001 |
| **OpenSearch** | Vector database for document embeddings | 9200 |
| **PostgreSQL** | Relational database for metadata | 5432 |
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

| Service | Image | Version |
|---------|-------|---------|
| OpenSearch | `opensearchproject/opensearch` | 2.11.0 |
| PostgreSQL | `postgres` | 16-bookworm |
| Redis | `redis` | 7-bookworm |

## Prerequisites

- Docker and Docker Compose
- (Optional) Kubernetes cluster with Helm for production deployments

## Quick Start

### Local Development with Docker Compose

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

## Kubernetes Deployment

For Kubernetes deployments using Helm:

```bash
# Install Helm dependencies
make helm-deps

# Deploy to dev environment
make dev

# Deploy to prod environment
make prod

# Uninstall
make uninstall-dev
make uninstall-prod
```

## Project Structure

```
├── services/
│   ├── api-gateway/       # Node.js API Gateway
│   ├── document-processor/ # Python document processing
│   ├── embedding-service/  # PyTorch embedding generation
│   ├── frontend/          # React/Vite frontend
│   ├── llm-service/       # PyTorch LLM service
│   └── nginx/             # NGINX reverse proxy
├── k8s/
│   └── charts/            # Helm charts for Kubernetes
├── docker-compose.yaml    # Local development setup
└── Makefile              # Build and deployment commands
```