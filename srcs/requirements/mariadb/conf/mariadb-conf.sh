#!/bin/bash

#Demarre service Mariadb
service mariadb start

# Attend que Mariadb soit pret a recevoir les requetes
until mariadb -u root -e "SELECT 1;" > /dev/null 2>&1; do
    echo "Waiting for MariaDB to be ready..."
    sleep 0.5
done
echo "MariaDB is ready."

#Executez dans le bash du container mariadb
mariadb -u root <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%';
FLUSH PRIVILEGES;
EOSQL

#Coupe mariadb
mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown
#Redemarre
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
