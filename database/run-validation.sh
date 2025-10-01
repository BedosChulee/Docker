#!/bin/bash

# PostgreSQL Database Validation Runner
# This script runs the validation queries against the PostgreSQL database

set -e

# Default connection parameters
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-postgres}
DB_USER=${DB_USER:-postgres}
DB_PASSWORD=${DB_PASSWORD:-postgres}

echo "=== PostgreSQL Database Validation Runner ==="
echo "Connecting to: $DB_HOST:$DB_PORT/$DB_NAME as $DB_USER"
echo ""

# Check if PostgreSQL is accessible
echo "Checking database connectivity..."
if ! PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1; then
    echo "ERROR: Cannot connect to PostgreSQL database"
    echo "Please ensure:"
    echo "  - PostgreSQL container is running"
    echo "  - Connection parameters are correct"
    echo "  - Database has been initialized"
    exit 1
fi

echo "✓ Database connection successful"
echo ""

# Run validation script
echo "Running validation queries..."
PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f validate.sql

echo ""
echo "=== Validation Complete ==="