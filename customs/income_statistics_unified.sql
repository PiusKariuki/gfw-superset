-- Income Statistics for Unified Dataset
-- This script calculates comprehensive income statistics from the baseline_income column

SELECT 
    -- Basic statistics
    ROUND(AVG(CAST(baseline_income AS NUMERIC)), 2) as average_income,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2) as median_income,
    ROUND(AVG(CAST(baseline_income AS NUMERIC)), 2) as mean_income,
    
    -- Range statistics
    ROUND(MIN(CAST(baseline_income AS NUMERIC)), 2) as min_income,
    ROUND(MAX(CAST(baseline_income AS NUMERIC)), 2) as max_income,
    ROUND(MAX(CAST(baseline_income AS NUMERIC)) - MIN(CAST(baseline_income AS NUMERIC)), 2) as income_range,
    
    -- Dispersion statistics
    ROUND(STDDEV(CAST(baseline_income AS NUMERIC)), 2) as income_standard_deviation,
    ROUND(VARIANCE(CAST(baseline_income AS NUMERIC)), 2) as income_variance,
    
    -- Percentiles
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2) as q1_income,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CAST(baseline_income AS NUMERIC)), 2) as q3_income,
    
    -- Count statistics
    COUNT(*) as total_records,
    COUNT(baseline_income) as records_with_income_data,
    COUNT(*) - COUNT(baseline_income) as records_without_income_data,
    ROUND((COUNT(baseline_income)::NUMERIC / COUNT(*)) * 100, 2) as data_completeness_percentage

FROM (
    -- Replace this with your actual unified query or table reference
    SELECT baseline_income
    FROM your_unified_table  -- Replace with actual table name
    WHERE baseline_income IS NOT NULL 
      AND baseline_income != '' 
      AND baseline_income ~ '^[0-9]+\.?[0-9]*$'  -- Only numeric values
) income_data;
