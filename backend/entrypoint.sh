#!/bin/sh
set -e

# Read database password from secret file if provided
if [ -n "$POSTGRES_PASSWORD_FILE" ] && [ -f "$POSTGRES_PASSWORD_FILE" ]; then
  export POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
  export PGPASSWORD="$POSTGRES_PASSWORD"     # pour libpq / psql
  export DATABASE_PASSWORD="$POSTGRES_PASSWORD" # pour database.yml si tu utilises DATABASE_PASSWORD
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

# Fix bundle platforms for development
if [ "$RAILS_ENV" = "development" ]; then
  echo "Fixing bundle platforms for development..."
  bundle lock --add-platform aarch64-linux-musl
  bundle lock --add-platform ruby
fi

# Remove Rails server.pid if it exists (prevents "server is already running" errors)
if [ -f tmp/pids/server.pid ]; then
  echo "Removing existing server.pid file"
  rm tmp/pids/server.pid
fi

# Run database migrations
echo "Running database migrations..."
bin/rails db:create db:migrate

# Execute the provided command
echo "Starting Rails application..."
exec "$@"