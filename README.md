#Tutoriel d’installation

Ce guide explique comment **réinstaller entièrement** l’environnement WordPress + Zabbix depuis le repository GitHub.

---

#Récupération du projet depuis GitHub

Sur votre VM, commencez par cloner le repo :

```bash
git clone https://github.com/Alexandre-Domont/tp-final.git
```

Puis entrez dans le dossier :

```bash cd tp-final ```

### ▶️ Rendez le script exécutable :

```bash
chmod +x install_docker.sh
```

### ▶️ Lancez l’installation :

```bash
./install_docker.sh
```

Une fois terminé, vérifiez l’installation :

```bash
docker --version
docker compose version
```

---

#Installation de WordPress + Zabbix
#Lancer l’environnement Docker

Une fois Docker installé, vous pouvez tout déployer en une seule commande.

Depuis le dossier où se trouve votre `docker-compose.yml` :

### Méthode recommandée :

```bash
docker compose up -d
```

### Si votre VM utilise encore l’ancien binaire :

```bash
docker-compose up -d
```

---

#Vérifier que tout fonctionne

Affichez les conteneurs en cours d’exécution :

```bash
docker ps
```

# 🌐 6. Accès aux services

### 🔵 WordPress

Accédez à WordPress via votre navigateur :

```
http://IP_DE_VOTRE_VM:8080
```
---

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

# 🧹 7. Commandes utiles

### Arrêter tout l’environnement

```bash
docker compose down
```

### Redémarrer les services

```bash
docker compose restart
```

### Voir les logs

```bash
docker compose logs -f
```

---

