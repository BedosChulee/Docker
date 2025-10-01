#!/bin/bash

# Script pour démarrer l'environnement de développement PostgreSQL avec Adminer
# Ce script démarre la base de données et l'interface d'administration Adminer

set -e

echo "=== Démarrage de l'environnement de développement PostgreSQL ==="
echo ""

# Vérifier que le fichier de mot de passe existe
if [ ! -f "secrets/db_password.txt" ]; then
    echo "Création du fichier de mot de passe..."
    mkdir -p secrets
    echo "postgres" > secrets/db_password.txt
    chmod 600 secrets/db_password.txt
    echo "✓ Fichier de mot de passe créé avec le mot de passe par défaut"
fi

# Démarrer la base de données
echo "Démarrage de la base de données PostgreSQL..."
docker-compose up -d --build

# Attendre que PostgreSQL soit prêt
echo "Attente que PostgreSQL soit prêt..."
timeout=60
counter=0

while [ $counter -lt $timeout ]; do
    if docker-compose exec -T db pg_isready -U postgres -d postgres > /dev/null 2>&1; then
        echo "✓ PostgreSQL est prêt !"
        break
    fi
    
    echo "Attente... ($counter/$timeout)"
    sleep 2
    counter=$((counter + 2))
done

if [ $counter -ge $timeout ]; then
    echo "❌ Timeout : PostgreSQL n'est pas devenu prêt dans les $timeout secondes"
    docker-compose logs db
    exit 1
fi

# Démarrer Adminer avec le profil dev
echo ""
echo "Démarrage d'Adminer..."
docker-compose -f docker-compose.yml -f docker-compose.dev.yml --profile dev up -d

echo ""
echo "=== Environnement de développement prêt ==="
echo ""
echo "🗄️  PostgreSQL : accessible via le réseau Docker 'database'"
echo "🌐 Adminer : http://localhost:8080"
echo ""
echo "Informations de connexion Adminer :"
echo "  Système : PostgreSQL"
echo "  Serveur : db"
echo "  Utilisateur : postgres"
echo "  Mot de passe : $(cat secrets/db_password.txt)"
echo "  Base de données : postgres"
echo ""
echo "Pour arrêter l'environnement :"
echo "  docker-compose -f docker-compose.yml -f docker-compose.dev.yml --profile dev down"