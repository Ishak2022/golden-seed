# Complete setup and test script for Golden Seed project (Windows)

Write-Host "🚀 Golden Seed - Complete Setup & Verification" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Please install Node.js v18+" -ForegroundColor Red
    exit 1
}

# Check Python
try {
    $pythonVersion = python --version
    Write-Host "✅ Python $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Please install Python 3.10+" -ForegroundColor Red
    exit 1
}

# Check PostgreSQL
try {
    $null = Get-Command psql -ErrorAction Stop
    Write-Host "✅ PostgreSQL available" -ForegroundColor Green
} catch {
    Write-Host "⚠️  PostgreSQL CLI not found (optional for local setup)" -ForegroundColor Yellow
}

# Check Redis
try {
    $null = Get-Command redis-cli -ErrorAction Stop
    Write-Host "✅ Redis available" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Redis not found. Install Redis for rate limiting and caching" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow

# Install frontend dependencies
Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
Set-Location frontend
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Frontend dependency installation failed" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Frontend dependencies installed" -ForegroundColor Green

# Install backend dependencies
Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
Set-Location ..\backend
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
pip install -r requirements-test.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Backend dependency installation failed" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Backend dependencies installed" -ForegroundColor Green

Set-Location ..

Write-Host ""
Write-Host "🔧 Setting up database..." -ForegroundColor Yellow

# Check if .env exists
if (-not (Test-Path "frontend\.env.local")) {
    Write-Host "⚠️  No .env.local found. Creating from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example frontend\.env.local
    Write-Host "⚠️  Please configure frontend/.env.local with your settings" -ForegroundColor Yellow
}

if (-not (Test-Path "backend\.env")) {
    Write-Host "⚠️  No backend .env found. Creating from .env.example..." -ForegroundColor Yellow
    Copy-Item .env.example backend\.env
    Write-Host "⚠️  Please configure backend/.env with your settings" -ForegroundColor Yellow
}

# Generate Prisma client
Set-Location frontend
npx prisma generate
Write-Host "✅ Prisma client generated" -ForegroundColor Green

# Run migrations (if DATABASE_URL is set)
if ($env:DATABASE_URL) {
    Write-Host "Running database migrations..." -ForegroundColor Cyan
    npx prisma migrate deploy
    Write-Host "✅ Database migrations applied" -ForegroundColor Green
    
    # Apply performance indexes
    if (Test-Path "..\prisma\performance-indexes.sql") {
        Write-Host "Applying performance indexes..." -ForegroundColor Cyan
        psql $env:DATABASE_URL -f ..\prisma\performance-indexes.sql
        Write-Host "✅ Performance indexes applied" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  DATABASE_URL not set. Skipping migrations." -ForegroundColor Yellow
}

Set-Location ..

Write-Host ""
Write-Host "🧪 Running tests..." -ForegroundColor Yellow

# Frontend tests
Write-Host "Running frontend tests..." -ForegroundColor Cyan
Set-Location frontend
npm test -- --run
$frontendTestResult = $LASTEXITCODE
Set-Location ..

if ($frontendTestResult -eq 0) {
    Write-Host "✅ Frontend tests passed" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend tests failed" -ForegroundColor Red
}

# Backend tests
Write-Host "Running backend tests..." -ForegroundColor Cyan
Set-Location backend
.\venv\Scripts\Activate.ps1
pytest
$backendTestResult = $LASTEXITCODE
Set-Location ..

if ($backendTestResult -eq 0) {
    Write-Host "✅ Backend tests passed" -ForegroundColor Green
} else {
    Write-Host "❌ Backend tests failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "🏗️  Building frontend..." -ForegroundColor Yellow
Set-Location frontend
npm run build
$buildResult = $LASTEXITCODE
Set-Location ..

if ($buildResult -eq 0) {
    Write-Host "✅ Frontend build successful" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend build failed" -ForegroundColor Red
}

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "📊 Setup Summary" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan

if (($frontendTestResult -eq 0) -and ($backendTestResult -eq 0) -and ($buildResult -eq 0)) {
    Write-Host "✅ All checks passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Ready for deployment!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Configure environment variables in frontend/.env.local and backend/.env"
    Write-Host "  2. Start development: npm run dev (frontend) and python backend/main.py (backend)"
    Write-Host "  3. Or deploy to production using DEPLOYMENT_COMPLETE.md guide"
} else {
    Write-Host "❌ Some checks failed. Please review the output above." -ForegroundColor Red
}

Write-Host ""
