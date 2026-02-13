NAME			:= inception
COMPOSE_ROUTE	:= srcs/docker-compose.yml
VOLUMES			:= mariadb wordpress
VOL_DIR			:= /home/samartin/data
VOL_ROUTE		:= ${addprefix ${VOL_DIR}/,${VOLUMES}}

all: ${NAME}

${NAME}:
	docker compose -p ${NAME} -f ${COMPOSE_ROUTE} up -d --remove-orphans

.PHONY:		all stop clean fclean re
