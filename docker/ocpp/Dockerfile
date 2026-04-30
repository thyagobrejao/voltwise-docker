# =============================================================================
# voltwise-ocpp — Dockerfile
#
# Multi-stage build:
#   1. builder — compile Go binary with CGO disabled
#   2. final   — minimal Alpine runtime image
#
# Build context: repo root (voltwise/)
# =============================================================================

# ── Stage 1: compile ──────────────────────────────────────────────────────────
FROM golang:1.26-alpine AS builder

WORKDIR /src

# Copy module files first for dependency caching
COPY voltwise-ocpp/go.mod voltwise-ocpp/go.sum* ./

RUN go mod download

# Copy full source
COPY voltwise-ocpp/ .

# Build a statically linked binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -ldflags="-s -w" -o /bin/voltwise-ocpp ./cmd/voltwise-ocpp

# ── Stage 2: minimal runtime ──────────────────────────────────────────────────
FROM alpine:3.21 AS final

# ca-certificates needed for outbound TLS (future integrations)
RUN apk add --no-cache ca-certificates wget

COPY --from=builder /bin/voltwise-ocpp /usr/local/bin/voltwise-ocpp

EXPOSE 8080

CMD ["voltwise-ocpp"]
