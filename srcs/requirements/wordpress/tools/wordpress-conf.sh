#!/bin/bash

echo "Attente de la disponibilité de MariaDB..."
max_tries=30
count=0

# Boucle d'attente plus robuste
while [ $count -lt $max_tries ]; do
    if mysql -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
        echo "Connexion à MariaDB établie avec succès."
        break
    fi
    echo "Tentative $((count+1))/$max_tries: Connexion à MariaDB impossible, nouvelle tentative dans 5 secondes..."
    sleep 5
    count=$((count+1))
done

if [ $count -eq $max_tries ]; then
    echo "ERREUR: Impossible de se connecter à la base de données après $max_tries tentatives."
    echo "Vérification des paramètres de connexion:"
    echo "Host: ${WORDPRESS_DB_HOST}"
    echo "User: ${WORDPRESS_DB_USER}"
    echo "Database: ${WORDPRESS_DB_NAME}"
    exit 1
fi

# Création du répertoire PHP-FPM
mkdir -p /run/php

# Configuration de WordPress si non configuré
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Configuration de WordPress..."
    cd /var/www/html
    
    # Création de wp-config.php
    wp config create --dbname="${WORDPRESS_DB_NAME}" \
                     --dbuser="${WORDPRESS_DB_USER}" \
                     --dbpass="${WORDPRESS_DB_PASSWORD}" \
                     --dbhost="${WORDPRESS_DB_HOST}" \
                     --dbprefix="${WORDPRESS_TABLE_PREFIX}" \
                     --allow-root
    
    # Installation de WordPress
    wp core install --url="${WORDPRESS_URL}" \
                    --title="${WORDPRESS_TITLE}" \
                    --admin_user="${WORDPRESS_ADMIN_USER}" \
                    --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
                    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
                    --allow-root
    
    # Création d'un utilisateur supplémentaire
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
                  --role=author \
                  --user_pass="${WP_USER_PASSWORD}" \
                  --allow-root
    
    echo "WordPress configuré avec succès."
fi

# Démarrage de PHP-FPM
echo "Démarrage de PHP-FPM..."
exec php-fpm7.4 -F
