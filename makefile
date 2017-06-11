PATH := $(PATH):$(HOME)/.local/bin:$(HOME)/bin:/bin:/usr/local/bin
SHELL := /usr/bin/env bash

.DEFAULT_GOAL := help

CLUSTER_ZONE=${CLUSTER_ZONE:-'europe-west1-b'}
export PROJECT=run-melody

help: ## Display this help
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN { FS = ":.*?## " }; { printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 }'

image-build: ## Build image
	docker build -t run-melody:latest .

image-run: ## Run image
	docker run --rm --name=php-melody -d -p 80:80 -it run-melody && open http://localhost/

image-stop: ## Stop imate
	docker stop php-melody

deploy-on-minikube: image-build ## deploy on minikube
	@source ./gcloud && \
	gcloud:project:set run-melody && \
	kubectl start && \
	gcloud:image:push run-melody:latest && \
	gcloud:container:start && \
	minikube service run-melody
	
deploy-on-gcloud: image-build ## deploy on gcloud
	@source ./gcloud && \
	gcloud:project:set run-melody && \
	gcloud:container:cluster:create && \
	gcloud:container:cluster:configure && \
	gcloud:image:push run-melody:latest && \
	gcloud:container:start && \
	gcloud:ip --watch
