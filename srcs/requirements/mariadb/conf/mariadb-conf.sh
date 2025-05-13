#!/bin/bash
set -e

echo "[MariaDB] Préparation du répertoire..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# DEBUG facultatif
env | grep DB_

# Initialisation si la DB n'existe pas
if [ ! -f "/var/lib/mysql/.init_done" ]; then
    echo "[MariaDB] Initialisation de la base..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    echo "[MariaDB] Configuration des utilisateurs et de la base..."
    mysqld --user=mysql --bootstrap --datadir=/var/lib/mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    touch /var/lib/mysql/.init_done
    echo "[MariaDB] Configuration initiale OK."
fi

echo "[MariaDB] Lancement de MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0

