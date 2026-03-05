#!/bin/sh

mkdir -p /var/www/localhost/htdocs
cd /var/www/localhost/htdocs
chmod +x wp-cli.phar
./wp-cli.phar core download --allow-root
./wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
./wp-cli.phar core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root

php-fpm83 -F