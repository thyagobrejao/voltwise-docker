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

echo "==> Starting Daphne (ASGI)..."
exec daphne -b 0.0.0.0 -p 8000 config.asgi:application
