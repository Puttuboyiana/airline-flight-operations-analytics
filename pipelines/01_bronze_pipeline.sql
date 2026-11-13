-- Bronze pipeline: ingest raw airline flight CSV files.
-- Run in Databricks SQL with the source CSV files available in this Volume.

CREATE OR REFRESH STREAMING TABLE workspace.flights.bronze_airline_flights
AS
SELECT
    *,
    _metadata.file_name AS source_file,
    current_timestamp() AS loaded_at
FROM STREAM read_files(
    '/Volumes/workspace/flights/raw_files/',
    format => 'csv',
    header => true
);
