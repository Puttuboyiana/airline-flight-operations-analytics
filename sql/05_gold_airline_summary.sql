-- Gold: airline-level operating and revenue summary.
CREATE OR REFRESH MATERIALIZED VIEW gold_airline_summary
AS
SELECT
    airline,
    COUNT(*) AS total_flights,
    SUM(passengers) AS total_passengers,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    ROUND(SUM(ticket_revenue), 2) AS total_revenue,
    ROUND(AVG(avg_fare), 2) AS avg_fare
FROM silver_airline_flights
GROUP BY airline;
