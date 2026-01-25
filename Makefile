.PHONY: help build up down logs dev prod helm-deps helm-lint helm-template clean

help:
	@echo "RAG Knowledge Base - Available commands:"
	@echo ""
	@echo "Docker Compose (Local Development):"
	@echo "  make build         - Build all Docker images"
	@echo "  make up            - Start all services (docker-compose)"
	@echo "  make down          - Stop all services"
	@echo "  make logs          - View logs from all services"
	@echo ""
	@echo "Helm (Kubernetes):"
	@echo "  make helm-deps     - Add Helm repositories and update dependencies"
	@echo "  make helm-lint     - Lint the Helm chart"
	@echo "  make helm-template - Render chart templates locally"
	@echo "  make dev           - Deploy to Kubernetes (dev environment)"
	@echo "  make prod          - Deploy to Kubernetes (prod environment)"
	@echo "  make uninstall-dev - Uninstall dev release"
	@echo "  make uninstall-prod- Uninstall prod release"
	@echo ""

# Docker Compose commands
build:
	docker-compose build

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f

# Helm commands
CHART_PATH := k8s/charts/rag-knowledge-base
RELEASE_NAME := rag

helm-deps:
	@echo "Adding Helm repositories..."
	helm repo add opensearch https://opensearch-project.github.io/helm-charts/
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add cnpg https://cloudnative-pg.github.io/charts
	helm repo add ot-helm https://ot-container-kit.github.io/helm-charts/
	helm repo update
	@echo ""
	@echo "Updating chart dependencies..."
	helm dependency update $(CHART_PATH)
	@echo ""
	@echo "Dependencies installed successfully!"

helm-lint:
	helm lint $(CHART_PATH)
	helm lint $(CHART_PATH) -f $(CHART_PATH)/values-dev.yaml
	helm lint $(CHART_PATH) -f $(CHART_PATH)/values-prod.yaml

helm-template:
	helm template $(RELEASE_NAME) $(CHART_PATH)

helm-template-dev:
	helm template $(RELEASE_NAME) $(CHART_PATH) -f $(CHART_PATH)/values-dev.yaml

helm-template-prod:
	helm template $(RELEASE_NAME) $(CHART_PATH) -f $(CHART_PATH)/values-prod.yaml

dev:
	helm upgrade --install $(RELEASE_NAME)-dev $(CHART_PATH) \
		-f $(CHART_PATH)/values-dev.yaml \
		--create-namespace \
		--namespace rag-knowledge-base-dev

prod:
	helm upgrade --install $(RELEASE_NAME)-prod $(CHART_PATH) \
		-f $(CHART_PATH)/values-prod.yaml \
		--create-namespace \
		--namespace rag-knowledge-base-prod

uninstall-dev:
	helm uninstall $(RELEASE_NAME)-dev --namespace rag-knowledge-base-dev

uninstall-prod:
	helm uninstall $(RELEASE_NAME)-prod --namespace rag-knowledge-base-prod

# Package chart for distribution
helm-package:
	helm package $(CHART_PATH)

# Clean up
clean:
	docker-compose down -v --rmi local
