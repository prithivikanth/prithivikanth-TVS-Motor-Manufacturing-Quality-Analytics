# Presentation Guide — TVS Manufacturing Quality Analytics

Use this guide to prepare and deliver a short project presentation. It is a speaking guide, not a claim that every suggested insight has already been proven.

> **Data disclaimer:** The project uses synthetic practice data, not official TVS Motor Company operational records. State this clearly at the beginning.

## 1. Opening (30–45 seconds)

“My project is titled **TVS Motor Manufacturing Quality, Defect and Production Analytics**. It demonstrates how manufacturing-style data can be organised, validated and analysed using Excel, MySQL and Power BI. The aim is to explore production output, defects, downtime and rework using a structured analytics workflow. The dataset is synthetic and is used for learning and portfolio demonstration.”

## 2. Business Problem (30 seconds)

Manufacturing-style datasets can store production and defect details separately. Without consistent data preparation and analysis, it can be difficult to compare quality indicators across plants, machines, products and shifts. This project demonstrates a way to structure the data and explore those comparisons.

## 3. Tools and Workflow (45 seconds)

Explain the role of each tool:

- **Excel:** inspect the raw workbook.
- **CSV:** store the cleaned tables in a portable format.
- **MySQL:** create relational tables and run analysis queries.
- **Power BI:** model the data and present interactive visuals.
- **GitHub:** keep the project files, SQL scripts and documentation together.

Workflow: Raw workbook → cleaned CSV files → MySQL tables → import validation → SQL analysis → Power BI report → observations.

## 4. Explain the Five CSV Datasets (45–60 seconds)

| Dataset | Explain it this way |
|---|---|
| `plants.csv` | Reference information describing plants. |
| `machines.csv` | Machine IDs, names and machine types. |
| `products.csv` | Product IDs, names and categories. |
| `production.csv` | Production records, production quantity, production-table defect quantity, shift and downtime. |
| `defects.csv` | Separate defect log containing defect type, recorded root-cause label, quantity and rework indicator. |

Use the [Data Dictionary](DATA_DICTIONARY.md) if someone asks what a particular column means.

## 5. Explain the Data Model (30–45 seconds)

The plants, machines and products tables are dimension/reference tables. The production and defects tables are separate fact tables. Each fact table references plant, machine and product IDs.

Important: production-table `Defect_Qty` and defect-log `Defect_Qty` are not automatically interchangeable. Joining the two fact tables directly can multiply rows and inflate totals. Explain the model and measures actually used in your PBIX file.

## 6. Demonstrate SQL (45–60 seconds)

Show the SQL scripts in this order:

1. `01_create_tables.sql` — creates the schema and tables.
2. `02_insert_data.sql` — inserts the synthetic data.
3. `03_verify_import.sql` — checks row counts, quality flags and validation KPIs.
4. `04_analysis_queries.sql` — contains analytical queries.

Do not run `01_create_tables.sql` casually during the presentation: it includes `DROP DATABASE IF EXISTS tvs_manufacturing`, which deletes and recreates that database. Show the code or pre-existing output instead.

## 7. Demonstrate Power BI (1–2 minutes)

Open the actual Power BI report and:

1. Identify each page and its purpose.
2. Explain the KPI cards using their exact definitions.
3. Demonstrate a filter or slicer if it works in the report.
4. Explain one chart and what question it answers.
5. Cross-check a headline number against the SQL validation output.

Use the screenshots in [Power BI screenshots](../TVs_Poject/Screenshots/Power%20BI%20Screenshot/) as a backup if the report cannot be opened live.

## 8. Discuss Findings

Only state findings that you have personally verified from the SQL query output and Power BI report. Use this pattern:

- **Observation:** What the chart or query actually shows.
- **Evidence:** Which metric, filter and time period support it.
- **Interpretation:** What the pattern may indicate.
- **Limitation:** What the data cannot prove.

Do not invent a highest-defect machine, a root cause, a cost saving or a production improvement unless the analysis supports it.

The SQL verification script documents these expected values for `OK` production rows: 3,626,137 production units, 138,990 production-table defect units, a 3.83% production-table defect rate and average downtime of 34.80 minutes. Confirm them in your actual database and Power BI measures before quoting them.

## 9. Limitations and Closing (30 seconds)

“The project demonstrates data preparation, relational modelling, SQL validation and Power BI reporting using synthetic practice data. The next improvement would be to strengthen automated data-quality checks, document KPI definitions and validate the dashboard measures against SQL outputs.”

## Likely Questions and Answers

**Q: Is this actual TVS Motor Company data?**  
A: No. It is synthetic practice data for demonstrating the analytics workflow, not official company data.

**Q: Why use both SQL and Power BI?**  
A: SQL is useful for data storage, validation, joins and aggregation. Power BI helps model the data and communicate results through interactive visualisations.

**Q: What is the difference between a dimension and a fact table?**  
A: Dimension tables describe entities such as plants, machines and products. Fact tables record events or measurements, such as production and defects.

**Q: Why keep production and defects as separate fact tables?**  
A: They represent different record grains and measures. A careless join can multiply matching rows and inflate totals.

**Q: How do you validate your dashboard?**  
A: Compare row counts and KPI calculations from the SQL verification script with the Power BI measures, using the same filters and definitions.

**Q: Does a recorded root cause prove why a defect happened?**  
A: No. It is a category recorded in the synthetic dataset, not independent evidence of causation.

**Q: What would you improve next?**  
A: Automate quality checks, add reproducible refresh steps, document every KPI formula and test the model for duplicated totals.

## Final Checklist

- [ ] Open the PBIX file before the presentation.
- [ ] Keep MySQL Workbench and the validation query ready.
- [ ] Verify all KPI numbers and filters.
- [ ] Know the purpose of each of the five CSV files.
- [ ] Be able to explain the dimension/fact table structure.
- [ ] State clearly that the data is synthetic.
- [ ] Do not claim unverified findings.
