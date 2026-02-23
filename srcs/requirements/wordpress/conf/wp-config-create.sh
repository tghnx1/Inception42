#!/bin/sh

set -e

echo ">>> Waiting for MariaDB..."
until nc -z mariadb 3306; do
  sleep 1
done
echo ">>> MariaDB is ready!"

: "${MARIADB_DATABASE:?Missing MARIADB_DATABASE}"
: "${MARIADB_USER:?Missing MARIADB_USER}"
: "${MARIADB_PASSWORD:?Missing MARIADB_PASSWORD}"
: "${DB_HOST:?Missing DB_HOST}"
: "${DOMAIN_NAME:?Missing DOMAIN_NAME}"
: "${WP_ADMIN_USER:?Missing WP_ADMIN_USER}"
: "${WP_ADMIN_PASS:?Missing WP_ADMIN_PASS}"
: "${WP_ADMIN_EMAIL:?Missing WP_ADMIN_EMAIL}"
: "${WP_USER:?Missing WP_USER}"
: "${WP_USER_PASS:?Missing WP_USER_PASS}"
: "${WP_USER_EMAIL:?Missing WP_USER_EMAIL}"

# Ensure WP_ADMIN_USER does not contain "admin" (42 requirement)
case "$(echo "$WP_ADMIN_USER" | tr '[:upper:]' '[:lower:]')" in
  *admin*)
    echo "ERROR: WP_ADMIN_USER ('${WP_ADMIN_USER}') must not contain 'admin'. Aborting."
    exit 1
    ;;
esac

# Copy WordPress core if volume empty
if [ ! -f /var/www/index.php ]; then
  echo ">>> Copying WordPress core..."
  cp -r /usr/src/wordpress/* /var/www/
fi

# Create wp-config.php if missing
if [ ! -f /var/www/wp-config.php ]; then
  echo ">>> Creating wp-config.php..."
  wp config create \
    --path=/var/www \
    --dbname="${MARIADB_DATABASE}" \
    --dbuser="${MARIADB_USER}" \
    --dbpass="${MARIADB_PASSWORD}" \
    --dbhost="${DB_HOST}" \
    --allow-root
fi

# Install WordPress if not installed
if ! wp core is-installed --path=/var/www --allow-root; then
  echo ">>> Installing WordPress..."
  wp core install \
    --path=/var/www \
    --url="https://${DOMAIN_NAME}" \
    --title="${LOGIN}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root
  echo ">>> WordPress installed!"

  # Create second user (required by 42)
  wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --path=/var/www \
    --user_pass="${WP_USER_PASS}" \
    --role=author \
    --allow-root
  echo ">>> Second user created!"
else
  echo ">>> WordPress already installed, skipping."
fi

  # Set correct permissions for WordPress

echo ">>> Setting permissions..."

# Main dir owned by root - not writable by php-fpm (nobody)
chown -R root:root /var/www
find /var/www -type d -exec chmod 755 {} \;
find /var/www -type f -exec chmod 644 {} \;

# wp-content and subdirs owned by nobody - writable by php-fpm
chown -R nobody:nobody /var/www/wp-content
chmod 775 /var/www/wp-content
mkdir -p /var/www/wp-content/uploads
chmod -R 775 /var/www/wp-content/uploads
chmod -R 775 /var/www/wp-content/plugins
chmod -R 775 /var/www/wp-content/themes

echo ">>> Permissions set!"
exec "$@"
