#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  RAG Knowledge Base - Minikube Deploy  ${NC}"
echo -e "${BLUE}========================================${NC}"

# Check if minikube is running
echo -e "\n${YELLOW}Checking Minikube status...${NC}"
if ! minikube status | grep -q "Running"; then
    echo -e "${RED}Minikube is not running. Starting...${NC}"
    minikube start --driver=docker
fi

echo -e "${GREEN}✓ Minikube is running${NC}"

# Configure docker to use minikube's docker daemon
echo -e "\n${YELLOW}Configuring Docker to use Minikube's daemon...${NC}"
eval $(minikube docker-env)
echo -e "${GREEN}✓ Docker configured${NC}"

# Build images directly in Minikube
echo -e "\n${YELLOW}Building Docker images in Minikube...${NC}"

SERVICES=("nginx" "api-gateway" "frontend" "document-processor")
CPU_SERVICES=("embedding-service" "llm-service")

for service in "${SERVICES[@]}"; do
    echo -e "\n${BLUE}Building ${service}...${NC}"
    docker build -t "mike-co-${service}:latest" "./services/${service}"
    echo -e "${GREEN}✓ ${service} built${NC}"
done

# Build CPU variants for ML services
for service in "${CPU_SERVICES[@]}"; do
    echo -e "\n${BLUE}Building ${service} (CPU)...${NC}"
    docker build -t "mike-co-${service}:latest" -f "./services/${service}/Dockerfile.cpu" "./services/${service}"
    echo -e "${GREEN}✓ ${service} built${NC}"
done

echo -e "\n${GREEN}✓ All images built${NC}"

# Create namespace
echo -e "\n${YELLOW}Creating namespace...${NC}"
kubectl create namespace rag-kb --dry-run=client -o yaml | kubectl apply -f -
echo -e "${GREEN}✓ Namespace created${NC}"

# Deploy with Helm
echo -e "\n${YELLOW}Deploying with Helm...${NC}"
cd k8s/charts/rag-knowledge-base

# Skip dependency update for now (we're using standalone components)
# helm dependency update

helm upgrade --install rag-kb . \
    -n rag-kb \
    -f values-minikube.yaml \
    --set opensearch.enabled=false \
    --set opensearchStandalone.enabled=true \
    --wait --timeout 5m

echo -e "${GREEN}✓ Helm deployment complete${NC}"

# Wait for pods
echo -e "\n${YELLOW}Waiting for pods to be ready...${NC}"
kubectl wait --for=condition=ready pod -l app.kubernetes.io/instance=rag-kb -n rag-kb --timeout=300s || true

# Show status
echo -e "\n${YELLOW}Deployment Status:${NC}"
kubectl get pods -n rag-kb

# Get the URL
echo -e "\n${YELLOW}Getting access URL...${NC}"
MINIKUBE_IP=$(minikube ip)
NODE_PORT=$(kubectl get svc -n rag-kb rag-kb-nginx -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "30080")

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}  Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\n${BLUE}Access the application at:${NC}"
echo -e "  http://${MINIKUBE_IP}:${NODE_PORT}"
echo -e "\n${BLUE}Or use minikube service:${NC}"
echo -e "  minikube service rag-kb-nginx -n rag-kb"
echo -e "\n${BLUE}View logs:${NC}"
echo -e "  kubectl logs -f -l app.kubernetes.io/instance=rag-kb -n rag-kb"
echo -e "\n${BLUE}View all pods:${NC}"
echo -e "  kubectl get pods -n rag-kb"
