# TVS Motor Manufacturing Quality, Defect and Production Analytics

**Prepared by:** Prithivi Kanth S  
**Project type:** Data Analytics / Business Intelligence portfolio project  
**Tools:** Microsoft Excel, CSV, MySQL 8, MySQL Workbench, Power Query, Power BI Desktop, GitHub

> **Data disclaimer:** This is an educational portfolio project using synthetic practice data. It is not official TVS Motor Company data and must not be presented as verified company performance or as an officially affiliated project.

## 1. Executive Summary

This project demonstrates an end-to-end analytics workflow for manufacturing-style production and quality data. The workflow starts with a raw Excel workbook and five cleaned CSV datasets, stores related records in MySQL, validates the import with SQL, performs analytical queries, and presents selected measures in a Power BI dashboard.

The analysis explores production quantities, recorded defect quantities, defect categories, root-cause labels, downtime and rework. The aim is to demonstrate data preparation, relational modelling, SQL analysis, KPI interpretation and dashboard storytelling.

## 2. Problem Statement

Manufacturing-style operations generate records across plants, machines, products, production shifts and defect logs. If these records are not organised and validated consistently, it becomes harder to compare performance, identify patterns and decide which areas deserve further investigation.

This project simulates that analytical challenge by organising production and quality data into related dimension and fact tables, using SQL for validation and analysis, and using Power BI to present results.

## 3. Project Objectives

- Organise plant, machine and product reference data.
- Analyse production quantities and production-table defect quantities.
- Explore defect categories and recorded root-cause labels.
- Examine downtime and rework indicators.
- Validate data imports, row counts and data-quality flags.
- Create a relational data model for reporting.
- Build an interactive Power BI report for manufacturing-style KPIs.
- Document datasets, measures, assumptions and limitations.

## 4. Tools and Technologies

| Tool | Purpose |
|---|---|
| Microsoft Excel | Inspect the source workbook and tabular records |
| CSV | Exchange structured data between preparation, SQL and reporting |
| MySQL 8 | Store related tables and execute queries |
| MySQL Workbench | Run schema creation, data loading, verification and analysis scripts |
| Power Query | Prepare and transform data for reporting |
| Power BI Desktop | Model the data and explore measures with report visuals |
| DAX | Define calculated measures where used in the report |
| GitHub | Version control, project sharing and documentation |

## 5. Repository Structure

The project files are organised as follows. Folder names reflect the existing repository and are retained to avoid breaking current file links.

| Path | Contents |
|---|---|
| [TVs_Poject/Raw Dataset](../TVs_Poject/Raw%20Dataset/) | Original Excel practice workbook |
| [TVs_Poject/Cleaned Dataset](../TVs_Poject/Cleaned%20Dataset/) | Five cleaned CSV datasets |
| [TVs_Poject/SQL](../TVs_Poject/SQL/) | Database setup, data insertion, import verification and analysis queries |
| [TVs_Poject/PowerBI](../TVs_Poject/PowerBI/) | Power BI Desktop report |
| [TVs_Poject/Screenshots](../TVs_Poject/Screenshots/) | Power BI and SQL screenshots |
| [Data Dictionary](DATA_DICTIONARY.md) | Field-level definitions for every cleaned CSV |
| [Presentation Guide](PRESENTATION_GUIDE.md) | Suggested presentation order and speaking notes |

## 6. Dataset Overview

The cleaned relational dataset contains five CSV files:

| Dataset | Role | Purpose |
|---|---|---|
| plants.csv | Dimension | Plant identifiers and location attributes |
| machines.csv | Dimension | Machine identifiers and machine categories |
| products.csv | Dimension | Product identifiers and product categories |
| production.csv | Fact | Production records, shift, production quantity, production-table defect quantity, downtime and quality flag |
| defects.csv | Fact | Defect records, defect type, recorded root-cause label, defect quantity, rework flag and quality flag |

The SQL import verification script documents these expected row counts: 3 plants, 11 machines, 6 products, 7,940 production records and 3,960 defect records. Run the verification script to confirm the actual imported counts.

See the [Data Dictionary](DATA_DICTIONARY.md) for every field, logical type, key role and data-quality note.

## 7. End-to-End Workflow

1. **Inspect source data:** review the raw Excel workbook and identify the worksheets and columns.
2. **Review cleaned CSVs:** check column names, dates, identifiers, quantities, missing values and unknown categories.
3. **Create database tables:** run the table-creation SQL script in MySQL Workbench.
4. **Load records:** execute the data-insertion script and check for errors.
5. **Validate imports:** run row-count, data-quality flag, date-range and KPI verification queries.
6. **Analyse with SQL:** run grouped summaries and analytical queries for production and quality questions.
7. **Model in Power BI:** check relationships, filters, measures and data-source paths.
8. **Present findings:** use verified query outputs and dashboard results; explain limitations.

### Important database safety note

The SQL script 01_create_tables.sql contains a DROP DATABASE IF EXISTS statement for the tvs_manufacturing database. Running it deletes and recreates that database. Confirm the target database and back up any important data before executing the script.

## 8. Data Model

The project uses three dimension tables and two fact tables.

- plants.Plant_ID relates to production.Plant_ID and defects.Plant_ID.
- machines.Machine_ID relates to production.Machine_ID and defects.Machine_ID.
- products.Product_ID relates to production.Product_ID and defects.Product_ID.

The dimension tables describe the plant, machine and product. The production and defects tables have different grains and independent record IDs. Avoid directly joining the two fact tables at row level using only date and dimension IDs, because multiple matching rows can multiply records and inflate totals. Aggregate to a compatible grain before combining measures.

## 9. Business Questions

The project is designed to explore questions such as:

- How does production quantity vary by plant, machine, product and shift?
- Which defect categories appear most frequently in the practice data?
- Which recorded root-cause labels occur most often?
- How do production-table defect quantities and defect-log quantities vary over time?
- How is recorded downtime distributed across plants and machines?
- What share of defect records is marked as requiring rework?
- How do results change when records with non-OK quality flags are excluded?

Only present answers that you have checked against the SQL outputs and Power BI report.

## 10. KPI Definitions and Interpretation

- **Total production units:** sum Production_Qty using the documented quality filter.
- **Production-table defect quantity:** sum production.Defect_Qty.
- **Defect-log quantity:** sum defects.Defect_Qty under the selected quality filter. This is separate from the production-table defect quantity.
- **Defect rate:** define the numerator and denominator explicitly. The SQL validation script calculates the production-table defect rate using production-table defect quantity divided by production quantity for rows flagged OK.
- **Downtime:** Downtime_Minutes is measured in minutes; confirm the field's grain before summing.
- **Rework:** distinguish the number of defect records marked Yes from the total Defect_Qty on those records.
- **Data-quality flags:** document which records are included or excluded and how this affects the totals.

The SQL verification script documents the following expected production KPIs for OK records: 7,916 rows, 3,626,137 production units, 138,990 production-table defect units, 3.83% defect rate and 34.80 average downtime minutes. These are expected validation targets for synthetic data, not actual company performance. Confirm the results in MySQL before using them in a presentation.

## 11. Data Quality Checks

Recommended checks include:

- Compare imported row counts with expected counts in the verification script.
- Check primary-key uniqueness and foreign-key matching.
- Validate date ranges and date types.
- Review missing, duplicate, negative or implausible quantities.
- Inspect Unknown categories rather than guessing their meaning.
- Review Data_Quality_Flag distributions and apply filters consistently.
- Confirm joins do not multiply fact records.
- Reconcile SQL totals with Power BI measures.

## 12. Power BI Dashboard

Open the [Power BI report](../TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix) in Power BI Desktop. If prompted, update the data-source paths to match the files or database on your computer, then refresh the report and validate the measures.

The repository contains screenshots of the available dashboard pages:

- [Page 1 — Overview](../TVs_Poject/Screenshots/Power%20BI%20Screenshot/dashboard_page1_overview.png)
- [Page 2 — Quality](../TVs_Poject/Screenshots/Power%20BI%20Screenshot/dashboard_page2_quality.png)
- [Page 3 — Machines](../TVs_Poject/Screenshots/Power%20BI%20Screenshot/dashboard_page3_machines.png)

Use the actual report and screenshots to explain the visuals. Do not claim a visual or measure exists unless you can show it in the PBIX file.

## 13. Limitations

- The dataset is synthetic practice data, not official TVS Motor Company data.
- Root-cause values are recorded categories and do not prove a confirmed cause.
- Correlation or group differences do not prove causation.
- Results depend on data grain, quality filters, relationships and KPI definitions.
- The Power BI file may require data-source path updates on another computer.

## 14. Suggested Presentation Flow

1. Introduce the project and the simulated manufacturing problem.
2. Explain the project objectives and tools.
3. Show the five datasets and describe the dimension/fact table design.
4. Demonstrate the SQL workflow: table creation, import verification and one or two analysis queries.
5. Open the Power BI report and explain the visuals and measures that are actually present.
6. Share only validated findings and explain how the figures were calculated.
7. Close with the synthetic-data limitation and possible next improvements.

## Project Links

- [Main README](../README.md)
- [Data Dictionary](DATA_DICTIONARY.md)
- [Presentation Guide](PRESENTATION_GUIDE.md)
- [Cleaned CSV datasets](../TVs_Poject/Cleaned%20Dataset/)
- [SQL scripts](../TVs_Poject/SQL/)
- [Power BI report](../TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix)

---
Maintainer: Prithivi Kanth S
