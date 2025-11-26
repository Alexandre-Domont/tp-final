Voici une version améliorée de votre README.md, avec une structure plus claire, une mise en forme uniforme, et une section expliquant **Docker** et **Docker Compose** :

````markdown
# Tutoriel d’installation

Ce guide explique comment **réinstaller entièrement** l’environnement WordPress + Zabbix depuis ce repository GitHub.

---

## 1. Prérequis

Avant de commencer, assurez-vous que votre VM dispose de :

- Git installé
- Un accès internet
- Les ports 8080 et 8081 libres pour WordPress et Zabbix

---

## 2. Récupération du projet depuis GitHub

Clonez le repository sur votre VM :

```bash
git clone https://github.com/Alexandre-Domont/tp-final.git
````

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

## 8. Conseils supplémentaires

* Sauvegardez régulièrement vos données WordPress et Zabbix.
* Vérifiez les fichiers de configuration dans `docker-compose.yml` pour ajuster les ports ou volumes si nécessaire.
* Pour toute modification majeure, pensez à recréer les conteneurs avec :

```bash
docker compose down
docker compose up -d --build
```

```

---

Si tu veux, je peux aussi créer une **version encore plus visuelle et friendly** avec des emojis, sections colorées et des encadrés pour Docker et Docker Compose pour que ton README soit ultra clair et moderne.  

Veux‑tu que je fasse ça ?
```
