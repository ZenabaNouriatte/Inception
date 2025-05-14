#!/bin/bash
set -e

echo "[MariaDB] Préparation du répertoire..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# DEBUG facultatif : afficher les variables d'env
env | grep DB_

# Vérifier si déjà initialisé
if [ ! -f "/var/lib/mysql/.init_completed" ]; then
    echo "[MariaDB] Initialisation de la base de données..."

    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql
    fi

    echo "[MariaDB] Configuration des utilisateurs et privilèges..."

    mysqld --bootstrap --user=mysql --datadir=/var/lib/mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

DROP USER IF EXISTS '${DB_USER}'@'%';
CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    touch /var/lib/mysql/.init_completed
    echo "[MariaDB] Initialisation terminée."
fi

echo "[MariaDB] Lancement du serveur..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0 --console
