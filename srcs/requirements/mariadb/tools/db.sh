#!/bin/sh
set -e

echo ">>> ENTRYPOINT STARTED"

# Validate required environment variables
: "${MARIADB_ROOT_PASSWORD:?Error: MARIADB_ROOT_PASSWORD not set}"
: "${MARIADB_DATABASE:?Error: MARIADB_DATABASE not set}"
: "${MARIADB_USER:?Error: MARIADB_USER not set}"
: "${MARIADB_PASSWORD:?Error: MARIADB_PASSWORD not set}"

# Ensure correct ownership (important for mounted volumes)
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Initialize system tables only if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo ">>> Initializing MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal

    echo ">>> Creating initialization SQL..."
    cat << EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;
DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS ''@'%';
DROP DATABASE IF EXISTS test;
ALTER USER root@localhost IDENTIFIED VIA mysql_native_password
  USING PASSWORD('${MARIADB_ROOT_PASSWORD}');
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo ">>> Running bootstrap SQL..."
    mariadbd --user=mysql --datadir=/var/lib/mysql --bootstrap < /tmp/init.sql

    echo ">>> Cleaning up init SQL..."
    rm -f /tmp/init.sql
fi

echo ">>> Starting MariaDB normally..."
exec mariadbd \
  --user=mysql \
  --datadir=/var/lib/mysql \
  --bind-address=0.0.0.0 \
  --port=3306

