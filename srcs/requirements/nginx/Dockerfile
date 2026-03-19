FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache nginx openssl && \
    mkdir -p /run/nginx && \
    mkdir -p /var/www/localhost/htdocs && \
    mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/key.pem -out /etc/nginx/ssl/cert.pem \
    -sha256 -days 3650 -nodes \
    -subj "/C=ES/ST=Madrid/L=Madrid/O=42Madrid/OU=Students/CN=samartin.42.fr"

COPY conf/default.conf /etc/nginx/http.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
