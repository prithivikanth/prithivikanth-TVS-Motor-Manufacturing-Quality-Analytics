# Presentation Guide — TVS Manufacturing Analytics

Use this as a quick speaking guide. Adapt it to the actual Power BI report and SQL results you can demonstrate.

## 1. Opening

“My project is TVS Motor Manufacturing Quality, Defect and Production Analytics. It demonstrates how manufacturing-style data can be structured, validated and analysed using Excel, CSV, MySQL and Power BI.”

Immediately clarify: “The dataset is synthetic practice data. It is not official TVS Motor Company data.”

## 2. Explain the problem

“Production and quality records can be spread across plant, machine, product, production and defect data. The project organises those records so I can compare production quantities, defect patterns, downtime and rework.”

## 3. Explain the tools

- Excel: inspect the source workbook.
- CSV: provide the structured files.
- MySQL: store related tables.
- SQL: validate imports and answer analytical questions.
- Power BI: present measures and comparisons visually.
- GitHub: keep the project files and documentation organised.

## 4. Explain the data model

“There are three dimension tables—plants, machines and products—and two fact tables—production and defects. The dimensions describe entities, while the fact tables store recorded activity. I keep the two fact tables separate because their record grain differs.”

If asked why not join production and defects directly, explain that a many-to-many row-level join can multiply records and inflate measures.

## 5. Demonstrate SQL

Open the SQL folder and explain the script sequence:

1. 01_create_tables.sql creates the database tables.
2. 02_insert_data.sql loads the practice data.
3. 03_verify_import.sql checks row counts, quality flags, KPIs, joins and date ranges.
4. 04_analysis_queries.sql contains analytical queries.

**Safety:** The table-creation script drops and recreates the tvs_manufacturing database. Do not execute it against a database with important data.

## 6. Demonstrate Power BI

Open the PBIX report and walk through the dashboard pages that actually exist. Explain what each visual measures, what filters affect it, and which source table supplies its data. If a number is asked about, show the SQL or measure definition used to calculate it.

## 7. KPI caution

The SQL verification script lists expected OK-row production metrics of 3,626,137 units, 138,990 production-table defect units, a 3.83% defect rate and 34.80 average downtime minutes. These are synthetic-data validation targets. Verify them in your current database and dashboard before presenting.

Do not confuse production.Defect_Qty with defects.Defect_Qty; they are different columns in separate fact tables. Explain the numerator and denominator whenever you discuss a defect rate.

## 8. Closing

“This project demonstrates a complete analytics workflow from source data inspection and SQL validation through dashboard reporting. A next step would be to strengthen automated data-quality checks, document KPI definitions and validate every dashboard measure against SQL.”

## Questions you may be asked

**Why did you use SQL and Power BI?**  
SQL supports structured storage, joins, validation and aggregations. Power BI makes the selected metrics easier to explore through interactive visuals.

**What is a dimension table?**  
A descriptive table such as plants, machines or products used to group and filter fact records.

**What is a fact table?**  
A table of recorded events or measurements, such as production records or defect logs.

**Why check data quality?**  
Incorrect keys, duplicate records, invalid quantities or inconsistent filters can make totals and KPIs misleading.

**Is this real TVS Motor Company data?**  
“No. It is synthetic practice data used to demonstrate analytics methods. It is not official company data.”

**What would you improve next?**  
Add repeatable data-quality tests, reconcile all Power BI measures to SQL, document the dashboard's actual business rules, and add more detailed trend analysis if suitable data is available.
