#!/usr/bin/env bash
# =========================================================
# Export all n8n workflows and credentials into backups/
#
#   bash backup.sh
#
# Credentials stay ENCRYPTED in the export. They can only be
# restored on an n8n that uses the SAME N8N_ENCRYPTION_KEY,
# so keep a safe copy of your .env together with backups.
# =========================================================

set -uo pipefail
cd "$(dirname "$0")"

if ! docker exec n8n true >/dev/null 2>&1; then
  echo "ERROR: n8n is not running. Start it first:  docker compose up -d"
  exit 1
fi

STAMP="$(date +%Y-%m-%d_%H-%M-%S)"
TARGET="/backups/${STAMP}"

echo "==> Exporting to backups/${STAMP} ..."
docker exec n8n mkdir -p "${TARGET}/workflows" "${TARGET}/credentials"

docker exec n8n n8n export:workflow --all --backup --output="${TARGET}/workflows/" \
  || echo "    (no workflows to export)"

docker exec n8n n8n export:credentials --all --backup --output="${TARGET}/credentials/" \
  || echo "    (no credentials to export)"

echo "==> Done: backups/${STAMP}"
echo ""
echo "To restore into a running n8n (same encryption key):"
echo "  docker exec n8n n8n import:credentials --separate --input=${TARGET}/credentials/"
echo "  docker exec n8n n8n import:workflow --separate --input=${TARGET}/workflows/"