-- Superset Custom SQL Metrics for Income Analysis
-- Use these as custom metrics in Superset charts

-- 1. Average Income Metric
ROUND(AVG(CAST(baseline_income AS NUMERIC)), 2)

-- 2. Median Income Metric  
ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2)

-- 3. Mean Income Metric (same as average)
ROUND(AVG(CAST(baseline_income AS NUMERIC)), 2)

-- 4. Minimum Income Metric
ROUND(MIN(CAST(baseline_income AS NUMERIC)), 2)

-- 5. Maximum Income Metric
ROUND(MAX(CAST(baseline_income AS NUMERIC)), 2)

-- 6. Income Standard Deviation Metric
ROUND(STDDEV(CAST(baseline_income AS NUMERIC)), 2)

-- 7. Income Range Metric
ROUND(MAX(CAST(baseline_income AS NUMERIC)) - MIN(CAST(baseline_income AS NUMERIC)), 2)

-- 8. Q1 Income (25th percentile) Metric
ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2)

-- 9. Q3 Income (75th percentile) Metric
ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2)

-- 10. Income Variance Metric
ROUND(VARIANCE(CAST(baseline_income AS NUMERIC)), 2)
