# TVS Motor Manufacturing Quality, Defect and Production Analytics

An end-to-end data analytics portfolio project using Excel, MySQL, and
Power BI to explore manufacturing production, quality defects, downtime,
and rework.

> **Dataset disclaimer:** This project uses synthetic practice data. It
> is not real TVS Motor Company data, and the findings should not be
> interpreted as actual company performance.

## Project Overview

Manufacturing teams need to monitor production output, defects,
downtime, and rework to identify where quality improvement efforts
should be focused. This project demonstrates a data analytics workflow
from data cleaning and SQL analysis to an interactive Power BI
dashboard.

## Objectives

-   Analyse production output and defect rates across plants, machines,
    products, and shifts.
-   Identify common defect types and recorded root causes.
-   Examine downtime patterns and their relationship with quality
    measures.
-   Track monthly quality trends.
-   Understand the share of recorded defects that require rework.
-   Present findings through a three-page Power BI dashboard.

## Tools and Technologies

-   **Excel:** Data cleaning, validation, and reconciliation checks
-   **MySQL 8:** Data loading, SQL analysis, joins, CTEs, window
    functions, and views
-   **Power BI Desktop:** Data modelling, DAX measures, and interactive
    dashboards
-   **GitHub:** Project version control and documentation

## Repository Structure

The exact folders in this repository may vary depending on which project
files have been uploaded.

``` text
prithivikanth-TVS-Motor-Manufacturing-Quality-Analytics/
├── README.md
├── data/
│   ├── raw/                 # Original practice dataset
│   └── clean/               # Cleaned datasets and workbook
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_insert_data.sql
│   ├── 03_verify_import.sql
│   └── 04_analysis_queries.sql
├── powerbi/
│   ├── TVS_Manufacturing_Dashboard.pbix
│   └── TVS_DAX_Measures.txt
├── images/                  # Dashboard and analysis screenshots
└── Business_Insights.md     # Detailed findings and recommendations
```

## Business Questions

1.  Which plant, machine, product, and shift have the highest defect
    rates?
2.  Which defect types and recorded root causes appear most frequently?
3.  Where is downtime concentrated, and how does it compare with quality
    results?
4.  How does the defect rate change month by month?
5.  What proportion of recorded defect incidents requires rework?

## Data Cleaning and Validation

The project workflow addresses data-quality issues such as:

-   Duplicate production and defect records
-   Dates stored as text instead of date values
-   Inconsistent capitalization and extra spaces in category fields
-   Missing values in shift, machine, defect type, and root-cause fields
-   Invalid or implausible quantities and downtime values
-   Zero-quantity defect records

Missing categories are labelled as `Unknown` rather than guessed.
Invalid records are flagged and excluded from KPI calculations where
specified by the project rules. Refer to the SQL scripts and cleaned
workbook for the actual implementation.

## Data Model

The Power BI model uses dimension tables such as plants, machines,
products, and a calendar table to analyse production and defect records.
Production and defect logs are treated as separate fact tables because
the defect log represents inspection incidents and has its own
quantities.

## SQL Analysis

The SQL scripts cover database/table setup, data loading, import
verification, and analytical queries. Analysis techniques include:

-   Filtering and sorting
-   Aggregations with `GROUP BY` and `HAVING`
-   Joins across manufacturing dimensions
-   Common Table Expressions (CTEs)
-   Window functions such as `RANK`, `LAG`, and running totals
-   Pareto analysis and cumulative shares
-   Downtime categorisation
-   Reusable views

## Power BI Dashboard

The report is designed around three pages:

1.  **Overview:** High-level production and quality KPIs
2.  **Quality and Defects:** Defect rates, defect types, root causes,
    and rework
3.  **Machines and Plants:** Comparisons across plants and machines,
    including downtime

### Dashboard Screenshots

Add or keep the screenshots in the `images/` folder and make sure these
filenames match the actual files in the repository.

  ----------------------------------------------------------------------------------------------------------------------------------------------
  Overview                                         Quality and Defects                            Machines and Plants
  ------------------------------------------------ ---------------------------------------------- ----------------------------------------------
  ![Dashboard                                      ![Quality and                                  ![Machines and
  overview](images/dashboard_page1_overview.png)   defects](images/dashboard_page2_quality.png)   plants](images/dashboard_page3_machines.png)

  ----------------------------------------------------------------------------------------------------------------------------------------------

If your screenshots use different filenames or are stored in another
folder, update the paths above.

## Key Findings

The current project analysis reports the following findings from the
synthetic practice dataset:

-   Nalagarh has a higher defect rate than Hosur in the analysed data.
-   Night shift (Shift C) shows a higher defect rate than Shift A.
-   July has the highest reported monthly defect rate in the analysis.
-   Paint Booth 02 has a higher defect rate and downtime than the
    reported average.
-   Four recorded root-cause categories account for most logged defects.
-   Rework affects a substantial share of recorded defect incidents.

For the exact values, calculations, and supporting context, see
[`Business_Insights.md`](Business_Insights.md), if that file is included
in the repository. These findings describe the synthetic dataset only.

## Recommendations

Based on the practice analysis, possible actions to investigate include:

1.  Review high-defect plant and shift combinations.
2.  Investigate machines with elevated defect rates and downtime.
3.  Standardise machine setup checks and operator procedures.
4.  Monitor monthly quality trends and plan additional checks during
    higher-defect periods.
5.  Review defect rate, downtime, and rework together rather than as
    isolated metrics.

These are analytical recommendations based on synthetic data, not
recommendations based on verified TVS Motor operations.

## How to Reproduce the Analysis

1.  Install and open MySQL 8 and MySQL Workbench.
2.  Review the SQL scripts and confirm the file paths and database
    names.
3.  Run `sql/01_create_tables.sql`.
4.  Run `sql/02_insert_data.sql`.
5.  Run `sql/03_verify_import.sql` to validate the imported data.
6.  Run `sql/04_analysis_queries.sql` to explore the analysis.
7.  Open `powerbi/TVS_Manufacturing_Dashboard.pbix` in Power BI Desktop.
8.  If rebuilding the report, load the cleaned CSV files, verify
    relationships and data types, and apply the measures in
    `powerbi/TVS_DAX_Measures.txt`.
9.  Check that the dashboard visuals and KPIs match the validated source
    data.

File names and execution steps may need adjustment to match the files
actually present in the repository.

## Limitations

-   The dataset is synthetic and does not represent real TVS Motor
    Company data.
-   The defect-rate target used in the analysis is an assumed benchmark.
-   Observed relationships do not establish causation.
-   Results depend on data-cleaning rules, definitions, and exclusions
    used in the project.

## Author

**Prithivi Kanth S**

-   GitHub: [@prithivikanth](https://github.com/prithivikanth)
-   Project repository: [TVS Motor Manufacturing Quality
    Analytics](https://github.com/prithivikanth/prithivikanth-TVS-Motor-Manufacturing-Quality-Analytics)

------------------------------------------------------------------------

If you use or adapt this project, verify the data, scripts, dashboard,
screenshot paths, and findings before relying on them.
