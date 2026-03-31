NAME			:= inception
COMPOSE_ROUTE	:= srcs/docker-compose.yml
VOLUMES			:= mariadb_data wordpress_data

all: ${NAME}

${NAME}:
	mkdir -p /home/$$USER/data/mariadb
	mkdir -p /home/$$USER/data/wordpress
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} up -d --remove-orphans

down:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} down

remove:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} down --rmi all --volumes

re:	remove ${NAME}

.PHONY:		all stop down remove re
