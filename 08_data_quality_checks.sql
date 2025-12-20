-- 08_data_quality_checks.sql
-- Data quality validations to protect KPI integrity
-- These queries are designed to be fast checks you can run after loading data.

-- =========================================================
-- 1) Row counts & distinct keys
-- =========================================================
SELECT 'LKP_EVENTS_CALENDAR' AS table_name, COUNT(*) AS row_count FROM LKP_EVENTS_CALENDAR
UNION ALL
SELECT 'LKP_STAND_LOCATIONS', COUNT(*) FROM LKP_STAND_LOCATIONS
UNION ALL
SELECT 'LKP_ITEM_DETAILS', COUNT(*) FROM LKP_ITEM_DETAILS
UNION ALL
SELECT 'SRC_RAW_SALES_BY_ITEM', COUNT(*) FROM SRC_RAW_SALES_BY_ITEM;

SELECT
  COUNT(*) AS sales_lines,
  COUNT(DISTINCT SALE_ID) AS transactions,
  AVG(lines_per_sale) AS avg_lines_per_sale
FROM (
  SELECT SALE_ID, COUNT(*) AS lines_per_sale
  FROM SRC_RAW_SALES_BY_ITEM
  GROUP BY SALE_ID
);

-- =========================================================
-- 2) Null / missing key fields (should be 0)
-- =========================================================
SELECT
  SUM(CASE WHEN SALE_ID IS NULL OR TRIM(SALE_ID) = '' THEN 1 ELSE 0 END) AS bad_sale_id,
  SUM(CASE WHEN ITEM_ID IS NULL OR TRIM(ITEM_ID) = '' THEN 1 ELSE 0 END) AS bad_item_id,
  SUM(CASE WHEN VENDOR_ID IS NULL OR TRIM(VENDOR_ID) = '' THEN 1 ELSE 0 END) AS bad_vendor_id,
  SUM(CASE WHEN SALE_TIME IS NULL THEN 1 ELSE 0 END) AS bad_sale_time
FROM SRC_RAW_SALES_BY_ITEM;

-- =========================================================
-- 3) Missing dimension joins (should be 0 in clean data)
-- =========================================================
-- Missing item mapping
SELECT
  COUNT(*) AS missing_item_rows
FROM SRC_RAW_SALES_BY_ITEM s
LEFT JOIN LKP_ITEM_DETAILS i
  ON s.ITEM_ID = i.ITEM_ID
WHERE i.ITEM_ID IS NULL;

-- Missing stand mapping
SELECT
  COUNT(*) AS missing_stand_rows
FROM SRC_RAW_SALES_BY_ITEM s
LEFT JOIN LKP_STAND_LOCATIONS l
  ON s.VENDOR_ID = l.VENDOR_ID
WHERE l.VENDOR_ID IS NULL;

-- Missing event attribution (based on your current join logic SALE_DATE = EVENT_DATE)
SELECT
  COUNT(*) AS missing_event_rows
FROM VW_REPORTING_TABLE
WHERE EVENT_NAME IS NULL;

-- =========================================================
-- 4) Duplicate inflation risk (same exact line repeated)
-- =========================================================
-- If these exist, KPIs can inflate.
SELECT
  SALE_ID,
  SALE_TIME,
  ITEM_ID,
  VENDOR_ID,
  POS_ID,
  UNITS_SOLD,
  NET_SALES,
  COUNT(*) AS dup_count
FROM SRC_RAW_SALES_BY_ITEM
GROUP BY
  SALE_ID, SALE_TIME, ITEM_ID, VENDOR_ID, POS_ID, UNITS_SOLD, NET_SALES
HAVING COUNT(*) > 1
ORDER BY dup_count DESC
LIMIT 50; -- increase limit if needed

-- =========================================================
-- 5) Value sanity checks (should be rare or 0)
-- =========================================================
-- Negative or zero values where they shouldn't occur
SELECT
  SUM(CASE WHEN UNITS_SOLD <= 0 THEN 1 ELSE 0 END) AS bad_units,
  SUM(CASE WHEN GROSS_SALES < 0 THEN 1 ELSE 0 END) AS bad_gross_sales,
  SUM(CASE WHEN NET_SALES < 0 THEN 1 ELSE 0 END) AS bad_net_sales,
  SUM(CASE WHEN DISCOUNTS < 0 THEN 1 ELSE 0 END) AS bad_discounts
FROM SRC_RAW_SALES_BY_ITEM;

-- Discount larger than gross (bad)
SELECT
  COUNT(*) AS discount_gt_gross_rows
FROM SRC_RAW_SALES_BY_ITEM
WHERE DISCOUNTS > GROSS_SALES;

-- Unusually high discount rate (flag)
SELECT
  *
FROM SRC_RAW_SALES_BY_ITEM
WHERE (DISCOUNTS / NULLIF(GROSS_SALES, 0)) > 0.50
ORDER BY (DISCOUNTS / NULLIF(GROSS_SALES, 0)) DESC
LIMIT 50;

-- =========================================================
-- 6) Quick “coverage summary” for recruiters
-- =========================================================
SELECT
  COUNT(*) AS total_lines,
  SUM(CASE WHEN EVENT_NAME IS NULL THEN 1 ELSE 0 END) AS missing_event_lines,
  SUM(CASE WHEN STAND_NAME IS NULL THEN 1 ELSE 0 END) AS missing_stand_lines,
  SUM(CASE WHEN ITEM_GROUP IS NULL THEN 1 ELSE 0 END) AS missing_item_lines
FROM VW_REPORTING_TABLE;
