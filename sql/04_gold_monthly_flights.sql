-- Gold: monthly flight and revenue KPIs.
CREATE OR REFRESH MATERIALIZED VIEW gold_monthly_flights
AS
SELECT
    DATE_FORMAT(flight_date, 'yyyy-MM') AS flight_month,
    COUNT(*) AS total_flights,
    SUM(passengers) AS total_passengers,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    ROUND(SUM(ticket_revenue), 2) AS total_revenue
FROM silver_airline_flights
GROUP BY DATE_FORMAT(flight_date, 'yyyy-MM');
