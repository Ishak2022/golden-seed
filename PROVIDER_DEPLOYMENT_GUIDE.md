# Provider Management System - Deployment Guide

## Prerequisites

### Environment Variables
Add the following to your `.env` file:

```bash
# Existing variables (ensure these are set)
DATABASE_URL=postgresql://user:password@localhost:5432/funtravelo
SECRET_KEY=your-secret-key-32-chars-minimum

# Provider Credentials (add after seeding)
# Expedia Rapid
EXPEDIA_API_KEY=your_expedia_api_key
EXPEDIA_SECRET=your_expedia_secret

# Booking.com
BOOKING_API_KEY=your_booking_api_key

# Kiwi Tequila
KIWI_API_KEY=your_kiwi_api_key

# Travelpayouts
TRAVELPAYOUTS_TOKEN=your_travelpayouts_token
TRAVELPAYOUTS_MARKER=your_affiliate_marker
```

## Deployment Steps

### 1. Database Migration

The Prisma schema has been extended with provider management tables. Run migrations:

```bash
cd backend
npx prisma migrate dev --name add_provider_management
```

Or if using raw SQL, the tables will be auto-created by SQLAlchemy on first run.

### 2. Seed Provider Data

Run the seed script to create Phase 1 providers:

```bash
cd backend
python scripts/seed_providers.py
```

This creates:
- **Expedia Rapid API** (Lodging) - Priority 10
- **Booking.com Demand API** (Lodging) - Priority 20
- **Kiwi Tequila API** (Flights Booking) - Priority 10
- **Travelpayouts / Aviasales** (Flights Discovery) - Priority 10

All providers are **disabled by default** until credentials are added.

### 3. Configure Providers via Backend API / Direct DB

The frontend Admin Dashboard has been removed for security. Use the Backend API (`:8000/docs`) or Prisma Studio to manage providers:

1. **Credentials Management**:
   - Add required API keys/secrets directly to the `ProviderCredential` table.
   - Use the `scripts/rotate_credentials.py` if available.

2. **Verify Connectivity**:
   - Use the health check worker cycle to verify provider status.
   - Enable providers by setting `enabled: true` in the `Provider` table.

3. **Configure Slots & Routing**:
   - Managed via the `ProviderSlot` table.
   - Adjust priority and `routing_rules_json` directly in the database.

### 4. Configure Packages (Backend Only)

Configuration of booking orders and rollback policies is now managed via global system settings in the backend or through the `Organization` policy JSON.

### 5. Verify Routing

Test the routing algorithm:

```bash
# In Python console
from app.services.provider_orchestrator import provider_orchestrator
from app.models import ProviderVertical
from app.core.database import SessionLocal

async def test_routing():
    async with SessionLocal() as db:
        provider = await provider_orchestrator.resolve_active_provider(
            db=db,
            vertical=ProviderVertical.Lodging,
            tenant_id=None,  # Global default
            context={"currency": "USD", "user_country": "US"}
        )
        print(f"Selected provider: {provider.name if provider else 'None'}")

import asyncio
asyncio.run(test_routing())
```

### 6. Health Monitoring (Optional Background Worker)

To enable automated health checks:

```bash
# Create a new background worker
cd backend
python -c "
import asyncio
from app.services.health_monitor import health_monitor

async def run():
    while True:
        await health_monitor.run_monitoring_cycle()
        await asyncio.sleep(300)  # Every 5 minutes

asyncio.run(run())
"
```

Or integrate into your existing background worker infrastructure.

## Security Checklist

- [ ] All provider credentials are encrypted at rest
- [ ] Admin actions are restricted to Backend/CLI (No Frontend UI leak)
- [ ] Secrets are masked in database logs
- [ ] Audit logs are enabled for all configuration changes
- [ ] Rate limits are configured per provider
- [ ] Test connections before enabling providers in production

## Monitoring

### Key Metrics to Monitor

1. **Provider Health**: Check `ProviderHealthMetric` table for error rates
2. **Routing Decisions**: Log which provider is selected for each request
3. **Credential Rotation**: Track `last_rotated_at` timestamps
4. **Audit Trail**: Review `ProviderAuditLog` for configuration changes

### System Metrics
The system tracks:
- Provider status (Enabled/Disabled)
- Environment mode (Sandbox/Production)
- Last health check timestamp
- P95 latency
- Error rate

## Troubleshooting

### Provider Not Selected by Routing Algorithm

**Symptoms**: No provider returned even though slots are configured

**Checks**:
1. Verify slot is enabled: `SELECT * FROM "ProviderSlot" WHERE enabled = true`
2. Check routing rules match request context (geo, currency)
3. Verify provider health metrics are not showing failures
4. Check priority ordering

### Credentials Not Decrypting

**Symptoms**: `[DECRYPTION_FAILED]` in logs

**Causes**:
- `SECRET_KEY` environment variable changed after encryption
- Corrupted encrypted_value in database

**Fix**: Rotate credentials via direct database updates or CLI scripts.

### Test Connection Fails

**Symptoms**: Connection test returns error

**Checks**:
1. Verify credentials are correct
2. Check environment mode (Sandbox vs Production URLs)
3. Verify network connectivity from server
4. Check provider API status page

## Tenant-Specific Overrides

To configure tenant-specific provider slots:

1. Create a slot with `tenant_id` = agency.id
2. Priority and routing rules override global defaults
3. If no tenant slots exist, falls back to global (tenant_id IS NULL)

Example via API:

```bash
curl -X POST http://localhost:8000/api/v1/admin/provider-slots \
  -H "Content-Type: application/json" \
  -d '{
    "vertical": "Lodging",
    "provider_id": "expedia-provider-id",
    "tenant_id": "agency-123",
    "enabled": true,
    "priority": 5,
    "routing_rules_json": {
      "currency_allow": ["EUR"]
    }
  }'
```

## Production Recommendations

1. **Use Production Mode**: Switch `environment_mode` to `PRODUCTION` after testing
2. **Enable Rate Limiting**: Configure Redis for production rate limiting
3. **Monitor Health**: Set up alerting on provider health metrics
4. **Rotate Credentials**: Establish a credential rotation schedule (e.g., quarterly)
5. **Backup Audit Logs**: Ensure `ProviderAuditLog` is included in backup strategy
6. **Load Test**: Verify routing performance under load
7. **Cache Properly**: Configure appropriate TTLs for each provider's cache policy

## Next Steps

- Integrate provider routing into booking flow
- Configure webhook endpoints for booking confirmations
- Set up monitoring dashboards for provider performance
- Document API rate limit consumption per tenant
