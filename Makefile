NAME			:= inception
COMPOSE_ROUTE	:= srcs/docker-compose.yml
VOLUMES			:= mariadb wordpress
VOL_DIR			:= /home/samartin/data
VOL_ROUTE		:= ${addprefix ${VOL_DIR}/,${VOLUMES}}

all: ${NAME}

${NAME}:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} up -d --remove-orphans

stop:
	docker compose -f ${COMPOSE_ROUTE} down

down:
	docker compose -f ${COMPOSE_ROUTE} down

remove:
	docker compose -f ${COMPOSE_ROUTE} down --rmi all --volumes
	sudo rm -rf srcs/database srcs/web

.PHONY:		all stop down remove re
