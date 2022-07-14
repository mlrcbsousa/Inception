all: init
	@docker-compose up

down:
	@docker-compose down

build: init
	@docker-compose build

clean:
	@docker stop $$(docker ps -qa --filter 'name=inception-*');\
	docker rm $$(docker ps -qa --filter 'name=inception-*');\
	docker rmi -f $$(docker images "inception_*" -qa);\
	docker volume rm $$(docker volume ls -q --filter 'name=inception-*');\
	docker network rm $$(docker network ls -q --filter 'name=inception-*');\

init:
	mkdir -p _data/mariadb _data/wordpress

.PHONY: all build down clean init
