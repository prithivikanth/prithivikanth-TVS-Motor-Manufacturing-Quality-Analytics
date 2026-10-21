# Project Documentation: TVS Motor Manufacturing Quality Analytics

**Author:** Prithivi Kanth S  
**Project type:** Data analytics portfolio project  
**Tools:** Excel, MySQL, Power BI, GitHub

> **Dataset disclaimer:** The project uses synthetic practice data. It is not official TVS Motor Company data. Findings must not be presented as actual company performance.

## 1. Project Overview

This project demonstrates an analytics workflow for manufacturing production and quality data. It uses a raw Excel dataset, cleaned CSV files, SQL scripts and a Power BI report to explore production output, defects, downtime and rework.

## 2. Project Objectives

- Review production and defect data.
- Compare quality indicators across plants, machines, products and shifts.
- Examine defect categories and recorded root causes.
- Explore downtime and rework.
- Validate imported data and run SQL analysis.
- Present metrics and comparisons in a Power BI report.

## 3. Repository Guide

Open the [TVs_Poject folder](TVs_Poject/).

| Folder or file | Purpose |
|---|---|
| [Raw Dataset](TVs_Poject/Raw%20Dataset/) | Original Excel practice dataset |
| [Cleaned Dataset](TVs_Poject/Cleaned%20Dataset/) | CSV files for plants, machines, products, production and defects |
| [SQL](TVs_Poject/SQL/) | SQL scripts for table creation, data insertion, import checks and analysis |
| [PowerBI](TVs_Poject/PowerBI/) | Power BI Desktop report file |
| [Screenshots](TVs_Poject/Screenshots/) | Supporting screenshots, grouped by Power BI and SQL |
| [Detailed project README](TVs_Poject/README_TVS_Project.md) | Project summary, analytical questions, methodology and limitations |

## 4. Tools Required

- Microsoft Excel or a compatible spreadsheet application to inspect the workbook.
- MySQL 8 and MySQL Workbench to execute the SQL scripts.
- Power BI Desktop to open the `.pbix` report.
- A web browser to view the repository and documentation.

## 5. Recommended Workflow

### Step 1 — Review the source data

Open the [raw dataset folder](TVs_Poject/Raw%20Dataset/) and inspect `TVS_Manufacturing_Analytics_Raw_Dataset.xlsx`. Treat it as practice data, not official company information.

### Step 2 — Review the cleaned data

Open the [Cleaned Dataset folder](TVs_Poject/Cleaned%20Dataset/). The available CSV files include:

- `plants.csv`
- `machines.csv`
- `products.csv`
- `production.csv`
- `defects.csv`

Review column names, data types, missing values and record counts before using these files.

### Step 3 — Run the SQL scripts in order

Open the [SQL folder](TVs_Poject/SQL/) in MySQL Workbench. Review each script before executing it, and ensure you are using the intended practice database.

1. [`01_create_tables.sql`](TVs_Poject/SQL/01_create_tables.sql) — creates the database tables.
2. [`02_insert_data.sql`](TVs_Poject/SQL/02_insert_data.sql) — inserts the project data.
3. [`03_verify_import.sql`](TVs_Poject/SQL/03_verify_import.sql) — checks the imported data.
4. [`04_analysis_queries.sql`](TVs_Poject/SQL/04_analysis_queries.sql) — runs analytical queries.

**Important:** Check the database name and script statements first. Do not run scripts blindly against a database containing important data. The insert script may take time because it is relatively large.

### Step 4 — Open the Power BI report

1. Download or open [`TVS_Manufacturing_Dashboard.pbix`](TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix).
2. Open it with Power BI Desktop.
3. If Power BI requests a data source or file path, update it to the correct location on your computer.
4. Refresh the data if appropriate, then check that visuals and measures show expected values.

The report may depend on local data paths or model settings; those cannot be guaranteed to work unchanged on every computer.

### Step 5 — Review the results

Use the report and SQL outputs to examine production, defects, plants, machines, shifts, downtime and rework. Cross-check important KPI calculations against the source data before making conclusions.

## 6. Questions This Project Explores

- Which plants, machines, products or shifts show higher defect rates in the practice dataset?
- Which defect categories and recorded root causes occur most often?
- How do production and quality measures vary over time?
- Where is downtime concentrated?
- How much recorded defect activity involves rework?

These are analytical questions, not proof of operational issues at TVS Motor Company.

## 7. Data and Interpretation Notes

- The data is synthetic and should be described as simulated or practice data.
- A pattern or correlation does not prove that one factor caused another.
- KPI definitions, exclusions, relationships and filters affect the results.
- Confirm data quality and calculations before quoting any figures.

## 8. Suggested Presentation Order

For a project review or interview:

1. Explain the business problem and project objectives.
2. Show the raw and cleaned datasets.
3. Explain the SQL workflow and a few meaningful queries.
4. Demonstrate the Power BI report and its main measures.
5. Present observations supported by the data.
6. Explain limitations and what you would improve next.

Be clear that this is a portfolio exercise using synthetic data. Do not claim that it uses confidential or real TVS Motor Company production records.

## 9. Project Links

- [Main GitHub repository](https://github.com/prithivikanth/prithivikanth-TVS-Motor-Manufacturing-Quality-Analytics)
- [Project files](TVs_Poject/)
- [Power BI report](TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix)
- [SQL scripts](TVs_Poject/SQL/)
- [Detailed project README](TVs_Poject/README_TVS_Project.md)

---
**Maintainer:** Prithivi Kanth S
