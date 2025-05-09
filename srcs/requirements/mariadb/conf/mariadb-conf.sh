#!/bin/bash
set -e

echo "[MariaDB] Création du répertoire /run/mysqld"
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Si la base n’est pas encore initialisée
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "[MariaDB] Initialisation de la base"
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	echo "[MariaDB] Démarrage temporaire..."
	mysqld_safe --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock &
	sleep 5

	echo "[MariaDB] Configuration initiale"
	mysql -u root <<-EOF
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
		CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
		FLUSH PRIVILEGES;
	EOF

	echo "[MariaDB] Arrêt du serveur temporaire"
	mysqladmin -uroot -p${DB_ROOT_PASSWORD} shutdown
	sleep 3
fi

# Lancer MariaDB en mode normal
echo "[MariaDB] Lancement final de MariaDB"
exec mysqld_safe --datadir=/var/lib/mysql --socket=/run/mysqld/mysqld.sock --bind-address=0.0.0.0

