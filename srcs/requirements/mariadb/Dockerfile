FROM alpine:3.23.3

RUN apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/mariadb.cnf /etc/my.cnf.d/
COPY tools/db.sh /usr/local/bin/db.sh
RUN chmod +x /usr/local/bin/db.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/db.sh"]
CMD ["mariadbd", "--user=mysql"]
