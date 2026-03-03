FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add --no-cache nginx openssl && \
    mkdir -p /run/nginx

COPY ./conf/default.conf /etc/nginx/http.d

CMD ["nginx", "-g", "daemon off;"]
