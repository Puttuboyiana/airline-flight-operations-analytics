-- Gold: point-in-time quality-count snapshot.
CREATE OR REPLACE TABLE workspace.flights.gold_data_quality AS
SELECT
    (SELECT COUNT(*) FROM workspace.flights.bronze_airline_flights) AS bronze_count,
    (SELECT COUNT(*) FROM workspace.flights.silver_airline_flights) AS silver_count,
    (SELECT COUNT(*) FROM workspace.flights.rejected_airline_flights) AS rejected_count,
    (SELECT COUNT(*) FROM workspace.flights.bronze_airline_flights)
    -
    (SELECT COUNT(DISTINCT flight_id) FROM workspace.flights.bronze_airline_flights)
    -
    (SELECT COUNT(*) FROM workspace.flights.bronze_airline_flights WHERE flight_id IS NULL) AS duplicate_count;
