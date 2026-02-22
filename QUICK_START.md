# Golden Seed - Quick Start Guide

Get your Golden Seed project running in minutes!

## Prerequisites

- Node.js 18+
- Python 3.10+
- PostgreSQL 14+
- Redis 6+ (Optional in dev, required in production via `REQUIRE_REDIS` flag)

## 🚀 Quick Setup (Automated)

### Windows
```powershell
# Run the automated setup script
.\setup-and-verify.ps1
```

### Linux/Mac
```bash
# Make executable
chmod +x setup-and-verify.sh

# Run the automated setup script
./setup-and-verify.sh
```

The script will:
- ✅ Check prerequisites
- ✅ Install all dependencies
- ✅ Generate Prisma client
- ✅ Run database migrations
- ✅ Apply performance indexes
- ✅ Run all tests
- ✅ Build the frontend

---

## 🔧 Manual Setup

### 1. Install Dependencies

**Frontend:**
```bash
cd frontend
npm install
```

**Backend:**
```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate

pip install -r requirements.txt
pip install -r requirements-test.txt
```

### 2. Configure Environment

**Copy example environment files:**
```bash
cp .env.example frontend/.env.local
cp .env.example backend/.env
```

**Edit the files and set:**
- `DATABASE_URL` - Your PostgreSQL connection string
- `NEXTAUTH_SECRET` - Generate with: `openssl rand -base64 32`
- `REDIS_URL` - Your Redis connection string (optional)

### 3. Setup Database

```bash
cd frontend

# Generate Prisma client
npx prisma generate

# Run migrations
npx prisma migrate deploy

# Apply performance indexes
cd ..
psql $DATABASE_URL < prisma/performance-indexes.sql

# (Optional) Seed Demo Data
# WARNING: This requires ENVIRONMENT=development
npx prisma db seed
```

### 4. Run Tests

**Frontend:**
```bash
cd frontend
npm test
```

**Backend:**
```bash
cd backend
source venv/bin/activate  # or venv\Scripts\activate on Windows
pytest
```

### 5. Build and Run

**Development:**
```bash
# Terminal 1 - Frontend
cd frontend
npm run dev

# Terminal 2 - Backend
cd backend
source venv/bin/activate
uvicorn main:app --reload
```

**Production:**
```bash
# Build frontend
cd frontend
npm run build
npm start

# Run backend
cd backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4

### 6. Demo Credentials (Development Only)

| Role | Email | Password | Access Level |
|------|-------|----------|--------------|
| **Platform Admin** | `admin@demo.local` | `Admin123!` | **Backend/DB Only** |
| **Enterprise Owner** | `enterprise@demo.local` | `Enterprise123!` | Frontend Dashboard |
| **Agency Owner** | `agency@demo.local` | `Agency123!` | Frontend Dashboard |
```

---

## 🧪 Testing

### Run All Tests
```bash
# Frontend
cd frontend
npm test

# Backend
cd backend
pytest

# With coverage
npm run test:coverage  # Frontend
pytest --cov           # Backend
```

### Test Specific Features

**Rate Limiting:**
```bash
# Make 6 rapid requests (6th should return 429)
for i in {1..6}; do curl -X POST http://localhost:8000/api/auth/login; done
```

**Health Checks:**
```bash
curl http://localhost:8000/health
curl http://localhost:3000/api/health
```

**Account Lockout:**
- Attempt 5 failed logins
- 6th attempt should show "Account locked"

---

## 📊 Verify Installation

### Check Health Endpoints

**Backend:**
```bash
curl http://localhost:8000/health
```

Expected response (Success):
```json
{
  "status": "healthy",
  "checks": {
    "database": "healthy",
    "redis": "healthy"
  }
}
```

**Health Logic & Redis:**
- In **development** (`ENVIRONMENT=development`), Redis is optional. If down, `/health` shows `redis: degraded` but returns 200.
- In **production** (`ENVIRONMENT=production`), Redis is **mandatory** by default. If down:
  - `/health` returns 503 with `redis: unhealthy`.
  - `/health/readiness` returns 503 NOT READY.
- Override behavior by explicitly setting `REQUIRE_REDIS=true` or `false`.

**Frontend:**
```bash
curl http://localhost:3000/api/health
```

### Verify Security Features

**Check Security Headers:**
```bash
curl -I http://localhost:3000
```

Look for:
- `X-Frame-Options: DENY`
- `Content-Security-Policy`
- `Strict-Transport-Security` (in production)

**Test Rate Limiting:**
```bash
# Should get 429 on 6th request
for i in {1..6}; do 
  echo "Request $i"
  curl -w "\nStatus: %{http_code}\n" http://localhost:8000/api/v1/test
done
```

---

## 🐛 Troubleshooting

### Database Connection Errors

```bash
# Test connection
psql $DATABASE_URL

# Check if DATABASE_URL is set
echo $DATABASE_URL

# Reset migrations (DANGER - dev only)
npx prisma migrate reset
```

### Redis Connection Errors

```bash
# Check if Redis is running
redis-cli ping

# Should return: PONG
```

### Build Errors

```bash
# Clear caches
rm -rf frontend/.next frontend/node_modules
rm -rf backend/venv

# Reinstall
cd frontend && npm install
cd backend && python -m venv venv && pip install -r requirements.txt
```

### Port Already in Use

```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:3000 | xargs kill -9
```

---

## 🌐 Access Points

Once running:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs
- **Backend Health**: http://localhost:8000/health
- **Frontend Health**: http://localhost:3000/api/health

---

## 📚 Next Steps

1. **Explore the API**: Visit http://localhost:8000/docs
2. **Review Documentation**: 
   - `API_DOCUMENTATION.md` - API reference
   - `DEPLOYMENT_COMPLETE.md` - Deployment guide
3. **Deploy to Production**: Follow the deployment guide
4. **Set up Monitoring**: Configure Sentry with `NEXT_PUBLIC_SENTRY_DSN`

---

## 🔐 Security Checklist

Before going to production:

- [ ] Change `NEXTAUTH_SECRET` from default
- [ ] Set `ALLOWED_ORIGINS` to your domain
- [ ] Configure `REDIS_URL` for rate limiting
- [ ] Set up SSL certificates
- [ ] Configure `NEXT_PUBLIC_SENTRY_DSN` for monitoring
- [ ] Review and set all environment variables
- [ ] Run security audit: `npm audit` (frontend)
- [ ] Test rate limiting and account lockout

---

## 💡 Tips

- Use `npm run test:watch` for test-driven development
- Use `npm run test:ui` for visual test interface
- Check logs in `logs/` directory
- Monitor Redis with `redis-cli monitor`
- Use PostgreSQL query planner: `EXPLAIN ANALYZE <query>`

---

## 🆘 Need Help?

1. Check the logs first
2. Review `DEPLOYMENT_COMPLETE.md` troubleshooting section
3. Verify environment variables are set correctly
4. Check database and Redis connectivity

**Production Status**: ✅ Ready to deploy!
