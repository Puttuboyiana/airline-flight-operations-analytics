-- Row counts by layer
SELECT COUNT(*) AS bronze_count FROM workspace.flights.bronze_airline_flights;
SELECT COUNT(*) AS silver_count FROM workspace.flights.silver_airline_flights;
SELECT COUNT(*) AS rejected_count FROM workspace.flights.rejected_airline_flights;

-- Duplicate flight IDs in Bronze
SELECT COUNT(*) - COUNT(DISTINCT flight_id) AS duplicate_id_count
FROM workspace.flights.bronze_airline_flights;

-- Silver airline performance
SELECT airline, COUNT(*) AS total_flights,
       SUM(passengers) AS total_passengers,
       ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes
FROM workspace.flights.silver_airline_flights
GROUP BY airline
ORDER BY total_flights DESC;

-- Monthly Gold output
SELECT *
FROM workspace.flights.gold_monthly_flights
ORDER BY flight_month;
