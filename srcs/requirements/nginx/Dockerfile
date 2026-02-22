FROM alpine:3.23.2

RUN apk add --no-cache nginx \
 && mkdir -p /etc/nginx/ssl

# Copy certs
COPY tools/mkokorev.42.fr.crt /etc/nginx/ssl/
COPY tools/mkokorev.42.fr.key /etc/nginx/ssl/

# Copy nginx config
COPY conf/nginx.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
