-- Silver: standardize selected fields, apply validation filters,
-- and retain the latest row per non-null flight_id.
CREATE OR REFRESH MATERIALIZED VIEW silver_airline_flights
AS
SELECT
    flight_id,
    TRIM(flight_number) AS flight_number,
    COALESCE(NULLIF(INITCAP(LOWER(TRIM(airline))), ''), 'Unknown') AS airline,
    aircraft_id,
    TRIM(aircraft_type) AS aircraft_type,
    flight_date,
    day_of_week,
    INITCAP(LOWER(TRIM(origin_city))) AS origin_city,
    INITCAP(LOWER(TRIM(destination_city))) AS destination_city,
    origin_region,
    distance_km,
    scheduled_departure,
    actual_departure,
    delay_minutes,
    COALESCE(NULLIF(TRIM(delay_reason), ''), 'Unknown') AS delay_reason,
    seat_capacity,
    passengers,
    avg_fare,
    COALESCE(ticket_revenue, passengers * avg_fare) AS ticket_revenue,
    fuel_cost,
    source_file,
    loaded_at
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY flight_id
            ORDER BY loaded_at DESC
        ) AS rn
    FROM bronze_airline_flights
    WHERE flight_id IS NOT NULL
      AND flight_date IS NOT NULL
      AND passengers <= seat_capacity
      AND passengers >= 0
      AND avg_fare >= 0
) cleaned
WHERE rn = 1;
