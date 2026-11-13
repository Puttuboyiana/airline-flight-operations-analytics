# Implementation notes

## Execution environment
The project tables and materialized views were created and queried using a Databricks SQL Warehouse in the `workspace.flights` schema.

## Layers
- Bronze: streaming table reading CSV files from a Unity Catalog Volume.
- Silver: materialized view applying selected field standardization, validation filters, and latest-row deduplication by `flight_id`.
- Rejected: materialized view containing rows matching the explicit rejection predicates.
- Gold: analytical materialized views for month, airline, route, and delay category, plus a data-quality snapshot table.

## Scope and limitations
- A separately deployed Lakeflow pipeline is not part of this repository.
- Delay minutes were retained from the source data; they were not recalculated from departure timestamps.
- Rejected rows and duplicate IDs are counted using different predicates and have not been proven to be mutually exclusive or exhaustive.
- Gold data quality is a snapshot created with `CREATE OR REPLACE TABLE`; rerun the script to refresh it.
