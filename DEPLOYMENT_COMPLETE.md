# Golden Seed Deployment Guide

## Prerequisites

### System Requirements
- **Node.js**: v18+ (v20 recommended)
- **Python**: 3.10+
- **PostgreSQL**: 14+
- **Redis**: 6+
- **Docker** (optional, for containerized deployment)

### Required Services
1. **PostgreSQL Database**: Production-ready instance
2. **Redis Server**: For rate limiting and caching
3. **Email Service**: Resend, SendGrid, or SMTP
4. **Payment Gateway**: Stripe account with API keys
5. **Monitoring** (optional): Sentry.io account

---

## Environment Configuration

### Backend (.env)
```bash
# Database
DATABASE_URL="postgresql://user:password@host:5432/dbname"

# Environment
ENVIRONMENT="production"  # development, staging, production

# CORS - Comma-separated allowed origins
ALLOWED_ORIGINS="https://app.funtravelo.com,https://admin.funtravelo.com"

# Redis
REDIS_URL="redis://redis-host:6379"
# Default is True if ENVIRONMENT=production, False otherwise
REQUIRE_REDIS="true"  

# Scout Agent (optional)
SCOUT_API_URL="https://scout-api.example.com"
SCOUT_API_KEY="your-scout-api-key"
```

### Frontend (.env.local)
```bash
# Database (same as backend)
DATABASE_URL="postgresql://user:password@host:5432/dbname"

# Auth
NEXTAUTH_SECRET="<generate-with: openssl rand -base64 32>"
NEXTAUTH_URL="https://app.funtravelo.com"
NODE_ENV="production"

# Stripe
STRIPE_SECRET_KEY="sk_live_..."
STRIPE_PUBLISHABLE_KEY="pk_live_..."
STRIPE_WEBHOOK_SECRET="whsec_..."
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY="pk_live_..."

# Monitoring (optional but recommended)
NEXT_PUBLIC_SENTRY_DSN="https://...@sentry.io/..."

# Redis
REDIS_URL="redis://redis-host:6379"

# Email (Resend)
RESEND_API_KEY="re_..."
EMAIL_FROM="noreply@funtravelo.com"

# S3/Cloudflare R2 (for file uploads)
S3_ENDPOINT="https://account-id.r2.cloudflarestorage.com"
S3_ACCESS_KEY_ID="..."
S3_SECRET_ACCESS_KEY="..."
S3_BUCKET_NAME="funtravelo-assets"
```

---

## Installation Steps

### 1. Clone Repository
```bash
git clone <repository-url>
cd golden-seed
```

### 2. Install Dependencies

**Frontend:**
```bash
cd frontend
npm install
```

**Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 3. Database Setup
```bash
cd frontend
npx prisma generate
npx prisma migrate deploy

# Optional: Seed database
npx prisma db seed
```

### 4. Apply Performance Indexes
```bash
psql $DATABASE_URL < prisma/performance-indexes.sql
```

### 5. Build Frontend
```bash
cd frontend
npm run build
```

---

## Deployment Options

### Option 1: Vercel (Frontend) + Fly.io (Backend)

**Frontend on Vercel:**
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd frontend
vercel

# Set environment variables in Vercel dashboard
```

**Backend on Fly.io:**
```bash
# Install Fly CLI
curl -L https://fly.io/install.sh | sh

# Create app
cd backend
fly launch

# Set secrets
fly secrets set DATABASE_URL="postgresql://..."
fly secrets set REDIS_URL="redis://..."
fly secrets set ALLOWED_ORIGINS="https://app.funtravelo.com"

# Deploy
fly deploy
```

### Option 2: Docker Compose

**Production docker-compose.yml:**
```yaml
version: '3.8'

services:
  postgres:
    image: postgres:14
    environment:
      POSTGRES_DB: goldenseed
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: always

  redis:
    image: redis:7-alpine
    restart: always
    command: redis-server --requirepass ${REDIS_PASSWORD}

  backend:
    build: ./backend
    environment:
      DATABASE_URL: postgresql://postgres:${DB_PASSWORD}@postgres:5432/goldenseed
      REDIS_URL: redis://:${REDIS_PASSWORD}@redis:6379
      ENVIRONMENT: production
      ALLOWED_ORIGINS: ${ALLOWED_ORIGINS}
    depends_on:
      - postgres
      - redis
    restart: always

  frontend:
    build: ./frontend
    environment:
      DATABASE_URL: postgresql://postgres:${DB_PASSWORD}@postgres:5432/goldenseed
      NEXTAUTH_SECRET: ${NEXTAUTH_SECRET}
      NEXTAUTH_URL: ${NEXTAUTH_URL}
      # ... other env vars
    depends_on:
      - postgres
    ports:
      - "3000:3000"
    restart: always

volumes:
  postgres_data:
```

**Deploy:**
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Option 3: Self-Hosted (Bare Metal/VPS)

**Install System Dependencies:**
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y nodejs npm postgresql redis-server nginx python3.10 python3.10-venv

# Configure PostgreSQL
sudo -u postgres createdb goldenseed
sudo -u postgres psql
# CREATE USER funtravelo WITH PASSWORD 'your-password';
# GRANT ALL PRIVILEGES ON DATABASE goldenseed TO funtravelo;

# Configure Redis
sudo systemctl enable redis-server
sudo systemctl start redis-server
```

**Setup Systemd Services:**

`/etc/systemd/system/funtravelo-backend.service`:
```ini
[Unit]
Description=FunTravelo Backend API
After=network.target postgresql.service redis.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/golden-seed/backend
Environment="PATH=/var/www/golden-seed/backend/venv/bin"
EnvironmentFile=/var/www/golden-seed/backend/.env
ExecStart=/var/www/golden-seed/backend/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
Restart=always

[Install]
WantedBy=multi-user.target
```

`/etc/systemd/system/funtravelo-frontend.service`:
```ini
[Unit]
Description=FunTravelo Frontend
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/golden-seed/frontend
EnvironmentFile=/var/www/golden-seed/frontend/.env.local
ExecStart=/usr/bin/npm start
Restart=always

[Install]
WantedBy=multi-user.target
```

**Enable and Start:**
```bash
sudo systemctl enable funtravelo-backend funtravelo-frontend
sudo systemctl start funtravelo-backend funtravelo-frontend
```

**Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name app.funtravelo.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name api.funtravelo.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

**Enable SSL with Let's Encrypt:**
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d app.funtravelo.com -d api.funtravelo.com
```

---

## Post-Deployment Checklist

### 1. Verify Health Endpoints
- **GET /health**: General status.
  - Fails (503) if DB is down OR if `REQUIRE_REDIS=true` and Redis is down.
  - Shows `redis: degraded` if `REQUIRE_REDIS=false` and Redis is down.
- **GET /health/readiness**: Kubernetes readiness. 
  - Fails (503) if `REQUIRE_REDIS=true` and Redis is unreachable.
  - Passes (200) otherwise.
- **GET /health/liveness**: Basic process check.

### 2. Test Core functionality
- [ ] User registration/login
- [ ] Password reset
- [ ] Golden Seed discovery
- [ ] Booking creation
- [ ] Payment processing (Stripe)
- [ ] Email sending

### 3. Monitor Logs
```bash
# Backend logs
tail -f /var/log/funtravelo-backend.log

# Frontend logs
tail -f /var/log/funtravelo-frontend.log

# Or with Docker
docker logs -f golden-seed-backend
docker logs -f golden-seed-frontend
```

### 4. Set Up Monitoring
- Configure Sentry for error tracking
- Set up uptime monitoring (UptimeRobot, Pingdom)
- Configure log aggregation (Datadog, New Relic)

### 5. Security
- [ ] SSL certificate installed and auto-renewal configured
- [ ] Firewall configured (only ports 80, 443, 22 open)
- [ ] Database backups scheduled
- [ ] Rate limiting verified
- [ ] CORS configured correctly

### 6. Performance
- [ ] CDN configured for static assets
- [ ] Redis cache working
- [ ] Database indexes applied
- [ ] Compression enabled

---

## Troubleshooting

### Backend won't start
```bash
# Check logs
sudo journalctl -u funtravelo-backend -n 50

# Verify environment
env | grep DATABASE_URL

# Test database connection
python -c "import psycopg2; psycopg2.connect('$DATABASE_URL')"
```

### Frontend build fails
```bash
# Clear cache
rm -rf .next node_modules
npm install
npm run build

# Check environment
npm run env-check
```

### Database connection errors
```bash
# Test connection
psql $DATABASE_URL

# Check migrations
npx prisma migrate status

# Reset (DANGEROUS - only in dev)
npx prisma migrate reset
```

### Redis connection errors
```bash
# Test Redis
redis-cli -u $REDIS_URL ping

# Check if Redis is running
sudo systemctl status redis-server
```

---

## Scaling Recommendations

### Horizontal Scaling
- Use load balancer (Nginx, HAProxy, Cloudflare)
- Deploy multiple backend instances
- Use managed PostgreSQL (AWS RDS, Supabase)
- Use managed Redis (AWS ElastiCache, Upstash)

### Database Optimization
- Enable connection pooling (PgBouncer)
- Set up read replicas
- Regular VACUUM and ANALYZE

### Caching Strategy
- Use Redis for frequently accessed data
- CDN for static assets (Cloudflare, Vercel Edge)
- React Query for client-side caching

---

## Backup Strategy

### Database Backups
```bash
# Daily backup script
#!/bin/bash
BACKUP_DIR="/var/backups/postgresql"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
pg_dump $DATABASE_URL > $BACKUP_DIR/backup_$TIMESTAMP.sql
# Keep only last 7 days
find $BACKUP_DIR -name "backup_*.sql" -mtime +7 -delete
```

### Schedule with cron
```bash
# Add to crontab
0 2 * * * /usr/local/bin/backup-db.sh
```

---

## Support

For issues or questions:
- Check logs first
- Review this documentation
- Contact development team

**Production Status**: ✅ Ready for deployment
