-- =====================================================================
-- Step 3: verify the import. Every "Expected" must match.
-- =====================================================================
USE tvs_manufacturing;

-- 3.1 Row counts            Expected: plants 3 | machines 11 | products 6 | production 7940 | defects 3960
SELECT 'plants'     AS table_name, COUNT(*) AS row_count FROM plants
UNION ALL SELECT 'machines',   COUNT(*) FROM machines
UNION ALL SELECT 'products',   COUNT(*) FROM products
UNION ALL SELECT 'production', COUNT(*) FROM production
UNION ALL SELECT 'defects',    COUNT(*) FROM defects;

-- 3.2 Flag split            Expected: production OK 7916 (24 flagged) | defects OK 3954 (6 Zero_Defect_Qty)
SELECT 'production' AS table_name, Data_Quality_Flag, COUNT(*) AS rows_n FROM production GROUP BY Data_Quality_Flag
UNION ALL
SELECT 'defects', Data_Quality_Flag, COUNT(*) FROM defects GROUP BY Data_Quality_Flag;

-- 3.3 Core KPIs (OK rows)   Expected: 7916 | 3626137 | 138990 | 3.83 | 34.80
SELECT COUNT(*)                                          AS ok_rows,
       SUM(Production_Qty)                               AS total_units,
       SUM(Defect_Qty)                                   AS total_defects,
       ROUND(SUM(Defect_Qty) * 100.0 / SUM(Production_Qty), 2) AS defect_rate_pct,
       ROUND(AVG(Downtime_Minutes), 2)                   AS avg_downtime_min
FROM production
WHERE Data_Quality_Flag = 'OK';

-- 3.4 Defect log            Expected: 3954 rows | 9285 units | Rework Yes 1417, No 2543 (all 3960 rows)
SELECT COUNT(*) AS ok_rows, SUM(Defect_Qty) AS total_defect_units
FROM defects WHERE Data_Quality_Flag = 'OK';
SELECT Rework_Required, COUNT(*) AS rows_n FROM defects GROUP BY Rework_Required;

-- 3.5 Join check            Expected: 7940 (joins must not lose rows, including the 96 'Unknown' machines)
SELECT COUNT(*) AS joined_rows
FROM production p
JOIN plants   pl ON pl.Plant_ID   = p.Plant_ID
JOIN machines m  ON m.Machine_ID  = p.Machine_ID
JOIN products pr ON pr.Product_ID = p.Product_ID;

-- 3.6 Date range            Expected: 2025-01-01 to 2025-12-31 (both tables)
SELECT MIN(`Date`) AS first_date, MAX(`Date`) AS last_date FROM production;
SELECT MIN(`Date`) AS first_date, MAX(`Date`) AS last_date FROM defects;
