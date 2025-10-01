#!/bin/bash

# Script pour arrêter l'environnement de développement PostgreSQL

set -e

echo "=== Arrêt de l'environnement de développement ==="
echo ""

# Arrêter tous les services
echo "Arrêt des services..."
docker-compose -f docker-compose.yml -f docker-compose.dev.yml --profile dev down

echo ""
echo "✓ Environnement de développement arrêté"
echo ""
echo "Pour supprimer également les volumes (données) :"
echo "  docker-compose -f docker-compose.yml -f docker-compose.dev.yml --profile dev down -v"