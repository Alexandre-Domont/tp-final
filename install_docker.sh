#!/bin/bash
set -e

echo "=== Mise à jour du système ==="
apt update -y && apt upgrade -y

echo "=== Installation des dépendances ==="
apt install -y ca-certificates curl gnupg lsb-release

echo "=== Ajout de la clé GPG Docker ==="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg \
    | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "=== Ajout du dépôt Docker ==="
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
$(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list

echo "=== Mise à jour des dépôts ==="
apt update -y

echo "=== Installation de Docker ==="
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Démarrage de Docker ==="
systemctl enable docker
systemctl start docker

echo "=== Vérification des versions ==="
docker --version
docker compose version || true

echo "=== Installation de Docker Compose standalone ==="
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "=== Installation terminée ! ==="
