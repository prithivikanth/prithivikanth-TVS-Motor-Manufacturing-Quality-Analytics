# Project Documentation — TVS Motor Manufacturing Quality, Defect and Production Analytics

**Prepared by:** Prithivi Kanth S  
**Project category:** Data Analytics Portfolio Project  
**Tools:** Microsoft Excel, MySQL 8 / MySQL Workbench, Power BI Desktop, GitHub

> **Important data disclaimer:** This project uses synthetic practice data. It is not official TVS Motor Company data, and its values must not be presented as the company's actual manufacturing results.

## 1. Executive Summary

This project demonstrates how manufacturing-style data can be prepared, checked, queried and visualised to understand production output and quality indicators. The workflow combines a raw Excel workbook, five cleaned CSV files, MySQL scripts and a Power BI report.

The analysis is designed to explore production quantity, defects, defect categories, recorded root-cause labels, downtime and rework. The project is a portfolio demonstration of an analytics workflow, not an audit of a real factory.

## 2. Business Problem

Manufacturing teams need a clear view of production output and quality indicators to spot patterns and decide where further investigation may be useful. Data can be spread across production logs, defect logs and reference tables, making it difficult to compare results consistently.

This project simulates that challenge and demonstrates how data can be organised into related tables, analysed with SQL and presented in Power BI.

## 3. Project Objectives

- Organise plant, machine and product reference data.
- Analyse production quantities and production-table defect quantities.
- Explore defect categories and recorded root-cause labels.
- Examine downtime and rework indicators.
- Validate imported records and data-quality flags.
- Create a Power BI view of manufacturing-style metrics.
- Document the datasets and explain the limitations of the results.

## 4. Tools Used

| Tool | Role in the project |
|---|---|
| Microsoft Excel | Inspect the original workbook and review tabular data |
| CSV files | Provide structured data for import and analysis |
| MySQL 8 | Store relational tables and run analytical SQL queries |
| MySQL Workbench | Execute table creation, data loading, validation and analysis scripts |
| Power BI Desktop | Model the data and explore KPIs through report visuals |
| GitHub | Store project files, SQL scripts and documentation |

## 5. Repository Structure

Open the [main project repository](https://github.com/prithivikanth/prithivikanth-TVS-Motor-Manufacturing-Quality-Analytics).

| Path | Purpose |
|---|---|
| [Raw Dataset](../TVs_Poject/Raw%20Dataset/) | Original Excel workbook |
| [Cleaned Dataset](../TVs_Poject/Cleaned%20Dataset/) | Five CSV files used in the project |
| [SQL scripts](../TVs_Poject/SQL/) | Database setup, data insertion, import checks and analysis queries |
| [Power BI report folder](../TVs_Poject/PowerBI/) | Power BI report file |
| [Screenshots](../TVs_Poject/Screenshots/) | Supporting SQL and Power BI screenshots |
| [Data Dictionary](DATA_DICTIONARY.md) | Definitions for every column in the five CSV files |

## 6. Dataset Overview

The cleaned dataset consists of five CSV files:

| CSV file | Table role | Purpose |
|---|---|---|
| `plants.csv` | Dimension | Plant identifiers and location attributes |
| `machines.csv` | Dimension | Machine identifiers and machine categories |
| `products.csv` | Dimension | Product identifiers and categories |
| `production.csv` | Fact table | Production records, quantities, shift and downtime |
| `defects.csv` | Fact table | Logged defect categories, quantities, root-cause labels and rework flag |

The SQL verification script documents expected table sizes of 3 plants, 11 machines, 6 products, 7,940 production rows and 3,960 defect rows. Confirm the actual counts after loading; these are expected counts documented in the project SQL, not independently measured business statistics.

See the [full data dictionary](DATA_DICTIONARY.md) for field names, logical data types, meanings, keys and relationship notes.

## 7. End-to-End Workflow

### Step 1 — Inspect the raw workbook

Open [`TVS_Manufacturing_Analytics_Raw_Dataset.xlsx`](../TVs_Poject/Raw%20Dataset/TVS_Manufacturing_Analytics_Raw_Dataset.xlsx). Review its worksheets and understand the fields before analysing the cleaned files.

### Step 2 — Review the cleaned CSVs

Open the [Cleaned Dataset folder](../TVs_Poject/Cleaned%20Dataset/). Review all five files and confirm column names, data types, dates, identifiers, missing or unknown categories, duplicate IDs and quantity values.

### Step 3 — Create the MySQL schema

Run [`01_create_tables.sql`](../TVs_Poject/SQL/01_create_tables.sql) in MySQL Workbench.

**Critical warning:** This script contains `DROP DATABASE IF EXISTS tvs_manufacturing`. Running it deletes and recreates a database with that name. Verify the target database and back up any important data before execution.

### Step 4 — Load the records

Run [`02_insert_data.sql`](../TVs_Poject/SQL/02_insert_data.sql). Wait for execution to finish and check for errors before moving on.

### Step 5 — Validate the import

Run [`03_verify_import.sql`](../TVs_Poject/SQL/03_verify_import.sql). Compare actual row counts, data-quality flag counts, date ranges and key KPI outputs with the expected values documented in the script. If results differ, investigate before presenting the dashboard figures.

### Step 6 — Run analysis queries

Run [`04_analysis_queries.sql`](../TVs_Poject/SQL/04_analysis_queries.sql). Read the query and its grouping/filter logic before interpreting the output. Use the results to answer the business questions listed below.

### Step 7 — Open the Power BI report

Open [`TVS_Manufacturing_Dashboard.pbix`](../TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix) in Power BI Desktop. If prompted, update data-source paths and refresh the report. Check relationships, filters, measures and totals against the underlying tables.

## 8. Data Model and Relationships

The reference (dimension) tables are `plants`, `machines` and `products`. They provide descriptive details for the two fact tables.

- `plants.Plant_ID` → `production.Plant_ID`
- `machines.Machine_ID` → `production.Machine_ID`
- `products.Product_ID` → `production.Product_ID`
- `plants.Plant_ID` → `defects.Plant_ID`
- `machines.Machine_ID` → `defects.Machine_ID`
- `products.Product_ID` → `defects.Product_ID`

The production and defects tables have different grains and independent record IDs. Do not directly join both fact tables on date, plant, machine and product without first aggregating to a compatible grain; otherwise, matching records can multiply and inflate totals.

## 9. Example Business Questions

1. How does production quantity vary by plant, machine, product and shift?
2. Which defect categories appear most frequently in the practice dataset?
3. Which recorded root-cause labels appear most often?
4. How do production-table defect quantities and defect-log quantities vary over time?
5. How is recorded downtime distributed across machines or plants?
6. What proportion of defect records is marked as requiring rework?
7. How do results change when records with non-`OK` quality flags are excluded?

These questions guide exploration. Report an answer only after checking the actual SQL output and Power BI calculations.

## 10. KPI Definitions and Interpretation

- **Total production units:** sum `production.Production_Qty` using the agreed data-quality filter.
- **Production-table defect quantity:** sum `production.Defect_Qty`; this belongs to the production fact table.
- **Defect-log quantity:** sum `defects.Defect_Qty` under the chosen quality filter; this belongs to the separate defect fact table.
- **Defect rate:** state the numerator and denominator explicitly. The SQL validation script calculates a production-table rate as total production-table defect quantity divided by production quantity for rows flagged `OK`. Do not silently substitute the defect-log total.
- **Downtime:** `Downtime_Minutes` is expressed in minutes. Verify the field's grain before summing it.
- **Rework:** distinguish the count of rows where `Rework_Required = 'Yes'` from the sum of defect quantity on those rows.
- **Data-quality exclusions:** document whether analysis includes only `OK` rows and explain the impact of excluding flagged records.

Always reconcile headline KPIs with the verification SQL and the Power BI measures before presenting them.

## 11. Data Quality Checks

Recommended checks include:

- Confirm row counts after import.
- Check that dimension IDs are unique and fact IDs are not duplicated.
- Verify that all foreign-key IDs map to a dimension row.
- Validate date ranges and date data types.
- Check quantities for nulls, negatives or implausible values.
- Review `Unknown` categories instead of assuming their actual values.
- Inspect `Data_Quality_Flag` counts and apply consistent filters.
- Confirm that joins do not multiply fact rows.
- Reconcile Power BI totals with SQL totals.

## 12. Limitations

- All records are synthetic and do not represent verified TVS Motor Company operations.
- Recorded root-cause labels are categories in the dataset, not evidence that a cause was independently confirmed.
- Correlation or a difference between groups does not prove causation.
- Results depend on data grain, filters, relationships and KPI definitions.
- The Power BI file may require data-source path changes on another computer.

## 13. Presentation Flow

For a short classroom or interview presentation, use this order:

1. **Introduction:** name the project and explain the simulated manufacturing problem.
2. **Objective:** describe the production and quality questions being explored.
3. **Tools:** explain the roles of Excel, CSV, MySQL and Power BI.
4. **Data model:** introduce the three dimension tables and two fact tables.
5. **SQL workflow:** show table creation, import validation and one or two analysis queries.
6. **Dashboard:** demonstrate the actual Power BI report and explain its main visuals.
7. **Findings:** present only verified findings from your own query and dashboard outputs.
8. **Limitations and conclusion:** clearly state that the dataset is synthetic and describe one or two possible improvements.

Do not invent findings or claim improvements in actual TVS factory performance. If asked about a number, explain its definition, filter and source.

## 14. Quick Links

- [Main README](../README.md)
- [Data Dictionary](DATA_DICTIONARY.md)
- [Cleaned CSV files](../TVs_Poject/Cleaned%20Dataset/)
- [SQL scripts](../TVs_Poject/SQL/)
- [Power BI report](../TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix)

---
Maintainer: Prithivi Kanth S
