# =============================================================================
# voltwise-portal — Dockerfile
#
# Multi-stage build:
#   1. build — install Node deps and build the Vue SPA
#   2. serve — serve static files with Nginx
#
# Build context: repo root (voltwise/)
# =============================================================================

# ── Stage 1: build the Vue SPA ───────────────────────────────────────────────
FROM node:20-alpine AS build

WORKDIR /app

COPY voltwise-portal/package.json voltwise-portal/package-lock.json ./

RUN npm ci

COPY voltwise-portal/ .

ARG VITE_API_URL=/api
ENV VITE_API_URL=${VITE_API_URL}

RUN npm run build

# ── Stage 2: serve with Nginx ────────────────────────────────────────────────
FROM nginx:1.27-alpine AS serve

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy built SPA files
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config for SPA routing
COPY voltwise-docker/docker/portal/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
