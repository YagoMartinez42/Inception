FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache php83 php83-fpm php83-mysqli php83-phar curl tar && \
    mkdir -p /var/www/localhost/htdocs
RUN cd /var/www/localhost/htdocs && \
    wp core download --version=6.9.4 --allow-root

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/wp-cli-2.12.0.phar /var/www/localhost/htdocs
COPY wpscript.sh .
RUN chmod +x wpscript.sh
CMD ["/wpscript.sh"]
