# Data Dictionary — TVS Manufacturing Analytics

This dictionary documents **all five cleaned CSV files** used in the project. Field types below are logical descriptions, with MySQL types taken from the schema where available.

> **Data disclaimer:** These are synthetic practice datasets. They are not official TVS Motor Company records.

## Dataset inventory

| CSV file | Table role | Expected rows from SQL verification script |
|---|---|---:|
| [plants.csv](../TVs_Poject/Cleaned%20Dataset/plants.csv) | Dimension | 3 |
| [machines.csv](../TVs_Poject/Cleaned%20Dataset/machines.csv) | Dimension | 11 |
| [products.csv](../TVs_Poject/Cleaned%20Dataset/products.csv) | Dimension | 6 |
| [production.csv](../TVs_Poject/Cleaned%20Dataset/production.csv) | Fact | 7,940 |
| [defects.csv](../TVs_Poject/Cleaned%20Dataset/defects.csv) | Fact | 3,960 |

These counts are expected values in the SQL verification script. Execute it to confirm the current database.

## 1. plants.csv — Plant dimension

| Column | Logical / SQL type | Key role | Definition |
|---|---|---|---|
| Plant_ID | Text / VARCHAR(10) | Primary key | Unique plant identifier. |
| Plant_Name | Text / VARCHAR(50) | Attribute | Plant name in the synthetic dataset. |
| State | Text / VARCHAR(50) | Attribute | State associated with the plant. |

**Validation:** Plant_ID should be unique and non-empty. Fact-table plant IDs should match this dimension.

## 2. machines.csv — Machine dimension

| Column | Logical / SQL type | Key role | Definition |
|---|---|---|---|
| Machine_ID | Text / VARCHAR(10) | Primary key | Unique machine identifier. Includes an Unknown row for records where the machine is not identified. |
| Machine_Name | Text / VARCHAR(50) | Attribute | Name assigned to the machine or work centre. |
| Machine_Type | Text / VARCHAR(30) | Attribute | Broad machine/work-centre category, such as CNC, Assembly, Welding or Painting. |

**Validation:** Machine_ID should be unique. Do not interpret Unknown as a specific real machine.

## 3. products.csv — Product dimension

| Column | Logical / SQL type | Key role | Definition |
|---|---|---|---|
| Product_ID | Text / VARCHAR(10) | Primary key | Unique product identifier. |
| Product_Name | Text / VARCHAR(50) | Attribute | Product or component name in the synthetic dataset. |
| Category | Text / VARCHAR(30) | Attribute | Broad product category, such as Motorcycle, Scooter, EV or Component. |

**Validation:** Product_ID should be unique and all fact-table product IDs should match this dimension.

## 4. production.csv — Production fact table

**Grain:** One production record identified by Production_ID for a date, plant, machine, product and shift.

| Column | Logical / SQL type | Key role | Definition |
|---|---|---|---|
| Production_ID | Text / VARCHAR(10) | Primary key | Unique production-record identifier. |
| Date | Date / DATE | Date field | Date associated with the production record; expected project range is 2025-01-01 to 2025-12-31. |
| Plant_ID | Text / VARCHAR(10) | Foreign key | Links to plants.Plant_ID. |
| Machine_ID | Text / VARCHAR(10) | Foreign key | Links to machines.Machine_ID. |
| Product_ID | Text / VARCHAR(10) | Foreign key | Links to products.Product_ID. |
| Shift | Text / VARCHAR(10) | Category | Shift label A, B, C or Unknown. |
| Production_Qty | Integer / INT | Measure | Recorded production quantity for the row. |
| Defect_Qty | Integer / INT | Measure | Defect quantity recorded in the production table. Do not automatically combine it with the separate defect-log quantity. |
| Downtime_Minutes | Integer / INT | Measure | Recorded downtime in minutes for the row. Confirm the grain before summing. |
| Data_Quality_Flag | Text / VARCHAR(25) | Quality status | Data quality classification. The SQL verification script uses OK rows for core production KPIs. |

**Validation notes:**
- Production_ID should be unique.
- Check production quantity and downtime for missing, negative or implausible values.
- The verification SQL expects 7,940 total rows: 7,916 OK rows and 24 flagged rows.
- Expected OK-row validation targets in the SQL script: 3,626,137 production units, 138,990 production-table defect units, a 3.83% defect rate and 34.80 average downtime minutes. Recalculate these from the current data before presenting.

## 5. defects.csv — Defect fact table

**Grain:** One defect log record identified by Defect_ID. This table is separate from the production fact table.

| Column | Logical / SQL type | Key role | Definition |
|---|---|---|---|
| Defect_ID | Text / VARCHAR(10) | Primary key | Unique defect-record identifier. |
| Date | Date / DATE | Date field | Date associated with the defect record; expected project range is 2025-01-01 to 2025-12-31. |
| Plant_ID | Text / VARCHAR(10) | Foreign key | Links to plants.Plant_ID. |
| Machine_ID | Text / VARCHAR(10) | Foreign key | Links to machines.Machine_ID. |
| Product_ID | Text / VARCHAR(10) | Foreign key | Links to products.Product_ID. |
| Defect_Type | Text / VARCHAR(30) | Category | Recorded defect category, such as Assembly Error, Surface Scratch, Alignment Issue, Paint Defect or Dimension Out of Spec. |
| Root_Cause | Text / VARCHAR(30) | Category | Recorded cause label, such as Material Issue, Process Variation, Machine Setting, Operator Error, Tool Wear or Maintenance Delay. It is not proof of a confirmed cause. |
| Defect_Qty | Integer / INT | Measure | Quantity associated with the defect log record. |
| Rework_Required | Text / VARCHAR(3) | Yes/No category | Indicates whether rework is marked as required: Yes or No. |
| Data_Quality_Flag | Text / VARCHAR(25) | Quality status | Quality classification. The SQL comments identify OK and Zero_Defect_Qty categories. |

**Validation notes:**
- Defect_ID should be unique.
- Check Defect_Qty for negative values and review zero-quantity rows.
- Check Rework_Required for expected Yes/No values.
- The verification SQL expects 3,960 total rows: 3,954 OK rows and six Zero_Defect_Qty rows.
- The SQL script documents 9,285 defect units among OK rows. Recalculate this in MySQL before presenting.

## 6. Relationships

| Dimension key | Fact-table key | Meaning |
|---|---|---|
| plants.Plant_ID | production.Plant_ID | One plant can have many production records. |
| machines.Machine_ID | production.Machine_ID | One machine can have many production records. |
| products.Product_ID | production.Product_ID | One product can appear in many production records. |
| plants.Plant_ID | defects.Plant_ID | One plant can have many defect records. |
| machines.Machine_ID | defects.Machine_ID | One machine can appear in many defect records. |
| products.Product_ID | defects.Product_ID | One product can appear in many defect records. |

The three dimensions describe entities; production and defects are separate fact tables. Use one-to-many relationships from dimensions to facts. Joining both fact tables row by row can multiply records and inflate totals. Aggregate them to a compatible grain before combining measures.

## 7. KPI interpretation

| Metric / field | Interpretation | Important caution |
|---|---|---|
| Production_Qty | Sum of production units under the selected quality rule. | Verify filters and record grain. |
| production.Defect_Qty | Defect quantity recorded alongside production. | Not automatically equivalent to defects.Defect_Qty. |
| defects.Defect_Qty | Quantity in the separate defect log. | Apply the documented quality filter. |
| Defect rate | Defined defect quantity divided by production quantity, multiplied by 100. | State which defect quantity field is used. |
| Downtime_Minutes | Downtime measured in minutes. | Verify whether values are event-level or production-record-level before summing. |
| Rework record count | Count of rows where Rework_Required is Yes. | Counts records, not defect units. |
| Rework defect quantity | Sum of Defect_Qty where Rework_Required is Yes. | Counts units, not records. |
| Data_Quality_Flag | Classification used for inclusion or exclusion rules. | Exclusions affect totals and denominators. |

## 8. Raw Excel workbook coverage

The [raw workbook](../TVs_Poject/Raw%20Dataset/TVS_Manufacturing_Analytics_Raw_Dataset.xlsx) is also included in the repository. This dictionary documents the five cleaned CSVs used by the SQL schema. If the raw workbook contains extra worksheets or fields that do not appear in these CSVs, document those separately before claiming that this dictionary describes every raw-workbook field.

---
[Back to Project Documentation](PROJECT_DOCUMENTATION.md) · [Back to main README](../README.md)
