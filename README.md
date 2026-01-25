# RAG Knowledge Base

A Retrieval-Augmented Generation (RAG) knowledge base application that allows users to upload documents, process them into embeddings, and query them using a large language model.

## Architecture

```
                                    ┌─────────────────────────────────────────────────────────────┐
                                    │                         User                                │
                                    └─────────────────────────────────────────────────────────────┘
                                                              │
                                                              ▼
                                    ┌─────────────────────────────────────────────────────────────┐
                                    │                    NGINX (Port 80)                          │
                                    │                    Reverse Proxy                            │
                                    └─────────────────────────────────────────────────────────────┘
                                                              │
                                      ┌───────────────────────┴───────────────────────┐
                                      ▼                                               ▼
                        ┌─────────────────────────┐                     ┌─────────────────────────┐
                        │        Frontend         │                     │      API Gateway        │
                        │      (React/Vite)       │                     │       (Node.js)         │
                        └─────────────────────────┘                     └─────────────────────────┘
                                                                                      │
                              ┌───────────────────────────────┬───────────────────────┼───────────────────────┐
                              ▼                               ▼                       ▼                       ▼
                ┌─────────────────────────┐     ┌─────────────────────────┐     ┌───────────┐     ┌───────────────────┐
                │   Document Processor    │     │   Embedding Service     │     │    LLM    │     │    Data Stores    │
                │        (Python)         │     │   (PyTorch/FastAPI)     │     │  Service  │     │                   │
                └─────────────────────────┘     └─────────────────────────┘     │ (PyTorch) │     │  ┌─────────────┐  │
                              │                               │                 └───────────┘     │  │  OpenSearch │  │
                              │                               │                                   │  │  (Vectors)  │  │
                              └───────────────────────────────┘                                   │  ├─────────────┤  │
                                              │                                                   │  │ PostgreSQL  │  │
                                              ▼                                                   │  │  (Metadata) │  │
                              ┌─────────────────────────────────┐                                 │  ├─────────────┤  │
                              │          OpenSearch             │◄────────────────────────────────┤  │    Redis    │  │
                              │       (Vector Storage)          │                                 │  │   (Cache)   │  │
                              └─────────────────────────────────┘                                 │  └─────────────┘  │
                                                                                                  └───────────────────┘
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