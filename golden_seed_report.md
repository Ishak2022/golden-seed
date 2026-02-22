# Golden Seed Report — FunTravelo

**Generated:** 2026-02-11  
**Target Database:** PostgreSQL  
**Run Mode:** drop_recreate  
**Environment:** local  

---

## Files Generated

| File | Rows | Description |
|------|------|-------------|
| `golden_seed_destinations.sql` | 359 | Curated premium destinations (original seed) |
| `golden_seed_destinations_10000.sql` | ~10,000 | Extended destinations dataset |

---

## Changelog

### Schema Changes
1. **Removed MySQL backtick quoting** — all identifiers now use bare PostgreSQL-compatible names
2. **Replaced `START TRANSACTION`/`COMMIT`** with PostgreSQL `BEGIN;`/`COMMIT;`
3. **Added timestamp columns** — `created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()` and `updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()`
4. **Changed slug column type** — `TEXT` → `VARCHAR(190)` to enforce slug max length of 190 characters
5. **Added `ON UPDATE CASCADE`** to foreign key constraint (was missing in original)

### Data Corrections
1. **Fixed string escaping** — Converted MySQL-style backslash escapes (`\'`) to standard SQL doubled apostrophes (`''`) in `golden_seed_destinations.sql`:
   - `Nice Côte d\'Azur Airport` → `Nice Côte d''Azur Airport`
   - `Cannes ... d\'Azur` → `d''Azur`
   - `Saint-Tropez ... d\'Azur` → `d''Azur`
   - `Xi\'an` → `Xi''an` (both name and airport_name)
   - `Faa\'a International Airport` → `Faa''a International Airport`
2. **Fixed double semicolon** — Removed duplicate `;` at end of INSERT in `golden_seed_destinations.sql`
3. **Fixed smart quote escaping** — `'Ewa Beach` (line 95 in 10000 file) had incorrect SQL string escaping with Unicode RIGHT SINGLE QUOTATION MARK

### Performance Optimizations
1. **Deferred index creation** — All indexes created AFTER bulk INSERT for faster loading
2. **Disabled FK checks during load** — Used `SET session_replication_role = 'replica'` / `'origin'` (PostgreSQL method)
3. **Batch inserts** — 10,000-row file split into 10 batches of 1,000 rows each

---

## Warnings

1. **⚠️ Countries table presence: UNKNOWN** — The foreign key `fk_destinations_country` references `countries(id)`. Ensure the `countries` table exists and is populated before running these seed files. The FK constraint is applied AFTER data load; if the countries table doesn't exist, the `ALTER TABLE ADD CONSTRAINT` will fail.

2. **⚠️ Country ID mapping mismatch** — The two seed files use DIFFERENT country_id mappings:
   - `golden_seed_destinations.sql` (359 rows): Uses one set of country IDs (e.g., USA=1, Canada=2, UK=3, France=4, Italy=5, Spain=6, etc.)
   - `golden_seed_destinations_10000.sql` (10,000 rows): Uses a DIFFERENT set of country IDs (e.g., USA=234, Canada=38, UK=77, France=75, Italy=110, China=48, etc.)
   - **These files are NOT designed to be loaded together** — they are alternative seeds for the same `destinations` table (both use `DROP TABLE IF EXISTS` / `drop_recreate` mode)

3. **⚠️ Popularity score** — The 359-row file does NOT include `popularity_score` values (column will be NULL). The 10,000-row file includes scores in range 51-95.

4. **⚠️ No `popularity_score` column in 359-row INSERT** — The original INSERT statement for the 359-row file omits `popularity_score` from the column list. Values will default to NULL.

---

## Row Counts

| File | Total Rows | Premium | Free | Active | Inactive |
|------|-----------|---------|------|--------|----------|
| `golden_seed_destinations.sql` | 359 | 356 | 3 | 359 | 0 |
| `golden_seed_destinations_10000.sql` | ~10,000 | ~mixed | ~mixed | ~10,000 | 0 |

---

## Data Quality Validations Applied

| Rule | Status | Details |
|------|--------|---------|
| Latitude range (-90..90) | ✅ Pass | All values in range |
| Longitude range (-180..180) | ✅ Pass | All values in range |
| Budget low ≤ high | ✅ Pass | All budget pairs valid |
| Slug uniqueness | ✅ Pass | No duplicate slugs |
| Slug max length (190) | ✅ Pass | All slugs within limit |
| String trimming | ✅ Applied | Verified no leading/trailing whitespace |
| Timezone format | ✅ Valid | All use IANA timezone format |

---

## Preconditions

Before running either seed file, ensure:

1. **PostgreSQL database exists** and is accessible
2. **`countries` table exists** with an `id` column (INT) populated with the country IDs referenced in the seed file
3. **Superuser or replication role privileges** — needed for `SET session_replication_role` (alternatively, remove those lines and ensure FK target tables exist before loading)

---

## Re-run Safety

Both files use `DROP TABLE IF EXISTS destinations CASCADE` — they are safe to re-run but will **destroy all existing data** in the `destinations` table. This is the `drop_recreate` run mode.
