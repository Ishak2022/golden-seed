
# =========================
# Golden Seed - Windows local run (one shot)
# Run from project root (folder that contains frontend/ and backend/)
# =========================

$ErrorActionPreference = "Stop"

# ---- 0) Fill these (required) ----
# Base Connection String (without ssl params)
$DB_BASE = 'postgresql://neondb_owner:npg_x0rDfNapQKk1@ep-cool-silence-agl54i68-pooler.c-2.eu-central-1.aws.neon.tech/neondb'

# Node/Prisma needs sslmode=require
# Node/Prisma needs sslmode=require
$DATABASE_URL_NODE = $DB_BASE + "?sslmode=require"

# Python/Asyncpg needs ssl=require
$DATABASE_URL_PYTHON = $DB_BASE + "?ssl=require"

$NEXTAUTH_URL = 'http://localhost:3000'
$ALLOWED_ORIGINS = 'http://localhost:3000,http://localhost:8000'

# Optional (dev): Redis can be off; keep REQUIRE_REDIS=false in dev
$REDIS_URL = 'redis://localhost:6379'
$REQUIRE_REDIS = 'false'

# ---- 1) Generate a strong NEXTAUTH_SECRET (base64) ----
$bytes = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$NEXTAUTH_SECRET = [Convert]::ToBase64String($bytes)

# Set DATABASE_URL for shell (Prisma needs Node version)
$env:DATABASE_URL = $DATABASE_URL_NODE

# ---- 2) Pick env example file name (.env.example or file.env.example) ----
$envExample = ".\.env.example"
if (!(Test-Path $envExample)) {
  if (Test-Path ".\file.env.example") { $envExample = ".\file.env.example" } else { throw "No .env.example or file.env.example found in root." }
}

# ---- 3) Copy env templates into expected locations ----
New-Item -ItemType Directory -Force -Path ".\frontend" | Out-Null
New-Item -ItemType Directory -Force -Path ".\backend"  | Out-Null

Copy-Item $envExample ".\frontend\.env.local" -Force
Copy-Item $envExample ".\frontend\.env" -Force
Copy-Item $envExample ".\backend\.env" -Force

function Set-EnvValue {
  param([string]$Path, [string]$Key, [string]$Value)

  $content = @()
  if (Test-Path $Path) { $content = Get-Content $Path -Raw -ErrorAction Stop -Encoding UTF8 } else { $content = "" }

  if ($content -match "(?m)^\s*$Key=") {
    $content = [regex]::Replace($content, "(?m)^\s*$Key=.*$", "$Key=`"$Value`"")
  } else {
    if ($content.Length -gt 0 -and -not $content.EndsWith("`n")) { $content += "`r`n" }
    $content += "$Key=`"$Value`"`r`n"
  }

  Set-Content -Path $Path -Value $content -Encoding UTF8
}

# ---- 4) Write minimal required vars for local dev ----
Set-EnvValue ".\frontend\.env.local" "DATABASE_URL"     $DATABASE_URL_NODE
Set-EnvValue ".\frontend\.env.local" "NEXTAUTH_SECRET"  $NEXTAUTH_SECRET
Set-EnvValue ".\frontend\.env.local" "NEXTAUTH_URL"     $NEXTAUTH_URL
Set-EnvValue ".\frontend\.env.local" "NODE_ENV"         "development"
Set-EnvValue ".\frontend\.env.local" "ENVIRONMENT"      "development"
Set-EnvValue ".\frontend\.env.local" "ALLOWED_ORIGINS"  $ALLOWED_ORIGINS
Set-EnvValue ".\frontend\.env.local" "REDIS_URL"        $REDIS_URL
Set-EnvValue ".\frontend\.env.local" "REQUIRE_REDIS"    $REQUIRE_REDIS

# Also update .env for Prisma CLI
Set-EnvValue ".\frontend\.env" "DATABASE_URL"     $DATABASE_URL_NODE
Set-EnvValue ".\frontend\.env" "NEXTAUTH_SECRET"  $NEXTAUTH_SECRET
Set-EnvValue ".\frontend\.env" "NEXTAUTH_URL"     $NEXTAUTH_URL
Set-EnvValue ".\frontend\.env" "NODE_ENV"         "development"
Set-EnvValue ".\frontend\.env" "ENVIRONMENT"      "development"
Set-EnvValue ".\frontend\.env" "ALLOWED_ORIGINS"  $ALLOWED_ORIGINS
Set-EnvValue ".\frontend\.env" "REDIS_URL"        $REDIS_URL
Set-EnvValue ".\frontend\.env" "REQUIRE_REDIS"    $REQUIRE_REDIS

Set-EnvValue ".\backend\.env" "DATABASE_URL"     $DATABASE_URL_PYTHON
Set-EnvValue ".\backend\.env" "ENVIRONMENT"      "development"
Set-EnvValue ".\backend\.env" "ALLOWED_ORIGINS"  $ALLOWED_ORIGINS
Set-EnvValue ".\backend\.env" "REDIS_URL"        $REDIS_URL
Set-EnvValue ".\backend\.env" "REQUIRE_REDIS"    $REQUIRE_REDIS

Write-Host "Env files created."

# ---- 5) Install dependencies ----
Write-Host "Installing Frontend Dependencies..."
Push-Location ".\frontend"
npm install
Pop-Location

Write-Host "Installing Backend Dependencies..."
Push-Location ".\backend"
python -m venv venv

# Activate venv (PowerShell)
if (Test-Path ".\venv\Scripts\Activate.ps1") { . .\venv\Scripts\Activate.ps1 } else { . .\venv\Scripts\activate }

pip install -r requirements.txt
pip install -r requirements-test.txt
Pop-Location

# ---- 6) Prisma generate + migrations ----
Write-Host "Running Prisma Migrations..."
Push-Location ".\frontend"
# Fix: Point to the schema file in parent directory
npx prisma generate --schema=../prisma/schema.prisma
npx prisma migrate deploy --schema=../prisma/schema.prisma
Pop-Location

# ---- 7) Start backend + frontend (two windows) ----
Write-Host "Starting Backend Service..."
Start-Process powershell -WorkingDirectory (Resolve-Path ".\backend") -ArgumentList @(
  "-NoExit",
  "-Command",
  "if (Test-Path .\venv\Scripts\Activate.ps1) { . .\venv\Scripts\Activate.ps1 } else { . .\venv\Scripts\activate }; uvicorn main:app --reload"
)

Write-Host "Starting Frontend Service..."
Start-Process powershell -WorkingDirectory (Resolve-Path ".\frontend") -ArgumentList @(
  "-NoExit",
  "-Command",
  "npm run dev"
)

# ---- 8) Health checks ----
Write-Host "Waiting for services to start..."
Start-Sleep -Seconds 15

Write-Host "`nBackend health:"
try { Invoke-WebRequest "http://localhost:8000/health" -UseBasicParsing | Select-Object -ExpandProperty Content } catch { Write-Host "Backend Check Failed: $_" }

Write-Host "`nFrontend health:"
try { Invoke-WebRequest "http://localhost:3000/api/health" -UseBasicParsing | Select-Object -ExpandProperty Content } catch { Write-Host "Frontend Check Failed: $_" }

Write-Host "`nDone. Access your app at:"
Write-Host " - Frontend: http://localhost:3000"
Write-Host " - Backend: http://localhost:8000"
Write-Host " - Docs: http://localhost:8000/docs"
