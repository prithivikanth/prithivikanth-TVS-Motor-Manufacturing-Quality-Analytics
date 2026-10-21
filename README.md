# TVS Motor Manufacturing Quality, Defect and Production Analytics

**Author:** Prithivi Kanth S  
**Project type:** Data Analytics Portfolio Project  
**Tools:** Excel, MySQL 8, Power BI Desktop, GitHub

> **Dataset disclaimer:** This project uses synthetic practice data. It is not official TVS Motor Company data. The plants, production records, defects, root causes and findings must not be interpreted as actual company performance.

## 1. Project Overview

This project demonstrates an end-to-end manufacturing analytics workflow. It uses a raw Excel workbook, cleaned CSV datasets, MySQL scripts and a Power BI report to explore production output, defects, downtime and rework.

The purpose is to practise data cleaning, data validation, relational modelling, SQL analysis and dashboard development.

## 2. Objectives

- Analyse production output and recorded defect quantities.
- Compare quality indicators across plants, machines, products and shifts.
- Explore defect types and recorded root causes.
- Examine downtime and rework patterns.
- Validate imported data and analyse it with SQL.
- Present operational-style metrics in Power BI.
- Document the data fields so users can understand the dataset.

## 3. Repository Contents

All project files are organised under the `TVs_Poject/` directory.

| Location | Contents |
|---|---|
| [Raw Dataset](TVs_Poject/Raw%20Dataset/) | Original Excel practice dataset |
| [Cleaned Dataset](TVs_Poject/Cleaned%20Dataset/) | Cleaned CSVs for plants, machines, products, production and defects |
| [SQL](TVs_Poject/SQL/) | Table creation, data insertion, import verification and analysis scripts |
| [Power BI](TVs_Poject/PowerBI/) | Power BI Desktop report |
| [Screenshots](TVs_Poject/Screenshots/) | Power BI and SQL screenshots |

## 4. Tools and Requirements

- **Excel or compatible spreadsheet software:** inspect the workbook and data.
- **MySQL 8 and MySQL Workbench:** create tables, load records and run queries.
- **Power BI Desktop:** open and explore the `.pbix` report.
- **GitHub:** version control and project sharing.

## 5. How to Use the Project

### Step 1 — Inspect the raw dataset

Open [`TVS_Manufacturing_Analytics_Raw_Dataset.xlsx`](TVs_Poject/Raw%20Dataset/TVS_Manufacturing_Analytics_Raw_Dataset.xlsx). Review the worksheets, columns, date fields, quantities and missing values.

### Step 2 — Review the cleaned CSV files

Open the [Cleaned Dataset folder](TVs_Poject/Cleaned%20Dataset/). It contains:

- [`plants.csv`](TVs_Poject/Cleaned%20Dataset/plants.csv)
- [`machines.csv`](TVs_Poject/Cleaned%20Dataset/machines.csv)
- [`products.csv`](TVs_Poject/Cleaned%20Dataset/products.csv)
- [`production.csv`](TVs_Poject/Cleaned%20Dataset/production.csv)
- [`defects.csv`](TVs_Poject/Cleaned%20Dataset/defects.csv)

These CSV files are useful for inspecting the dimensions and fact records independently of the Power BI report.

### Step 3 — Run the SQL scripts in order

Open the [SQL folder](TVs_Poject/SQL/) in MySQL Workbench. Review each script and confirm the target database before executing.

1. [`01_create_tables.sql`](TVs_Poject/SQL/01_create_tables.sql) — creates the `tvs_manufacturing` database and tables.
2. [`02_insert_data.sql`](TVs_Poject/SQL/02_insert_data.sql) — inserts the project records.
3. [`03_verify_import.sql`](TVs_Poject/SQL/03_verify_import.sql) — checks the imported data.
4. [`04_analysis_queries.sql`](TVs_Poject/SQL/04_analysis_queries.sql) — runs analytical queries.

**Important safety note:** The table-creation script contains `DROP DATABASE IF EXISTS tvs_manufacturing`. Running it deletes and recreates that database. Back up anything important and confirm the database name before running it. The insert script is relatively large and may take time to execute.

### Step 4 — Open the Power BI report

1. Open [`TVS_Manufacturing_Dashboard.pbix`](TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix) using Power BI Desktop.
2. If prompted, update data-source paths to match the location of the files on your computer.
3. Refresh the data if appropriate.
4. Check the relationships, filters, measures and visual totals against the underlying datasets.

The report may rely on local paths or model settings, so it may need adjustment on another computer.

### Step 5 — Interpret results carefully

Explore production, defects, defect types, root causes, plants, machines, shifts, downtime and rework. Validate the KPI definitions and source records before reporting any figures. A relationship between two measures does not, by itself, establish causation.

## 6. Data Dictionary

The dictionary below describes the columns in the five cleaned CSV files. Field types are logical descriptions; the SQL schema defines the database types for the fact and dimension tables.

### 6.1 `plants.csv` — Plant dimension

| Column | Logical type | Description |
|---|---|---|
| `Plant_ID` | Text / key | Unique identifier for a plant; referenced by production and defect records. |
| `Plant_Name` | Text | Plant name represented in the synthetic dataset. |
| `State` | Text | State associated with the plant in the dataset. |

Example plant names in the practice data include Hosur, Mysuru and Nalagarh.

### 6.2 `machines.csv` — Machine dimension

| Column | Logical type | Description |
|---|---|---|
| `Machine_ID` | Text / key | Unique machine identifier; referenced by production and defect records. |
| `Machine_Name` | Text | Machine or work-centre name. |
| `Machine_Type` | Text | Broad machine/work-centre category, such as CNC, Assembly, Welding or Painting. |

The dataset includes an `Unknown` machine row to represent records where a machine was not identified.

### 6.3 `products.csv` — Product dimension

| Column | Logical type | Description |
|---|---|---|
| `Product_ID` | Text / key | Unique product identifier; referenced by production and defect records. |
| `Product_Name` | Text | Product or component name. |
| `Category` | Text | Broad product category, such as Motorcycle, Scooter, EV or Component. |

### 6.4 `production.csv` — Production fact table

Each row represents a production record for a date, plant, machine, product and shift.

| Column | Logical type | Description |
|---|---|---|
| `Production_ID` | Text / key | Unique identifier for the production record. |
| `Date` | Date | Date associated with the production record; formatted as `YYYY-MM-DD` in the CSV. |
| `Plant_ID` | Text / foreign key | Links the record to `plants.Plant_ID`. |
| `Machine_ID` | Text / foreign key | Links the record to `machines.Machine_ID`. |
| `Product_ID` | Text / foreign key | Links the record to `products.Product_ID`. |
| `Shift` | Text / category | Shift label, represented as A, B, C or `Unknown`. |
| `Production_Qty` | Integer / count | Recorded production quantity for the row. |
| `Defect_Qty` | Integer / count | Defect quantity recorded alongside the production row. Confirm its intended definition before combining it with the separate defects table. |
| `Downtime_Minutes` | Integer / minutes | Recorded downtime in minutes for the production row. |
| `Data_Quality_Flag` | Text / status | Data quality status. The SQL comments identify `OK` records as eligible for analysis under the stated project rules. |

### 6.5 `defects.csv` — Defect fact table

Each row represents a logged defect record. It has its own defect quantity and is separate from the production fact table.

| Column | Logical type | Description |
|---|---|---|
| `Defect_ID` | Text / key | Unique identifier for the defect record. |
| `Date` | Date | Date associated with the defect record; formatted as `YYYY-MM-DD` in the CSV. |
| `Plant_ID` | Text / foreign key | Links the record to `plants.Plant_ID`. |
| `Machine_ID` | Text / foreign key | Links the record to `machines.Machine_ID`. |
| `Product_ID` | Text / foreign key | Links the record to `products.Product_ID`. |
| `Defect_Type` | Text / category | Recorded defect category, such as Assembly Error, Surface Scratch, Alignment Issue or Dimension Out of Spec. |
| `Root_Cause` | Text / category | Recorded cause category, such as Material Issue, Process Variation, Machine Setting, Operator Error, Tool Wear or Maintenance Delay. This is a recorded label, not proof of a confirmed cause. |
| `Defect_Qty` | Integer / count | Quantity associated with this defect record. |
| `Rework_Required` | Text / Yes-No | Indicates whether rework is recorded as required (`Yes` or `No`). |
| `Data_Quality_Flag` | Text / status | Data quality status. The SQL schema comments mention `OK` and `Zero_Defect_Qty`; apply the documented analysis rules consistently. |

### 6.6 Key relationships

- `plants.Plant_ID` → `production.Plant_ID`
- `machines.Machine_ID` → `production.Machine_ID`
- `products.Product_ID` → `production.Product_ID`
- `plants.Plant_ID` → `defects.Plant_ID`
- `machines.Machine_ID` → `defects.Machine_ID`
- `products.Product_ID` → `defects.Product_ID`

The three dimension tables describe plants, machines and products. The production and defects tables are separate fact tables. Avoid directly joining production and defects on plant, machine, product and date without considering the grain of each table: doing so can multiply rows and inflate totals. Use appropriate aggregation or a deliberate data model.

### 6.7 KPI interpretation notes

- **Production quantity:** aggregate `Production_Qty` using the selected data-quality rules.
- **Production-table defect quantity:** `production.Defect_Qty` is a field in the production fact table.
- **Defect-table quantity:** `defects.Defect_Qty` is recorded separately in the defects fact table. Do not add these two fields together without confirming that their definitions and grains make this valid.
- **Defect rate:** define the numerator and denominator explicitly before calculating a percentage. A possible production-based measure is valid only if the quantities and exclusions are consistent.
- **Downtime:** `Downtime_Minutes` is recorded in minutes; verify whether it represents event-level or production-record-level downtime before summing.
- **Rework share:** specify whether the measure counts defect records or sums `Defect_Qty` for records where `Rework_Required = 'Yes'`. These answer different questions.
- **Data-quality flags:** apply consistent filters and document excluded records.

## 7. Business Questions

The project is designed to explore questions such as:

1. How do production quantities and defect measures vary by plant, machine, product and shift?
2. Which defect types are most common in the synthetic data?
3. Which root-cause labels appear most often?
4. How do defect measures and downtime vary over time?
5. What share of defect records or defect quantity is marked for rework?

Any conclusions should be supported by query results and the report, and should be described as findings from simulated data.

## 8. Data Quality and Limitations

- Data is synthetic practice data, not official TVS Motor Company data.
- Values and categories are illustrative and do not represent verified factory operations.
- Unknown categories should not be guessed or silently replaced with assumed values.
- Duplicate records, missing values, invalid quantities and date types should be checked.
- KPI results depend on data grain, relationships, filters and exclusion rules.
- Recorded root-cause categories do not prove causation.
- Confirm totals and formulas before presenting results in an interview or portfolio.

## 9. Suggested Project Walkthrough

For a portfolio presentation or interview:

1. Explain the business question and project goals.
2. Show the raw workbook and cleaned CSV files.
3. Describe the dimension and fact tables using the data dictionary.
4. Demonstrate the SQL import-validation and analysis scripts.
5. Open the Power BI report and explain its measures and visuals.
6. Share only findings that you have checked against the data.
7. State the synthetic-data limitation clearly and explain what you would improve next.

## 10. Project Links

- [Main GitHub repository](https://github.com/prithivikanth/prithivikanth-TVS-Motor-Manufacturing-Quality-Analytics)
- [Raw dataset](TVs_Poject/Raw%20Dataset/)
- [Cleaned datasets](TVs_Poject/Cleaned%20Dataset/)
- [SQL scripts](TVs_Poject/SQL/)
- [Power BI report](TVs_Poject/PowerBI/TVS_Manufacturing_Dashboard.pbix)
- [Screenshots](TVs_Poject/Screenshots/)
- [GitHub profile](https://github.com/prithivikanth)

---
**Maintainer:** Prithivi Kanth S
