#!/bin/sh

mkdir -p /var/www/localhost/htdocs
cd /var/www/localhost/htdocs
chmod +x wp-cli.phar

if [ ! -f wp-config.php ]; then
    PHP="php -d memory_limit=512M"
    $PHP wp-cli.phar core download --allow-root
    $PHP wp-cli.phar config create --dbname=wordpress --dbuser=wpuser --dbpass=password --dbhost=mariadb --allow-root
    $PHP wp-cli.phar core install --url=localhost --title=inception --admin_user=admin --admin_password=admin --admin_email=admin@admin.com --allow-root
fi

php-fpm83 -F