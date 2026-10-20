-- =====================================================================
-- TVS Motor Company – Manufacturing Quality, Defect & Production Analytics
-- Step 4: SQL analysis queries (MySQL 8.x), beginner -> intermediate
--
-- HOW TO RUN: File > Open SQL Script > this file. Click inside ONE query and
-- press Ctrl+Enter to run just that query (the lightning icon would run
-- all of them). Read the business question, TRY writing the query yourself
-- first, then compare.
--
-- RULE: production queries use  WHERE Data_Quality_Flag = 'OK'
--       so the 24 flagged rows never distort a KPI.
-- Defect rate = SUM(Defect_Qty) / SUM(Production_Qty)  (never AVG of row rates).
-- =====================================================================
USE tvs_manufacturing;

-- #####################################################################
-- PART A – BEGINNER: SELECT, WHERE, ORDER BY, LIMIT, DISTINCT, COUNT
-- #####################################################################

-- Q01. What does the production table look like?
SELECT * FROM production LIMIT 10;

-- Q02. Which shift labels exist? (also proves Shift cleaning worked)
SELECT DISTINCT Shift FROM production ORDER BY Shift;

-- Q03. Which 10 production runs had the longest downtime?
SELECT Production_ID, `Date`, Plant_ID, Machine_ID, Shift, Downtime_Minutes
FROM production
WHERE Data_Quality_Flag = 'OK'
ORDER BY Downtime_Minutes DESC
LIMIT 10;

-- Q04. Which valid runs had a defect rate above 10%?
SELECT Production_ID, `Date`, Plant_ID, Machine_ID, Production_Qty, Defect_Qty,
       ROUND(Defect_Qty * 100.0 / Production_Qty, 2) AS defect_rate_pct
FROM production
WHERE Data_Quality_Flag = 'OK'
  AND Defect_Qty * 1.0 / Production_Qty > 0.10
ORDER BY defect_rate_pct DESC
LIMIT 10;

-- Q05. Headline KPIs for the whole business.
SELECT COUNT(*)                                              AS production_runs,
       SUM(Production_Qty)                                   AS total_units,
       SUM(Defect_Qty)                                       AS total_defects,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct,
       ROUND(AVG(Downtime_Minutes), 1)                       AS avg_downtime_min,
       SUM(Downtime_Minutes)                                 AS total_downtime_min
FROM production
WHERE Data_Quality_Flag = 'OK';

-- Q06. Which rows did the cleaning flag as bad (audit trail)?
SELECT Data_Quality_Flag, COUNT(*) AS rows_n
FROM production
WHERE Data_Quality_Flag <> 'OK'
GROUP BY Data_Quality_Flag
ORDER BY rows_n DESC;

-- #####################################################################
-- PART B – AGGREGATION: GROUP BY, HAVING, CASE
-- #####################################################################

-- Q07. Defect rate by plant.
SELECT Plant_ID,
       SUM(Production_Qty) AS units,
       SUM(Defect_Qty)     AS defects,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
FROM production
WHERE Data_Quality_Flag = 'OK'
GROUP BY Plant_ID
ORDER BY defect_rate_pct DESC;

-- Q08. Defect rate and downtime by shift (Unknown = blank shift in raw data).
SELECT Shift,
       COUNT(*)            AS runs,
       SUM(Production_Qty) AS units,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct,
       ROUND(AVG(Downtime_Minutes), 1) AS avg_downtime_min
FROM production
WHERE Data_Quality_Flag = 'OK'
GROUP BY Shift
ORDER BY Shift;

-- Q09. Defect rate by machine (known machines only).
SELECT Machine_ID,
       SUM(Production_Qty) AS units,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct,
       ROUND(AVG(Downtime_Minutes), 1) AS avg_downtime_min
FROM production
WHERE Data_Quality_Flag = 'OK' AND Machine_ID <> 'Unknown'
GROUP BY Machine_ID
ORDER BY defect_rate_pct DESC;

-- Q10. HAVING: which machines run above 4.5% defects?
SELECT Machine_ID,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
FROM production
WHERE Data_Quality_Flag = 'OK' AND Machine_ID <> 'Unknown'
GROUP BY Machine_ID
HAVING SUM(Defect_Qty) * 100.0 / SUM(Production_Qty) > 4.5
ORDER BY defect_rate_pct DESC;

-- Q11. Monthly production volume and defect rate (the trend line).
SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
       SUM(Production_Qty) AS units,
       SUM(Defect_Qty)     AS defects,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
FROM production
WHERE Data_Quality_Flag = 'OK'
GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
ORDER BY month;

-- Q12. Which defect types are most common? (inspection log)
SELECT Defect_Type, COUNT(*) AS incidents, SUM(Defect_Qty) AS defect_units
FROM defects
WHERE Data_Quality_Flag = 'OK'
GROUP BY Defect_Type
ORDER BY defect_units DESC;

-- Q13. Which root causes drive the most defects?
SELECT Root_Cause, SUM(Defect_Qty) AS defect_units, COUNT(*) AS incidents
FROM defects
WHERE Data_Quality_Flag = 'OK'
GROUP BY Root_Cause
ORDER BY defect_units DESC;

-- Q14. What share of defect incidents needs rework, by defect type?
SELECT Defect_Type,
       COUNT(*) AS incidents,
       SUM(CASE WHEN Rework_Required = 'Yes' THEN 1 ELSE 0 END) AS rework_incidents,
       ROUND(SUM(CASE WHEN Rework_Required = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS rework_pct
FROM defects
WHERE Data_Quality_Flag = 'OK'
GROUP BY Defect_Type
ORDER BY rework_pct DESC;

-- #####################################################################
-- PART C – JOINS: bring in names, types and categories
-- #####################################################################

-- Q15. Plant name and state with the defect rate.
SELECT pl.Plant_Name, pl.State,
       SUM(p.Production_Qty) AS units,
       ROUND(SUM(p.Defect_Qty) * 100.0 / SUM(p.Production_Qty), 2) AS defect_rate_pct
FROM production p
JOIN plants pl ON pl.Plant_ID = p.Plant_ID
WHERE p.Data_Quality_Flag = 'OK'
GROUP BY pl.Plant_Name, pl.State
ORDER BY defect_rate_pct DESC;

-- Q16. Which machine TYPE (CNC, Welding, Painting, Assembly) has the worst quality and downtime?
SELECT m.Machine_Type,
       SUM(p.Production_Qty) AS units,
       ROUND(SUM(p.Defect_Qty) * 100.0 / SUM(p.Production_Qty), 2) AS defect_rate_pct,
       ROUND(AVG(p.Downtime_Minutes), 1) AS avg_downtime_min
FROM production p
JOIN machines m ON m.Machine_ID = p.Machine_ID
WHERE p.Data_Quality_Flag = 'OK'
GROUP BY m.Machine_Type
ORDER BY defect_rate_pct DESC;

-- Q17. Defect rate by product category and product.
SELECT pr.Category, pr.Product_Name,
       SUM(p.Production_Qty) AS units,
       ROUND(SUM(p.Defect_Qty) * 100.0 / SUM(p.Production_Qty), 2) AS defect_rate_pct
FROM production p
JOIN products pr ON pr.Product_ID = p.Product_ID
WHERE p.Data_Quality_Flag = 'OK'
GROUP BY pr.Category, pr.Product_Name
ORDER BY defect_rate_pct DESC;

-- Q18. Plant x Shift matrix of defect rates (CASE pivot).
SELECT Plant_ID,
       ROUND(SUM(CASE WHEN Shift = 'A' THEN Defect_Qty END) * 100.0 /
             SUM(CASE WHEN Shift = 'A' THEN Production_Qty END), 2) AS shift_A,
       ROUND(SUM(CASE WHEN Shift = 'B' THEN Defect_Qty END) * 100.0 /
             SUM(CASE WHEN Shift = 'B' THEN Production_Qty END), 2) AS shift_B,
       ROUND(SUM(CASE WHEN Shift = 'C' THEN Defect_Qty END) * 100.0 /
             SUM(CASE WHEN Shift = 'C' THEN Production_Qty END), 2) AS shift_C
FROM production
WHERE Data_Quality_Flag = 'OK'
GROUP BY Plant_ID
ORDER BY Plant_ID;

-- Q19. Which defect types come from which machine types? (joins the defect log to machines)
SELECT m.Machine_Type, d.Defect_Type, SUM(d.Defect_Qty) AS defect_units
FROM defects d
JOIN machines m ON m.Machine_ID = d.Machine_ID
WHERE d.Data_Quality_Flag = 'OK'
  AND d.Defect_Type <> 'Unknown'
GROUP BY m.Machine_Type, d.Defect_Type
ORDER BY m.Machine_Type, defect_units DESC;

-- Q20. Plant, product category and defect type: where is the defect log concentrated?
SELECT pl.Plant_Name, pr.Category, SUM(d.Defect_Qty) AS defect_units
FROM defects d
JOIN plants   pl ON pl.Plant_ID   = d.Plant_ID
JOIN products pr ON pr.Product_ID = d.Product_ID
WHERE d.Data_Quality_Flag = 'OK'
GROUP BY pl.Plant_Name, pr.Category
ORDER BY defect_units DESC
LIMIT 10;

-- #####################################################################
-- PART D – INTERMEDIATE: CTEs, window functions, subqueries
-- #####################################################################

-- Q21. CTE: machines performing WORSE than the company average.
WITH overall AS (
    SELECT SUM(Defect_Qty) * 100.0 / SUM(Production_Qty) AS overall_rate
    FROM production
    WHERE Data_Quality_Flag = 'OK'
),
machine_perf AS (
    SELECT Machine_ID,
           SUM(Defect_Qty) * 100.0 / SUM(Production_Qty) AS machine_rate
    FROM production
    WHERE Data_Quality_Flag = 'OK' AND Machine_ID <> 'Unknown'
    GROUP BY Machine_ID
)
SELECT mp.Machine_ID,
       ROUND(mp.machine_rate, 2)                    AS machine_rate_pct,
       ROUND(o.overall_rate, 2)                     AS company_rate_pct,
       ROUND(mp.machine_rate - o.overall_rate, 2)   AS gap_pct_points
FROM machine_perf mp
CROSS JOIN overall o
WHERE mp.machine_rate > o.overall_rate
ORDER BY gap_pct_points DESC;

-- Q22. RANK(): rank machines inside each plant by defect rate (1 = worst).
WITH machine_perf AS (
    SELECT Plant_ID, Machine_ID,
           SUM(Production_Qty) AS units,
           ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
    FROM production
    WHERE Data_Quality_Flag = 'OK' AND Machine_ID <> 'Unknown'
    GROUP BY Plant_ID, Machine_ID
)
SELECT Plant_ID, Machine_ID, units, defect_rate_pct,
       RANK() OVER (PARTITION BY Plant_ID ORDER BY defect_rate_pct DESC) AS rank_in_plant
FROM machine_perf
ORDER BY Plant_ID, rank_in_plant;

-- Q23. LAG(): month-over-month change in defect rate (percentage points).
WITH monthly AS (
    SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month,
           ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
    FROM production
    WHERE Data_Quality_Flag = 'OK'
    GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
)
SELECT month, defect_rate_pct,
       LAG(defect_rate_pct) OVER (ORDER BY month) AS prev_month_rate,
       ROUND(defect_rate_pct - LAG(defect_rate_pct) OVER (ORDER BY month), 2) AS change_pct_points
FROM monthly
ORDER BY month;

-- Q24. Running total of units produced across the year.
WITH monthly AS (
    SELECT DATE_FORMAT(`Date`, '%Y-%m') AS month, SUM(Production_Qty) AS units
    FROM production
    WHERE Data_Quality_Flag = 'OK'
    GROUP BY DATE_FORMAT(`Date`, '%Y-%m')
)
SELECT month, units,
       SUM(units) OVER (ORDER BY month) AS cumulative_units
FROM monthly
ORDER BY month;

-- Q25. Pareto: defect types with % share and cumulative % (80/20 view).
--      Rows with an 'Unknown' type are left out of the Pareto.
WITH by_type AS (
    SELECT Defect_Type, SUM(Defect_Qty) AS defect_units
    FROM defects
    WHERE Data_Quality_Flag = 'OK' AND Defect_Type <> 'Unknown'
    GROUP BY Defect_Type
)
SELECT Defect_Type, defect_units,
       ROUND(defect_units * 100.0 / SUM(defect_units) OVER (), 1) AS pct_of_total,
       ROUND(SUM(defect_units) OVER (ORDER BY defect_units DESC, Defect_Type) * 100.0
             / SUM(defect_units) OVER (), 1) AS cumulative_pct
FROM by_type
ORDER BY defect_units DESC, Defect_Type;

-- Q26. ROW_NUMBER(): top 2 root causes inside each defect type.
WITH cause_rank AS (
    SELECT Defect_Type, Root_Cause, SUM(Defect_Qty) AS defect_units,
           ROW_NUMBER() OVER (PARTITION BY Defect_Type ORDER BY SUM(Defect_Qty) DESC) AS rn
    FROM defects
    WHERE Data_Quality_Flag = 'OK'
      AND Defect_Type <> 'Unknown' AND Root_Cause <> 'Unknown'
    GROUP BY Defect_Type, Root_Cause
)
SELECT Defect_Type, Root_Cause, defect_units, rn AS cause_rank
FROM cause_rank
WHERE rn <= 2
ORDER BY Defect_Type, rn;

-- Q27. Does more downtime go with more defects? (bucket the downtime)
SELECT CASE WHEN Downtime_Minutes < 15 THEN '1) 0-14 min'
            WHEN Downtime_Minutes < 30 THEN '2) 15-29 min'
            WHEN Downtime_Minutes < 60 THEN '3) 30-59 min'
            ELSE '4) 60+ min' END AS downtime_bucket,
       COUNT(*) AS runs,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
FROM production
WHERE Data_Quality_Flag = 'OK'
GROUP BY downtime_bucket
ORDER BY downtime_bucket;

-- Q28. Quarterly view for an executive summary.
SELECT CONCAT('Q', QUARTER(`Date`)) AS quarter,
       SUM(Production_Qty) AS units,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct,
       ROUND(AVG(Downtime_Minutes), 1) AS avg_downtime_min
FROM production
WHERE Data_Quality_Flag = 'OK'
GROUP BY CONCAT('Q', QUARTER(`Date`))
ORDER BY quarter;

-- Q29. Subquery: the 5 worst plant-machine-product combinations (min 20,000 units so small samples don't mislead).
SELECT *
FROM (
    SELECT Plant_ID, Machine_ID, Product_ID,
           SUM(Production_Qty) AS units,
           ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct
    FROM production
    WHERE Data_Quality_Flag = 'OK' AND Machine_ID <> 'Unknown'
    GROUP BY Plant_ID, Machine_ID, Product_ID
    HAVING SUM(Production_Qty) >= 20000
) t
ORDER BY defect_rate_pct DESC
LIMIT 5;

-- Q30. Reusable VIEW: a clean, joined table that Power BI or any query can use.
CREATE OR REPLACE VIEW vw_production_enriched AS
SELECT p.Production_ID, p.`Date`, p.Plant_ID, pl.Plant_Name, pl.State,
       p.Machine_ID, m.Machine_Name, m.Machine_Type,
       p.Product_ID, pr.Product_Name, pr.Category,
       p.Shift, p.Production_Qty, p.Defect_Qty, p.Downtime_Minutes
FROM production p
JOIN plants   pl ON pl.Plant_ID   = p.Plant_ID
JOIN machines m  ON m.Machine_ID  = p.Machine_ID
JOIN products pr ON pr.Product_ID = p.Product_ID
WHERE p.Data_Quality_Flag = 'OK';

SELECT * FROM vw_production_enriched LIMIT 5;
