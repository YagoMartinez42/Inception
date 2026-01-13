FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache php-fpm && \
    mkdir -p /run/wordpress

# COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

#With this, we make an alias so we can run any version of php-fpm even if #the one downloaded with apk is newest than the latests available when this
#Dockerfile was created
RUN ln -s $(find usr/sbin/ -name "php-fpm*" usr/sbin/php-fpm

CMD ["php-fpm", "-F"]
