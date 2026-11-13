# Three-Pipeline Architecture

This project follows the Medallion (Bronze–Silver–Gold) architecture. The three SQL pipeline files in this folder implement the flow shown below.

```mermaid
flowchart TD
    A[Raw airline CSV files<br/>Unity Catalog Volume] --> B[01_bronze_pipeline.sql<br/>Bronze ingestion]
    B --> C[workspace.flights.bronze_airline_flights]
    C --> D[02_silver_pipeline.sql<br/>Cleaning, standardization and deduplication]
    D --> E[workspace.flights.silver_airline_flights]
    D --> F[workspace.flights.rejected_airline_flights]
    E --> G[03_gold_pipeline.sql<br/>Business aggregations]
    C --> H[03_gold_pipeline.sql<br/>Data-quality metrics]
    E --> H
    F --> H
    G --> I[Gold analytics views: Monthly, Airline, Route, Delay]
    H --> J[Gold data-quality view]
    I --> K[Databricks AI/BI Dashboard]
    J --> K
```

## Pipeline responsibilities

1. **Bronze** — reads CSV files from the Unity Catalog Volume and preserves source metadata and load timestamp.
2. **Silver** — trims and standardizes selected fields, applies validation filters, deduplicates by `flight_id`, and exposes rejected rows separately.
3. **Gold** — creates analytics-ready materialized views for monthly flights, airline performance, routes, delay categories, and data-quality counts.

## Run order

Run the SQL files in this order after confirming the source Volume path and `workspace.flights` schema:

1. `01_bronze_pipeline.sql`
2. `02_silver_pipeline.sql`
3. `03_gold_pipeline.sql`

The scripts define Databricks SQL streaming/materialized tables and views; they are SQL pipeline definitions, not a pre-configured Databricks Workflows job.