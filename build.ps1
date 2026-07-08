# build.ps1 — build ArchNesic ISO on Windows (requires Docker Desktop)
$ErrorActionPreference = "Stop"
$ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ArchNesic — Windows build script"       -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Requires Docker Desktop for Windows."

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Docker not found. Install Docker Desktop from:" -ForegroundColor Red
    Write-Host "  https://docs.docker.com/desktop/install/windows-install/"
    exit 1
}

Write-Host "`n[1/2] Building Docker image..." -ForegroundColor Yellow
docker build -t archnesic-builder "$ROOT"
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "`n[2/2] Building ISO..." -ForegroundColor Yellow
$OUT_DIR = "$ROOT\archlive\out"
if (-not (Test-Path $OUT_DIR)) { New-Item -ItemType Directory -Path $OUT_DIR -Force | Out-Null }

docker run --privileged `
    -v "${ROOT}\archlive:/build" `
    -v "${OUT_DIR}:/out" `
    archnesic-builder
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "`nDone!" -ForegroundColor Green
$iso = Get-ChildItem "$OUT_DIR\*.iso" | Select-Object -First 1
if ($iso) {
    Write-Host "ISO created: $($iso.FullName)" -ForegroundColor Green
    Write-Host "Size: $('{0:N2} MB' -f ($iso.Length / 1MB))" -ForegroundColor Green
}

Write-Host "`nOr just push to GitHub — Actions builds it for free." -ForegroundColor Cyan