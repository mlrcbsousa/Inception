all: init
	@docker-compose up

down:
	@docker-compose down

re: init
	@docker-compose up --build

clean:
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker volume rm $$(docker volume ls -q);\
	docker network rm $$(docker network ls -q);\

init:
	mkdir -p _data/mariadb _data/wordpress

.PHONY: all re down clean