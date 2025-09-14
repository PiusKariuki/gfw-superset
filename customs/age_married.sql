CASE 
    -- Only process non-null, non-empty values that are numeric
    WHEN age_married IS NOT NULL AND age_married != '' AND age_married ~ '^[0-9]+$' THEN
        CASE 
            WHEN age_married::INTEGER < 18 THEN 'Under 18'
            WHEN age_married::INTEGER BETWEEN 18 AND 34 THEN '18-34'
            WHEN age_married::INTEGER BETWEEN 35 AND 54 THEN '35-54'
            WHEN age_married::INTEGER BETWEEN 55 AND 64 THEN '55-64'
            WHEN age_married::INTEGER >= 65 THEN '65+'
        END
END
