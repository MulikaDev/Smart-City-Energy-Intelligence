/* PROJECT: Smart City Energy Monitoring (Munich)
DESCRIPTION: System for tracking energy consumption and solar production in Schwabing district. */



-- 1. DATABASE STRUCTURE

CREATE TABLE IF NOT EXISTS smart_meters (
meter_id SERIAL PRIMARY KEY,
serial_number VARCHAR(50) UNIQUE NOT NULL,
district_name VARCHAR(100) NOT NULL,
created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS energy_metrics (
log_id BIGSERIAL PRIMARY KEY,
meter_id INT REFERENCES smart_meters(meter_id),
observation_time TIMESTAMPTZ NOT NULL,
consumption_kwh DECIMAL(10, 3) NOT NULL,
production_kwh DECIMAL(10, 3) DEFAULT 0,
price_eur_kwh DECIMAL(5, 4) NOT NULL
);


-- 2. METER REGISTRATION

INSERT INTO smart_meters (serial_number, district_name)
VALUES ('muc-schw-001', 'schwabing')
ON CONFLICT (serial_number) DO NOTHING;


-- 3. 24-HOUR DATA SEEDING

INSERT INTO energy_metrics (meter_id, observation_time, consumption_kwh, production_kwh, price_eur_kwh)
VALUES
(1, '2026-02-23 00:00:00+01', 0.150, 0.0, 0.15),
(1, '2026-02-23 01:00:00+01', 0.120, 0.0, 0.14),
(1, '2026-02-23 02:00:00+01', 0.110, 0.0, 0.13),
(1, '2026-02-23 03:00:00+01', 0.115, 0.0, 0.13),
(1, '2026-02-23 04:00:00+01', 0.130, 0.0, 0.14),
(1, '2026-02-23 05:00:00+01', 0.250, 0.0, 0.16),
(1, '2026-02-23 06:00:00+01', 0.600, 0.0, 0.22),
(1, '2026-02-23 07:00:00+01', 0.900, 0.0, 0.26),
(1, '2026-02-23 08:00:00+01', 0.850, 0.1, 0.28),
(1, '2026-02-23 09:00:00+01', 0.450, 0.4, 0.24),
(1, '2026-02-23 10:00:00+01', 0.300, 0.8, 0.20),
(1, '2026-02-23 11:00:00+01', 0.250, 1.2, 0.18),
(1, '2026-02-23 12:00:00+01', 0.350, 1.6, 0.17),
(1, '2026-02-23 13:00:00+01', 0.300, 1.7, 0.17),
(1, '2026-02-23 14:00:00+01', 0.280, 1.5, 0.18),
(1, '2026-02-23 15:00:00+01', 0.320, 1.1, 0.19),
(1, '2026-02-23 16:00:00+01', 0.450, 0.6, 0.21),
(1, '2026-02-23 17:00:00+01', 1.100, 0.2, 0.27),
(1, '2026-02-23 18:00:00+01', 1.800, 0.0, 0.31),
(1, '2026-02-23 19:00:00+01', 2.200, 0.0, 0.33),
(1, '2026-02-23 20:00:00+01', 1.900, 0.0, 0.30),
(1, '2026-02-23 21:00:00+01', 1.400, 0.0, 0.26),
(1, '2026-02-23 22:00:00+01', 0.800, 0.0, 0.20),
(1, '2026-02-23 23:00:00+01', 0.400, 0.0, 0.17);


-- 4. BASIC DATA VERIFICATION

SELECT * FROM energy_metrics LIMIT 5; 

-- 5. SELECTING SPECIFIС DATA

SELECT observation_time, consumption_kwh 
FROM energy_metrics LIMIT 10;

-- 6. CALCULATED FIELDS (NET USAGE)

SELECT observation_time, 
	   (consumption_kwh - production_kwh) AS net_usage
FROM energy_metrics LIMIT 10;

-- 7. FILTERING DATA
-- Finding only those when solar panels were active

SELECT observation_time, production_kwh
FROM energy_metrics
WHERE production_kwh > 0;

-- 8. SORTING SOLAR DATA
-- Peak hours
SELECT observation_time, 
	   production_kwh
FROM energy_metrics
WHERE production_kwh > 0
ORDER BY production_kwh DESC;

-- 9. DAILY TOTALS AND AVERAGES
-- Calculating total consumption and average price for the whole day

SELECT SUM(consumption_kwh) AS total_daily_consumption,
	   AVG(price_eur_kwh) AS average_price
FROM energy_metrics;

-- 10. FINANCIAL SUMMARY
-- Total cost and consumption

SELECT SUM(consumption_kwh) AS total_kwh,
	   AVG(price_eur_kwh) AS avg_price,
	   SUM(consumption_kwh * price_eur_kwh) AS total_cost_eur
FROM energy_metrics;
	

-- 11. HOURLY AGGREGATION 
-- Grouping data by hour to see consumption trends

SELECT
	DATE_TRUNC('hour', observation_time) AS hour,
	SUM(consumption_kwh) AS total_consumption,
	SUM(production_kwh) AS total_production
FROM energy_metrics
GROUP BY 1 ORDER BY 1;


-- 12. ADVANCED ANALYTICS: WEIGHTED AVERAGE PRICE

SELECT
	SUM(consumption_kwh * price_eur_kwh) /
	NULLIF(SUM(consumption_kwh), 0) AS weighted_avg_price
FROM energy_metrics;

-- 13. DATA ENRICHMENT (JOIN)
-- Final view for Power BI export

SELECT 
	sm.district_name,
	em.observation_time,
	em.consumption_kwh,
	em.production_kwh,
	em.price_eur_kwh,
	(em.consumption_kwh - em.production_kwh) AS net_usage
FROM energy_metrics em
JOIN smart_meters sm ON em.meter_id = sm.meter_id;
