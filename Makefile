# Command Variables
# If sudo is needed, change to: DOCKER_COMPOSE = sudo docker compose
DC_LOCAL = docker compose -f docker-compose.local.yml
DC_PROD  = docker compose -f docker-compose.yml

# Main container service name
APP_SERVICE = app
# Queue service name
QUEUE_SERVICE = queue
# Scheduler service name
SCHEDULER_SERVICE = scheduler

# -----------------------------------------------------------------------------
# DEFAULT / HELP
# -----------------------------------------------------------------------------
.PHONY: help
help:
	@echo "Usage: make [command]"
	@echo ""
	@echo "Development commands (Local):"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# -----------------------------------------------------------------------------
# LOCAL ENVIRONMENT (DEV) - Default
# -----------------------------------------------------------------------------
.PHONY: up down restart build logs shell bash

up: ## Start local environment (detached)
	$(DC_LOCAL) --env-file .env up -d

down: ## Stop and remove local containers
	$(DC_LOCAL) down

stop: ## Stop local containers (without removing)
	$(DC_LOCAL) stop

build: ## Rebuild local images (useful after Dockerfile changes)
	$(DC_LOCAL) build

restart: down up ## Restart local environment from scratch

logs: ## View local container logs (follow)
	$(DC_LOCAL) logs -f

shell: ## Access the shell of the local app container
	$(DC_LOCAL) exec $(APP_SERVICE) sh

queue-shell: ## Access the shell of the local queue container
	$(DC_LOCAL) exec $(QUEUE_SERVICE) sh

scheduler-shell: ## Access the shell of the local scheduler container
	$(DC_LOCAL) exec $(SCHEDULER_SERVICE) sh

# -----------------------------------------------------------------------------
# LARAVEL UTILITIES (LOCAL)
# Usage: make artisan cmd="migrate"
# -----------------------------------------------------------------------------
.PHONY: artisan composer test

artisan: ## Run local artisan commands. Ex: make artisan cmd="migrate"
	$(DC_LOCAL) exec $(APP_SERVICE) php artisan $(cmd)

composer: ## Run local composer commands. Ex: make composer cmd="install"
	$(DC_LOCAL) exec $(APP_SERVICE) composer $(cmd)

test: ## Run test suite (Pest/PHPUnit)
	$(DC_LOCAL) exec $(APP_SERVICE) php artisan test

# -----------------------------------------------------------------------------
# PRODUCTION ENVIRONMENT
# -----------------------------------------------------------------------------
.PHONY: up-prod down-prod build-prod logs-prod deploy-prod

up-prod: ## Start production environment
	$(DC_PROD) --env-file .env.production up -d

down-prod: ## Stop and remove production environment
	$(DC_PROD) down

build-prod: ## Rebuild production image
	$(DC_PROD) build

logs-prod: ## View production logs
	$(DC_PROD) logs -f

# Example of a safe deploy command
deploy-prod: down-prod build-prod up-prod ## Full deploy: Down -> Build -> Up (Prod)
