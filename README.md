# TVS Motor Manufacturing Quality, Defect and Production Analytics

**Author:** Prithivi Kanth S  
**Project type:** Data Analytics Portfolio Project  
**Tools:** Microsoft Excel, MySQL 8, Power BI Desktop, GitHub

> **Dataset disclaimer:** This project uses synthetic practice data. It is not official TVS Motor Company data. The data and findings must not be represented as actual company performance.

## Project Overview

This project demonstrates an end-to-end manufacturing analytics workflow: inspect a raw Excel workbook, work with five cleaned CSV datasets, create and validate MySQL tables, analyse production and quality indicators with SQL, and explore the results in Power BI.

## Start Here

| Resource | Purpose |
|---|---|
| [Project Documentation](docs/PROJECT_DOCUMENTATION.md) | Project overview, business problem, objectives, tools, workflow, data model, KPIs, limitations and presentation structure |
| [Presentation Guide](docs/PRESENTATION_GUIDE.md) | Speaking order, demo checklist and likely presentation questions |
| [Data Dictionary](docs/DATA_DICTIONARY.md) | Field definitions, logical types, keys, relationships and data-quality notes for all five cleaned CSV datasets |
| [SQL Workflow Guide](docs/SQL_WORKFLOW_GUIDE.md) | Script order, expected validation checks, safety warning and troubleshooting |

## Repository Structure

```text
.
├── README.md
├── docs/
│   ├── PROJECT_DOCUMENTATION.md
│   ├── PRESENTATION_GUIDE.md
│   ├── DATA_DICTIONARY.md
│   └── SQL_WORKFLOW_GUIDE.md
└── TVs_Poject/
    ├── Raw Dataset/
    │   └── TVS_Manufacturing_Analytics_Raw_Dataset.xlsx
    ├── Cleaned Dataset/
    │   ├── plants.csv
    │   ├── machines.csv
    │   ├── products.csv
    │   ├── production.csv
    │   └── defects.csv
    ├── SQL/
    │   ├── 01_create_tables.sql
    │   ├── 02_insert_data.sql
    │   ├── 03_verify_import.sql
    │   └── 04_analysis_queries.sql
    ├── PowerBI/
    │   └── TVS_Manufacturing_Dashboard.pbix
    └── Screenshots/
        ├── Power BI Screenshot/
        └── SQL Screenshot/
```

## Technology Stack

| Tool | Role |
|---|---|
| Excel | Inspect the original workbook |
| CSV | Store cleaned tabular datasets |
| MySQL 8 / MySQL Workbench | Relational storage, validation and SQL analysis |
| Power BI Desktop | Data modelling, measures and interactive reporting |
| GitHub | Version control, documentation and portfolio sharing |

## Cleaned Datasets

| Dataset | Description |
|---|---|
| [plants.csv](TVs_Poject/Cleaned%20Dataset/plants.csv) | Plant reference data |
| [machines.csv](TVs_Poject/Cleaned%20Dataset/machines.csv) | Machine identifiers, names and types |
| [products.csv](TVs_Poject/Cleaned%20Dataset/products.csv) | Product identifiers, names and categories |
| [production.csv](TVs_Poject/Cleaned%20Dataset/production.csv) | Production records, production quantity, production-table defect quantity, shift, downtime and quality flags |
| [defects.csv](TVs_Poject/Cleaned%20Dataset/defects.csv) | Separate defect records, defect type, recorded root-cause label, quantity, rework flag and quality flags |

See the [Data Dictionary](docs/DATA_DICTIONARY.md) for field-by-field descriptions and relationship notes.

## SQL Workflow

Run the scripts in order, after reading each file:

1. [01_create_tables.sql](TVs_Poject/SQL/01_create_tables.sql) — creates the database and tables.
2. [02_insert_data.sql](TVs_Poject/SQL/02_insert_data.sql) — inserts practice records.
3. [03_verify_import.sql](TVs_Poject/SQL/03_verify_import.sql) — checks row counts, quality flags, KPI calculations and joins.
4. [04_analysis_queries.sql](TVs_Poject/SQL/04_analysis_queries.sql) — runs analysis queries.

**Safety warning:** The table-creation script contains `DROP DATABASE IF EXISTS tvs_manufacturing`. It deletes and recreates that database. Do not run it against a database containing important work.

See the [SQL Workflow Guide](docs/SQL_WORKFLOW_GUIDE.md) for expected validation checks and troubleshooting.

## Power BI Report Preview

Screenshots stored in this repository:

### Dashboard overview
![Power BI dashboard overview](TVs_Poject/Screenshots/Power%20BI%20Screenshot/dashboard_page1_overview.png)

### Quality analysis
![Power BI quality analysis](TVs_Poject/Screenshots/Power%20BI%20Screenshot/dashboard_page2_quality.png)

### Machine analysis
![Power BI machine analysis](TVs_Poject/Screenshots/Power%20BI%20Screenshot/dashboard_page3_machines.png)

Open the [Power BI report folder](TVs_Poject/PowerBI/) to access the PBIX file. If it requests data-source paths, update them for your computer and validate the report after refreshing.

## Data Model and KPI Caution

The `plants`, `machines` and `products` tables are dimensions. `production` and `defects` are separate fact tables. Do not directly join both fact tables at row level and sum quantities without considering their different grains; this can multiply records and inflate totals.

Also distinguish `production.Defect_Qty` from `defects.Defect_Qty`. They are separate measures and should not be combined without confirming their definitions. Verify KPI formulas and filters against the SQL validation script and Power BI measures before presenting numbers.

## Suggested Presentation Flow

1. Explain the business problem and project objectives.
2. Introduce the five cleaned CSV datasets and data dictionary.
3. Explain dimension tables and fact tables.
4. Demonstrate SQL table creation and import validation.
5. Walk through the Power BI pages and explain verified measures.
6. Discuss observations, limitations and possible improvements.

For the speaking outline, see the [Presentation Guide](docs/PRESENTATION_GUIDE.md).

## Limitations

- The dataset is synthetic practice data, not official TVS Motor Company data.
- Recorded root-cause labels do not prove actual causation.
- Results depend on data quality, filters, relationships and KPI definitions.
- Findings should be reported only after checking SQL outputs and dashboard calculations.

## Links

- [Project Documentation](docs/PROJECT_DOCUMENTATION.md)
- [Presentation Guide](docs/PRESENTATION_GUIDE.md)
- [Data Dictionary](docs/DATA_DICTIONARY.md)
- [SQL Workflow Guide](docs/SQL_WORKFLOW_GUIDE.md)
- [Raw Dataset folder](TVs_Poject/Raw%20Dataset/)
- [Cleaned Dataset folder](TVs_Poject/Cleaned%20Dataset/)
- [SQL folder](TVs_Poject/SQL/)
- [Power BI report](TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix)
- [Screenshots folder](TVs_Poject/Screenshots/)

---
Maintainer: Prithivi Kanth S
