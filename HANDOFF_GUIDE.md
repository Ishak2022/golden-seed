# FunTravelo B2B - Handoff Guide

## Documentation Index
- **[System Report](file:///C:/Users/User/Desktop/GOLDEN%20FOLDERS/golden%20seed/FUNTRAVELO_SYSTEM_REPORT.txt)**: Overall B2B architecture and business model.
- **[API Documentation](file:///C:/Users/User/Desktop/GOLDEN%20FOLDERS/golden%20seed/API_DOCUMENTATION.md)**: Full REST API reference with verified routes.
- **[Quick Start](file:///C:/Users/User/Desktop/GOLDEN%20FOLDERS/golden%20seed/QUICK_START.md)**: Local development setup.

## Acceptance Evidence

### Agentic Service Verification (E2E)
The "Zero-Touch" agents (Scout & Sentinel) have been verified end-to-end using a dedicated worker loop (`backend/scripts/agent_worker.py`).

#### 1. Scout Agent (Golden Seeds)
- **Action**: Scanning markets for arbitrage opportunities between Wholesale (Amadeus) and retail inventory.
- **Entrypoint**: `scout_agent.scan_market()`
- **Evidence**:
  - Found: **Holiday Inn Paris** (41.18% Margin)
  - Found: **Grand Hyatt London** (200.00% Margin)
  - DB Record ID: `61f6ddeb-36cd-400c-8d3f-f52e9eb0c392`
  - DB Record ID: `a5bcbe3c-dfd8-4961-aecc-0807f7a59502`
  - Timestamp: `2026-02-11 18:59:46 UTC`

#### 2. Sentinel Agent (Proactive Protection)
- **Action**: Monitoring PNR updates for delays/cancellations and triggering proactive re-booking.
- **Entrypoint**: `sentinel_agent.process_pnr_update()`
- **Evidence**:
  - Event: `DELAYED` (150min) for PNR-195947
  - Action: `REBOOKED` (Auto-rebooked due to PNR_UPDATE)
  - DB Record ID: `1c9563cf-08d3-4454-b298-b4b94c72e2a6`
  - Timestamp: `2026-02-11 19:00:52 UTC`

#### 3. Negative Testing
- **Procedure**: Terminated `agent_worker.py` and observed database state for 120 seconds.
- **Result**: Record counts remained static; no new Golden Seeds or Sentinel Events were generated, proving the worker is the sole authoritative source of these actions.

---

## 8. Development & Support
- **[Deployment Guide](file:///C:/Users/User/Desktop/GOLDEN%20FOLDERS/golden%20seed/DEPLOYMENT_COMPLETE.md)**: Production infrastructure setup.

## Required Environment Variables

### Backend (`backend/.env`)
- `DATABASE_URL`: PostgreSQL connection string (Neon/RDS).
- `SECRET_KEY`: Minimum 32-character JWT signing key.
- `REDIS_URL`: Redis connection string.
- `REQUIRE_REDIS`: If `true`, fails health/readiness if Redis is down. 
  - *Default*: `true` if `ENVIRONMENT=production`, otherwise `false`.
- `ALLOWED_ORIGINS`: Comma-separated list of allowed CORS origins.

### Frontend (`frontend/.env.local`)
- `DATABASE_URL`: Same as backend.
- `NEXTAUTH_SECRET`: Used for session encryption.
- `NEXTAUTH_URL`: Your base application URL.

## Seed / Demo Users

| Role | Email | Password | Scope |
| :--- | :--- | :--- | :--- |
| PLATFORM_ADMIN | `admin@platform.com` | `admin123` | Global (Backend/DB Only) |
| AGENCY_ADMIN | `agency1@test.com` | `pass123` | Tenant-Scoped |
| STAFF_USER | `staff1@test.com` | `pass123` | Tenant-Scoped |

*To create more users, use the `scripts/seed_b2b.py` or direct database overrides (Prisma).*

## Commands to Run

### 1. Start Backend
```powershell
cd backend
python -m uvicorn main:app --reload --port 8000
```

### 2. Run Verification Suite
```powershell
python -m pytest backend/tests
```

### 3. Run E2E Smoke Test
```powershell
python scripts/smoke_test.py
```

### 4. Direct Health Check
```bash
curl http://localhost:8000/health
```

## Expected Verification Output
- **Pytest**: All 15+ tests should pass with Green.
- **Smoke Test**: Should confirm:
  - Phase 1: Institutional Admin Auth SUCCESS
  - Phase 2: Agency Operations SUCCESS
  - Phase 3: Cross-Tenant Isolation SUCCESS

## Support & Maintenance
The platform is designed for zero-adoption friction. Agencies can be provisioned instantly via the Enterprise Dashboard or direct API calls without technical intervention.
