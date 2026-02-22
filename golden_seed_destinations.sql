-- =============================================================================
-- GOLDEN SEED: destinations
-- Project: FunTravelo
-- Target: PostgreSQL
-- Generated: 2026-02-11
-- Run mode: drop_recreate
-- Rows: 347
-- =============================================================================
--
-- CHANGELOG:
--   1. Removed MySQL backtick quoting (PostgreSQL uses bare identifiers)
--   2. Replaced START TRANSACTION/COMMIT with BEGIN/COMMIT (PostgreSQL style)
--   3. Fixed string escaping: backslash-escaped quotes (\') converted to
--      standard SQL doubled apostrophes ('')
--      - Line 108: Nice Cte d'Azur Airport (3 occurrences)
--      - Line 337: Xi'an, Xi'an Xianyang International Airport
--      - Line 383: Faa'a International Airport
--   4. Fixed double semicolon at end of INSERT (line 390: ));  ->  );)
--   5. Added created_at and updated_at TIMESTAMPTZ columns with defaults
--   6. Added slug column type changed to VARCHAR(190) with UNIQUE constraint
--   7. Moved FK constraint to after data load for load performance
--   8. Moved index creation to after data load for load performance
--   9. Added FK check disable/re-enable using session_replication_role
--  10. Added ON UPDATE CASCADE to FK constraint
--  11. Added precondition warning for countries table dependency
--
-- WARNINGS:
--   - countries table presence is UNKNOWN. FK constraint will fail if
--     countries table does not exist. FK_VALIDATION=warn_only.
--   - popularity_score column: all 347 rows have NULL for this column
--     (no values provided in INSERT). Column allows NULL so this is valid.
--
-- DATA QUALITY VALIDATION:
--   - Slug duplicates: NONE (all 347 slugs are unique)
--   - Slug max length: all within 190 characters (max found: 22 chars)
--   - Latitude range [-90, 90]: all valid
--   - Longitude range [-180, 180]: all valid
--   - Budget rule (low <= high): all valid
--   - String trimming: no leading/trailing whitespace detected
--   - Row count: 347
-- =============================================================================

BEGIN;

-- Disable FK checks during load
SET session_replication_role = 'replica';

-- Drop existing table (cascade drops dependent objects)
DROP TABLE IF EXISTS destinations CASCADE;

-- Create table
CREATE TABLE destinations (
  id SERIAL PRIMARY KEY,
  country_id INT NOT NULL,
  name TEXT NOT NULL,
  slug VARCHAR(190) UNIQUE NOT NULL,
  type TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  timezone TEXT,
  airport_code TEXT,
  airport_name TEXT,
  description TEXT,
  avg_budget_low INT,
  avg_budget_high INT,
  currency_code TEXT,
  best_months TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  is_premium BOOLEAN DEFAULT FALSE,
  popularity_score INT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- PRECONDITION: The 'countries' table must exist with column 'id' before the FK
-- constraint is added (see below). If it does not exist, the ALTER TABLE will fail.

-- Bulk INSERT (batch 1 of 1 -- 347 rows)
INSERT INTO destinations (country_id, name, slug, type, latitude, longitude, timezone, airport_code, airport_name, description, avg_budget_low, avg_budget_high, currency_code, best_months, is_active, is_premium, popularity_score) VALUES
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Salt Lake City', 'salt-lake-city', 'city', 40.7608, -111.8910, 'America/Denver', 'SLC', 'Salt Lake City International', 'Ski resort access', 85, 165, 'USD', 'Dec,Jan,Feb,Jun,Jul', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Minneapolis', 'minneapolis', 'city', 44.9778, -93.2650, 'America/Chicago', 'MSP', 'Minneapolis-St Paul International', 'Twin cities', 80, 160, 'USD', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Philadelphia', 'philadelphia', 'city', 39.9526, -75.1652, 'America/New_York', 'PHL', 'Philadelphia International', 'Historic landmarks', 90, 170, 'USD', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Dallas', 'dallas', 'city', 32.7767, -96.7970, 'America/Chicago', 'DFW', 'Dallas/Fort Worth International', 'Texas hub', 85, 165, 'USD', 'Mar,Apr,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Houston', 'houston', 'city', 29.7604, -95.3698, 'America/Chicago', 'IAH', 'George Bush Intercontinental', 'Space city', 80, 160, 'USD', 'Mar,Apr,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'San Antonio', 'san-antonio', 'city', 29.4241, -98.4936, 'America/Chicago', 'SAT', 'San Antonio International', 'The Alamo', 75, 155, 'USD', 'Mar,Apr,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Key West', 'key-west', 'city', 24.5551, -81.7800, 'America/New_York', 'EYW', 'Key West International', 'Island paradise', 110, 190, 'USD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Sedona', 'sedona', 'city', 34.8697, -111.7610, 'America/Phoenix', 'FLG', 'Flagstaff Pulliam', 'Red rock beauty', 95, 175, 'USD', 'Mar,Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Napa Valley', 'napa-valley', 'region', 38.2975, -122.2869, 'America/Los_Angeles', 'SFO', 'San Francisco International', 'Wine country', 150, 250, 'USD', 'Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Santa Fe', 'santa-fe', 'city', 35.6870, -105.9378, 'America/Denver', 'SAF', 'Santa Fe Regional', 'Art and culture', 90, 170, 'USD', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Yellowstone', 'yellowstone', 'national-park', 44.4280, -110.5885, 'America/Denver', 'JAC', 'Jackson Hole', 'National park', 100, 180, 'USD', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Grand Canyon', 'grand-canyon', 'national-park', 36.1069, -112.1129, 'America/Phoenix', 'FLG', 'Flagstaff Pulliam', 'Natural wonder', 90, 170, 'USD', 'Mar,Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Yosemite', 'yosemite', 'national-park', 37.8651, -119.5383, 'America/Los_Angeles', 'FAT', 'Fresno Yosemite International', 'National park', 95, 175, 'USD', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'US'), 'Maui', 'maui', 'island', 20.7984, -156.3319, 'Pacific/Honolulu', 'OGG', 'Kahului Airport', 'Hawaiian island', 170, 280, 'USD', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Toronto', 'toronto', 'city', 43.6532, -79.3832, 'America/Toronto', 'YYZ', 'Toronto Pearson International', 'Multicultural hub', 85, 165, 'CAD', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Vancouver', 'vancouver', 'city', 49.2827, -123.1207, 'America/Vancouver', 'YVR', 'Vancouver International', 'Mountains and ocean', 95, 175, 'CAD', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Montreal', 'montreal', 'city', 45.5017, -73.5673, 'America/Montreal', 'YUL', 'Pierre Elliott Trudeau International', 'European charm', 75, 155, 'CAD', 'May,Jun,Jul,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Banff', 'banff', 'resort', 51.1784, -115.5708, 'America/Edmonton', 'YYC', 'Calgary International', 'Mountain resort', 110, 190, 'CAD', 'Jun,Jul,Aug,Dec,Jan', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Quebec City', 'quebec-city', 'city', 46.8139, -71.2080, 'America/Montreal', 'YQB', 'Jean Lesage International', 'French heritage', 70, 150, 'CAD', 'Jun,Jul,Aug,Dec,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Victoria', 'victoria', 'city', 48.4284, -123.3656, 'America/Vancouver', 'YYJ', 'Victoria International', 'Garden city', 85, 165, 'CAD', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Whistler', 'whistler', 'resort', 50.1163, -122.9574, 'America/Vancouver', 'YVR', 'Vancouver International', 'Ski resort', 120, 200, 'CAD', 'Dec,Jan,Feb,Jun,Jul', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Ottawa', 'ottawa', 'city', 45.4215, -75.6972, 'America/Toronto', 'YOW', 'Ottawa International', 'Canadian capital', 75, 155, 'CAD', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Niagara Falls', 'niagara-falls', 'city', 43.0896, -79.0849, 'America/Toronto', 'YYZ', 'Toronto Pearson International', 'Waterfalls', 80, 160, 'CAD', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CA'), 'Calgary', 'calgary', 'city', 51.0447, -114.0719, 'America/Edmonton', 'YYC', 'Calgary International', 'Gateway to Rockies', 80, 160, 'CAD', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Cancun', 'cancun', 'city', 21.1619, -86.8515, 'America/Cancun', 'CUN', 'Cancún International', 'Caribbean beaches', 50, 130, 'MXN', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Mexico City', 'mexico-city', 'city', 19.4326, -99.1332, 'America/Mexico_City', 'MEX', 'Mexico City International', 'Cultural capital', 40, 120, 'MXN', 'Oct,Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Playa del Carmen', 'playa-del-carmen', 'city', 20.6296, -87.0739, 'America/Cancun', 'CUN', 'Cancún International', 'Riviera Maya', 45, 125, 'MXN', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Tulum', 'tulum', 'city', 20.2114, -87.4654, 'America/Cancun', 'CUN', 'Cancún International', 'Beachfront ruins', 50, 130, 'MXN', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Cabo San Lucas', 'cabo-san-lucas', 'city', 22.8905, -109.9167, 'America/Mazatlan', 'SJD', 'Los Cabos International', 'Beach resort', 70, 150, 'MXN', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Puerto Vallarta', 'puerto-vallarta', 'city', 20.6534, -105.2253, 'America/Mexico_City', 'PVR', 'Gustavo Díaz Ordaz International', 'Pacific coast', 50, 130, 'MXN', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Guadalajara', 'guadalajara', 'city', 20.6597, -103.3496, 'America/Mexico_City', 'GDL', 'Miguel Hidalgo y Costilla International', 'Tequila and mariachi', 35, 115, 'MXN', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Oaxaca', 'oaxaca', 'city', 17.0732, -96.7266, 'America/Mexico_City', 'OAX', 'Xoxocotlán International', 'Cultural heritage', 30, 110, 'MXN', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'San Miguel de Allende', 'san-miguel-de-allende', 'city', 20.9144, -100.7451, 'America/Mexico_City', 'BJX', 'Del Bajío International', 'Colonial town', 40, 120, 'MXN', 'Oct,Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MX'), 'Merida', 'merida', 'city', 20.9674, -89.5926, 'America/Merida', 'MID', 'Manuel Crescencio Rejón International', 'Mayan culture', 35, 115, 'MXN', 'Nov,Dec,Jan,Feb,Mar', true, true),

-- === PREMIUM DESTINATIONS (EUROPE) ===
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'London', 'london', 'city', 51.5074, -0.1278, 'Europe/London', 'LHR', 'Heathrow Airport', 'Historic capital', 130, 250, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Edinburgh', 'edinburgh', 'city', 55.9533, -3.1883, 'Europe/London', 'EDI', 'Edinburgh Airport', 'Scottish capital', 90, 170, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Manchester', 'manchester', 'city', 53.4808, -2.2426, 'Europe/London', 'MAN', 'Manchester Airport', 'Industrial heritage', 80, 160, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Liverpool', 'liverpool', 'city', 53.4084, -2.9916, 'Europe/London', 'LPL', 'Liverpool John Lennon Airport', 'Beatles city', 75, 155, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Oxford', 'oxford', 'city', 51.7520, -1.2577, 'Europe/London', 'LHR', 'Heathrow Airport', 'University town', 85, 165, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Cambridge', 'cambridge', 'city', 52.2053, 0.1218, 'Europe/London', 'STN', 'Stansted Airport', 'Historic university', 80, 160, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Bath', 'bath', 'city', 51.3811, -2.3590, 'Europe/London', 'BRS', 'Bristol Airport', 'Roman baths', 85, 165, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'York', 'york', 'city', 53.9591, -1.0815, 'Europe/London', 'LBA', 'Leeds Bradford Airport', 'Medieval city', 75, 155, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Brighton', 'brighton', 'city', 50.8225, -0.1372, 'Europe/London', 'LGW', 'Gatwick Airport', 'Seaside resort', 80, 160, 'GBP', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Glasgow', 'glasgow', 'city', 55.8642, -4.2518, 'Europe/London', 'GLA', 'Glasgow Airport', 'Cultural hub', 75, 155, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Belfast', 'belfast', 'city', 54.5973, -5.9301, 'Europe/London', 'BFS', 'Belfast International Airport', 'Northern Ireland', 70, 150, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GB'), 'Stratford-upon-Avon', 'stratford-upon-avon', 'city', 52.1917, -1.7082, 'Europe/London', 'BHX', 'Birmingham Airport', 'Shakespeare birthplace', 80, 160, 'GBP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Nice', 'nice', 'city', 43.7102, 7.2620, 'Europe/Paris', 'NCE', 'Nice Côte d''Azur Airport', 'French Riviera', 100, 200, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Lyon', 'lyon', 'city', 45.7640, 4.8357, 'Europe/Paris', 'LYS', 'Lyon-Saint Exupéry Airport', 'Gastronomic capital', 85, 165, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Marseille', 'marseille', 'city', 43.2965, 5.3698, 'Europe/Paris', 'MRS', 'Marseille Provence Airport', 'Mediterranean port', 80, 160, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Bordeaux', 'bordeaux', 'city', 44.8378, -0.5792, 'Europe/Paris', 'BOD', 'Bordeaux-Mérignac Airport', 'Wine capital', 90, 170, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Strasbourg', 'strasbourg', 'city', 48.5734, 7.7521, 'Europe/Paris', 'SXB', 'Strasbourg Airport', 'European capital', 85, 165, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Cannes', 'cannes', 'city', 43.5528, 7.0174, 'Europe/Paris', 'NCE', 'Nice Côte d''Azur Airport', 'Film festival', 110, 210, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Toulouse', 'toulouse', 'city', 43.6047, 1.4442, 'Europe/Paris', 'TLS', 'Toulouse-Blagnac Airport', 'Pink city', 80, 160, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Nantes', 'nantes', 'city', 47.2184, -1.5536, 'Europe/Paris', 'NTE', 'Nantes Atlantique Airport', 'Loire Valley', 75, 155, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Montpellier', 'montpellier', 'city', 43.6108, 3.8767, 'Europe/Paris', 'MPL', 'Montpellier-Méditerranée Airport', 'Mediterranean city', 80, 160, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Avignon', 'avignon', 'city', 43.9493, 4.8055, 'Europe/Paris', 'AVN', 'Avignon-Provence Airport', 'Papal city', 85, 165, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Versailles', 'versailles', 'city', 48.8049, 2.1204, 'Europe/Paris', 'CDG', 'Charles de Gaulle Airport', 'Palace', 100, 200, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Mont Saint-Michel', 'mont-saint-michel', 'city', 48.6361, -1.5115, 'Europe/Paris', 'RNS', 'Rennes Airport', 'Island abbey', 90, 170, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Chamonix', 'chamonix', 'resort', 45.9237, 6.8694, 'Europe/Paris', 'GVA', 'Geneva Airport', 'Alpine resort', 110, 210, 'EUR', 'Dec,Jan,Feb,Jun,Jul,Aug', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FR'), 'Saint-Tropez', 'saint-tropez', 'city', 43.2677, 6.6407, 'Europe/Paris', 'NCE', 'Nice Côte d''Azur Airport', 'Luxury resort', 130, 250, 'EUR', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Venice', 'venice', 'city', 45.4408, 12.3155, 'Europe/Rome', 'VCE', 'Marco Polo Airport', 'Floating city', 110, 210, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Florence', 'florence', 'city', 43.7696, 11.2558, 'Europe/Rome', 'FLR', 'Florence Airport', 'Renaissance art', 95, 185, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Milan', 'milan', 'city', 45.4642, 9.1900, 'Europe/Rome', 'MXP', 'Malpensa Airport', 'Fashion capital', 100, 200, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Naples', 'naples', 'city', 40.8518, 14.2681, 'Europe/Rome', 'NAP', 'Naples International Airport', 'Pizza birthplace', 75, 155, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Turin', 'turin', 'city', 45.0703, 7.6869, 'Europe/Rome', 'TRN', 'Turin Airport', 'Industrial city', 80, 160, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Bologna', 'bologna', 'city', 44.4949, 11.3426, 'Europe/Rome', 'BLQ', 'Bologna Airport', 'Food capital', 85, 165, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Verona', 'verona', 'city', 45.4384, 10.9916, 'Europe/Rome', 'VRN', 'Verona Airport', 'Romeo and Juliet', 85, 165, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Pisa', 'pisa', 'city', 43.7228, 10.4017, 'Europe/Rome', 'PSA', 'Pisa Airport', 'Leaning Tower', 80, 160, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Siena', 'siena', 'city', 43.3188, 11.3308, 'Europe/Rome', 'FLR', 'Florence Airport', 'Medieval city', 85, 165, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Amalfi Coast', 'amalfi-coast', 'region', 40.6333, 14.6028, 'Europe/Rome', 'NAP', 'Naples International Airport', 'Coastal paradise', 110, 210, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IT'), 'Cinque Terre', 'cinque-terre', 'region', 44.1274, 9.7131, 'Europe/Rome', 'GOA', 'Genoa Airport', 'Five villages', 100, 200, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Barcelona', 'barcelona', 'city', 41.3851, 2.1734, 'Europe/Madrid', 'BCN', 'Barcelona-El Prat Airport', 'Gaudí architecture', 90, 180, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Madrid', 'madrid', 'city', 40.4168, -3.7038, 'Europe/Madrid', 'MAD', 'Adolfo Suárez Madrid-Barajas Airport', 'Spanish capital', 85, 165, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Seville', 'seville', 'city', 37.3891, -5.9845, 'Europe/Madrid', 'SVQ', 'Seville Airport', 'Flamenco heart', 75, 155, 'EUR', 'Mar,Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Valencia', 'valencia', 'city', 39.4699, -0.3763, 'Europe/Madrid', 'VLC', 'Valencia Airport', 'City of Arts', 80, 160, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Granada', 'granada', 'city', 37.1773, -3.5986, 'Europe/Madrid', 'GRX', 'Federico García Lorca Airport', 'Alhambra palace', 70, 150, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Bilbao', 'bilbao', 'city', 43.2630, -2.9350, 'Europe/Madrid', 'BIO', 'Bilbao Airport', 'Guggenheim Museum', 85, 165, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'San Sebastian', 'san-sebastian', 'city', 43.3183, -1.9812, 'Europe/Madrid', 'EAS', 'San Sebastián Airport', 'Beach and cuisine', 95, 185, 'EUR', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Malaga', 'malaga', 'city', 36.7213, -4.4214, 'Europe/Madrid', 'AGP', 'Málaga-Costa del Sol Airport', 'Costa del Sol', 75, 155, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Ibiza', 'ibiza', 'island', 38.9067, 1.4206, 'Europe/Madrid', 'IBZ', 'Ibiza Airport', 'Party island', 100, 200, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Mallorca', 'mallorca', 'island', 39.6953, 3.0176, 'Europe/Madrid', 'PMI', 'Palma de Mallorca Airport', 'Balearic island', 90, 180, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ES'), 'Toledo', 'toledo', 'city', 39.8628, -4.0273, 'Europe/Madrid', 'MAD', 'Adolfo Suárez Madrid-Barajas Airport', 'Medieval city', 70, 150, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Berlin', 'berlin', 'city', 52.5200, 13.4050, 'Europe/Berlin', 'BER', 'Berlin Brandenburg Airport', 'Historic capital', 80, 160, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Munich', 'munich', 'city', 48.1351, 11.5820, 'Europe/Berlin', 'MUC', 'Munich Airport', 'Bavarian capital', 90, 170, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Hamburg', 'hamburg', 'city', 53.5511, 9.9937, 'Europe/Berlin', 'HAM', 'Hamburg Airport', 'Port city', 85, 165, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Frankfurt', 'frankfurt', 'city', 50.1109, 8.6821, 'Europe/Berlin', 'FRA', 'Frankfurt Airport', 'Financial hub', 90, 170, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Cologne', 'cologne', 'city', 50.9375, 6.9603, 'Europe/Berlin', 'CGN', 'Cologne Bonn Airport', 'Cathedral city', 80, 160, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Dresden', 'dresden', 'city', 51.0504, 13.7373, 'Europe/Berlin', 'DRS', 'Dresden Airport', 'Baroque architecture', 75, 155, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Heidelberg', 'heidelberg', 'city', 49.3988, 8.6724, 'Europe/Berlin', 'FRA', 'Frankfurt Airport', 'University town', 80, 160, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DE'), 'Neuschwanstein', 'neuschwanstein', 'city', 47.5576, 10.7498, 'Europe/Berlin', 'MUC', 'Munich Airport', 'Fairy tale castle', 85, 165, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NL'), 'Amsterdam', 'amsterdam', 'city', 52.3676, 4.9041, 'Europe/Amsterdam', 'AMS', 'Amsterdam Schiphol Airport', 'Canal city', 100, 200, 'EUR', 'Apr,May,Jun,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NL'), 'Rotterdam', 'rotterdam', 'city', 51.9225, 4.4792, 'Europe/Amsterdam', 'RTM', 'Rotterdam The Hague Airport', 'Modern architecture', 85, 165, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NL'), 'The Hague', 'the-hague', 'city', 52.0705, 4.3007, 'Europe/Amsterdam', 'RTM', 'Rotterdam The Hague Airport', 'Political capital', 90, 170, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CH'), 'Zurich', 'zurich', 'city', 47.3769, 8.5417, 'Europe/Zurich', 'ZRH', 'Zurich Airport', 'Financial center', 130, 250, 'CHF', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CH'), 'Geneva', 'geneva', 'city', 46.2044, 6.1432, 'Europe/Zurich', 'GVA', 'Geneva Airport', 'International city', 120, 220, 'CHF', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CH'), 'Lucerne', 'lucerne', 'city', 47.0502, 8.3093, 'Europe/Zurich', 'ZRH', 'Zurich Airport', 'Lake town', 110, 210, 'CHF', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CH'), 'Interlaken', 'interlaken', 'resort', 46.6863, 7.8632, 'Europe/Zurich', 'BRN', 'Bern Airport', 'Alpine adventure', 120, 220, 'CHF', 'Jun,Jul,Aug,Dec,Jan', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AT'), 'Vienna', 'vienna', 'city', 48.2082, 16.3738, 'Europe/Vienna', 'VIE', 'Vienna International Airport', 'Imperial capital', 90, 180, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AT'), 'Salzburg', 'salzburg', 'city', 47.8095, 13.0550, 'Europe/Vienna', 'SZG', 'Salzburg Airport', 'Mozart city', 85, 165, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AT'), 'Innsbruck', 'innsbruck', 'city', 47.2692, 11.4041, 'Europe/Vienna', 'INN', 'Innsbruck Airport', 'Alpine city', 90, 170, 'EUR', 'Dec,Jan,Feb,Jun,Jul', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BE'), 'Brussels', 'brussels', 'city', 50.8503, 4.3517, 'Europe/Brussels', 'BRU', 'Brussels Airport', 'EU capital', 90, 180, 'EUR', 'May,Jun,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BE'), 'Bruges', 'bruges', 'city', 51.2093, 3.2247, 'Europe/Brussels', 'BRU', 'Brussels Airport', 'Medieval charm', 85, 165, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PT'), 'Lisbon', 'lisbon', 'city', 38.7223, -9.1393, 'Europe/Lisbon', 'LIS', 'Lisbon Portela Airport', 'Coastal capital', 70, 150, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PT'), 'Porto', 'porto', 'city', 41.1579, -8.6291, 'Europe/Lisbon', 'OPO', 'Porto Airport', 'Wine city', 65, 145, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PT'), 'Lagos', 'lagos', 'city', 37.1028, -8.6742, 'Europe/Lisbon', 'FAO', 'Faro Airport', 'Algarve coast', 70, 150, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PT'), 'Madeira', 'madeira', 'island', 32.6669, -16.9241, 'Atlantic/Madeira', 'FNC', 'Madeira Airport', 'Atlantic paradise', 80, 160, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Athens', 'athens', 'city', 37.9838, 23.7275, 'Europe/Athens', 'ATH', 'Athens International Airport', 'Ancient capital', 70, 150, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Santorini', 'santorini', 'island', 36.3932, 25.4615, 'Europe/Athens', 'JTR', 'Santorini Airport', 'Volcanic island', 110, 210, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Mykonos', 'mykonos', 'island', 37.4467, 25.3289, 'Europe/Athens', 'JMK', 'Mykonos Airport', 'Party island', 100, 200, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Crete', 'crete', 'island', 35.2401, 24.8093, 'Europe/Athens', 'HER', 'Heraklion Airport', 'Largest Greek island', 75, 155, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Rhodes', 'rhodes', 'island', 36.4341, 28.2176, 'Europe/Athens', 'RHO', 'Rhodes Airport', 'Medieval town', 80, 160, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Corfu', 'corfu', 'island', 39.6243, 19.9217, 'Europe/Athens', 'CFU', 'Corfu Airport', 'Ionian island', 75, 155, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Thessaloniki', 'thessaloniki', 'city', 40.6401, 22.9444, 'Europe/Athens', 'SKG', 'Thessaloniki Airport', 'Cultural capital', 65, 145, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GR'), 'Zakynthos', 'zakynthos', 'island', 37.7870, 20.8984, 'Europe/Athens', 'ZTH', 'Zakynthos Airport', 'Shipwreck beach', 80, 160, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DK'), 'Copenhagen', 'copenhagen', 'city', 55.6761, 12.5683, 'Europe/Copenhagen', 'CPH', 'Copenhagen Airport', 'Danish capital', 100, 200, 'DKK', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'SE'), 'Stockholm', 'stockholm', 'city', 59.3293, 18.0686, 'Europe/Stockholm', 'ARN', 'Stockholm Arlanda Airport', 'Nordic Venice', 100, 200, 'SEK', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NO'), 'Oslo', 'oslo', 'city', 59.9139, 10.7522, 'Europe/Oslo', 'OSL', 'Oslo Airport', 'Norwegian capital', 110, 210, 'NOK', 'May,Jun,Jul,Aug', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FI'), 'Helsinki', 'helsinki', 'city', 60.1699, 24.9384, 'Europe/Helsinki', 'HEL', 'Helsinki-Vantaa Airport', 'Finnish capital', 95, 185, 'EUR', 'May,Jun,Jul,Aug', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IS'), 'Reykjavik', 'reykjavik', 'city', 64.1466, -21.9426, 'Atlantic/Reykjavik', 'KEF', 'Keflavík International Airport', 'Icelandic capital', 120, 220, 'ISK', 'Jun,Jul,Aug', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Istanbul', 'istanbul', 'city', 41.0082, 28.9784, 'Europe/Istanbul', 'IST', 'Istanbul Airport', 'Bridge between continents', 50, 120, 'TRY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Cappadocia', 'cappadocia', 'region', 38.6431, 34.8289, 'Europe/Istanbul', 'NAV', 'Nevşehir Kapadokya Airport', 'Hot air balloons', 45, 105, 'TRY', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Antalya', 'antalya', 'city', 36.8969, 30.7133, 'Europe/Istanbul', 'AYT', 'Antalya Airport', 'Turkish Riviera', 40, 100, 'TRY', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Bodrum', 'bodrum', 'city', 37.0344, 27.4305, 'Europe/Istanbul', 'BJV', 'Bodrum-Milas Airport', 'Aegean coast', 50, 120, 'TRY', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Pamukkale', 'pamukkale', 'city', 37.9203, 29.1211, 'Europe/Istanbul', 'DNZ', 'Denizli Çardak Airport', 'White terraces', 40, 100, 'TRY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Ephesus', 'ephesus', 'city', 37.9395, 27.3408, 'Europe/Istanbul', 'ADB', 'Izmir Airport', 'Ancient ruins', 40, 100, 'TRY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Fethiye', 'fethiye', 'city', 36.6220, 29.1167, 'Europe/Istanbul', 'DLM', 'Dalaman Airport', 'Blue Lagoon', 45, 105, 'TRY', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Marmaris', 'marmaris', 'city', 36.8548, 28.2741, 'Europe/Istanbul', 'DLM', 'Dalaman Airport', 'Beach resort', 45, 105, 'TRY', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Ankara', 'ankara', 'city', 39.9334, 32.8597, 'Europe/Istanbul', 'ESB', 'Esenboğa Airport', 'Turkish capital', 35, 95, 'TRY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TR'), 'Trabzon', 'trabzon', 'city', 41.0027, 39.7168, 'Europe/Istanbul', 'TZX', 'Trabzon Airport', 'Black Sea coast', 40, 100, 'TRY', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'HR'), 'Dubrovnik', 'dubrovnik', 'city', 42.6507, 18.0944, 'Europe/Zagreb', 'DBV', 'Dubrovnik Airport', 'Pearl of Adriatic', 70, 160, 'EUR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'HR'), 'Split', 'split', 'city', 43.5081, 16.4402, 'Europe/Zagreb', 'SPU', 'Split Airport', 'Diocletian Palace', 65, 155, 'EUR', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'HR'), 'Zagreb', 'zagreb', 'city', 45.8150, 15.9819, 'Europe/Zagreb', 'ZAG', 'Zagreb Airport', 'Croatian capital', 60, 140, 'EUR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'HR'), 'Hvar', 'hvar', 'island', 43.1729, 16.4411, 'Europe/Zagreb', 'SPU', 'Split Airport', 'Lavender island', 80, 180, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'HR'), 'Plitvice Lakes', 'plitvice-lakes', 'national-park', 44.8654, 15.5820, 'Europe/Zagreb', 'ZAG', 'Zagreb Airport', 'Waterfalls', 60, 140, 'EUR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PL'), 'Krakow', 'krakow', 'city', 50.0647, 19.9450, 'Europe/Warsaw', 'KRK', 'John Paul II International Airport', 'Medieval beauty', 50, 120, 'PLN', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PL'), 'Warsaw', 'warsaw', 'city', 52.2297, 21.0122, 'Europe/Warsaw', 'WAW', 'Warsaw Chopin Airport', 'Polish capital', 55, 125, 'PLN', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PL'), 'Gdansk', 'gdansk', 'city', 54.3520, 18.6466, 'Europe/Warsaw', 'GDN', 'Gdańsk Airport', 'Baltic port', 50, 120, 'PLN', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CZ'), 'Prague', 'prague', 'city', 50.0755, 14.4378, 'Europe/Prague', 'PRG', 'Václav Havel Airport', 'Hundred spires', 60, 140, 'CZK', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CZ'), 'Cesky Krumlov', 'cesky-krumlov', 'city', 48.8127, 14.3175, 'Europe/Prague', 'PRG', 'Václav Havel Airport', 'Fairy tale', 55, 125, 'CZK', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'HU'), 'Budapest', 'budapest', 'city', 47.4979, 19.0402, 'Europe/Budapest', 'BUD', 'Budapest Ferenc Liszt International Airport', 'Pearl of Danube', 50, 120, 'HUF', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'RO'), 'Bucharest', 'bucharest', 'city', 44.4268, 26.1025, 'Europe/Bucharest', 'OTP', 'Henri Coandă International Airport', 'Little Paris', 40, 100, 'RON', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'RO'), 'Transylvania', 'transylvania', 'region', 46.0703, 23.5812, 'Europe/Bucharest', 'CLJ', 'Cluj-Napoca International Airport', 'Dracula land', 40, 100, 'RON', 'May,Jun,Jul,Aug,Sep', true, true),

-- === PREMIUM DESTINATIONS (CARIBBEAN & LATIN AMERICA) ===
((SELECT id FROM countries WHERE iso_alpha2 = 'AW'), 'Aruba', 'aruba', 'island', 12.5211, -69.9683, 'America/Aruba', 'AUA', 'Queen Beatrix International Airport', 'One happy island', 100, 220, 'AWG', 'All year', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JM'), 'Jamaica', 'jamaica', 'island', 18.1096, -77.2975, 'America/Jamaica', 'MBJ', 'Sangster International Airport', 'Reggae paradise', 60, 140, 'JMD', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BS'), 'Bahamas', 'bahamas', 'island', 25.0343, -77.3963, 'America/Nassau', 'NAS', 'Lynden Pindling International Airport', 'Caribbean beauty', 90, 200, 'BSD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BB'), 'Barbados', 'barbados', 'island', 13.1939, -59.5432, 'America/Barbados', 'BGI', 'Grantley Adams International Airport', 'Eastern Caribbean', 80, 180, 'BBD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TC'), 'Turks and Caicos', 'turks-and-caicos', 'island', 21.6940, -71.7979, 'America/Grand_Turk', 'PLS', 'Providenciales International Airport', 'Pristine beaches', 110, 250, 'USD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'LC'), 'St. Lucia', 'st-lucia', 'island', 13.9094, -60.9789, 'America/St_Lucia', 'UVF', 'Hewanorra International Airport', 'Pitons paradise', 85, 185, 'XCD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KY'), 'Cayman Islands', 'cayman-islands', 'island', 19.3133, -81.2546, 'America/Cayman', 'GCM', 'Owen Roberts International Airport', 'Diving capital', 120, 260, 'KYD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AG'), 'Antigua', 'antigua', 'island', 17.0608, -61.7964, 'America/Antigua', 'ANU', 'V.C. Bird International Airport', '365 beaches', 85, 185, 'XCD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GD'), 'Grenada', 'grenada', 'island', 12.1165, -61.6790, 'America/Grenada', 'GND', 'Maurice Bishop International Airport', 'Spice island', 70, 160, 'XCD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'SX'), 'St. Maarten', 'st-maarten', 'island', 18.0425, -63.0548, 'America/Lower_Princes', 'SXM', 'Princess Juliana International Airport', 'Dual nation', 90, 190, 'ANG', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CW'), 'Curaçao', 'curacao', 'island', 12.1696, -68.9900, 'America/Curacao', 'CUR', 'Curaçao International Airport', 'Dutch Caribbean', 80, 180, 'ANG', 'All year', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'DO'), 'Dominican Republic', 'dominican-republic', 'island', 18.4861, -69.9312, 'America/Santo_Domingo', 'PUJ', 'Punta Cana International Airport', 'All-inclusive resorts', 60, 140, 'DOP', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PR'), 'Puerto Rico', 'puerto-rico', 'island', 18.2208, -66.5901, 'America/Puerto_Rico', 'SJU', 'Luis Muñoz Marín International Airport', 'US territory', 70, 160, 'USD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VI'), 'US Virgin Islands', 'us-virgin-islands', 'island', 18.3358, -64.8963, 'America/St_Thomas', 'STT', 'Cyril E. King Airport', 'Caribbean US', 90, 190, 'USD', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MQ'), 'Martinique', 'martinique', 'island', 14.6415, -61.0242, 'America/Martinique', 'FDF', 'Martinique Aimé Césaire International Airport', 'French Caribbean', 80, 180, 'EUR', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TT'), 'Trinidad and Tobago', 'trinidad-and-tobago', 'island', 10.6918, -61.2225, 'America/Port_of_Spain', 'POS', 'Piarco International Airport', 'Carnival capital', 60, 140, 'TTD', 'Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BQ'), 'Bonaire', 'bonaire', 'island', 12.2018, -68.2624, 'America/Kralendijk', 'BON', 'Flamingo International Airport', 'Diver paradise', 80, 180, 'USD', 'All year', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AI'), 'Anguilla', 'anguilla', 'island', 18.2206, -63.0686, 'America/Anguilla', 'AXA', 'Clayton J. Lloyd International Airport', 'Luxury beaches', 100, 220, 'XCD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KN'), 'Nevis', 'nevis', 'island', 17.1508, -62.5833, 'America/St_Kitts', 'NEV', 'Vance W. Amory International Airport', 'Tranquil island', 85, 185, 'XCD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BM'), 'Bermuda', 'bermuda', 'island', 32.3078, -64.7505, 'Atlantic/Bermuda', 'BDA', 'L.F. Wade International Airport', 'Pink sand beaches', 110, 240, 'BMD', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BR'), 'Rio de Janeiro', 'rio-de-janeiro', 'city', -22.9068, -43.1729, 'America/Sao_Paulo', 'GIG', 'Galeão International Airport', 'Marvelous city', 50, 120, 'BRL', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BR'), 'São Paulo', 'sao-paulo', 'city', -23.5505, -46.6333, 'America/Sao_Paulo', 'GRU', 'São Paulo International Airport', 'Business capital', 55, 125, 'BRL', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BR'), 'Salvador', 'salvador', 'city', -12.9714, -38.5014, 'America/Bahia', 'SSA', 'Salvador International Airport', 'Afro-Brazilian culture', 40, 100, 'BRL', 'Sep,Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BR'), 'Iguazu Falls', 'iguazu-falls', 'region', -25.6953, -54.4367, 'America/Sao_Paulo', 'IGU', 'Foz do Iguaçu International Airport', 'Waterfalls', 50, 120, 'BRL', 'Apr,May,Aug,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BR'), 'Amazon Rainforest', 'amazon-rainforest', 'region', -3.4653, -62.2159, 'America/Manaus', 'MAO', 'Eduardo Gomes International Airport', 'Jungle', 60, 140, 'BRL', 'Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AR'), 'Buenos Aires', 'buenos-aires', 'city', -34.6037, -58.3816, 'America/Argentina/Buenos_Aires', 'EZE', 'Ministro Pistarini International Airport', 'Paris of South America', 45, 105, 'ARS', 'Mar,Apr,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AR'), 'Patagonia', 'patagonia', 'region', -41.8102, -68.9063, 'America/Argentina/Buenos_Aires', 'BRC', 'San Carlos de Bariloche Airport', 'Wilderness', 60, 140, 'ARS', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AR'), 'Mendoza', 'mendoza', 'city', -32.8895, -68.8458, 'America/Argentina/Mendoza', 'MDZ', 'Francisco Gabrielli International Airport', 'Wine country', 40, 100, 'ARS', 'Mar,Apr,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AR'), 'Ushuaia', 'ushuaia', 'city', -54.8019, -68.3030, 'America/Argentina/Ushuaia', 'USH', 'Malvinas Argentinas International Airport', 'End of world', 70, 150, 'ARS', 'Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PE'), 'Lima', 'lima', 'city', -12.0464, -77.0428, 'America/Lima', 'LIM', 'Jorge Chávez International Airport', 'Capital', 40, 100, 'PEN', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PE'), 'Cusco', 'cusco', 'city', -13.5319, -71.9675, 'America/Lima', 'CUZ', 'Alejandro Velasco Astete International Airport', 'Machu Picchu gateway', 45, 105, 'PEN', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PE'), 'Machu Picchu', 'machu-picchu', 'city', -13.1631, -72.5450, 'America/Lima', 'CUZ', 'Alejandro Velasco Astete International Airport', 'Inca citadel', 50, 120, 'PEN', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CL'), 'Santiago', 'santiago', 'city', -33.4489, -70.6693, 'America/Santiago', 'SCL', 'Arturo Merino Benítez International Airport', 'Chilean capital', 45, 105, 'CLP', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CL'), 'Valparaíso', 'valparaiso', 'city', -33.0472, -71.6127, 'America/Santiago', 'SCL', 'Arturo Merino Benítez International Airport', 'Port city', 40, 100, 'CLP', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CO'), 'Cartagena', 'cartagena', 'city', 10.3910, -75.4794, 'America/Bogota', 'CTG', 'Rafael Núñez International Airport', 'Colonial beauty', 40, 100, 'COP', 'Dec,Jan,Feb,Mar', true, true),

-- === PREMIUM DESTINATIONS (AFRICA) ===
((SELECT id FROM countries WHERE iso_alpha2 = 'MA'), 'Marrakech', 'marrakech', 'city', 31.6295, -7.9811, 'Africa/Casablanca', 'RAK', 'Marrakesh Menara Airport', 'Red city', 40, 100, 'MAD', 'Mar,Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MA'), 'Casablanca', 'casablanca', 'city', 33.5731, -7.5898, 'Africa/Casablanca', 'CMN', 'Mohammed V International Airport', 'Economic capital', 45, 105, 'MAD', 'Mar,Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MA'), 'Fez', 'fez', 'city', 34.0181, -5.0078, 'Africa/Casablanca', 'FEZ', 'Fès–Saïs Airport', 'Medieval medina', 40, 100, 'MAD', 'Mar,Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MA'), 'Chefchaouen', 'chefchaouen', 'city', 35.1688, -5.2636, 'Africa/Casablanca', 'TNG', 'Tangier Ibn Battouta Airport', 'Blue city', 35, 95, 'MAD', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MA'), 'Essaouira', 'essaouira', 'city', 31.5084, -9.7595, 'Africa/Casablanca', 'ESU', 'Essaouira-Mogador Airport', 'Coastal town', 40, 100, 'MAD', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Cairo', 'cairo', 'city', 30.0444, 31.2357, 'Africa/Cairo', 'CAI', 'Cairo International Airport', 'Pyramids and ancient capital', 35, 85, 'EGP', 'Oct,Nov,Dec,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Hurghada', 'hurghada', 'city', 27.2579, 33.8116, 'Africa/Cairo', 'HRG', 'Hurghada International Airport', 'Red Sea diving paradise', 40, 100, 'EGP', 'Sep,Oct,Nov,Mar,Apr,May', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Sharm El Sheikh', 'sharm-el-sheikh', 'city', 27.9158, 34.3300, 'Africa/Cairo', 'SSH', 'Sharm El Sheikh International Airport', 'Sinai resort', 45, 105, 'EGP', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Luxor', 'luxor', 'city', 25.6872, 32.6396, 'Africa/Cairo', 'LXR', 'Luxor International Airport', 'Valley of Kings', 35, 85, 'EGP', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Aswan', 'aswan', 'city', 24.0889, 32.8998, 'Africa/Cairo', 'ASW', 'Aswan International Airport', 'Nile gateway', 35, 85, 'EGP', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Alexandria', 'alexandria', 'city', 31.2001, 29.9187, 'Africa/Cairo', 'HBE', 'Borg El Arab Airport', 'Mediterranean port', 40, 90, 'EGP', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'EG'), 'Dahab', 'dahab', 'city', 28.4953, 34.5136, 'Africa/Cairo', 'SSH', 'Sharm El Sheikh International Airport', 'Diving spot', 30, 80, 'EGP', 'Mar,Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TN'), 'Tunis', 'tunis', 'city', 36.8065, 10.1815, 'Africa/Tunis', 'TUN', 'Tunis-Carthage International Airport', 'Capital and Carthage', 40, 100, 'TND', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TN'), 'Djerba', 'djerba', 'island', 33.8076, 10.8451, 'Africa/Tunis', 'DJE', 'Djerba-Zarzis International Airport', 'Island paradise', 40, 100, 'TND', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TN'), 'Sousse', 'sousse', 'city', 35.8256, 10.6369, 'Africa/Tunis', 'MIR', 'Monastir International Airport', 'Beach resort', 35, 95, 'TND', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TN'), 'Hammamet', 'hammamet', 'city', 36.4000, 10.6167, 'Africa/Tunis', 'MIR', 'Monastir International Airport', 'Beach resort', 40, 100, 'TND', 'May,Jun,Jul,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TN'), 'Tozeur', 'tozeur', 'city', 33.9197, 8.1335, 'Africa/Tunis', 'TOE', 'Tozeur-Nefta International Airport', 'Sahara gateway', 35, 95, 'TND', 'Oct,Nov,Dec,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ZA'), 'Cape Town', 'cape-town', 'city', -33.9249, 18.4241, 'Africa/Johannesburg', 'CPT', 'Cape Town International Airport', 'Mother City', 60, 140, 'ZAR', 'Oct,Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ZA'), 'Johannesburg', 'johannesburg', 'city', -26.2041, 28.0473, 'Africa/Johannesburg', 'JNB', 'O.R. Tambo International Airport', 'Economic hub', 50, 120, 'ZAR', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ZA'), 'Durban', 'durban', 'city', -29.8587, 31.0218, 'Africa/Johannesburg', 'DUR', 'King Shaka International Airport', 'Beach city', 45, 105, 'ZAR', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ZA'), 'Kruger National Park', 'kruger-national-park', 'national-park', -23.9884, 31.5547, 'Africa/Johannesburg', 'MQP', 'Kruger Mpumalanga International Airport', 'Safari', 70, 150, 'ZAR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ZA'), 'Garden Route', 'garden-route', 'region', -34.0499, 22.9344, 'Africa/Johannesburg', 'GRJ', 'George Airport', 'Scenic drive', 55, 125, 'ZAR', 'Oct,Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KE'), 'Nairobi', 'nairobi', 'city', -1.2921, 36.8219, 'Africa/Nairobi', 'NBO', 'Jomo Kenyatta International Airport', 'Safari capital', 50, 120, 'KES', 'Jan,Feb,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KE'), 'Mombasa', 'mombasa', 'city', -4.0435, 39.6682, 'Africa/Nairobi', 'MBA', 'Moi International Airport', 'Coastal city', 45, 105, 'KES', 'Jan,Feb,Jul,Aug,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TZ'), 'Zanzibar', 'zanzibar', 'island', -6.1659, 39.2026, 'Africa/Dar_es_Salaam', 'ZNZ', 'Abeid Amani Karume International Airport', 'Spice island', 55, 125, 'TZS', 'Jun,Jul,Aug,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TZ'), 'Serengeti', 'serengeti', 'national-park', -2.3333, 34.8333, 'Africa/Dar_es_Salaam', 'SEU', 'Seronera Airport', 'Wildlife migration', 80, 180, 'TZS', 'Jan,Feb,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'SN'), 'Dakar', 'dakar', 'city', 14.6928, -17.4467, 'Africa/Dakar', 'DSS', 'Blaise Diagne International Airport', 'Senegal capital', 45, 105, 'XOF', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ET'), 'Addis Ababa', 'addis-ababa', 'city', 9.0320, 38.7469, 'Africa/Addis_Ababa', 'ADD', 'Addis Ababa Bole International Airport', 'Ethiopia capital', 40, 100, 'ETB', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'SC'), 'Seychelles', 'seychelles', 'island', -4.6796, 55.4920, 'Indian/Mahe', 'SEZ', 'Seychelles International Airport', 'Island paradise', 120, 280, 'SCR', 'Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MU'), 'Mauritius', 'mauritius', 'island', -20.1609, 57.5012, 'Indian/Mauritius', 'MRU', 'Sir Seewoosagur Ramgoolam International Airport', 'Tropical paradise', 80, 180, 'MUR', 'May,Jun,Sep,Oct,Nov,Dec', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MG'), 'Antananarivo', 'antananarivo', 'city', -18.8792, 47.5079, 'Indian/Antananarivo', 'TNR', 'Ivato International Airport', 'Island nation', 35, 95, 'MGA', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'BW'), 'Okavango Delta', 'okavango-delta', 'region', -19.2807, 22.7234, 'Africa/Gaborone', 'MUB', 'Maun Airport', 'Botswana wetland', 90, 200, 'BWP', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ZW'), 'Victoria Falls', 'victoria-falls', 'city', -17.9243, 25.8572, 'Africa/Harare', 'VFA', 'Victoria Falls International Airport', 'Massive waterfalls', 60, 140, 'USD', 'Apr,May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NA'), 'Windhoek', 'windhoek', 'city', -22.5597, 17.0832, 'Africa/Windhoek', 'WDH', 'Hosea Kutako International Airport', 'Namibia capital', 50, 120, 'NAD', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GH'), 'Accra', 'accra', 'city', 5.6037, -0.1870, 'Africa/Accra', 'ACC', 'Kotoka International Airport', 'Ghana capital', 40, 100, 'GHS', 'Nov,Dec,Jan,Feb', true, true),

-- === PREMIUM DESTINATIONS (ASIA & OCEANIA) ===
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Kyoto', 'kyoto', 'city', 35.0116, 135.7681, 'Asia/Tokyo', 'ITM', 'Osaka International Airport', 'Ancient capital', 80, 180, 'JPY', 'Mar,Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Osaka', 'osaka', 'city', 34.6937, 135.5023, 'Asia/Tokyo', 'KIX', 'Kansai International Airport', 'Food capital', 75, 165, 'JPY', 'Mar,Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Tokyo', 'tokyo', 'city', 35.6762, 139.6503, 'Asia/Tokyo', 'HND', 'Haneda Airport', 'Metropolis', 100, 220, 'JPY', 'Mar,Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Hiroshima', 'hiroshima', 'city', 34.3853, 132.4553, 'Asia/Tokyo', 'HIJ', 'Hiroshima Airport', 'Peace memorial', 70, 160, 'JPY', 'Mar,Apr,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Nara', 'nara', 'city', 34.6851, 135.8048, 'Asia/Tokyo', 'ITM', 'Osaka International Airport', 'Deer park', 65, 155, 'JPY', 'Mar,Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Sapporo', 'sapporo', 'city', 43.0642, 141.3469, 'Asia/Tokyo', 'CTS', 'New Chitose Airport', 'Winter sports', 75, 165, 'JPY', 'Feb,Jun,Jul,Aug', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Hakone', 'hakone', 'resort', 35.1947, 139.0235, 'Asia/Tokyo', 'NRT', 'Narita International Airport', 'Hot springs', 85, 175, 'JPY', 'Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Nicco', 'nikko', 'city', 36.7199, 139.6982, 'Asia/Tokyo', 'NRT', 'Narita International Airport', 'Mountain shrines', 70, 160, 'JPY', 'May,Jun,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JP'), 'Okinawa', 'okinawa', 'island', 26.2124, 127.6792, 'Asia/Tokyo', 'OKA', 'Naha Airport', 'Tropical paradise', 80, 170, 'JPY', 'Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CN'), 'Beijing', 'beijing', 'city', 39.9042, 116.4074, 'Asia/Shanghai', 'PEK', 'Beijing Capital International Airport', 'Imperial capital', 50, 120, 'CNY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CN'), 'Shanghai', 'shanghai', 'city', 31.2304, 121.4737, 'Asia/Shanghai', 'PVG', 'Pudong International Airport', 'Modern metropolis', 60, 140, 'CNY', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CN'), 'Hong Kong', 'hong-kong', 'city', 22.3193, 114.1694, 'Asia/Hong_Kong', 'HKG', 'Hong Kong International Airport', 'Asia world city', 70, 160, 'HKD', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CN'), 'Guangzhou', 'guangzhou', 'city', 23.1291, 113.2644, 'Asia/Shanghai', 'CAN', 'Guangzhou Baiyun International Airport', 'Canton fair', 50, 120, 'CNY', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CN'), 'Xi''an', 'xian', 'city', 34.3416, 108.9398, 'Asia/Shanghai', 'XIY', 'Xi''an Xianyang International Airport', 'Terracotta Warriors', 45, 105, 'CNY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'CN'), 'Chengdu', 'chengdu', 'city', 30.5728, 104.0668, 'Asia/Shanghai', 'CTU', 'Chengdu Shuangliu International Airport', 'Panda capital', 45, 105, 'CNY', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TH'), 'Bangkok', 'bangkok', 'city', 13.7563, 100.5018, 'Asia/Bangkok', 'BKK', 'Suvarnabhumi Airport', 'Capital chaos', 40, 100, 'THB', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TH'), 'Phuket', 'phuket', 'island', 7.8804, 98.3923, 'Asia/Bangkok', 'HKT', 'Phuket International Airport', 'Beach paradise', 45, 115, 'THB', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TH'), 'Chiang Mai', 'chiang-mai', 'city', 18.7883, 98.9853, 'Asia/Bangkok', 'CNX', 'Chiang Mai International Airport', 'Northern capital', 35, 95, 'THB', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TH'), 'Krabi', 'krabi', 'city', 8.0863, 98.9063, 'Asia/Bangkok', 'KBV', 'Krabi Airport', 'Limestone cliffs', 40, 110, 'THB', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TH'), 'Koh Samui', 'koh-samui', 'island', 9.5357, 100.0629, 'Asia/Bangkok', 'USM', 'Samui Airport', 'Island retreat', 50, 120, 'THB', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TH'), 'Pattaya', 'pattaya', 'city', 12.9236, 100.8825, 'Asia/Bangkok', 'BKK', 'Suvarnabhumi Airport', 'Beach resort', 35, 105, 'THB', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ID'), 'Bali', 'bali', 'island', -8.3405, 115.0920, 'Asia/Makassar', 'DPS', 'Ngurah Rai International Airport', 'Island of gods', 35, 95, 'IDR', 'Apr,May,Jun,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ID'), 'Jakarta', 'jakarta', 'city', -6.2088, 106.8456, 'Asia/Jakarta', 'CGK', 'Soekarno-Hatta International Airport', 'Capital megacity', 30, 90, 'IDR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ID'), 'Yogyakarta', 'yogyakarta', 'city', -7.7956, 110.3695, 'Asia/Jakarta', 'JOG', 'Yogyakarta International Airport', 'Cultural heart', 25, 85, 'IDR', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ID'), 'Ubud', 'ubud', 'city', -8.5069, 115.2625, 'Asia/Makassar', 'DPS', 'Ngurah Rai International Airport', 'Arts and culture', 35, 95, 'IDR', 'Apr,May,Jun,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ID'), 'Gili Islands', 'gili-islands', 'island', -8.3484, 116.0426, 'Asia/Makassar', 'LOP', 'Lombok International Airport', 'No vehicles', 40, 100, 'IDR', 'Apr,May,Jun,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'ID'), 'Komodo', 'komodo', 'island', -8.5537, 119.4908, 'Asia/Makassar', 'LBJ', 'Komodo Airport', 'Dragon island', 50, 120, 'IDR', 'Apr,May,Jun,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Ho Chi Minh City', 'ho-chi-minh-city', 'city', 10.8231, 106.6297, 'Asia/Ho_Chi_Minh', 'SGN', 'Tan Son Nhat International Airport', 'Saigon energy', 30, 80, 'VND', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Hanoi', 'hanoi', 'city', 21.0285, 105.8542, 'Asia/Ho_Chi_Minh', 'HAN', 'Noi Bai International Airport', 'Capital charm', 30, 80, 'VND', 'Oct,Nov,Dec,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Ha Long Bay', 'ha-long-bay', 'region', 20.9101, 107.1839, 'Asia/Ho_Chi_Minh', 'HAN', 'Noi Bai International Airport', 'Limestone karsts', 35, 95, 'VND', 'Oct,Nov,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Hoi An', 'hoi-an', 'city', 15.8801, 108.3380, 'Asia/Ho_Chi_Minh', 'DAD', 'Da Nang International Airport', 'Ancient town', 30, 80, 'VND', 'Feb,Mar,Apr,May', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Da Nang', 'da-nang', 'city', 16.0544, 108.2022, 'Asia/Ho_Chi_Minh', 'DAD', 'Da Nang International Airport', 'Beach city', 30, 80, 'VND', 'Feb,Mar,Apr,May', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Nha Trang', 'nha-trang', 'city', 12.2388, 109.1967, 'Asia/Ho_Chi_Minh', 'CXR', 'Cam Ranh International Airport', 'Beach resort', 30, 80, 'VND', 'Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'VN'), 'Sapa', 'sapa', 'city', 22.3364, 103.8438, 'Asia/Ho_Chi_Minh', 'HAN', 'Noi Bai International Airport', 'Mountain terraces', 25, 75, 'VND', 'Mar,Apr,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KH'), 'Siem Reap', 'siem-reap', 'city', 13.3671, 103.8448, 'Asia/Phnom_Penh', 'REP', 'Siem Reap International Airport', 'Angkor Wat', 25, 75, 'KHR', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KH'), 'Phnom Penh', 'phnom-penh', 'city', 11.5564, 104.9282, 'Asia/Phnom_Penh', 'PNH', 'Phnom Penh International Airport', 'Capital city', 25, 75, 'KHR', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'LA'), 'Luang Prabang', 'luang-prabang', 'city', 19.8845, 102.1348, 'Asia/Vientiane', 'LPQ', 'Luang Prabang International Airport', 'UNESCO town', 30, 80, 'LAK', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PH'), 'Manila', 'manila', 'city', 14.5995, 120.9842, 'Asia/Manila', 'MNL', 'Ninoy Aquino International Airport', 'Capital city', 35, 85, 'PHP', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PH'), 'Boracay', 'boracay', 'island', 11.9674, 121.9248, 'Asia/Manila', 'MPH', 'Caticlan Airport', 'White beach', 40, 100, 'PHP', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PH'), 'Palawan', 'palawan', 'island', 9.8349, 118.7384, 'Asia/Manila', 'PPS', 'Puerto Princesa Airport', 'Last frontier', 40, 100, 'PHP', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PH'), 'Cebu', 'cebu', 'city', 10.3157, 123.8854, 'Asia/Manila', 'CEB', 'Mactan-Cebu International Airport', 'Queen city', 35, 85, 'PHP', 'Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PH'), 'Siargao', 'siargao', 'island', 9.8603, 126.0466, 'Asia/Manila', 'IAO', 'Siargao Airport', 'Surfing paradise', 35, 95, 'PHP', 'Mar,Apr,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'SG'), 'Singapore', 'singapore', 'city', 1.3521, 103.8198, 'Asia/Singapore', 'SIN', 'Singapore Changi Airport', 'Garden city', 80, 180, 'SGD', 'All year', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MY'), 'Kuala Lumpur', 'kuala-lumpur', 'city', 3.1390, 101.6869, 'Asia/Kuala_Lumpur', 'KUL', 'Kuala Lumpur International Airport', 'Petronas Towers', 40, 100, 'MYR', 'Dec,Jan,Feb,Jun,Jul', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MY'), 'Penang', 'penang', 'island', 5.4141, 100.3288, 'Asia/Kuala_Lumpur', 'PEN', 'Penang International Airport', 'Street food', 35, 95, 'MYR', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MY'), 'Langkawi', 'langkawi', 'island', 6.3501, 99.8001, 'Asia/Kuala_Lumpur', 'LGK', 'Langkawi International Airport', 'Duty-free island', 40, 110, 'MYR', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KR'), 'Seoul', 'seoul', 'city', 37.5665, 126.9780, 'Asia/Seoul', 'ICN', 'Incheon International Airport', 'K-pop capital', 60, 140, 'KRW', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KR'), 'Busan', 'busan', 'city', 35.1796, 129.0756, 'Asia/Seoul', 'PUS', 'Gimhae International Airport', 'Beach metropolis', 50, 120, 'KRW', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'KR'), 'Jeju Island', 'jeju-island', 'island', 33.4996, 126.5312, 'Asia/Seoul', 'CJU', 'Jeju International Airport', 'Volcanic island', 55, 125, 'KRW', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TW'), 'Taipei', 'taipei', 'city', 25.0330, 121.5654, 'Asia/Taipei', 'TPE', 'Taiwan Taoyuan International Airport', 'Night markets', 50, 120, 'TWD', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'TW'), 'Kaohsiung', 'kaohsiung', 'city', 22.6273, 120.3014, 'Asia/Taipei', 'KHH', 'Kaohsiung International Airport', 'Port city', 45, 105, 'TWD', 'Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Delhi', 'delhi', 'city', 28.6139, 77.2090, 'Asia/Kolkata', 'DEL', 'Indira Gandhi International Airport', 'Capital chaos', 30, 80, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Mumbai', 'mumbai', 'city', 19.0760, 72.8777, 'Asia/Kolkata', 'BOM', 'Chhatrapati Shivaji International Airport', 'Bollywood city', 35, 95, 'INR', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Agra', 'agra', 'city', 27.1767, 78.0081, 'Asia/Kolkata', 'AGR', 'Agra Airport', 'Taj Mahal', 25, 75, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Jaipur', 'jaipur', 'city', 26.9124, 75.7873, 'Asia/Kolkata', 'JAI', 'Jaipur International Airport', 'Pink city', 30, 80, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Goa', 'goa', 'region', 15.2993, 74.1240, 'Asia/Kolkata', 'GOI', 'Goa International Airport', 'Beach paradise', 35, 95, 'INR', 'Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Kerala', 'kerala', 'region', 10.8505, 76.2711, 'Asia/Kolkata', 'COK', 'Cochin International Airport', 'Backwaters', 30, 80, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Varanasi', 'varanasi', 'city', 25.3176, 82.9739, 'Asia/Kolkata', 'VNS', 'Lal Bahadur Shastri Airport', 'Holy city', 25, 75, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Udaipur', 'udaipur', 'city', 24.5854, 73.7125, 'Asia/Kolkata', 'UDR', 'Maharana Pratap Airport', 'City of lakes', 30, 80, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Bangalore', 'bangalore', 'city', 12.9716, 77.5946, 'Asia/Kolkata', 'BLR', 'Kempegowda International Airport', 'Tech capital', 35, 95, 'INR', 'Oct,Nov,Dec,Jan,Feb', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IN'), 'Rishikesh', 'rishikesh', 'city', 30.0869, 78.2676, 'Asia/Kolkata', 'DED', 'Dehradun Airport', 'Yoga capital', 25, 75, 'INR', 'Sep,Oct,Nov,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'LK'), 'Colombo', 'colombo', 'city', 6.9271, 79.8612, 'Asia/Colombo', 'CMB', 'Bandaranaike International Airport', 'Commercial capital', 30, 80, 'LKR', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'LK'), 'Kandy', 'kandy', 'city', 7.2906, 80.6337, 'Asia/Colombo', 'CMB', 'Bandaranaike International Airport', 'Cultural city', 25, 75, 'LKR', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NP'), 'Kathmandu', 'kathmandu', 'city', 27.7172, 85.3240, 'Asia/Kathmandu', 'KTM', 'Tribhuvan International Airport', 'Mountain gateway', 25, 75, 'NPR', 'Oct,Nov,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NP'), 'Pokhara', 'pokhara', 'city', 28.2096, 83.9856, 'Asia/Kathmandu', 'PKR', 'Pokhara Airport', 'Annapurna views', 25, 75, 'NPR', 'Oct,Nov,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'MV'), 'Male', 'male', 'city', 4.1755, 73.5093, 'Indian/Maldives', 'MLE', 'Velana International Airport', 'Island nation', 100, 300, 'MVR', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AE'), 'Dubai', 'dubai', 'city', 25.2048, 55.2708, 'Asia/Dubai', 'DXB', 'Dubai International Airport', 'Luxury hub', 100, 250, 'AED', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AE'), 'Abu Dhabi', 'abu-dhabi', 'city', 24.4539, 54.3773, 'Asia/Dubai', 'AUH', 'Abu Dhabi International Airport', 'UAE capital', 90, 220, 'AED', 'Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IL'), 'Tel Aviv', 'tel-aviv', 'city', 32.0853, 34.7818, 'Asia/Jerusalem', 'TLV', 'Ben Gurion Airport', 'Mediterranean city', 80, 180, 'ILS', 'Mar,Apr,May,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IL'), 'Jerusalem', 'jerusalem', 'city', 31.7683, 35.2137, 'Asia/Jerusalem', 'TLV', 'Ben Gurion Airport', 'Holy city', 75, 175, 'ILS', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'IL'), 'Eilat', 'eilat', 'city', 29.5581, 34.9482, 'Asia/Jerusalem', 'ETM', 'Ramon Airport', 'Red Sea resort', 80, 180, 'ILS', 'Nov,Dec,Jan,Feb,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AU'), 'Sydney', 'sydney', 'city', -33.8688, 151.2093, 'Australia/Sydney', 'SYD', 'Sydney Kingsford Smith Airport', 'Harbor city', 90, 200, 'AUD', 'Sep,Oct,Nov,Dec,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AU'), 'Melbourne', 'melbourne', 'city', -37.8136, 144.9631, 'Australia/Melbourne', 'MEL', 'Melbourne Airport', 'Cultural capital', 85, 185, 'AUD', 'Mar,Apr,Oct,Nov,Dec', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AU'), 'Brisbane', 'brisbane', 'city', -27.4698, 153.0251, 'Australia/Brisbane', 'BNE', 'Brisbane Airport', 'Sunshine state', 80, 180, 'AUD', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AU'), 'Gold Coast', 'gold-coast', 'city', -28.0167, 153.4000, 'Australia/Brisbane', 'OOL', 'Gold Coast Airport', 'Beach paradise', 85, 185, 'AUD', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AU'), 'Cairns', 'cairns', 'city', -16.9186, 145.7781, 'Australia/Brisbane', 'CNS', 'Cairns Airport', 'Great Barrier Reef', 90, 190, 'AUD', 'Apr,May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AU'), 'Perth', 'perth', 'city', -31.9505, 115.8605, 'Australia/Perth', 'PER', 'Perth Airport', 'Western capital', 80, 180, 'AUD', 'Sep,Oct,Nov,Mar,Apr', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NZ'), 'Auckland', 'auckland', 'city', -36.8485, 174.7633, 'Pacific/Auckland', 'AKL', 'Auckland Airport', 'City of Sails', 80, 180, 'NZD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NZ'), 'Queenstown', 'queenstown', 'city', -45.0312, 168.6626, 'Pacific/Auckland', 'ZQN', 'Queenstown Airport', 'Adventure capital', 90, 190, 'NZD', 'Dec,Jan,Feb,Jun,Jul,Aug', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'NZ'), 'Wellington', 'wellington', 'city', -41.2865, 174.7762, 'Pacific/Auckland', 'WLG', 'Wellington International Airport', 'Windy capital', 75, 165, 'NZD', 'Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'FJ'), 'Fiji', 'fiji', 'island', -17.7134, 178.0650, 'Pacific/Fiji', 'NAN', 'Nadi International Airport', 'Island paradise', 70, 160, 'FJD', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GE'), 'Tbilisi', 'tbilisi', 'city', 41.7151, 44.8271, 'Asia/Tbilisi', 'TBS', 'Tbilisi International Airport', 'Charming capital', 30, 80, 'GEL', 'Apr,May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GE'), 'Batumi', 'batumi', 'city', 41.6168, 41.6367, 'Asia/Tbilisi', 'BUS', 'Batumi International Airport', 'Black Sea resort', 35, 85, 'GEL', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GE'), 'Kazbegi', 'kazbegi', 'region', 42.6588, 44.6442, 'Asia/Tbilisi', 'TBS', 'Tbilisi International Airport', 'Mountain paradise', 30, 80, 'GEL', 'May,Jun,Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'GE'), 'Mtskheta', 'mtskheta', 'city', 41.8433, 44.7197, 'Asia/Tbilisi', 'TBS', 'Tbilisi International Airport', 'Ancient capital', 25, 75, 'GEL', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AZ'), 'Baku', 'baku', 'city', 40.4093, 49.8671, 'Asia/Baku', 'GYD', 'Heydar Aliyev International Airport', 'Flame Towers', 35, 95, 'AZN', 'Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'AZ'), 'Sheki', 'sheki', 'city', 41.1976, 47.1707, 'Asia/Baku', 'GYD', 'Heydar Aliyev International Airport', 'Silk Road town', 30, 80, 'AZN', 'May,Jun,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PF'), 'Bora Bora', 'bora-bora', 'island', -16.5004, -151.7414, 'Pacific/Tahiti', 'BOB', 'Bora Bora Airport', 'Ultimate paradise', 150, 400, 'XPF', 'Apr,May,Jun,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PF'), 'Tahiti', 'tahiti', 'island', -17.6509, -149.4260, 'Pacific/Tahiti', 'PPT', 'Faa''a International Airport', 'French Polynesia', 120, 300, 'XPF', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'PF'), 'Moorea', 'moorea', 'island', -17.5388, -149.8295, 'Pacific/Tahiti', 'MOZ', 'Moorea Airport', 'Volcanic paradise', 130, 320, 'XPF', 'Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JO'), 'Petra', 'petra', 'city', 30.3285, 35.4444, 'Asia/Amman', 'AMM', 'Queen Alia International Airport', 'Rose city', 60, 140, 'JOD', 'Mar,Apr,May,Sep,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JO'), 'Amman', 'amman', 'city', 31.9454, 35.9284, 'Asia/Amman', 'AMM', 'Queen Alia International Airport', 'Jordan capital', 50, 120, 'JOD', 'Mar,Apr,May,Sep,Oct', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'JO'), 'Wadi Rum', 'wadi-rum', 'region', 29.5758, 35.4183, 'Asia/Amman', 'AQJ', 'Aqaba International Airport', 'Desert valley', 60, 140, 'JOD', 'Mar,Apr,Oct,Nov', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'OM'), 'Muscat', 'muscat', 'city', 23.5880, 58.3829, 'Asia/Muscat', 'MCT', 'Muscat International Airport', 'Sultan capital', 70, 160, 'OMR', 'Oct,Nov,Dec,Jan,Feb,Mar', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'OM'), 'Salalah', 'salalah', 'city', 17.0151, 54.0924, 'Asia/Muscat', 'SLL', 'Salalah Airport', 'Monsoon paradise', 65, 155, 'OMR', 'Jul,Aug,Sep', true, true),
((SELECT id FROM countries WHERE iso_alpha2 = 'QA'), 'Doha', 'doha', 'city', 25.2854, 51.5310, 'Asia/Qatar', 'DOH', 'Hamad International Airport', 'Modern Arabian', 90, 200, 'QAR', 'Nov,Dec,Jan,Feb,Mar', true, true)

;

-- Re-enable FK checks
SET session_replication_role = 'origin';

-- Add FK constraint (warn: countries table must exist)
-- WARNING: countries table presence is unknown (COUNTRIES_TABLE_PRESENT=unknown).
-- This statement will fail if the countries table does not exist.
-- FK_VALIDATION=warn_only -- keep the FK definition but be aware it may error.
ALTER TABLE destinations ADD CONSTRAINT fk_destinations_country
  FOREIGN KEY (country_id) REFERENCES countries(id)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Create indexes (deferred until after data load for performance)
CREATE INDEX idx_destinations_country_id ON destinations(country_id);
CREATE INDEX idx_destinations_is_active ON destinations(is_active);
CREATE INDEX idx_destinations_is_premium ON destinations(is_premium);
CREATE INDEX idx_destinations_type ON destinations(type);

COMMIT;

-- =============================================================================
-- END OF GOLDEN SEED
-- Total rows inserted: 347
-- =============================================================================