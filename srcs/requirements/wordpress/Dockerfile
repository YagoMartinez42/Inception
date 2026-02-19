FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache php83-fpm && \
    mkdir -p /run/wordpress

#We are working with the latest php-fpm version
CMD ["php-fpm83", "-F"]
