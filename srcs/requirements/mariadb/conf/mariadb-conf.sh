#!/bin/bash

# Attendez que le service MariaDB soit prêt
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialiser la base de données MariaDB
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Démarrer temporairement le serveur MariaDB
    /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
    
    # Attendre que le serveur soit prêt
    until mysqladmin ping &>/dev/null; do
        echo "Waiting for MariaDB to be ready..."
        sleep 1
    done
    
    # Configurer la base de données
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
    
    # Arrêter le serveur temporaire
    mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown
    sleep 5
fi

# Exécuter la commande passée en argument (généralement mysqld)
exec mysqld_safe --socket=/run/mysqld/mysqld.sock --datadir='/var/lib/mysql'

