#!/bin/sh
set -xe

DATADIR="/var/lib/mysql"
SOCKET_DIR="/run/mysqld"
SOCKET="${SOCKET_DIR}/mysqld.sock"
INIT_MARKER="${DATADIR}/.inception_initialized"
MYSQL_CLIENT="mariadb"
MYSQLADMIN_CLIENT="mariadb-admin"
BIND_ADDR="0.0.0.0"

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
    mariadb-install-db --user=mysql --datadir="${DATADIR}"
fi

chown -R mysql:mysql "${DATADIR}"

if [ ! -f "${INIT_MARKER}" ]; then
  echo "Initializing database '${DB_NAME}' and user '${DB_USER}'..."
  mariadbd --user=mysql --datadir="${DATADIR}" --skip-networking --socket="${SOCKET}" &
  pid="$!"
  sleep 2
  
  if ! kill -0 "$pid" 2>/dev/null; then
    echo "ERROR: mariadbd failed to start. Check logs:"
    cat /tmp/mariadb-init.log
    exit 1
  fi

WAIT_TIME=0
until [ -S "${SOCKET}" ] && "${MYSQLADMIN_CLIENT}" --socket="${SOCKET}" --host=localhost ping >/dev/null 2>&1; do
  WAIT_TIME=$((WAIT_TIME + 1))
  if [ $WAIT_TIME -gt 30 ]; then
    echo "ERROR: MariaDB socket not ready after 30s. Socket file exists: $([ -S "${SOCKET}" ] && echo 'yes' || echo 'no')"
    echo "Attempting to get mariadbd status..."
    if ! kill -0 "$pid" 2>/dev/null; then
      echo "ERROR: mariadbd process died!"
      cat /tmp/mariadb-init.log 2>/dev/null || echo "No init log available"
    fi
    exit 1
  fi
  sleep 1
done

  "${MYSQL_CLIENT}" --socket="${SOCKET}" --host=localhost <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

  touch "${INIT_MARKER}"
  chown mysql:mysql "${INIT_MARKER}"
  "${MYSQLADMIN_CLIENT}" --socket="${SOCKET}" --host=localhost -uroot -p"${ROOT_PASS}" shutdown
  wait "$pid"
  echo "Initialization done."
fi

exec mariadbd --user=mysql --datadir="${DATADIR}" --socket="${SOCKET}"