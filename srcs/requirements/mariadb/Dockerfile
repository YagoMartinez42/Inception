FROM alpine:3.22

RUN mkdir /docker-entrypoint-initdb.d

RUN apk update && apk upgrade && \
    apk add --no-cache mariadb && \
    mkdir -p /run/mariadb

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/.
COPY ./init.sql /etc/.

CMD ["mariadbd", "-F"]
