#!/usr/bin/env bash
# =========================================================
# n8n setup - macOS / Linux
#
# Run from the project folder:
#   chmod +x setup.sh     (only the first time)
#   ./setup.sh
#
# What it does:
#   1. Checks that Docker is installed and running
#   2. Creates .env from .env.example (only if .env is missing)
#      and fills in two random secrets
#   3. Builds the task runner and starts n8n
#
# Safe to run again: an existing .env is NEVER overwritten,
# because changing N8N_ENCRYPTION_KEY breaks saved credentials.
# =========================================================

set -euo pipefail

cd "$(dirname "$0")"

echo "==> Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is not installed. Install Docker Desktop and try again."
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker is installed but not running. Start Docker Desktop and try again."
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "ERROR: 'docker compose' is not available. Update Docker Desktop."
  exit 1
fi

random_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
  else
    python3 -c "import secrets; print(secrets.token_hex(32))"
  fi
}

if [ -f .env ]; then
  echo "==> .env already exists - keeping it (secrets unchanged)."
else
  echo "==> Creating .env with new random secrets..."
  cp .env.example .env
  ENC_KEY="$(random_secret)"
  RUN_TOKEN="$(random_secret)"
  # Portable in-place edit (works on macOS and Linux)
  sed "s/^N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=${ENC_KEY}/; s/^N8N_RUNNERS_AUTH_TOKEN=.*/N8N_RUNNERS_AUTH_TOKEN=${RUN_TOKEN}/" .env > .env.tmp
  mv .env.tmp .env
  chmod 600 .env
  echo "    Done. Keep .env private and do not change N8N_ENCRYPTION_KEY later."
fi

if grep -q "CHANGE_ME" .env; then
  echo "ERROR: .env still contains CHANGE_ME. Delete .env and run ./setup.sh again."
  exit 1
fi

mkdir -p backups

echo "==> Validating n8n-task-runners.json..."
if command -v python3 >/dev/null 2>&1; then
  python3 -m json.tool n8n-task-runners.json >/dev/null
fi

echo "==> Building task runner and starting n8n (first run can take a few minutes)..."
docker compose up -d --build

PORT="$(grep -E '^N8N_PORT=' .env | cut -d= -f2)"
PORT="${PORT:-5678}"

echo ""
echo "==> n8n is starting. Open: http://localhost:${PORT}"
echo "    Status:        docker compose ps"
echo "    n8n logs:      docker logs -f n8n"
echo "    Runner logs:   docker logs -f n8n-runners"
