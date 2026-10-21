# TVS Motor Manufacturing Quality, Defect and Production Analytics

**Author:** Prithivi Kanth S  
**Project type:** Data Analytics Portfolio Project  
**Tools:** Microsoft Excel, MySQL 8, Power BI Desktop, GitHub

> **Dataset disclaimer:** This project uses synthetic practice data. It is not official TVS Motor Company data. The data and findings must not be represented as actual company performance.

## Project Overview

This portfolio project demonstrates an end-to-end manufacturing analytics workflow: inspect a raw Excel workbook, work with five cleaned CSV datasets, create and validate MySQL tables, analyse production and quality indicators with SQL, and explore the results in Power BI.

## Start Here

| Resource | What it contains |
|---|---|
| **[Project Documentation](docs/PROJECT_DOCUMENTATION.md)** | Presentation-ready overview, objectives, tools, workflow, data model, business questions, KPI interpretation, validation and limitations |
| **[Data Dictionary](docs/DATA_DICTIONARY.md)** | Field-by-field definitions, logical data types, keys, relationships and data-quality notes for all five cleaned CSV datasets |

## Project Files

- [Raw Excel dataset](TVs_Poject/Raw%20Dataset/)
- [Cleaned CSV datasets](TVs_Poject/Cleaned%20Dataset/)
- [MySQL scripts](TVs_Poject/SQL/)
- [Power BI report](TVs_Poject/PowerBI/)
- [Screenshots](TVs_Poject/Screenshots/)

## Cleaned CSV Datasets

- `plants.csv` — plant reference data
- `machines.csv` — machine reference data
- `products.csv` — product reference data
- `production.csv` — production records, quantities, shift and downtime
- `defects.csv` — defect records, categories, recorded root-cause labels, quantities and rework flag

See the [Data Dictionary](docs/DATA_DICTIONARY.md) for complete field definitions.

## Suggested Presentation Order

1. Introduce the simulated manufacturing problem and project goals.
2. Explain the tools and five CSV datasets.
3. Show the data model and SQL validation process.
4. Demonstrate selected SQL queries.
5. Walk through the Power BI report and explain verified KPIs.
6. Discuss data limitations and possible improvements.

Only present findings you have verified from the SQL outputs and Power BI report. The dataset is synthetic; it does not describe actual TVS Motor Company operations.

## Repository

[Open this GitHub repository](https://github.com/prithivikanth/prithivikanth-TVS-Motor-Manufacturing-Quality-Analytics)

---
Maintainer: Prithivi Kanth S
