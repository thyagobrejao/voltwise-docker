#!/bin/sh
# =============================================================================
# voltwise-cloud entrypoint
#
# Waits for the database, runs migrations, collects static files, seeds
# cities (if empty), then starts Daphne (ASGI).
# =============================================================================
set -e

echo "==> Waiting for database to be ready..."
DB_HOST="${DB_HOST:-db}"
DB_PORT="${DB_PORT:-5432}"
for i in $(seq 1 30); do
  if python -c "
import socket, sys
try:
    s = socket.create_connection(('$DB_HOST', $DB_PORT), timeout=2)
    s.close()
    sys.exit(0)
except OSError:
    sys.exit(1)
" 2>/dev/null; then
    echo "    Database is ready (attempt $i)."
    break
  fi
  echo "    Waiting for database... (attempt $i/30)"
  sleep 2
done

echo "==> Running database migrations..."
python manage.py migrate --noinput

echo "==> Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "==> Seeding city catalog (only when empty)..."
python manage.py sync_cities --if-empty || echo "WARN: city sync skipped/failed (continuing)."

echo "==> Starting Daphne (ASGI)..."
exec python -m daphne -b 0.0.0.0 -p 8000 config.asgi:application
