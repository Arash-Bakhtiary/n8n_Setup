# =========================================================
# Export all n8n workflows and credentials into backups\  (Windows)
#
#   powershell -ExecutionPolicy Bypass -File backup.ps1
#
# Credentials stay ENCRYPTED in the export. They can only be
# restored on an n8n that uses the SAME N8N_ENCRYPTION_KEY,
# so keep a safe copy of your .env together with backups.
# =========================================================

Set-Location -Path $PSScriptRoot

docker exec n8n true *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: n8n is not running. Start it first:  docker compose up -d"
    exit 1
}

$stamp  = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$target = "/backups/$stamp"

Write-Host "==> Exporting to backups\$stamp ..."
docker exec n8n mkdir -p "$target/workflows" "$target/credentials"

docker exec n8n n8n export:workflow --all --backup --output="$target/workflows/"
if ($LASTEXITCODE -ne 0) { Write-Host "    (no workflows to export)" }

docker exec n8n n8n export:credentials --all --backup --output="$target/credentials/"
if ($LASTEXITCODE -ne 0) { Write-Host "    (no credentials to export)" }

Write-Host "==> Done: backups\$stamp"
Write-Host ""
Write-Host "To restore into a running n8n (same encryption key):"
Write-Host "  docker exec n8n n8n import:credentials --separate --input=$target/credentials/"
Write-Host "  docker exec n8n n8n import:workflow --separate --input=$target/workflows/"
