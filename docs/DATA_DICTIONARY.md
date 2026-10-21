# Data Dictionary — TVS Manufacturing Analytics

This document defines the fields in **all five cleaned CSV datasets** used by this portfolio project.

> **Dataset disclaimer:** These are synthetic practice datasets, not official TVS Motor Company data. Names, quantities, categories and recorded causes are illustrative.

## Dataset inventory

| CSV file | Role | Expected row count in SQL verification script |
|---|---|---:|
| [plants.csv](../TVs_Poject/Cleaned%20Dataset/plants.csv) | Dimension / reference | 3 |
| [machines.csv](../TVs_Poject/Cleaned%20Dataset/machines.csv) | Dimension / reference | 11 |
| [products.csv](../TVs_Poject/Cleaned%20Dataset/products.csv) | Dimension / reference | 6 |
| [production.csv](../TVs_Poject/Cleaned%20Dataset/production.csv) | Fact table | 7,940 |
| [defects.csv](../TVs_Poject/Cleaned%20Dataset/defects.csv) | Fact table | 3,960 |

Row counts above are the expected counts documented in the project's SQL validation script. Run the validation query to confirm the actual counts in your database.

## 1. plants.csv — Plant dimension

**Purpose:** Stores descriptive information about each plant. Plant IDs are referenced by both fact tables.

| Column | Logical data type | Key / role | Description |
|---|---|---|---|
| `Plant_ID` | Text (`VARCHAR(10)` in SQL) | Primary key | Unique identifier for a plant. |
| `Plant_Name` | Text (`VARCHAR(50)` in SQL) | Attribute | Plant name represented in the synthetic data. |
| `State` | Text (`VARCHAR(50)` in SQL) | Attribute | State associated with the plant in the dataset. |

**Data checks:** `Plant_ID` should be unique and non-empty. Every plant ID in the fact tables should match a row in this table.

## 2. machines.csv — Machine dimension

**Purpose:** Stores machine/work-centre descriptions. Both fact tables reference the machine ID.

| Column | Logical data type | Key / role | Description |
|---|---|---|---|
| `Machine_ID` | Text (`VARCHAR(10)` in SQL) | Primary key | Unique machine identifier. Includes an `Unknown` row for records where the machine was not identified. |
| `Machine_Name` | Text (`VARCHAR(50)` in SQL) | Attribute | Name assigned to the machine or work centre. |
| `Machine_Type` | Text (`VARCHAR(30)` in SQL) | Attribute | Broad machine/work-centre category. |

**Data checks:** Confirm machine IDs are unique and every machine ID in both fact tables matches this dimension. Do not interpret `Unknown` as a specific real machine.

## 3. products.csv — Product dimension

**Purpose:** Stores descriptive information about products or components.

| Column | Logical data type | Key / role | Description |
|---|---|---|---|
| `Product_ID` | Text (`VARCHAR(10)` in SQL) | Primary key | Unique product identifier. |
| `Product_Name` | Text (`VARCHAR(50)` in SQL) | Attribute | Product or component name represented in the dataset. |
| `Category` | Text (`VARCHAR(30)` in SQL) | Attribute | Broad product category used for grouping and comparison. |

**Data checks:** Confirm product IDs are unique and all product IDs in both fact tables match this dimension.

## 4. production.csv — Production fact table

**Grain:** One production record, identified by `Production_ID`, for a date, plant, machine, product and shift.

| Column | Logical data type | Key / role | Description |
|---|---|---|---|
| `Production_ID` | Text (`VARCHAR(10)` in SQL) | Primary key | Unique ID for the production record. |
| `Date` | Date (`DATE` in SQL) | Date dimension / filter | Date associated with the production record. Expected project date range: 2025-01-01 through 2025-12-31. |
| `Plant_ID` | Text (`VARCHAR(10)` in SQL) | Foreign key | Links to `plants.Plant_ID`. |
| `Machine_ID` | Text (`VARCHAR(10)` in SQL) | Foreign key | Links to `machines.Machine_ID`. |
| `Product_ID` | Text (`VARCHAR(10)` in SQL) | Foreign key | Links to `products.Product_ID`. |
| `Shift` | Text (`VARCHAR(10)` in SQL) | Category | Shift label: A, B, C or `Unknown`. |
| `Production_Qty` | Integer (`INT` in SQL) | Measure | Production quantity recorded for the row. |
| `Defect_Qty` | Integer (`INT` in SQL) | Measure | Defect quantity recorded in the production table. Keep separate from `defects.Defect_Qty` unless definitions and grain have been reconciled. |
| `Downtime_Minutes` | Integer (`INT` in SQL) | Measure | Downtime recorded in minutes for the production record. Confirm the measure's grain before summing. |
| `Data_Quality_Flag` | Text (`VARCHAR(25)` in SQL) | Quality status | Row quality classification. The validation script treats `OK` rows as the basis for its core production KPIs. |

**Data checks and interpretation**

- `Production_ID` should be unique.
- Check production quantities and downtime for missing, negative or implausible values.
- Check the count of each `Data_Quality_Flag` before applying filters.
- The SQL validation script expects 7,940 total rows, of which 7,916 have `Data_Quality_Flag = 'OK'` and 24 are flagged.
- The SQL validation script lists expected `OK`-row KPIs: 3,626,137 production units, 138,990 production-table defect units, a 3.83% production-table defect rate and average downtime of 34.80 minutes. Treat these as validation targets in the synthetic project and confirm by executing the script.

## 5. defects.csv — Defect fact table

**Grain:** One defect log record, identified by `Defect_ID`. This is a separate fact table from production.

| Column | Logical data type | Key / role | Description |
|---|---|---|---|
| `Defect_ID` | Text (`VARCHAR(10)` in SQL) | Primary key | Unique ID for the defect log record. |
| `Date` | Date (`DATE` in SQL) | Date dimension / filter | Date associated with the defect record. Expected project date range: 2025-01-01 through 2025-12-31. |
| `Plant_ID` | Text (`VARCHAR(10)` in SQL) | Foreign key | Links to `plants.Plant_ID`. |
| `Machine_ID` | Text (`VARCHAR(10)` in SQL) | Foreign key | Links to `machines.Machine_ID`. |
| `Product_ID` | Text (`VARCHAR(10)` in SQL) | Foreign key | Links to `products.Product_ID`. |
| `Defect_Type` | Text (`VARCHAR(30)` in SQL) | Category | Category assigned to the defect record. |
| `Root_Cause` | Text (`VARCHAR(30)` in SQL) | Category | Recorded root-cause label. It is not, by itself, proof of a confirmed cause. |
| `Defect_Qty` | Integer (`INT` in SQL) | Measure | Quantity associated with the defect log record. |
| `Rework_Required` | Text (`VARCHAR(3)` in SQL) | Yes/No category | Indicates whether rework is recorded as required: `Yes` or `No`. |
| `Data_Quality_Flag` | Text (`VARCHAR(25)` in SQL) | Quality status | Quality classification. SQL comments identify `OK` and `Zero_Defect_Qty` categories. |

**Data checks and interpretation**

- `Defect_ID` should be unique.
- Confirm `Defect_Qty` is non-negative and review zero-quantity rows.
- Check whether `Rework_Required` contains only expected values.
- Check counts by `Data_Quality_Flag` before choosing an analysis filter.
- The SQL validation script expects 3,960 total defect rows, with 3,954 rows flagged `OK` and six flagged `Zero_Defect_Qty`.
- The SQL script documents 9,285 total defect units in `OK` rows. Verify by running the validation query.

## 6. Relationship map

| From | To | Relationship meaning |
|---|---|---|
| `plants.Plant_ID` | `production.Plant_ID` | One plant can have many production records. |
| `machines.Machine_ID` | `production.Machine_ID` | One machine can have many production records. |
| `products.Product_ID` | `production.Product_ID` | One product can appear in many production records. |
| `plants.Plant_ID` | `defects.Plant_ID` | One plant can have many defect records. |
| `machines.Machine_ID` | `defects.Machine_ID` | One machine can appear in many defect records. |
| `products.Product_ID` | `defects.Product_ID` | One product can appear in many defect records. |

The three dimension tables describe entities; production and defects are separate fact tables. Use one-to-many relationships from dimensions to facts. Avoid directly joining both fact tables at row level using only date and dimension IDs: multiple matching records can multiply quantities and produce incorrect totals. Aggregate each fact table to a compatible grain before combining measures.

## 7. KPI and field usage guide

| Measure / field | Recommended interpretation | Caution |
|---|---|---|
| `Production_Qty` | Sum production units under the documented quality filter. | Validate that units and row grain are consistent. |
| `production.Defect_Qty` | Defect quantity recorded with production records. | This is not automatically the same as defect-log quantity. |
| `defects.Defect_Qty` | Quantity logged in the separate defect table. | Apply the intended quality-flag filter. |
| Defect rate | Explicitly defined defect quantity ÷ production quantity × 100. | State which defect quantity field is the numerator. |
| `Downtime_Minutes` | Downtime in minutes. | Check whether values represent events or production records before summing. |
| Rework record count | Count rows where `Rework_Required = 'Yes'`. | This counts records, not units. |
| Rework defect quantity | Sum `Defect_Qty` for rows marked `Yes`. | This counts units, not records. |
| `Data_Quality_Flag` | Use to include/exclude records under a documented rule. | Exclusions change the KPI denominator and totals. |

## 8. Raw Excel workbook

The repository also contains [`TVS_Manufacturing_Analytics_Raw_Dataset.xlsx`](../TVs_Poject/Raw%20Dataset/TVS_Manufacturing_Analytics_Raw_Dataset.xlsx). It is the source workbook for inspection and should be reviewed alongside the cleaned CSVs. This dictionary describes the **five cleaned CSV files**, which are the documented relational tables in the SQL schema. If the workbook contains additional worksheets or columns not represented in those CSVs, document them separately before claiming this dictionary covers every raw-workbook field.

## 9. Related files

- [Project documentation](PROJECT_DOCUMENTATION.md)
- [Main repository README](../README.md)
- [Cleaned Dataset folder](../TVs_Poject/Cleaned%20Dataset/)
- [SQL schema](../TVs_Poject/SQL/01_create_tables.sql)
- [SQL import validation](../TVs_Poject/SQL/03_verify_import.sql)

---
Maintainer: Prithivi Kanth S
