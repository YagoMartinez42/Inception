#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

chown -R mysql:mysql /var/lib/mysql

mariadbd --console --user=mysql