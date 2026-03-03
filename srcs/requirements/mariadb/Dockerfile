FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache mariadb && \
    mkdir -p /run/mariadb

COPY conf/mariadb-server.cnf /etc/my.cnf.d
COPY init.sql /etc
COPY mdbscript.sh .
RUN chmod +x mdbscript.sh
CMD ["/mdbscript.sh"]
