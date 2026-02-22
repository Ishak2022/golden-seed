Version 1.3.0 | February 2026

## Base URLs

- **Production**: `https://api.funtravelo.com` (Main Institutional Gateway)
- **Staging**: `https://staging-api.funtravelo.com`
- **Development**: `http://localhost:8000`

## Authentication

All authenticated endpoints require a valid Multi-Tenant session or API key.

### Session Authentication (Dashboard Users)
```typescript
// Login via Agency/Enterprise credentials
import { signIn } from 'next-auth/react';
await signIn('credentials', { email, password });
```

### API Key Authentication (API Clients)
*Available for Growth, Business, and Enterprise plans.*

```bash
curl -H "X-API-KEY: your-api-key" \
     -H "X-Enterprise-ID: your-ent-id" \
     -H "X-Agency-ID: your-agency-id" \
     https://api.funtravelo.com/api/v1/...
```

## Smoke Test Routes
The following endpoints are priority for Client acceptance testing:
- **Auth**: `POST /api/v1/auth/login`
- **Enterprise**: `GET /api/v1/enterprises`, `POST /api/v1/enterprises`
- **Subagency Management**: `POST /api/v1/enterprises/{id}/subagencies`, `GET /api/v1/enterprises/{id}/subagencies`
- **Golden Seed Search**: `GET /api/v1/agencies/{id}/golden-seeds`
- **Institutional Booking**: `POST /api/v1/agencies/{id}/bookings`, `GET /api/v1/agencies/{id}/bookings`

---

## Health Check Endpoints

### GET /health
Returns overall system health status.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-02-10T05:50:00.000Z",
  "checks": {
    "database": "healthy",
    "redis": "healthy"
  },
  "version": "1.0.0",
  "environment": "production"
}
```

### GET /health/readiness
Kubernetes readiness probe.

### GET /health/liveness
Kubernetes liveness probe.

---

## Golden Seeds API

### GET /api/v1/agencies/{id}/golden-seeds
Get list of active Golden Seed opportunities for a specific agency.

**Query Parameters:**
- `origin` (optional): Origin airport code
- `destination` (optional): Destination airport code
- `minSavings` (optional): Minimum percentage savings (default: 15)
- `page` (optional): Page number (default: 1)
- `limit` (optional): Results per page (default: 20, max: 100)

**Response:**
```json
{
  "data": [
    {
      "id": "gs_123",
      "origin": "LAX",
      "destination": "JFK",
      "departureDate": "2026-03-01",
      "returnDate": "2026-03-08",
      "currentPrice": 250.00,
      "originalPrice": 300.00,
      "delta": 50.00,
      "percentageSavings": 16.67,
      "source": "kayak",
      "confidence": 0.95,
      "expiresAt": "2026-02-10T23:59:59.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 145,
    "pages": 8
  }
}
```

### GET /api/v1/agencies/{id}/golden-seeds/{seed_id}
Get specific Golden Seed details.
Get specific Golden Seed details.

**Response:**
```json
{
  "id": "gs_123",
  "origin": "LAX",
  "destination": "JFK",
  "departureDate": "2026-03-01",
  "returnDate": "2026-03-08",
  "currentPrice": 250.00,
  "originalPrice": 300.00,
  "delta": 50.00,
  "percentageSavings": 16.67,
  "source": "kayak",
  "confidence": 0.95,
  "metadata": {
    "airline": "Delta",
    "stops": 0,
    "cabin": "Economy"
  },
  "createdAt": "2026-02-10T00:00:00.000Z",
  "expiresAt": "2026-02-10T23:59:59.000Z"
}
```

---

## Booking API

### POST /api/v1/agencies/{id}/bookings
Create a new booking for an agency.

**Request Body:**
```json
{
  "goldenSeedId": "gs_123",
  "passengers": [
    {
      "firstName": "John",
      "lastName": "Doe",
      "email": "john@example.com",
      "dateOfBirth": "1990-01-01"
    }
  ],
  "paymentMethodId": "pm_stripe_123"
}
```

**Response:**
```json
{
  "id": "booking_abc",
  "status": "CONFIRMED",
  "confirmationCode": "ABC123",
  "totalAmount": 250.00,
  "currency": "USD",
  "createdAt": "2026-02-10T05:50:00.000Z"
}
```

### GET /api/v1/agencies/{id}/bookings
List agency's bookings.

**Query Parameters:**
- `status` (optional): Filter by status (PENDING, CONFIRMED, CANCELLED)
- `page`, `limit`: Pagination

### GET /api/v1/bookings/:id
Get booking details.

### PUT /api/v1/bookings/:id/cancel
Cancel a booking.

---

## Subagency API

### POST /api/v1/search
Headless search API for API Clients.

**Headers:**
- `X-API-KEY: your-api-key`

**Request:**
```json
{
  "origin": "LAX",
  "destination": "JFK",
  "departureDate": "2026-03-01",
  "returnDate": "2026-03-08",
  "passengers": 2
}
```

**Response:**
```json
{
  "results": [
    {
      "price": 250.00,
      "savings": 50.00,
      "percentageSavings": 16.67,
      "airline": "Delta",
      "departure": "2026-03-01T10:00:00Z",
      "arrival": "2026-03-01T18:30:00Z",
      "bookingUrl": "https://app.funtravelo.com/book/gs_123"
    }
  ]
}
```

### GET /api/v1/b2b/analytics
Get API usage analytics.

**Response:**
```json
{
  "period": "last_30_days",
  "requests": 15234,
  "successRate": 99.2,
  "avgResponseTime": 145,
  "topEndpoints": [
    {
      "endpoint": "/search",
      "requests": 12000
    }
  ]
}
```

---

## User Management API

### GET /api/v1/users/me
Get current user profile.

### PUT /api/v1/users/me
Update user profile.

### POST /api/v1/users/change-password
Change password.

---

## Payment API

### POST /api/v1/stripe/create-checkout-session
Create Stripe checkout session.

### POST /api/v1/stripe/webhook
Stripe webhook handler (internal use).

### POST /api/v1/stripe/portal
Create Stripe customer portal session.

---

## Admin API

All admin endpoints require admin role.

### GET /api/v1/admin/users
List all users.

### GET /api/v1/admin/metrics
System metrics dashboard.

### GET /api/v1/admin/audit-logs
View audit logs.

---

## Rate Limiting

All endpoints are rate limited based on the agency's plan:

- **GROWTH Plan**: 100 requests/minute (3,000 calls/month included)
- **BUSINESS Plan**: 500 requests/minute (8,000 calls/month included)
- **ENTERPRISE Plan**: 1,000 requests/minute (40,000 calls/month included)

Rate limits are enforced per-tenant using Redis sliding window counters.

**Response (429 Too Many Requests):**
```json
{
  "error": "Too many requests",
  "message": "Rate limit exceeded. Max 100 requests per 60 seconds."
}
```

**Rate Limit Headers:**
- `X-RateLimit-Limit`: Maximum requests per minute
- `X-RateLimit-Remaining`: Remaining requests in current window
- `X-Usage-Calls-Included`: Total API calls included in plan


---

## Error Responses

### Standard Error Format
```json
{
  "error": "ErrorType",
  "message": "Human-readable error message",
  "code": "ERROR_CODE",
  "details": {}
}
```

### HTTP Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `429` - Too Many Requests
- `500` - Internal Server Error
- `503` - Service Unavailable

---

## Webhooks

### Stripe Webhooks
Configure in Stripe Dashboard:
- **URL**: `https://api.funtravelo.com/api/v1/stripe/webhook`
- **Events**: `checkout.session.completed`, `customer.subscription.updated`

---

## SDKs & Examples

### JavaScript/TypeScript
```typescript
import { FunTraveloClient } from '@funtravelo/sdk';

const client = new FunTraveloClient({
  apiKey: 'your-api-key',
  baseUrl: 'https://api.funtravelo.com'
});

const goldenSeeds = await client.goldenSeeds.list({
  origin: 'LAX',
  destination: 'JFK',
  minSavings: 15
});
```

### Python
```python
from funtravelo import Client

client = Client(api_key='your-api-key')
golden_seeds = client.golden_seeds.list(
    origin='LAX',
    destination='JFK',
    min_savings=15
)
```

### cURL
```bash
curl -H "X-API-KEY: your-api-key" \
  "https://api.funtravelo.com/api/v1/golden-seeds?origin=LAX&destination=JFK"
```

---

## Changelog

### v1.3.0 (2026-02-12)
- Strategic Pivot: Agency vs. Enterprise focus
- Simplified API Key scoping (Growth/Business/Enterprise only)
- Hierarchical terminology update (Enterprise -> Subagency -> Agent)
- Restructured Booking ledger

### v1.0.0 (2026-02-10)
- Initial API release
- Golden Seeds endpoints
- Booking management
- Agency/Enterprise API
- Health checks and monitoring

---

**API Status**: ✅ Production Ready  
**Last Updated**: February 12, 2026
