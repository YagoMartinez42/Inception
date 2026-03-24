#!/bin/sh
set -e

DATADIR="/var/lib/mysql"
SOCKET_DIR="/run/mysqld"
SOCKET="${SOCKET_DIR}/mysqld.sock"
INIT_MARKER="${DATADIR}/.inception_initialized"
MYSQL_CLIENT="mariadb"
MYSQLADMIN_CLIENT="mariadb-admin"

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
DB_PASS="$(read_secret /run/secrets/db_password)"
ROOT_PASS="$(read_secret /run/secrets/db_root_password)"

if [ -z "$DB_PASS" ] || [ -z "$ROOT_PASS" ]; then
  echo "Error: db_password and/or db_root_password secret is missing/empty"
  exit 1
fi

mkdir -p "$SOCKET_DIR"
chown -R mysql:mysql "$SOCKET_DIR"

if [ ! -d "${DATADIR}/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

chown -R mysql:mysql "${DATADIR}"

if [ ! -f "${INIT_MARKER}" ]; then
  echo "Initializing database '${DB_NAME}' and user '${DB_USER}'..."
  mariadbd --user=mysql --datadir="${DATADIR}" --skip-networking --socket="${SOCKET}" &
  pid="$!"

  until "${MYSQLADMIN_CLIENT}" --socket="${SOCKET}" ping >/dev/null 2>&1; do
    sleep 1
  done

  "${MYSQL_CLIENT}" --socket="${SOCKET}" <<-SQL
      ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';
      CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
      CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
      GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
      FLUSH PRIVILEGES;
SQL

  touch "${INIT_MARKER}"
  chown mysql:mysql "${INIT_MARKER}"
  "${MYSQLADMIN_CLIENT}" --socket="${SOCKET}" -uroot -p"${ROOT_PASS}" shutdown
  wait "$pid"
  echo "Initialization done."
fi

exec mariadbd --console --user=mysql --datadir="${DATADIR}"