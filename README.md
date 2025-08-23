# Inception – Projet 42
> Projet école 42.

> Objectif : Déployer rapidement une infrastructure web sécurisée et scalable sans utiliser d'images Docker Hub, utilisable comme base pour un intranet, un blog d’entreprise etc.

---

## Objectif technique du sujet
> Construire une stack de services web **conteneurisée**, tout en respectant des **bonnes pratiques de sécurité**, de modularité et de gestion système.  
Chaque service fonctionne dans un conteneur **Docker isolé**, configuré et orchestré via **Docker Compose**.

---

## Services déployés
- **Nginx** – Serveur web en reverse proxy avec SSL (certificat auto-signé)
- **WordPress** – CMS hébergé sur une base de données distante
- **MariaDB** – Base de données sécurisée, configurée à l'aide de variables d'environnement

Chaque service est contenu dans son propre conteneur, interconnecté via un **réseau Docker dédié**.

## Technologies
- Docker & Docker Compose
- NGINX (reverse proxy + SSL)
- MariaDB (base de données)
- WordPress + PHP-FPM
- Makefile automation

## Résultats
+ Temps de déploiement : < 5 min :  automatisé en 1 commande
+ 100% des services isolés réseau
+ Données persistantes après redémarrage
+ SSL/TLS configuré
  
---

##  Architecture du projet
```
inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── requirements/
│   │   ├── mariadb/
│   │   │   └── conf/
│   │   ├── nginx/
│   │   │   └── conf/
│   │   └── wordpress/
│   │       └── tools/
│   └── .env
├── Makefile
└── README.md
```

- Configuration des services via fichiers Dockerfile et scripts Bash
- Utilisation d'un `.env` pour la gestion des secrets et paramètres variables
- Certificat SSL généré avec OpenSSL

---

##  Sécurité & bonnes pratiques
- Utilisation de **certificats SSL auto-signés**
- Création d'un **utilisateur non-root** dans les conteneurs
- Base de données initialisée avec un **mot de passe sécurisé**
- **Volumes persistants** pour les données de WordPress et MariaDB
- Réseau privé Docker pour isoler les services

---

##  Lancer le projet

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/ZenabaNouriatte/Inception.git
   cd Inception/srcs
   ```
   
2. Créer et configurer un fichier `.env` :
   ```env
   DOMAIN_NAME=login.42.fr
   MYSQL_ROOT_PASSWORD=your_root_pwd
   MYSQL_USER=your_user
   MYSQL_PASSWORD=your_user_pwd
   MYSQL_DATABASE=wordpress
   ```

3. Lancer l'infrastructure :
   ```bash
   make
   ```

4. Accéder à votre site WordPress :
   ```
   https://login.42.fr
   ```
   (ou l'IP/nom de domaine configuré sur votre machine via `/etc/hosts`)

---
##   Résultat en images

- Compilation et lancement avec Docker Compose :
  ```bash
   Make
   ```
  ![Build & Compose](Screenshots/Screenshot%20from%202025-07-11%2011-08-13.png)

- Conteneurs en cours d’exécution :
  ```bash
   sudo docker ps
   ```
  ![Docker PS](Screenshots/Screenshot%20from%202025-07-11%2010-58-10.png)
  
- Page de connexion WordPress
  
  ![Login WordPress](Screenshots/Screenshot%20from%202025-07-11%2010-52-58.png)
  
- Accès au site WordPress via HTTPS
  
  ![Site WordPress actif](Screenshots/Screenshot%20from%202025-07-11%2010-52-43.png)
  
- Tableau de bord WordPress
  
  ![Dashboard WordPress](Screenshots/Screenshot%20from%202025-07-11%2010-53-24.png)
  
- Bonus : Interface Adminer connectée à la base de données
  
  ![Adminer](Screenshots/Screenshot%20from%202025-07-11%2011-06-37.png)

- Bonus : Site statique exposé sur un port différent
  
  ![Site HTML bonus](Screenshots/Screenshot%20from%202025-07-11%2011-06-00.png)

## Test
+ Page d’accueil WordPress s’affiche 
+ Installation guidée atteignable 
+ Upload média persistant après make down && make up 
+ Redirections HTTP→HTTPS 
  
##  Compétences développées
- Docker & Docker Compose
- Configuration de services Linux (Nginx, MariaDB, WordPress)
- Automatisation de déploiement
- Réseaux, volumes, users, permissions Linux
- Gestion de certificats SSL avec OpenSSL
- Isolation et sécurité des services en conteneurs
