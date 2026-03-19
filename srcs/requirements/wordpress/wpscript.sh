#!/bin/sh
set -e

mkdir -p /var/www/localhost/htdocs
cd /var/www/localhost/htdocs

if [ ! -f wp-settings.php ]; then
    wp core download --version=6.9.4 --allow-root
fi

if [ ! -f wp-config.php ]; then
    PHP="php -d memory_limit=512M"
    $PHP /usr/local/bin/wp config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
    $PHP /usr/local/bin/wp core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root
fi

php-fpm83 -F