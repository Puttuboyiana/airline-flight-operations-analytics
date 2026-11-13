-- Rejected: records failing the selected Silver validation conditions.
CREATE OR REFRESH MATERIALIZED VIEW rejected_airline_flights
AS
SELECT *
FROM bronze_airline_flights
WHERE flight_id IS NULL
   OR flight_date IS NULL
   OR passengers > seat_capacity
   OR passengers < 0
   OR avg_fare < 0;
