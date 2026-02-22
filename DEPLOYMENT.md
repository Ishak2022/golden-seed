# GOLDEN SEED DEPLOYMENT GUIDE (v1.0)

## 🚀 QUICK START
1. **Install Docker**: [Download Docker Desktop](https://www.docker.com/products/docker-desktop)
2. **Start System**:
   ```bash
   docker-compose up --build
   ```
3. **Access Dashboards**:
   - Frontend: `http://localhost:3000`
   - Backend API: `http://localhost:8000/docs`

---
## 🔑 ENVIRONMENT VARIABLES
Create a `.env` file in the root directory (if not exists) with these real credentials:

```ini
# CORE
DATABASE_URL=postgresql://postgres:postgres@db:5432/goldenseed
NEXTAUTH_SECRET=changeme_in_prod
NEXTAUTH_URL=http://localhost:3000

# SECURITY
SCOUT_API_KEY=your_secure_internal_key_here

# REAL API KEYS (Required for Logical Agents)
AMADEUS_CLIENT_ID=your_amadeus_client_id
AMADEUS_CLIENT_SECRET=your_amadeus_secret
AMADEUS_ENV=PROD

# BILLING
STRIPE_SECRET_KEY=sk_test_...
PADDLE_WEBHOOK_SECRET=your_paddle_secret
```

---
## 🏗 ARCHITECTURE
- **Frontend Container**: Node.js 18 (Standalone)
- **Backend Container**: Python 3.10 (FastAPI)
- **Database**: PostgreSQL 15
- **Cache**: Redis 7

## ⚠️ TROUBLESHOOTING
- **"Port already in use"**: Stop other running web servers or changed ports in `docker-compose.yml`.
- **"Connection Refused"**: Ensure the `db` container is healthy before the backend tries to connect (it has auto-retry logic).
