.DEFAULT_GOAL := help

all: build up  ## Builds and starts the inception app

up: init ## Starts the inception app
	@docker-compose up

down: ## Stops the inception app
	@docker-compose down

build: ## Builds the inception docker images
	@docker-compose build

clean: ## Deletes all containers, images, volumes and networks
	@docker stop $$(docker ps -qa --filter 'name=inception-*');\
	docker rm $$(docker ps -qa --filter 'name=inception-*');\
	docker rmi -f $$(docker images "inception_*" -qa);\
	docker volume rm $$(docker volume ls -q --filter 'name=inception-*');\
	docker network rm $$(docker network ls -q --filter 'name=inception-*');\

init: ## Initialisation
	mkdir -p _data/mariadb _data/wordpress

.PHONY: all build up down clean init

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
