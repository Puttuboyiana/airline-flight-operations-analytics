-- Gold: classify flights by delay duration.
CREATE OR REFRESH MATERIALIZED VIEW gold_delay_summary
AS
SELECT
    CASE
        WHEN delay_minutes <= 15 THEN 'On Time'
        WHEN delay_minutes <= 60 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END AS delay_category,
    COUNT(*) AS total_flights,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    SUM(passengers) AS total_passengers,
    ROUND(SUM(ticket_revenue), 2) AS total_revenue
FROM silver_airline_flights
GROUP BY
    CASE
        WHEN delay_minutes <= 15 THEN 'On Time'
        WHEN delay_minutes <= 60 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END;
