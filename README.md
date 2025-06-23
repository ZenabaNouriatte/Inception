# 🏗️ Inception – Projet 42

> Projet réalisé dans le cadre de ma formation à l’école 42.  
> Objectif : Déployer une infrastructure web sécurisée en utilisant Docker et Docker Compose.

---

## 🎯 Objectif pédagogique

Ce projet a pour but de construire une stack de services web **conteneurisée**, tout en respectant des **bonnes pratiques de sécurité**, de modularité et de gestion système.  
Chaque service fonctionne dans un conteneur **Docker isolé**, configuré et orchestré via **Docker Compose**.

---

## 📦 Services déployés

- **Nginx** – Serveur web en reverse proxy avec SSL (certificat auto-signé)
- **WordPress** – CMS hébergé sur une base de données distante
- **MariaDB** – Base de données sécurisée, configurée à l’aide de variables d’environnement

Chaque service est contenu dans son propre conteneur, interconnecté via un **réseau Docker dédié**.

---

## 🧱 Architecture du projet

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

- Configuration des services via fichiers Dockerfile et scripts Bash
- Utilisation d’un `.env` pour la gestion des secrets et paramètres variables
- Certificat SSL généré avec OpenSSL

---

## 🔐 Sécurité & bonnes pratiques

- Utilisation de **certificats SSL auto-signés**
- Création d’un **utilisateur non-root** dans les conteneurs
- Base de données initialisée avec un **mot de passe sécurisé**
- **Volumes persistants** pour les données de WordPress et MariaDB
- Réseau privé Docker pour isoler les services

---

## 🚀 Lancer le projet

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/ZenabaNouriatte/Inception.git
   cd Inception/srcs
   
2. Créer et configurer un fichier .env :


DOMAIN_NAME=login.42.fr
MYSQL_ROOT_PASSWORD=your_root_pwd
MYSQL_USER=your_user
MYSQL_PASSWORD=your_user_pwd
MYSQL_DATABASE=wordpress

3.Lancer l’infrastructure :
make
Accéder à votre site WordPress :

http://login.42.fr
(ou l’IP/nom de domaine configuré sur votre machine via /etc/hosts)

🧠 Compétences développées
Docker & Docker Compose

Configuration de services Linux (Nginx, MariaDB, WordPress)

Automatisation de déploiement

Réseaux, volumes, users, permissions Linux

Gestion de certificats SSL avec OpenSSL

Isolation et sécurité des services en conteneurs
