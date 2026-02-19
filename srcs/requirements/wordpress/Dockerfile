FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache php83-fpm && \
    mkdir -p /run/wordpress

COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf

CMD ["php-fpm83", "-F"]
