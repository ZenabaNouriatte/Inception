#!/bin/bash

service mariadb start

until mariadb -u root -e "SELECT 1;" > /dev/null 2>&1; do
    echo "En attente de MariaDB..."
    sleep 0.5
done


mariadb -u root <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO \`${DB_USER}\`@'%';
FLUSH PRIVILEGES;
EOSQL


mysqladmin -u root -p$DB_ROOT_PASSWORD shutdown
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
