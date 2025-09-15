-- Custom SQL metric for income statistics
-- This script calculates average, median, and mean income from baseline_income column

SELECT 
    -- Average income (mean)
    ROUND(AVG(CAST(baseline_income AS NUMERIC)), 2) as average_income,
    
    -- Median income (50th percentile)
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2) as median_income,
    
    -- Mean income (same as average, but explicitly labeled)
    ROUND(AVG(CAST(baseline_income AS NUMERIC)), 2) as mean_income,
    
    -- Additional useful statistics
    ROUND(MIN(CAST(baseline_income AS NUMERIC)), 2) as min_income,
    ROUND(MAX(CAST(baseline_income AS NUMERIC)), 2) as max_income,
    ROUND(STDDEV(CAST(baseline_income AS NUMERIC)), 2) as income_standard_deviation,
    COUNT(*) as total_records,
    COUNT(baseline_income) as records_with_income_data

FROM (
    -- Your main query here - replace this with your actual table/subquery
    SELECT baseline_income
    FROM your_table_name  -- Replace with actual table name or subquery
    WHERE baseline_income IS NOT NULL 
      AND baseline_income != '' 
      AND baseline_income ~ '^[0-9]+\.?[0-9]*$'  -- Only numeric values
) income_data;
