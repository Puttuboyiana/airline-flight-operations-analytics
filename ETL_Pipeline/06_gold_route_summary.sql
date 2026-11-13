-- Gold: origin-destination route summary.
CREATE OR REFRESH MATERIALIZED VIEW gold_route_summary
AS
SELECT
    origin_city,
    destination_city,
    COUNT(*) AS total_flights,
    SUM(passengers) AS total_passengers,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    ROUND(SUM(ticket_revenue), 2) AS total_revenue
FROM silver_airline_flights
GROUP BY origin_city, destination_city;
