
### Tutoriel d’installation pour Debian 12

Ce guide pour **réinstaller** l’environnement WordPress + Zabbix depuis ce repository GitHub.

---

## 1. Prérequis

Avant de commencer, assurez-vous que votre VM dispose de :

- Git installé
```bash
apt install git
```
- Un accès internet
- Les ports 8080 et 8081 libres pour WordPress et Zabbix

---

## 2. Récupération du projet depuis GitHub

Clonez le repository sur votre VM :

```bash
git clone https://github.com/Alexandre-Domont/tp-final.git
```

Entrez ensuite dans le dossier du projet :

```bash
cd tp-final
```

### ▶️ Rendez le script d’installation exécutable

```bash
chmod +x install_docker.sh
```

### ▶️ Lancez l’installation

```bash
./install_docker.sh
```

Une fois l’installation terminée, vérifiez que Docker et Docker Compose sont bien installés :

```bash
docker --version
docker compose version
```

---

## 3. Introduction à Docker et Docker Compose

### Docker

Docker est une plateforme qui permet de **créer, déployer et exécuter des applications dans des conteneurs**.
Un conteneur est un environnement léger, isolé et portable qui contient tout ce dont une application a besoin pour fonctionner (code, bibliothèques, dépendances).

**Avantages :**

* Isolation complète des applications
* Portabilité entre différents systèmes
* Déploiement rapide

### Docker Compose

Docker Compose est un outil qui permet de **définir et gérer des applications multi-conteneurs** à l’aide d’un fichier `docker-compose.yml`.
Au lieu de lancer chaque conteneur individuellement, vous pouvez tout déployer en une seule commande.

---

## 4. Installation de WordPress + Zabbix

Une fois Docker installé, vous pouvez déployer l’environnement complet depuis le dossier contenant le fichier `docker-compose.yml`.

### Méthode recommandée

```bash
docker compose up -d
```

### Pour les anciennes versions utilisant l’ancien binaire

```bash
docker-compose up -d
```

| Outil      | Fonction principale               |
|------------|-----------------------------------|
| WordPress  | Création de sites / gestion de contenu |
| Zabbix     | Supervision réseau et infrastructure |

---

## 5. Vérifier que tout fonctionne

Pour voir les conteneurs en cours d’exécution :

```bash
docker ps
```

Vous devriez voir au moins les conteneurs WordPress et Zabbix actifs.

---

## 6. Accès aux services

### 🔵 WordPress

Accédez à WordPress via votre navigateur :

```
http://IP_DE_VOTRE_VM:8080
```

### 🔴 Zabbix

Accédez à Zabbix via :

```
http://IP_DE_VOTRE_VM:8081
```

Identifiants par défaut :

| Champ            | Valeur |
| ---------------- | ------ |
| **Login**        | Admin  |
| **Mot de passe** | zabbix |

⚠️ Pensez à changer ce mot de passe après la première connexion.

---

## 7. Commandes Docker utiles

### Arrêter tout l’environnement

```bash
docker compose down
```

### Redémarrer les services

```bash
docker compose restart
```

### Voir les logs en temps réel

```bash
docker compose logs -f
```
---

# 📘 **docker-compose.yml avec explications**

```yaml
version: "3.9"                # Version du format Docker Compose

services:                     # Début de la section des services (conteneurs)

  # WORDPRESS — Base de données

  wordpress-db:
    image: mariadb:11         # Image MariaDB version 11
    restart: always           # Redémarre automatiquement en cas d’arrêt
    environment:              # Variables d’environnement pour configurer MySQL
      MYSQL_ROOT_PASSWORD: rootpassword   # Mot de passe root MySQL
      MYSQL_DATABASE: wordpress           # Base WordPress à créer
      MYSQL_USER: wpuser                 # Utilisateur MySQL pour WordPress
      MYSQL_PASSWORD: wppass             # Mot de passe de wpuser
    volumes:
      - wp-db:/var/lib/mysql  # Volume persistant pour les données MySQL


  # WORDPRESS — Application web

  wordpress:
    image: wordpress:latest   # Image officielle WordPress
    restart: always           # Redémarre automatiquement
    ports:
      - "8080:80"             # WordPress sera accessible sur http://IP:8080
    environment:
      WORDPRESS_DB_HOST: wordpress-db    # Nom du conteneur DB WordPress
      WORDPRESS_DB_USER: wpuser          # Identifiant MySQL
      WORDPRESS_DB_PASSWORD: wppass      # Mot de passe MySQL
      WORDPRESS_DB_NAME: wordpress       # Nom de la base WordPress
    volumes:
      - wp-data:/var/www/html # Stockage persistant des fichiers WordPress
    depends_on:
      - wordpress-db          # WordPress attend que la DB soit prête

  # ZABBIX — Base de donnée
  zabbix-db:
    image: mariadb:11         # Image MariaDB version 11
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: zabbixroot   # Mot de passe root MySQL
      MYSQL_DATABASE: zabbix            # Base Zabbix
      MYSQL_USER: zabbix                # Utilisateur Zabbix
      MYSQL_PASSWORD: zabbixpass        # Mot de passe utilisateur
    volumes:
      - zabbix-db:/var/lib/mysql        # Volume persistant Zabbix DB

  # ZABBIX — Serveur
  
  zabbix-server:
    image: zabbix/zabbix-server-mysql:latest   # Serveur Zabbix + support MySQL
    restart: always
    environment:              # Connexion à la base de données Zabbix
      DB_SERVER_HOST: zabbix-db     # Adresse de la base (nom du service)
      MYSQL_USER: zabbix            # Identifiant MySQL
      MYSQL_PASSWORD: zabbixpass    # Mot de passe MySQL
      MYSQL_DATABASE: zabbix        # Nom de la base Zabbix
    depends_on:
      - zabbix-db            # Zabbix server démarre après la DB

  
  # ZABBIX — Interface web

  zabbix-frontend:
    image: zabbix/zabbix-web-nginx-mysql:latest  # Interface web Zabbix (Nginx + PHP)
    restart: always
    ports:
      - "8081:8080"        # Zabbix Web accessible sur http://IP:8081
    environment:
      DB_SERVER_HOST: zabbix-db   # Adresse de la base de Zabbix
      MYSQL_USER: zabbix          # Identifiant MySQL
      MYSQL_PASSWORD: zabbixpass  # Mot de passe MySQL
      MYSQL_DATABASE: zabbix      # Nom de la base Zabbix
      PHP_TZ: "Europe/Paris"      # Fuseau horaire PHP
    depends_on:
      - zabbix-server       # Le frontend attend le serveur Zabbix


  #  ZABBIX — Agent
  
  zabbix-agent:
    image: zabbix/zabbix-agent:latest   # Agent Zabbix installé dans un conteneur
    restart: always
    environment:
      ZBX_SERVER_HOST: zabbix-server    # Adresse du serveur Zabbix pour envoyer les données
    depends_on:
      - zabbix-server                   # L’agent attend le serveur


# VOLUMES PERSISTANTS

volumes:
  wp-db:          # Volume pour base WordPress
  wp-data:        # Volume pour fichiers WordPress
  zabbix-db:      # Volume pour base Zabbix
```

---

# 📘 **install_docker.sh avec explications**

```bash
#!/bin/bash
set -e   # Arrête le script si une commande échoue

echo "=== Mise à jour du système ==="
apt update -y && apt upgrade -y   # Met à jour la liste des paquets puis les met à niveau

echo "=== Installation des dépendances ==="
apt install -y ca-certificates curl gnupg lsb-release   # Installe les utilitaires nécessaires pour ajouter le dépôt Docker

echo "=== Ajout de la clé GPG Docker ==="
install -m 0755 -d /etc/apt/keyrings   # Crée le dossier des clés APT s’il n’existe pas
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg    # Télécharge et convertit la clé GPG Docker
chmod a+r /etc/apt/keyrings/docker.gpg   # Permet à APT de lire la clé

echo "=== Ajout du dépôt Docker ==="
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
$(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list   # Ajoute le dépôt officiel Docker à APT

echo "=== Mise à jour des dépôts ==="
apt update -y   # Recharge la liste des paquets incluant maintenant Docker

echo "=== Installation de Docker ==="
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Installe le moteur Docker, le client, containerd, Buildx et Docker Compose v2

echo "=== Démarrage de Docker ==="
systemctl enable docker   # Active Docker au démarrage
systemctl start docker    # Démarre Docker maintenant

echo "=== Vérification des versions ==="
docker --version          # Affiche la version de Docker
docker compose version || true   # Vérifie la version de Docker Compose v2 (n'échoue pas si absent)

echo "=== Installation de Docker Compose standalone ==="
if ! command -v docker-compose &> /dev/null; then   # Si docker-compose (v1) n'est pas installé
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose              # Télécharge Docker Compose v1 standalone
    chmod +x /usr/local/bin/docker-compose            # Rend le binaire exécutable
fi

echo "=== Installation terminée ! ==="   # Message final
```
