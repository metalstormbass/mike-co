.PHONY: help build up down logs clean

help:
	@echo "RAG Knowledge Base - Available commands:"
	@echo ""
	@echo "Docker Compose:"
	@echo "  make build         - Build all Docker images"
	@echo "  make up            - Start all services"
	@echo "  make down          - Stop all services"
	@echo "  make logs          - View logs from all services"
	@echo "  make clean         - Stop services and remove volumes/images"
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

# Clean up
clean:
	docker-compose down -v --rmi local
