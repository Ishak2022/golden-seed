#!/bin/bash
# Complete setup and test script for Golden Seed project

echo "🚀 Golden Seed - Complete Setup & Verification"
echo "=============================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not found. Please install Node.js v18+${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js $(node --version)${NC}"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python not found. Please install Python 3.10+${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Python $(python3 --version)${NC}"

# Check PostgreSQL
if ! command -v psql &> /dev/null; then
    echo -e "${YELLOW}⚠️  PostgreSQL CLI not found (optional for local setup)${NC}"
else
    echo -e "${GREEN}✅ PostgreSQL available${NC}"
fi

# Check Redis
if ! command -v redis-cli &> /dev/null; then
    echo -e "${YELLOW}⚠️  Redis not found. Install Redis for rate limiting and caching${NC}"
else
    echo -e "${GREEN}✅ Redis available${NC}"
fi

echo ""
echo "📦 Installing dependencies..."

# Install frontend dependencies
echo "Installing frontend dependencies..."
cd frontend
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Frontend dependency installation failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Frontend dependencies installed${NC}"

# Install backend dependencies
echo "Installing backend dependencies..."
cd ../backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install -r requirements-test.txt
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Backend dependency installation failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Backend dependencies installed${NC}"

cd ..

echo ""
echo "🔧 Setting up database..."

# Check if .env exists
if [ ! -f "frontend/.env.local" ]; then
    echo -e "${YELLOW}⚠️  No .env.local found. Creating from .env.example...${NC}"
    cp .env.example frontend/.env.local
    echo -e "${YELLOW}⚠️  Please configure frontend/.env.local with your settings${NC}"
fi

if [ ! -f "backend/.env" ]; then
    echo -e "${YELLOW}⚠️  No backend .env found. Creating from .env.example...${NC}"
    cp .env.example backend/.env
    echo -e "${YELLOW}⚠️  Please configure backend/.env with your settings${NC}"
fi

# Generate Prisma client
cd frontend
npx prisma generate
echo -e "${GREEN}✅ Prisma client generated${NC}"

# Run migrations (if DATABASE_URL is set)
if [ ! -z "$DATABASE_URL" ]; then
    echo "Running database migrations..."
    npx prisma migrate deploy
    echo -e "${GREEN}✅ Database migrations applied${NC}"
    
    # Apply performance indexes
    if [ -f "../prisma/performance-indexes.sql" ]; then
        echo "Applying performance indexes..."
        psql $DATABASE_URL < ../prisma/performance-indexes.sql
        echo -e "${GREEN}✅ Performance indexes applied${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  DATABASE_URL not set. Skipping migrations.${NC}"
fi

cd ..

echo ""
echo "🧪 Running tests..."

# Frontend tests
echo "Running frontend tests..."
cd frontend
npm test -- --run
FRONTEND_TEST_RESULT=$?
cd ..

if [ $FRONTEND_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Frontend tests passed${NC}"
else
    echo -e "${RED}❌ Frontend tests failed${NC}"
fi

# Backend tests
echo "Running backend tests..."
cd backend
source venv/bin/activate
pytest
BACKEND_TEST_RESULT=$?
cd ..

if [ $BACKEND_TEST_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Backend tests passed${NC}"
else
    echo -e "${RED}❌ Backend tests failed${NC}"
fi

echo ""
echo "🏗️  Building frontend..."
cd frontend
npm run build
BUILD_RESULT=$?
cd ..

if [ $BUILD_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ Frontend build successful${NC}"
else
    echo -e "${RED}❌ Frontend build failed${NC}"
fi

echo ""
echo "=============================================="
echo "📊 Setup Summary"
echo "=============================================="

if [ $FRONTEND_TEST_RESULT -eq 0 ] && [ $BACKEND_TEST_RESULT -eq 0 ] && [ $BUILD_RESULT -eq 0 ]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
    echo ""
    echo "🚀 Ready for deployment!"
    echo ""
    echo "Next steps:"
    echo "  1. Configure environment variables in frontend/.env.local and backend/.env"
    echo "  2. Start development: npm run dev (frontend) and uvicorn main:app --reload (backend)"
    echo "  3. Or deploy to production using DEPLOYMENT_COMPLETE.md guide"
else
    echo -e "${RED}❌ Some checks failed. Please review the output above.${NC}"
fi

echo ""
