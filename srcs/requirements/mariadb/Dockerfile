FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache mariadb && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY mdbscript.sh .
RUN chmod +x mdbscript.sh
CMD ["/mdbscript.sh"]
