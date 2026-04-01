#!/bin/sh
set -e

read_secret() {
  file="$1"
  if [ -f "$file" ]; then
    tr -d '\r\n' < "$file"
  else
    echo ""
  fi
}

DB_NAME="${MYSQL_DATABASE:-wordpress}"
DB_USER="${MYSQL_USER:-wpuser}"
DB_HOST="${MYSQL_HOST:-mariadb}"
DB_PASS="$(read_secret /run/secrets/db_password)"

WP_URL="${WP_URL:-samartin.42.fr}"
WP_TITLE="${WP_TITLE:-inception}"
WP_ADMIN_USER="${WP_ADMIN_USER:-admin}"
WP_ADMIN_EMAIL="${WP_ADMIN_EMAIL:-admin@admin.com}"
WP_ADMIN_PASS="$(read_secret /run/secrets/wp_admin_password)"

if [ -z "$DB_PASS" ] || [ -z "$WP_ADMIN_PASS" ]; then
  echo "Error: db_password and/or wp_admin_password secret is missing/empty"
  exit 1
fi

mkdir -p /var/www/localhost/htdocs
cd /var/www/localhost/htdocs
  PHP="php -d memory_limit=512M"

if [ ! -f wp-settings.php ]; then
    $PHP $(which wp) core download --version=6.9.4 --allow-root
fi

if [ ! -f wp-config.php ]; then

  $PHP /usr/local/bin/wp config create \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASS}" \
    --dbhost="${DB_HOST}" \
    --allow-root

  $PHP /usr/local/bin/wp core install \
    --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_USER}" \
    --admin_password="${WP_ADMIN_PASS}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root
fi

exec php-fpm83 -F