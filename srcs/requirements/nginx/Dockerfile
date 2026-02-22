FROM alpine:3.23.2

RUN apk add --no-cache nginx \
 && mkdir -p /etc/nginx/ssl

# Generate certs
RUN apk add --no-cache nginx openssl &&\
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mkokorev.42.fr.key \
    -out /etc/nginx/ssl/mkokorev.42.fr.crt \
    -subj "/CN=mkokorev.42.fr"

# Copy nginx config
COPY conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
