FROM alpine:3.22

RUN apk update && apk upgrade && \
    apk add nginx openssl && \
    mkdir -p /run/nginx

# COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
