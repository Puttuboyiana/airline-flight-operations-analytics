-- Gold pipeline: publish analytics-ready aggregate views from Silver.

CREATE OR REFRESH MATERIALIZED VIEW workspace.flights.gold_monthly_flights
AS
SELECT
    DATE_TRUNC('MONTH', flight_date) AS flight_month,
    COUNT(*) AS total_flights,
    SUM(passengers) AS total_passengers,
    SUM(ticket_revenue) AS total_revenue,
    AVG(delay_minutes) AS avg_delay_minutes
FROM workspace.flights.silver_airline_flights
GROUP BY DATE_TRUNC('MONTH', flight_date);

CREATE OR REFRESH MATERIALIZED VIEW workspace.flights.gold_airline_summary
AS
SELECT
    airline,
    COUNT(*) AS total_flights,
    SUM(passengers) AS total_passengers,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    SUM(ticket_revenue) AS total_revenue,
    ROUND(AVG(ticket_revenue), 2) AS avg_revenue_per_flight
FROM workspace.flights.silver_airline_flights
GROUP BY airline;

CREATE OR REFRESH MATERIALIZED VIEW workspace.flights.gold_route_summary
AS
SELECT
    origin_city,
    destination_city,
    COUNT(*) AS total_flights,
    SUM(passengers) AS total_passengers,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    SUM(ticket_revenue) AS total_revenue
FROM workspace.flights.silver_airline_flights
GROUP BY origin_city, destination_city;

CREATE OR REFRESH MATERIALIZED VIEW workspace.flights.gold_delay_summary
AS
SELECT
    CASE
        WHEN COALESCE(delay_minutes, 0) <= 15 THEN 'On Time'
        WHEN delay_minutes <= 60 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END AS delay_category,
    COUNT(*) AS total_flights,
    ROUND(AVG(delay_minutes), 2) AS avg_delay_minutes,
    SUM(passengers) AS total_passengers,
    SUM(ticket_revenue) AS total_revenue
FROM workspace.flights.silver_airline_flights
GROUP BY
    CASE
        WHEN COALESCE(delay_minutes, 0) <= 15 THEN 'On Time'
        WHEN delay_minutes <= 60 THEN 'Minor Delay'
        ELSE 'Major Delay'
    END;

CREATE OR REFRESH MATERIALIZED VIEW workspace.flights.gold_data_quality
AS
SELECT
    (SELECT COUNT(*) FROM workspace.flights.bronze_airline_flights) AS bronze_records,
    (SELECT COUNT(*) FROM workspace.flights.silver_airline_flights) AS silver_records,
    (SELECT COUNT(*) FROM workspace.flights.rejected_airline_flights) AS rejected_records,
    (
        SELECT COUNT(*) - COUNT(DISTINCT flight_id)
        FROM workspace.flights.bronze_airline_flights
        WHERE flight_id IS NOT NULL
    ) AS duplicate_flight_ids;
