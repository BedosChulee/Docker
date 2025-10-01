#!/bin/bash

# Script de test pour docker-compose PostgreSQL
# Ce script démarre le service, attend qu'il soit prêt, et exécute les validations

set -e

echo "=== Test Docker Compose PostgreSQL Setup ==="
echo ""

# Nettoyer les conteneurs existants
echo "Nettoyage des conteneurs existants..."
docker-compose down -v 2>/dev/null || true

# Construire et démarrer les services
echo "Construction et démarrage des services..."
docker-compose up -d --build

# Attendre que le service soit prêt
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

# Exécuter les validations
echo ""
echo "Exécution des validations..."
docker-compose exec -T db psql -U postgres -d postgres -f /docker-entrypoint-initdb.d/../validate.sql

echo ""
echo "=== Test terminé avec succès ==="
echo ""
echo "Pour arrêter les services :"
echo "  docker-compose down"
echo ""
echo "Pour arrêter et supprimer les volumes :"
echo "  docker-compose down -v"