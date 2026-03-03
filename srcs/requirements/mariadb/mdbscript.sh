#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=root --datadir=/var/lib/mysql
fi

mariadbd -F