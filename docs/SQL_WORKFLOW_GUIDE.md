# SQL Workflow Guide — TVS Manufacturing Analytics

## Purpose

This guide explains how the four SQL scripts fit together. Use MySQL 8 / MySQL Workbench and the database name `tvs_manufacturing`.

> **Warning:** `01_create_tables.sql` starts with `DROP DATABASE IF EXISTS tvs_manufacturing`. This deletes and recreates that database. Confirm the target database and back up important data before running it.

## Script order

| Order | File | Purpose |
|---:|---|---|
| 1 | [01_create_tables.sql](../TVs_Poject/SQL/01_create_tables.sql) | Creates the database and dimension/fact tables. |
| 2 | [02_insert_data.sql](../TVs_Poject/SQL/02_insert_data.sql) | Inserts the practice data. |
| 3 | [03_verify_import.sql](../TVs_Poject/SQL/03_verify_import.sql) | Validates row counts, quality flags, core KPIs, joins and date ranges. |
| 4 | [04_analysis_queries.sql](../TVs_Poject/SQL/04_analysis_queries.sql) | Runs the project's analysis queries. |

## Before running

1. Open MySQL Workbench and connect to the intended MySQL server.
2. Confirm that you can use the intended practice database.
3. Read each script before execution.
4. Do not run the destructive table-creation script on a database containing important work.
5. Execute scripts sequentially and inspect errors before continuing.

## Expected import checks

The verification script documents these expected counts:

| Table | Expected rows |
|---|---:|
| `plants` | 3 |
| `machines` | 11 |
| `products` | 6 |
| `production` | 7,940 |
| `defects` | 3,960 |

Quality-flag expectations in the script:

- `production`: 7,916 `OK` rows and 24 flagged rows.
- `defects`: 3,954 `OK` rows and 6 `Zero_Defect_Qty` rows.

The core KPI query for `production` rows flagged `OK` documents these expected validation targets:

- Production rows: 7,916
- Production quantity: 3,626,137
- Production-table defect quantity: 138,990
- Production-table defect rate: 3.83%
- Average downtime: 34.80 minutes

For `defects` rows flagged `OK`, the script documents 3,954 rows and 9,285 defect units. These are expected targets from the project SQL, not external company facts. Confirm the actual results by executing the queries.

## Important modelling note

`production` and `defects` are separate fact tables. Do not directly join them on date, plant, machine and product and then sum quantities without aggregating to a compatible grain; many-to-many matches can duplicate rows. Use each fact table for its own measures, or aggregate before combining.

## Troubleshooting

- **Row count differs:** check whether the insert script completed, whether it was run more than once, and whether you are using the correct database.
- **Foreign-key error:** load dimension tables before fact records and check that all IDs exist in the dimension tables.
- **Power BI totals differ from SQL:** check filters, relationships, data types, duplicate rows and whether both tools use the same KPI definition.
- **Unexpected defect rate:** confirm whether the numerator is `production.Defect_Qty` or `defects.Defect_Qty`, and use the correct denominator and quality filter.
