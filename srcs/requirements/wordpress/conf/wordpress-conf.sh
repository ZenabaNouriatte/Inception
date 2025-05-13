#!/bin/bash
set -e

# Attendre que MariaDB soit disponible
until nc -z -v -w30 $WORDPRESS_DB_HOST 3306; do
  echo "En attente de la connexion à MariaDB..."
  sleep 5
done
echo "MariaDB est disponible !"

# Vérifier si wp-config.php existe
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Configuration de WordPress..."
    
    # Copier le fichier de configuration exemple
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    # Configurer la base de données
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/g" /var/www/html/wp-config.php
    sed -i "s/username_here/$WORDPRESS_DB_USER/g" /var/www/html/wp-config.php
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/g" /var/www/html/wp-config.php
    sed -i "s/localhost/$WORDPRESS_DB_HOST/g" /var/www/html/wp-config.php
    sed -i "s/wp_/$WORDPRESS_TABLE_PREFIX/g" /var/www/html/wp-config.php
    
    # Ajouter les clés d'authentification uniques
    for key in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT; do
    raw=$(openssl rand -base64 48)
    escaped=$(printf '%s\n' "$raw" | sed 's/[&/\]/\\&/g')
    sed -i "s/define( '${key}', '.*' );/define( '${key}', '${escaped}' );/g" /var/www/html/wp-config.php
   
    done

    echo "[WordPress] Configuration terminée."
fi

# Lancer PHP-FPM
exec "$@"
