#!/bin/sh
set -e

# Read database password from secret file if provided
if [ -n "$POSTGRES_PASSWORD_FILE" ] && [ -f "$POSTGRES_PASSWORD_FILE" ]; then
  export POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
fi

# Set default values for database connection
DATABASE_HOST=${DATABASE_HOST:-postgres}
DATABASE_PORT=${DATABASE_PORT:-5432}
DATABASE_USER=${DATABASE_USER:-postgres}

echo "Waiting for PostgreSQL to be ready..."

# Wait for PostgreSQL to be ready with pg_isready
until pg_isready -h "$DATABASE_HOST" -p "$DATABASE_PORT" -U "$DATABASE_USER" > /dev/null 2>&1; do
  echo "PostgreSQL is unavailable - sleeping for 2 seconds"
  sleep 2
done

echo "PostgreSQL is ready!"

# Remove Rails server.pid if it exists (prevents "server is already running" errors)
if [ -f tmp/pids/server.pid ]; then
  echo "Removing existing server.pid file"
  rm tmp/pids/server.pid
fi

# Execute the provided command
echo "Starting Rails application..."
exec "$@"