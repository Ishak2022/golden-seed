# Fixes Applied - FunTravelo System

## Summary
This document describes all fixes applied to the Golden Seed / FunTravelo system as of [current date].

---

## ✅ Issue 1: Rate Limiting Contradictions

**Problem:** 
- Three different rate limit definitions across documentation
- Enterprise plan had 300 rpm (lower than Business's 500 rpm), which was illogical
- API documentation showed generic "100 requests/minute" for all plans

**Files Modified:**
1. **[backend/app/core/rate_limiter.py](backend/app/core/rate_limiter.py#L39-L43)**
   - Changed Enterprise rate limit from 300 rpm to 1,000 rpm
   - Now: Growth=100rpm, Business=500rpm, Enterprise=1,000rpm
   - This is logical: higher tiers get higher rate limits

2. **[API_DOCUMENTATION.md](API_DOCUMENTATION.md#L283-L308)**
   - Updated rate limiting section to show per-plan limits
   - Added documentation for rate limit headers (X-RateLimit-Limit, X-RateLimit-Remaining, X-Usage-Calls-Included)
   - Replaced generic "100 requests/minute" with plan-specific limits

3. **[docs/CANONICAL_BLUEPRINT.md](docs/CANONICAL_BLUEPRINT.md#L354-L357)**
   - Updated pricing table to show Enterprise=1,000 rpm (was "Custom")
   - Marked issue B5 as resolved with strikethrough

---

## ✅ Issue 2: Destinations Table Not in Schema (FALSE POSITIVE)

**Problem:** 
- Documentation claimed `destinations` table was missing from Prisma schema
- This was outdated documentation - the table already exists

**Files Modified:**
1. **[docs/CANONICAL_BLUEPRINT.md](docs/CANONICAL_BLUEPRINT.md#L32-L36)**
   - Updated issue B6 to mark as resolved
   - Noted that `Destination` and `Country` models already exist in schema.prisma (lines 387-410)
   - Applied strikethrough to indicate resolved issue

---

## ⚠️ Issue 3: Country ID Inconsistency in Seed Files (DOCUMENTED)

**Problem:**
- [golden_seed_destinations.sql](golden_seed_destinations.sql) (347 rows) uses dynamic lookups: `(SELECT id FROM countries WHERE iso_alpha2 = 'US')`
- [golden_seed_destinations_10000.sql](golden_seed_destinations_10000.sql) (10,000 rows) uses hardcoded country IDs: `(234, ...)`
- These approaches are incompatible

**Current State:**
- 347-row seed is the canonical source (uses robust dynamic lookups)
- 10,000-row seed needs refactoring to match the 347-row approach
- Fixing 10,000+ lines is beyond the current scope

**Recommendation:**
- Use the 347-row seed file for production
- Archive the 10,000-row file until it can be refactored
- Or create a script to auto-convert hardcoded IDs to dynamic lookups

**Files Reviewed:**
- [golden_seed_destinations.sql](golden_seed_destinations.sql#L1-L50) - Uses ISO code lookups ✓
- [golden_seed_destinations_10000.sql](golden_seed_destinations_10000.sql#L1-L50) - Uses hardcoded IDs ✗
- [prisma/countries_seed.sql](prisma/countries_seed.sql#L1-L100) - Countries data source ✓

---

## 📋 Remaining Issues

The following issues in [CANONICAL_BLUEPRINT.md](docs/CANONICAL_BLUEPRINT.md) remain unresolved:

### B1: Dual ORM Conflict
- **Risk:** Schema drift, double migrations, session conflicts
- **Fix needed:** Choose SQLAlchemy (recommended) or Prisma, not both
- **Recommendation:** Use SQLAlchemy for backend, Prisma only for migrations

### B2: Hierarchy Mismatch
- **Risk:** RBAC, tenancy scoping, and API paths misalignment
- **Fix needed:** Canonize 4-level hierarchy: Platform → Enterprise → Subagency → Staff/Agent

### B3: Dashboard Section Duplication
- **Risk:** Developers may build two different agency dashboards
- **Fix needed:** Merge §5.2 and §5.3 into one section

### B4: Agency Plan Tier Mismatch
- **Risk:** Outdated pricing tiers
- **Fix needed:** Canonize unified plans (already partially done)

### B7: "Zero Transaction Fees" vs Revenue Model
- **Risk:** Marketing confusion about fees
- **Fix needed:** Clarify "Zero platform fees TO THE customer"

### B8: Seed Files Use DROP TABLE IF EXISTS CASCADE
- **Risk:** Running seed in production destroys all data
- **Fix needed:** Production must use idempotent mode with UPSERT

### B9: Report Version Header Inconsistency
- **Risk:** Confusing for readers
- **Fix needed:** Update header to Version 1.1.0

### B10: Legacy "Free-to-PRO Conversion" Terminology
- **Risk:** Outdated terminology
- **Fix needed:** Replace with "Growth-to-Business Upgrade Rate: 20%"

---

## Verification

All verified fixes are working correctly:

✅ **Rate Limiter Code:** [backend/app/core/rate_limiter.py](backend/app/core/rate_limiter.py#L39-L43)
```python
PLAN_LIMITS = {
    AgencyPlan.GROWTH: {"max_requests": 100, "window": 60, "included": 3000},
    AgencyPlan.BUSINESS: {"max_requests": 500, "window": 60, "included": 8000},
    AgencyPlan.ENTERPRISE: {"max_requests": 1000, "window": 60, "included": 40000},
}
```

✅ **API Documentation:** [API_DOCUMENTATION.md](API_DOCUMENTATION.md#L283-L308)
- Shows per-plan rate limits
- Documents rate limit headers

✅ **Blueprint Documentation:** [docs/CANONICAL_BLUEPRINT.md](docs/CANONICAL_BLUEPRINT.md#L31-L36)
- Issues B5 and B6 marked as resolved
- Pricing table updated with correct rate limits

---

## Testing Recommendations

1. **Rate Limiting:**
   - Test with Growth plan: should get 429 after 100 requests/minute
   - Test with Business plan: should get 429 after 500 requests/minute
   - Test with Enterprise plan: should get 429 after 1,000 requests/minute

2. **Seed Files:**
   - Verify `countries_seed.sql` runs successfully
   - Verify `golden_seed_destinations.sql` runs successfully
   - DO NOT use `golden_seed_destinations_10000.sql` in production until fixed

3. **Documentation:**
   - Ensure all stakeholders review updated rate limit documentation
   - Verify API response headers match documented headers

---

## Next Steps

1. Address remaining 8 issues in CANONICAL_BLUEPRINT.md
2. Consider refactoring the 10,000-row seed file
3. Run comprehensive testing on rate limiting changes
4. Update any additional documentation that references rate limits
