FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache php83 php83-fpm php83-mysqli php83-phar php83-intl php83-iconv php83-mbstring curl tar && \
    mkdir -p /var/www/localhost/htdocs
RUN curl -fsSL -o /usr/local/bin/wp \
      https://github.com/wp-cli/wp-cli/releases/download/v2.12.0/wp-cli-2.12.0.phar && \
    chmod +x /usr/local/bin/wp && \
    wp --info --allow-root

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY wpscript.sh .
RUN chmod +x wpscript.sh
CMD ["/wpscript.sh"]
