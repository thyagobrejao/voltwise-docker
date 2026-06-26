#!/bin/sh
# =============================================================================
# voltwise-cloud entrypoint
#
# Runs database migrations then starts Gunicorn.
# Executed inside the cloud container on every start.
# =============================================================================
set -e

echo "==> Running database migrations..."
python manage.py migrate --noinput

echo "==> Collecting static files..."
python manage.py collectstatic --noinput --clear

echo "==> Seeding city catalog (only when empty)..."
python manage.py sync_cities --if-empty || echo "WARN: city sync skipped/failed (continuing)."

echo "==> Starting Daphne (ASGI)..."
exec python -m daphne -b 0.0.0.0 -p 8000 config.asgi:application
