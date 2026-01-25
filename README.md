# RAG Knowledge Base

A Retrieval-Augmented Generation (RAG) knowledge base application that allows users to upload documents, process them into embeddings, and query them using a large language model.

## Architecture

```
                                         ┌─────────────────────────────────────────┐
                                         │                  User                   │
                                         └─────────────────────────────────────────┘
                                                            │
                                                            ▼
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                           Docker Compose Network                                         │
│                                                                                                          │
│    ┌────────────────────────────────────────────────────────────────────────────────────────────────┐   │
│    │                                    nginx (Port 80)                                              │   │
│    │                              [services/nginx/Dockerfile]                                        │   │
│    └────────────────────────────────────────────────────────────────────────────────────────────────┘   │
│                                                  │                                                       │
│                          ┌───────────────────────┴───────────────────────┐                              │
│                          ▼                                               ▼                              │
│    ┌─────────────────────────────────────┐             ┌─────────────────────────────────────┐          │
│    │            frontend                 │             │           api-gateway              │          │
│    │   [services/frontend/Dockerfile]    │             │  [services/api-gateway/Dockerfile] │          │
│    │          React + Vite               │             │            Node.js                 │          │
│    └─────────────────────────────────────┘             └─────────────────────────────────────┘          │
│                                                                          │                              │
│                    ┌─────────────────────────────┬───────────────────────┼───────────────────┐          │
│                    ▼                             ▼                       ▼                   ▼          │
│    ┌───────────────────────────┐ ┌───────────────────────────┐ ┌─────────────────┐ ┌─────────────────┐  │
│    │    document-processor     │ │    embedding-service      │ │   llm-service   │ │   Data Stores   │  │
│    │        (Port 8002)        │ │       (Port 8000)         │ │   (Port 8001)   │ │                 │  │
│    │ [services/document-       │ │ [services/embedding-      │ │ [services/llm-  │ │ ┌─────────────┐ │  │
│    │  processor/Dockerfile]    │ │  service/Dockerfile]      │ │  service/       │ │ │ opensearch  │ │  │
│    │        Python             │ │    PyTorch + FastAPI      │ │  Dockerfile]    │ │ │ (Port 9200) │ │  │
│    └───────────────────────────┘ └───────────────────────────┘ │ PyTorch+Mistral │ │ ├─────────────┤ │  │
│                    │                             │             └─────────────────┘ │ │ postgresql  │ │  │
│                    │                             │                                 │ │ (Port 5432) │ │  │
│                    └──────────────┬──────────────┘                                 │ ├─────────────┤ │  │
│                                   ▼                                                │ │   redis     │ │  │
│                    ┌───────────────────────────────┐                               │ │ (Port 6379) │ │  │
│                    │         opensearch            │◄──────────────────────────────┤ └─────────────┘ │  │
│                    │  opensearchproject/opensearch │                               └─────────────────┘  │
│                    │          :2.11.0              │                                                    │
│                    └───────────────────────────────┘                                                    │
│                                                                                                          │
│    ┌──────────────────────────┐  ┌──────────────────────────┐  ┌──────────────────────────┐             │
│    │        postgresql        │  │          redis           │  │       Volumes            │             │
│    │    postgres:16-alpine    │  │      redis:7-alpine      │  │  - opensearch-data       │             │
│    │       (Port 5432)        │  │       (Port 6379)        │  │  - postgresql-data       │             │
│    └──────────────────────────┘  └──────────────────────────┘  │  - redis-data            │             │
│                                                                └──────────────────────────┘             │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────┘
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