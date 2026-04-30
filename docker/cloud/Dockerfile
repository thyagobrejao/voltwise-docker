# =============================================================================
# voltwise-cloud — Dockerfile
#
# Multi-stage build:
#   1. deps  — install Python dependencies (cached layer)
#   2. final — copy app source and run with Gunicorn
#
# Build context: repo root (voltwise/)
# =============================================================================

# ── Stage 1: dependency installation ─────────────────────────────────────────
FROM python:3.12-slim AS deps

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /deps

# System libraries required by psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
        libpq-dev \
        gcc \
    && rm -rf /var/lib/apt/lists/*

COPY voltwise-cloud/requirements.txt .

# Install Django deps + gunicorn (not in requirements.txt)
RUN pip install --no-cache-dir -r requirements.txt gunicorn==22.*

# ── Stage 2: application image ────────────────────────────────────────────────
FROM python:3.12-slim AS final

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Runtime library for psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
        libpq5 \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Copy installed packages from deps stage
COPY --from=deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=deps /usr/local/bin/gunicorn /usr/local/bin/gunicorn

# Copy application source
COPY voltwise-cloud/ .

# Copy and configure entrypoint
COPY voltwise-docker/docker/cloud/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/entrypoint.sh"]
