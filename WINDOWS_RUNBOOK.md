# Golden Seed - Windows Local Development Runbook

> **Last Updated**: 2026-02-22  
> **Status**: Initial Audit in Progress  
> **OS**: Windows 10/11 with PowerShell 5.1+ or PowerShell 7+

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Detailed Setup Steps](#detailed-setup-steps)
4. [Running the Application](#running-the-application)
5. [Troubleshooting](#troubleshooting)
6. [Development Workflow](#development-workflow)

---

## Prerequisites

### Required Software

| Software | Version | Check Command | Install Link |
|----------|---------|---------------|--------------|
| **Node.js** | 18+ | `node --version` | [nodejs.org](https://nodejs.org/) |
| **Python** | 3.10+ | `python --version` | [python.org](https://www.python.org/) |
| **Docker Desktop** | Latest | `docker --version` | [docker.com](https://www.docker.com/products/docker-desktop) |
| **Git** | Any | `git --version` | [git-scm.com](https://git-scm.com/) |
| **PowerShell** | 5.1+ or 7+ | `$PSVersionTable.PSVersion` | Built-in on Windows |

### Optional Software

| Software | Purpose | Check Command |
|----------|---------|---------------|
| **Redis** | Caching (can use Docker) | `redis-cli --version` |
| **PostgreSQL CLI** | Direct DB access | `psql --version` |

### Prerequisites Verification

Run this in PowerShell to verify your setup:

```powershell
Write-Host "Checking prerequisites..." -ForegroundColor Cyan

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found. Install Node.js v18+" -ForegroundColor Red
}

# Check Python
try {
    $pythonVersion = python --version
    Write-Host "✅ Python $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Python not found. Install Python 3.10+" -ForegroundColor Red
}

# Check Docker
try {
    $dockerVersion = docker --version
    Write-Host "✅ Docker $dockerVersion" -ForegroundColor Green
    
    # Check if Docker Desktop is running
    $dockerRunning = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker Desktop is running" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Docker Desktop is not running. Start it first." -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Docker not found. Install Docker Desktop" -ForegroundColor Red
}

# Check Git
try {
    $gitVersion = git --version
    Write-Host "✅ Git $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Git not found. Install Git" -ForegroundColor Red
}

# Check PowerShell
$psVersion = $PSVersionTable.PSVersion
Write-Host "✅ PowerShell $psVersion" -ForegroundColor Green
```

---

## Quick Start

### Option A: Automated Setup (Recommended)

The repository includes an automated setup script:

```powershell
# From the project root directory
.\setup-and-verify.ps1
```

This script will:
- ✅ Check prerequisites
- ✅ Install frontend and backend dependencies
- ✅ Copy environment templates
- ✅ Generate Prisma client
- ✅ Run database migrations
- ✅ Apply performance indexes

### Option B: Manual Setup with Docker Compose

```powershell
# 1. Start Docker Desktop if not running
# (Manually start Docker Desktop from Start Menu)

# 2. Start all services
docker-compose up --build

# 3. Access services:
# - Frontend: http://localhost:3000
# - Backend API: http://localhost:8000/docs
# - Database: localhost:5432
# - Redis: localhost:6379

# To stop services:
docker-compose down
```

### Option C: Manual Local Development

Follow the [Detailed Setup Steps](#detailed-setup-steps) below.

---

## Detailed Setup Steps

### Step 1: Clone or Navigate to Repository

```powershell
# If cloning:
git clone <repository-url>
cd "golden seed"

# If already cloned, navigate to the project root:
cd "c:\Users\User\Desktop\GOLDEN FOLDERS\golden seed"
```

### Step 2: Configure Environment Variables

Create environment files in the appropriate locations:

#### Create `.env` files:

```powershell
# Copy the example environment file
Copy-Item .env.example frontend\.env.local -Force
Copy-Item .env.example frontend\.env -Force
Copy-Item .env.example backend\.env -Force
```

#### Minimal Required Environment Variables

Add these to both `frontend/.env.local` and `backend/.env`:

```ini
# DATABASE (Required)
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/goldenseed

# AUTH (Required)
NEXTAUTH_SECRET=dev-secret-key-change-in-production-min-32-chars
NEXTAUTH_URL=http://localhost:3000

# DEMO LOGIN (Development Only - Optional)
# Set ENABLE_DEMO_LOGIN=true to enable demo accounts for development/testing
# Demo accounts ONLY work when NODE_ENV=development AND ENABLE_DEMO_LOGIN=true
ENABLE_DEMO_LOGIN=false
DEMO_ADMIN_EMAIL=admin@demo.local
DEMO_ADMIN_PASSWORD=Admin123!

# ENVIRONMENT (Required)
ENVIRONMENT=development
NODE_ENV=development

# CORS (Required)
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8000

# REDIS (Optional in dev)
REDIS_URL=redis://localhost:6379
REQUIRE_REDIS=false

# BACKEND ONLY
SECRET_KEY=dev-secret-key-change-in-production-min-32-chars
SCOUT_API_KEY=somesecurekey
```

#### Generate a Secure NEXTAUTH_SECRET (Optional)

```powershell
# Generate a secure random base64 string for NEXTAUTH_SECRET
$bytes = New-Object byte[] 32
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$secret = [Convert]::ToBase64String($bytes)
Write-Host "Generated NEXTAUTH_SECRET: $secret" -ForegroundColor Cyan
```

### Step 3: Start Docker Services (Database & Redis)

```powershell
# Start PostgreSQL and Redis containers
docker-compose up -d db redis

# Verify containers are running
docker ps

# Check database is ready (wait until healthy)
docker logs golden-seed-db

# Check Redis is ready
docker logs golden-seed-redis
```

### Step 4: Backend Setup

#### 4.1 Create Python Virtual Environment

```powershell
cd backend
python -m venv venv
```

#### 4.2 Activate Virtual Environment

```powershell
# Windows PowerShell
.\venv\Scripts\Activate.ps1

# If you get an execution policy error, run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

You should see `(venv)` in your prompt when activated.

#### 4.3 Install Dependencies

```powershell
# Install runtime dependencies
pip install -r requirements.txt

# Install test dependencies
pip install -r requirements-test.txt
```

#### 4.4 Run Database Migrations

The backend uses Alembic for migrations:

```powershell
# Ensure DATABASE_URL is set
alembic upgrade head

# Check migration status
alembic current
alembic history
```

#### 4.5 Start Backend Server

```powershell
# Start with auto-reload for development
uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Alternative: using python
python -m uvicorn main:app --reload
```

The backend will start on `http://localhost:8000`

#### 4.6 Verify Backend Health

```powershell
# In a new PowerShell terminal
curl http://localhost:8000/health

# Or use Invoke-WebRequest
Invoke-WebRequest -Uri http://localhost:8000/health | Select-Object -ExpandProperty Content

# Access API documentation
Start-Process http://localhost:8000/docs
```

### Step 5: Frontend Setup

#### 5.1 Install Dependencies

```powershell
# Open a new PowerShell terminal (keep backend running)
cd frontend
npm install
```

#### 5.2 Generate Prisma Client

```powershell
# Generate Prisma client
npx prisma generate

# Check Prisma schema
npx prisma format
```

#### 5.3 Run Prisma Migrations

```powershell
# Run migrations (only if using Prisma-managed schema)
npx prisma migrate deploy

# Or create a new migration if needed
npx prisma migrate dev --name init
```

#### 5.4 (Optional) Enable Demo Login

```powershell
# Edit frontend/.env.local to enable demo accounts
# Set ENABLE_DEMO_LOGIN=true

# Demo Accounts (Available when ENABLE_DEMO_LOGIN=true and NODE_ENV=development):
# - Platform Admin:  admin@demo.local  /  Admin123!
#   (Access: All tenants, full admin dashboard)
#
# Note: Demo accounts are disabled by default for security.
# Never enable ENABLE_DEMO_LOGIN in production!
```

#### 5.5 (Optional) Seed Demo Data

```powershell
# WARNING: This resets the database!
# Only run in development
npx prisma db seed
```

#### 5.6 Start Frontend Dev Server

```powershell
# Start development server
npm run dev

# Build for production
npm run build
npm start
```

The frontend will start on `http://localhost:3000`

#### 5.7 Verify Frontend

```powershell
# Access in browser
Start-Process http://localhost:3000

# Test pages to visit:
# - http://localhost:3000/ (home)
# - http://localhost:3000/docs (API docs)
# - http://localhost:3000/auth/signin (login)
```

---

## Running the Application

### All Services Running

You should have these services running:

| Service | URL | Status Check |
|---------|-----|--------------|
| **Frontend** | http://localhost:3000 | `curl http://localhost:3000` |
| **Backend API** | http://localhost:8000 | `curl http://localhost:8000/health` |
| **API Docs** | http://localhost:8000/docs | Open in browser |
| **Database** | localhost:5432 | `docker ps \| findstr postgres` |
| **Redis** | localhost:6379 | `docker ps \| findstr redis` |

### Development Workflow

**Terminal 1 - Backend:**
```powershell
cd backend
.\venv\Scripts\Activate.ps1
uvicorn main:app --reload
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm run dev
```

**Terminal 3 - Docker (if not using docker-compose):**
```powershell
docker-compose up -d db redis
```

### Running Tests

**Backend Tests:**
```powershell
cd backend
.\venv\Scripts\Activate.ps1
pytest

# Run with coverage
pytest --cov=app --cov-report=html
```

**Frontend Tests:**
```powershell
cd frontend
npm test

# Run with coverage
npm run test:coverage
```

---

## Troubleshooting

### Common Windows Issues

#### Issue 1: PowerShell Execution Policy Error

**Error:** `cannot be loaded because running scripts is disabled on this system`

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Issue 2: Python venv Activation Fails

**Error:** `running scripts is disabled` or similar

**Solution:**
```powershell
# Try bypassing execution policy for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\venv\Scripts\Activate.ps1
```

#### Issue 3: Port Already in Use

**Error:** `Port 3000/8000/5432 is already in use`

**Solution:**
```powershell
# Find process using the port
netstat -ano | findstr :3000  # or :8000, :5432

# Kill the process (replace <PID> with actual process ID)
taskkill /PID <PID> /F

# Or change the port in docker-compose.yml or dev command
```

#### Issue 4: Docker Desktop Not Running

**Error:** `Cannot connect to the Docker daemon`

**Solution:**
1. Start Docker Desktop from Start Menu
2. Wait for "Docker Desktop is running" notification
3. Verify with: `docker info`

#### Issue 5: Line Ending Issues (CRLF vs LF)

**Error:** Scripts or Python files have line ending issues

**Solution:**
```powershell
# Configure Git to use LF (recommended for cross-platform)
git config --global core.autocrlf input

# Or convert line endings for existing files
# Install dos2unix or use Notepad++ to convert
```

#### Issue 6: Database Connection Refused

**Error:** `could not connect to server: Connection refused`

**Solution:**
```powershell
# Check if PostgreSQL container is running
docker ps | findstr postgres

# Check container logs
docker logs golden-seed-db

# Restart the database container
docker-compose restart db

# Wait a few seconds and try again
```

#### Issue 7: Module Not Found Errors

**Error:** `ModuleNotFoundError: No module named 'xxx'`

**Solution:**
```powershell
# Ensure virtual environment is activated
.\venv\Scripts\Activate.ps1

# Reinstall dependencies
pip install -r requirements.txt --force-reinstall
```

#### Issue 8: CORS Errors in Browser

**Error:** `Access to XMLHttpRequest at ... has been blocked by CORS policy`

**Solution:**
```powershell
# Check ALLOWED_ORIGINS in .env files
# Ensure it includes http://localhost:3000 and http://localhost:8000

# Restart backend after changing .env
```

#### Issue 9: Prisma Client Not Generated

**Error:** `Error: @prisma/client did not initialize yet`

**Solution:**
```powershell
cd frontend
npx prisma generate
# Try again
npm run dev
```

#### Issue 10: Redis Connection Errors (if REQUIRE_REDIS=true)

**Error:** `Error connecting to Redis`

**Solution:**
```powershell
# Ensure Redis is running
docker ps | findstr redis

# Or disable Redis requirement in dev
# Set REQUIRE_REDIS=false in backend/.env
# Restart backend
```

### Checking Logs

**Backend Logs:**
```powershell
# Backend terminal shows live logs
# Or check specific log files if configured
```

**Frontend Logs:**
```powershell
# Frontend terminal shows build/runtime logs
# Browser DevTools Console (F12) shows client-side errors
```

**Docker Logs:**
```powershell
# Database logs
docker logs golden-seed-db -f

# Redis logs
docker logs golden-seed-redis -f

# All services
docker-compose logs -f
```

### Resetting Everything

```powershell
# Stop all services
docker-compose down

# Remove containers and volumes (WARNING: deletes all data)
docker-compose down -v

# Remove node_modules (if needed)
Remove-Item -Recurse -Force frontend\node_modules
Remove-Item -Recurse -Force backend\venv

# Reinstall and start fresh
.\setup-and-verify.ps1
```

---

## Development Workflow

### Making Changes

1. **Backend changes:**
   - Edit Python files in `backend/`
   - Server auto-reloads with `--reload` flag
   - Check logs for any errors

2. **Frontend changes:**
   - Edit files in `frontend/src/`
   - Next.js hot-reloads automatically
   - Check browser console for errors

3. **Database changes:**
   - Backend: Create Alembic migration: `alembic revision --autogenerate -m "description"`
   - Apply migration: `alembic upgrade head`
   - Frontend: Create Prisma migration: `npx prisma migrate dev --name "description"`

### Environment-Specific Config

**Development:**
- `ENVIRONMENT=development`
- Debug mode enabled
- Detailed error messages
- No Redis requirement (by default)

**Production:**
- `ENVIRONMENT=production`
- Debug mode disabled
- Minimal error messages
- Redis required
- Secure secrets required

### Useful Commands

```powershell
# Check all running processes
Get-Process | Where-Object {$_.ProcessName -like "*node*" -or $_.ProcessName -like "*python*" -or $_.ProcessName -like "*docker*"}

# Kill a process by name
Get-Process node | Stop-Process -Force

# Clear npm cache
npm cache clean --force

# Rebuild Docker containers
docker-compose build --no-cache
docker-compose up

# Check Python packages
pip list

# Check npm packages
npm list --depth=0
```

---

## Next Steps

After successfully running the application:

1. **Review the API Documentation**: Visit `http://localhost:8000/docs`
2. **Explore the Frontend**: Navigate through different pages
3. **Check Tests**: Run the test suites to verify functionality
4. **Review Code**: Explore the codebase structure
5. **Customize**: Modify environment variables and configuration as needed

---

## Additional Resources

- [README.md](README.md) - Main project documentation
- [QUICK_START.md](QUICK_START.md) - Quick start guide
- [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment instructions
- [API_DOCUMENTATION.md](API_DOCUMENTATION.md) - API details
- [docs/](docs/) - Detailed documentation

---

## Support

If you encounter issues not covered in this runbook:

1. Check the existing [Troubleshooting](#troubleshooting) section
2. Review the GitHub Issues (if available)
3. Check the [docs/](docs/) folder for detailed guides
4. Enable debug logging and check logs carefully

---

**End of Windows Runbook**
