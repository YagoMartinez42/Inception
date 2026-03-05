FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache php83-fpm php83-mysqli && \
    mkdir -p /run/wordpress

COPY conf/www.conf /etc/php83/php-fpm.d
COPY wp-cli.phar /var/www/localhost/htdocs
COPY wpscript.sh .
RUN chmod +x wpscript.sh
CMD ["/wpscript.sh"]
