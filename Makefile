include ./srcs/.env

TOOLS 				= ./srcs/requirements/tools
VOLUMES 			= ${VOLUME_MARIADB} ${VOLUME_WORDPRESS} ${VOLUME_CERTS}
VOLUME_PATHS 	= ${VOLUME_MARIADB_PATH} ${VOLUME_WORDPRESS_PATH} ${VOLUME_CERTS_PATH}


##---  Run  ---##
all:		certs build up

build:	init
				cd srcs && docker compose build

init:
				mkdir -p ${VOLUME_PATHS}

up:
				cd srcs && docker compose up -d
				${TOOLS}/hosts.sh create

down:
				cd srcs && docker compose down


##---  Tools  ---##
certs:	init
				cp ${TOOLS}/certs.sh ${VOLUME_CERTS_PATH}
				chmod +x ${VOLUME_CERTS_PATH}/certs.sh
				cd ${VOLUME_CERTS_PATH} && ./certs.sh ${DOMAIN} ${DOMAIN_IP} ${LOGIN}

hosts:
				${TOOLS}/hosts.sh create


##---  Debug  ---##
logs:
				cd srcs && docker compose logs --tail=200 -f

mariadb: ## Run a shell inside one of the service containers
				cd srcs && docker compose exec -it mariadb sh

wordpress:
				cd srcs && docker compose exec -it wordpress sh

nginx:
				cd srcs && docker compose exec -it nginx sh


##---  Clean  ---##
clean: 	clean_stop clean_rm clean_rmi clean_volume clean_network
				-docker system prune

clean_stop:
				-docker stop $$(docker ps -qa)

clean_rm:
				-docker rm $$(docker ps -qa)

clean_rmi:
				-docker rmi -f $$(docker images -qa)

clean_volume:
				-docker volume rm $$(docker volume ls -q)

clean_network:
				-docker network rm $$(docker network ls -q --filter 'name=srcs_inception')

fclean:	clean
				-docker volume rm ${VOLUMES}
				-sudo rm -rf ${VOLUME_PATHS}
				-${TOOLS}/hosts.sh delete


.PHONY: all build init up down certs hosts logs mariadb wordpress nginx clean \
				clean_stop clean_rm clean_rmi clean_volume clean_network fclean