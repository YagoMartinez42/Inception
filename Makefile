NAME			:= inception
COMPOSE_ROUTE	:= srcs/docker-compose.yml
VOLUMES			:= mariadb_data wordpress_data
VOL_DIR			:= /home/samartin/data
VOL_ROUTE		:= ${addprefix ${VOL_DIR}/,${VOLUMES}}

all: ${NAME}

${NAME}:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} up -d --remove-orphans

down:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} down

remove:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} down --rmi all --volumes

re:	remove ${NAME}

.PHONY:		all stop down remove re
