# =========================================================
# n8n setup - Windows (PowerShell)
#
# Run from the project folder:
#   powershell -ExecutionPolicy Bypass -File setup.ps1
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

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host "==> Checking Docker..."
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker is not installed. Install Docker Desktop and try again."
    exit 1
}
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is installed but not running. Start Docker Desktop and try again."
    exit 1
}
docker compose version *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: 'docker compose' is not available. Update Docker Desktop."
    exit 1
}

function New-RandomSecret {
    $bytes = New-Object byte[] 32
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($bytes)
    $rng.Dispose()
    return -join ($bytes | ForEach-Object { $_.ToString("x2") })
}

if (Test-Path ".env") {
    Write-Host "==> .env already exists - keeping it (secrets unchanged)."
}
else {
    Write-Host "==> Creating .env with new random secrets..."
    $encKey   = New-RandomSecret
    $runToken = New-RandomSecret
    $content = Get-Content ".env.example" -Raw
    $content = $content -replace "(?m)^N8N_ENCRYPTION_KEY=.*$", "N8N_ENCRYPTION_KEY=$encKey"
    $content = $content -replace "(?m)^N8N_RUNNERS_AUTH_TOKEN=.*$", "N8N_RUNNERS_AUTH_TOKEN=$runToken"
    $content = $content -replace "`r`n", "`n"
    # Write without BOM so Docker Compose reads it correctly
    [System.IO.File]::WriteAllText((Join-Path $PSScriptRoot ".env"), $content, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "    Done. Keep .env private and do not change N8N_ENCRYPTION_KEY later."
}

if (Select-String -Path ".env" -Pattern "CHANGE_ME" -Quiet) {
    Write-Host "ERROR: .env still contains CHANGE_ME. Delete .env and run setup.ps1 again."
    exit 1
}

New-Item -ItemType Directory -Force -Path "backups" | Out-Null

Write-Host "==> Validating n8n-task-runners.json..."
try {
    Get-Content "n8n-task-runners.json" -Raw | ConvertFrom-Json | Out-Null
}
catch {
    Write-Host "ERROR: n8n-task-runners.json is not valid JSON: $_"
    exit 1
}

Write-Host "==> Building task runner and starting n8n (first run can take a few minutes)..."
docker compose up -d --build
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: docker compose failed. Check the messages above."
    exit 1
}

$port = (Select-String -Path ".env" -Pattern "^N8N_PORT=(.*)$").Matches.Groups[1].Value
if (-not $port) { $port = "5678" }

Write-Host ""
Write-Host "==> n8n is starting. Open: http://localhost:$port"
Write-Host "    Status:        docker compose ps"
Write-Host "    n8n logs:      docker logs -f n8n"
Write-Host "    Runner logs:   docker logs -f n8n-runners"
