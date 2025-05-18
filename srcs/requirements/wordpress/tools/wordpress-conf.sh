#!/bin/bash

echo "Waiting for Mariadb to be available"
max_tries=30
count=0

# Boucle d'attente pour 30 essais
while [ $count -lt $max_tries ]; do
    if mysql -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
        echo "MariaDB connexion OK !"
        break
    fi
    echo "Attempt $((count+1))/$max_tries: Unable to connect to MDB, next try in 5sec..."
    sleep 5
    count=$((count+1))
done

# Si la connexion a echoue apres toutes les tentatives
if [ $count -eq $max_tries ]; then
    echo "ERROR: Failed to connect to MariaDB after $max_tries attempts."
    echo "Check the following parameters::"
    echo "Host: ${WORDPRESS_DB_HOST}"
    echo "User: ${WORDPRESS_DB_USER}"
    echo "Database: ${WORDPRESS_DB_NAME}"
    exit 1
fi

# Creation du dossier PHP-FPM
mkdir -p /run/php

# Config de WordPress si pas fait
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress configuration..."
    cd /var/www/html
    
    # Creation de wp-config.php
    wp config create --dbname="${WORDPRESS_DB_NAME}" \
                     --dbuser="${WORDPRESS_DB_USER}" \
                     --dbpass="${WORDPRESS_DB_PASSWORD}" \
                     --dbhost="${WORDPRESS_DB_HOST}" \
                     --dbprefix="${WORDPRESS_TABLE_PREFIX}" \
                     --allow-root
    
    # Installation WordPress
    wp core install --url="${WORDPRESS_URL}" \
                    --title="${WORDPRESS_TITLE}" \
                    --admin_user="${WORDPRESS_ADMIN_USER}" \
                    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
                    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
                    --allow-root
    
    # Creation user supplementaire
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
                  --role=author \
                  --user_pass="${WP_USER_PASSWORD}" \
                  --allow-root
    
    echo "Wordpress config ok !"
fi

# Demarrage PHP-FPM
echo "Demarrage de PHP-FPM..."
exec php-fpm7.4 -F
