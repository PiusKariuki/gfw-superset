-- WISALA Dashboard Flattened Dataset - Clean Version
-- Fixed structure to include all dependent categories

SELECT 
    ea.enrollment,
    ou.name as org_unit_name,
    ea.org_unit as org_unit_id,
    
    -- Hierarchy levels - showing the actual org unit at each level
    ou.level as org_unit_level,
    
    -- Level 2: Always Country
    COALESCE(
        CASE WHEN ou.level = 2 THEN ou.name END,
        CASE WHEN parent1.level = 2 THEN parent1.name END,
        CASE WHEN parent2.level = 2 THEN parent2.name END,
        CASE WHEN parent3.level = 2 THEN parent3.name END
    ) as level_2_country,
    
    -- Level 3: Cohort or Region 
    COALESCE(
        CASE WHEN ou.level = 3 THEN ou.name END,
        CASE WHEN parent1.level = 3 THEN parent1.name END,
        CASE WHEN parent2.level = 3 THEN parent2.name END
    ) as level_3_cohort_or_region,
    
    -- Level 4: Sub-region/Sub-county
    COALESCE(
        CASE WHEN ou.level = 4 THEN ou.name END,
        CASE WHEN parent1.level = 4 THEN parent1.name END
    ) as level_4_sub_region,
    
    -- Level 5: Region
    CASE WHEN ou.level = 5 THEN ou.name END as level_5_region,
    
    -- For dashboard filtering - use Level 2 as Country
    COALESCE(
        CASE WHEN ou.level = 2 THEN ou.name END,
        CASE WHEN parent1.level = 2 THEN parent1.name END,
        CASE WHEN parent2.level = 2 THEN parent2.name END,
        CASE WHEN parent3.level = 2 THEN parent3.name END,
        'Unknown Country'
    ) as country,
    
    -- For dashboard filtering - use Level 3 as Cohort/Region
    COALESCE(
        CASE WHEN ou.level = 3 THEN ou.name END,
        CASE WHEN parent1.level = 3 THEN parent1.name END,
        CASE WHEN parent2.level = 3 THEN parent2.name END,
        'No Cohort/Region'
    ) as cohort_or_region,
    
    -- Basic Demographics from Attributes
    ea.current_age,
    ea.date_of_birth,
    ea.first_name,
    ea.last_name,
    ea.email,
    ea.phone,
    ea.address,
    ea.national_id,
    ea.project,
    ea.gfw_internal_id,
    ea.wisala_id,
    ea.total_savings,
    
    -- Survey Data from Data Elements
    edv.age_widowed,
    edv.age_married,
    edv.reason_for_widowhood,
    edv.reason_for_joining_wisala,
    edv.dependents,
    edv.children_under_5,
    edv.children_5_to_18,
    edv.elderly_over_65,
    edv.other_disabled,
    edv.education_level,
    edv.literacy,
    edv.marriage_registered,
    edv.inherited_home,
    edv.inherited_land,
    edv.inherited_business,
    edv.inherited_financial,
    edv.who_inherited_land,
    edv.cultural_practices,
    edv.baseline_income,
    edv.baseline_income_activities,
    edv.baseline_savings,
    edv.baseline_bank_account,
    edv.baseline_ability_pay,
    edv.baseline_school_age_dependents,
    edv.baseline_school_attendance,
    edv.baseline_school_fees,
    edv.baseline_can_pay_education,
    edv.baseline_food_worry,
    edv.baseline_skip_meals,
    edv.baseline_whole_day_no_food,
    edv.baseline_ate_less,
    edv.baseline_can_pay_medical,
    edv.baseline_afford_medical,
    edv.baseline_feel_safe,
    edv.baseline_community_belonging,
    edv.post_intervention_community_belonging,
    edv.baseline_happiness,
    edv.post_intervention_happiness,
    edv.baseline_control_decisions,
    edv.post_intervention_control_decisions,
    edv.baseline_feel_respected,
    edv.post_intervention_feel_respected,
    edv.baseline_money_decisions,
    edv.post_intervention_money_decisions,
    edv.baseline_constitution_knowledge,
    edv.post_intervention_constitution_knowledge,
    edv.baseline_gender_equality_knowledge,
    edv.post_intervention_gender_equality_knowledge,
    edv.baseline_customary_laws_knowledge,
    edv.post_intervention_customary_laws_knowledge,
    edv.baseline_succession_laws_knowledge,
    edv.post_intervention_succession_laws_knowledge,
    edv.baseline_matrimonial_laws_knowledge,
    edv.post_intervention_matrimonial_laws_knowledge,
    edv.baseline_land_ownership_knowledge,
    edv.post_intervention_land_ownership_knowledge,
    edv.baseline_legal_empowerment,
    edv.post_intervention_legal_empowerment,
    
    -- Post-Intervention Changes and Impact (Post-Intervention Only)
    edv.changes_since_joining_wisala,
    edv.financial_improvement,
    edv.financial_deterioration,
    edv.nutrition_improvement,
    edv.nutrition_deterioration,
    edv.medical_ability_increase,
    edv.medical_ability_decrease,
    edv.education_payment_easier,
    edv.education_payment_difficult,
    edv.emotional_improvement,
    edv.emotional_deterioration,
    edv.rights_knowledge_increase,
    
    -- WISALA Money Usage and Asset Purchases (Post-Intervention Only)
    edv.first_thing_with_wisala_money,
    edv.second_thing_with_wisala_money,
    edv.able_to_purchase_assets,
    edv.purchased_home,
    edv.purchased_land,
    edv.purchased_livestock,
    edv.purchased_valuable_plants,
    edv.purchased_mobile_phone,
    edv.purchased_appliances,
    edv.opened_bank_account,
    edv.purchased_vehicle,
    edv.started_business,
    edv.business_with_wisala_borrowings,
    edv.recommend_wisala_to_other_widows,
    
    edv.post_income,
    edv.monthly_post_intervention_income,
    edv.post_intervention_savings,
    edv.post_intervention_ability_pay,
    edv.post_intervention_school_age_dependents,
    edv.post_intervention_school_attendance,
    edv.post_intervention_can_pay_education,
    edv.post_intervention_school_fees,
    edv.post_intervention_can_pay_medical,
    edv.post_bank_account,
    edv.post_opened_bank_account,
    edv.post_intervention_food_worry,
    edv.post_intervention_skip_meals,
    edv.post_intervention_whole_day_no_food,
    edv.changes_experienced,
    edv.purchased_assets,
    edv.what_assets,
    edv.recommend_wisala,
    edv.second_money_use,
    edv.how_learned_wisala,
    edv.reason_joining_other,
    edv.reason_joining_specify,
    
    -- Expense Data - Baseline
    edv.baseline_expense_bread,
    edv.baseline_expense_cereals,
    edv.baseline_expense_meat,
    edv.baseline_expense_housing,
    edv.baseline_expense_utilities,
    edv.baseline_expense_medical_adults,
    edv.baseline_expense_medical_children,
    edv.baseline_expense_medicine_adults,
    edv.baseline_expense_medicine_children,
    
    -- Expense Data - Post Intervention
    edv.post_intervention_expense_bread,
    edv.post_intervention_expense_cereals,
    edv.post_intervention_expense_meat,
    edv.post_intervention_expense_housing,
    edv.post_intervention_expense_utilities,
    edv.post_intervention_expense_medical_adults,
    edv.post_intervention_expense_medical_children,
    edv.post_intervention_expense_medicine_adults,
    edv.post_intervention_expense_medicine_children,
    
    -- Meat Consumption Frequency
    edv.baseline_meat_consumption_frequency,
    edv.post_intervention_meat_consumption_frequency,
    
    -- Expense in Food (only exists in baseline)
    edv.baseline_expense_food,
    
    -- Medical Expenses
    edv.baseline_medical_expenses,
    edv.post_intervention_medical_expenses,
    
    -- Ability to Pay for Housing Needs (only exists in post-intervention)
    edv.post_intervention_ability_pay_housing,
    
    -- Violence Experience
    edv.baseline_violence_experience,
    edv.post_intervention_violence_experience,
    
    -- Changes After Widowhood (Impact of Widowhood Analysis - All 9 Categories)
    edv.change_community_behavior,
    edv.change_dress,
    edv.change_eating_habits,
    edv.change_freedom_movement,
    edv.change_increase_violence

FROM (
    SELECT 
        av.enrollment,
        av.org_unit,
        MAX(CASE WHEN tea.display_name = 'Age in years العمر بالسنوات' THEN av.value END) as current_age,
        MAX(CASE WHEN tea.display_name = 'Date of Birth تاريخ الميلاد' THEN av.value END) as date_of_birth,
        MAX(CASE WHEN tea.display_name = 'First Name الاسم الأول' THEN av.value END) as first_name,
        MAX(CASE WHEN tea.display_name = 'Last Name اسم العائلة' THEN av.value END) as last_name,
        MAX(CASE WHEN tea.display_name = 'Email بريد إلكتروني' THEN av.value END) as email,
        MAX(CASE WHEN tea.display_name = 'Phone رقم التليفون' THEN av.value END) as phone,
        MAX(CASE WHEN tea.display_name = 'Location / Address عنوان' THEN av.value END) as address,
        MAX(CASE WHEN tea.display_name = 'National ID رقم الهوية الوطنية' THEN av.value END) as national_id,
        MAX(CASE WHEN tea.display_name = 'Project مشروع' THEN av.value END) as project,
        MAX(CASE WHEN tea.display_name = 'GFW Internal ID معرف داخلي لـ G.F.W.' THEN av.value END) as gfw_internal_id,
        MAX(CASE WHEN tea.display_name = 'WISALA ID هوية وصال' THEN av.value END) as wisala_id,
        MAX(CASE WHEN tea.display_name = 'Total Savings' THEN av.value END) as total_savings
    FROM attribute_values av
    JOIN tracked_entity_attributes tea ON av.attribute = tea.id
    GROUP BY av.enrollment, av.org_unit
) ea

LEFT JOIN (
    SELECT 
        e.enrollment,
        MAX(CASE WHEN de.name = 'BL-Age in which you became a widow?' OR de.id = 'age_widow_id' THEN dv.value END) as age_widowed,
        MAX(CASE WHEN de.name = 'BL-Age in which you were married?' OR de.id = 'age_married_id' THEN dv.value END) as age_married,
        MAX(CASE WHEN de.name = 'Reason for widowhood' THEN dv.value END) as reason_for_widowhood,
        MAX(CASE WHEN de.id = 'gBQBSQwOuC4' THEN dv.value END) as reason_for_joining_wisala,
        MAX(CASE WHEN de.name = 'How many dependents of school age children do you have? كم عدد المعالين من الأطفال في سن المدرسة لديك؟' THEN dv.value END) as dependents,
        MAX(CASE WHEN de.name = 'Children under 5' THEN dv.value END) as children_under_5,
        MAX(CASE WHEN de.name = 'Children 5 to 18' THEN dv.value END) as children_5_to_18,
        MAX(CASE WHEN de.name = 'Elderly over 65 years' THEN dv.value END) as elderly_over_65,
        MAX(CASE WHEN de.name = 'Other disabled' THEN dv.value END) as other_disabled,
        MAX(CASE WHEN de.name = 'Level of Education' THEN dv.value END) as education_level,
        MAX(CASE WHEN de.name = 'Are you able to read and/or write?' OR de.id = 'QNtD4slPwWu' THEN dv.value END) as literacy,
        MAX(CASE WHEN de.name = 'Was your marriage registered with your country''s government (did you have a marriage certificate)?' THEN dv.value END) as marriage_registered,
        MAX(CASE WHEN de.name = 'Did you inherit your husband''s: Home' THEN dv.value END) as inherited_home,
        MAX(CASE WHEN de.name = 'Did you inherit your husband''s: Land' THEN dv.value END) as inherited_land,
        MAX(CASE WHEN de.name = 'Did you inherit your husband''s: Business' THEN dv.value END) as inherited_business,
        MAX(CASE WHEN de.name = 'Did you inherit your husband''s: Bank account/financial assets' THEN dv.value END) as inherited_financial,
        MAX(CASE WHEN de.name = 'Who inherited your husband''s agricultural land? من ورث أرض زوجك الزراعية؟' THEN dv.value END) as who_inherited_land,
        MAX(CASE WHEN de.id = 'uPPP9PFgYE2' THEN dv.value END) as cultural_practices,
        MAX(CASE WHEN de.name = 'Income: What is your net income per month (local currency)?' THEN dv.value END) as baseline_income,
        MAX(CASE WHEN de.id = 'sEBmvKJ7dMu' THEN dv.value END) as baseline_income_activities,
        MAX(CASE WHEN de.id = 'tsVNAWBALre' AND e.program_stage IN ('glKRXmp3I9k') THEN dv.value END) as baseline_savings,
        MAX(CASE WHEN de.id = 'u0k18gR6UeP' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_bank_account,
        MAX(CASE WHEN de.id = 'NiWjENOliNL' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_ability_pay,
        MAX(CASE WHEN de.id = 'dLYeHIgbW5m' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[0-9]+$' THEN CAST(dv.value AS INTEGER) END) as baseline_school_age_dependents,
        MAX(CASE WHEN de.id = 'GNj9pNISlZX' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[0-9]+$' THEN CAST(dv.value AS INTEGER) END) as baseline_school_attendance,
        MAX(CASE WHEN de.id = 'q72P7dX5la6' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_school_fees,
        MAX(CASE WHEN de.id = 'Xg4WbsWBWvd' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_can_pay_education,
        MAX(CASE WHEN de.id = 'XUKGIGjlS04' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_food_worry,
        MAX(CASE WHEN de.id = 'idK1WA0I6lj' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_skip_meals,
        MAX(CASE WHEN de.id = 'h9RwWr2rgO4' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_whole_day_no_food,
        MAX(CASE WHEN de.name = '"Ate less ?"أيضاً ، بالتفكير حول ال 12 شهراً الماضية، هل حدث وأن أكلت أنت أو أي شخص  آخر في أسرتك أقل مما اعتقدتم أنكم يجب أن تأكلوا بسبب عدم توفر النقود الكافية أو المصادر  الأخرى للحصول على الطعام؟"' THEN dv.value END) as baseline_ate_less,
        MAX(CASE WHEN de.name = 'Are you able to pay for the fees surrounding the medical needs of yourself and your dependents?' THEN dv.value END) as baseline_can_pay_medical,
        MAX(CASE WHEN de.name = 'Can you afford to pay for your and your family''s medical needs?  هل تستطيعين دفع مصروفات الاحتياجات الطبية لك ولمن معك؟' THEN dv.value END) as baseline_afford_medical,
        MAX(CASE WHEN de.name = 'Do you feel safe in your home and community? هل تشعر بالأمان في منزلك ومجتمعك؟' THEN dv.value END) as baseline_feel_safe,
        MAX(CASE WHEN de.id = 'trJ9WfQ3Ahr' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_community_belonging,
        MAX(CASE WHEN de.id = 'trJ9WfQ3Ahr' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_community_belonging,
        MAX(CASE WHEN de.id = 'GzGKk9By7UK' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_happiness,
        MAX(CASE WHEN de.id = 'V4VipmbiD13' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_control_decisions,
        MAX(CASE WHEN de.id = 'v7QNAnNWfwB' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_feel_respected,
        MAX(CASE WHEN de.id = 'yoUIV1i6Iyp' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_money_decisions,
        
        -- Post-intervention versions
        MAX(CASE WHEN de.id = 'GzGKk9By7UK' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_happiness,
        MAX(CASE WHEN de.id = 'V4VipmbiD13' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_control_decisions,
        MAX(CASE WHEN de.id = 'v7QNAnNWfwB' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_feel_respected,
        MAX(CASE WHEN de.id = 'yoUIV1i6Iyp' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_money_decisions,
        
        -- Legal Knowledge (1-5 scale)
        MAX(CASE WHEN de.id = 'SGX8oljcisb' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_constitution_knowledge,
        MAX(CASE WHEN de.id = 'SGX8oljcisb' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_constitution_knowledge,
        MAX(CASE WHEN de.id = 'HLe5CYwi6Pt' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_gender_equality_knowledge,
        MAX(CASE WHEN de.id = 'HLe5CYwi6Pt' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_gender_equality_knowledge,
        MAX(CASE WHEN de.id = 'HaU8FDlSFyR' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_customary_laws_knowledge,
        MAX(CASE WHEN de.id = 'HaU8FDlSFyR' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_customary_laws_knowledge,
        MAX(CASE WHEN de.id = 'BEdEHGqpJdO' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_succession_laws_knowledge,
        MAX(CASE WHEN de.id = 'BEdEHGqpJdO' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_succession_laws_knowledge,
        MAX(CASE WHEN de.id = 'D42UaX0Ydr0' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_matrimonial_laws_knowledge,
        MAX(CASE WHEN de.id = 'D42UaX0Ydr0' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_matrimonial_laws_knowledge,
        MAX(CASE WHEN de.id = 'oPTM9v4wCax' AND e.program_stage = 'glKRXmp3I9k' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as baseline_land_ownership_knowledge,
        MAX(CASE WHEN de.id = 'oPTM9v4wCax' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[1-5]$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_land_ownership_knowledge,
        
        -- Legal Empowerment (not a number)
        MAX(CASE WHEN de.id = 'By6L7oP3mlK' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_legal_empowerment,
        MAX(CASE WHEN de.id = 'By6L7oP3mlK' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_legal_empowerment,
        
        -- Post-Intervention Changes and Impact (Post-Intervention Only)
        MAX(CASE WHEN de.id = 'IqrKlowanOs' THEN dv.value END) as changes_since_joining_wisala,
        MAX(CASE WHEN de.id = 'ZAOFNF0XSKb' THEN dv.value END) as financial_improvement,
        MAX(CASE WHEN de.id = 'RRi0ThhquZh' THEN dv.value END) as financial_deterioration,
        MAX(CASE WHEN de.id = 'ws9EOYTuJ39' THEN dv.value END) as nutrition_improvement,
        MAX(CASE WHEN de.id = 'Vec6MW4LbJa' THEN dv.value END) as nutrition_deterioration,
        MAX(CASE WHEN de.id = 'G8upm0LzCU1' THEN dv.value END) as medical_ability_increase,
        MAX(CASE WHEN de.id = 'Tk97BfeiY3N' THEN dv.value END) as medical_ability_decrease,
        MAX(CASE WHEN de.id = 'Z2wznEDrveB' THEN dv.value END) as education_payment_easier,
        MAX(CASE WHEN de.id = 'FziApQ5Nx4M' THEN dv.value END) as education_payment_difficult,
        MAX(CASE WHEN de.id = 'sTmpxflNhL7' THEN dv.value END) as emotional_improvement,
        MAX(CASE WHEN de.id = 'GGHxCks5aXZ' THEN dv.value END) as emotional_deterioration,
        MAX(CASE WHEN de.id = 'slsJy0N2G4E' THEN dv.value END) as rights_knowledge_increase,
        
        -- WISALA Money Usage and Asset Purchases (Post-Intervention Only)
        MAX(CASE WHEN de.id = 'u0Q4Mf1WcVf' THEN dv.value END) as first_thing_with_wisala_money,
        MAX(CASE WHEN de.id = 'un6B2QX85qn' THEN dv.value END) as second_thing_with_wisala_money,
        MAX(CASE WHEN de.id = 'm960CyoAFH4' THEN dv.value END) as able_to_purchase_assets,
        MAX(CASE WHEN de.id = 'CE7j9FfdNo7' THEN dv.value END) as purchased_home,
        MAX(CASE WHEN de.id = 'hsUxqD4DCT8' THEN dv.value END) as purchased_land,
        MAX(CASE WHEN de.id = 'IVR3A7Ok5cq' THEN dv.value END) as purchased_livestock,
        MAX(CASE WHEN de.id = 'Hfi1OTaEXEj' THEN dv.value END) as purchased_valuable_plants,
        MAX(CASE WHEN de.id = 'ANeKcy4Vuum' THEN dv.value END) as purchased_mobile_phone,
        MAX(CASE WHEN de.id = 'VQsmF98Rj9f' THEN dv.value END) as purchased_appliances,
        MAX(CASE WHEN de.id = 'Xlg4mUtcMYQ' THEN dv.value END) as opened_bank_account,
        MAX(CASE WHEN de.id = 'X4oDkFVr3EW' THEN dv.value END) as purchased_vehicle,
        MAX(CASE WHEN de.id = 'Wy8xSvKUt5i' THEN dv.value END) as started_business,
        MAX(CASE WHEN de.id = 'uIs40SzzXCG' THEN dv.value END) as business_with_wisala_borrowings,
        MAX(CASE WHEN de.id = 'HP3Bz3ycb3l' THEN dv.value END) as recommend_wisala_to_other_widows,
        
        MAX(CASE WHEN de.name = 'PS- Specify - Income' THEN dv.value END) as post_income,
        MAX(CASE WHEN de.id = 'sAHilA2M5uA' THEN dv.value END) as monthly_post_intervention_income,
        MAX(CASE WHEN de.id = 'tsVNAWBALre' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_savings,
        MAX(CASE WHEN de.id = 'NiWjENOliNL' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_ability_pay,
        MAX(CASE WHEN de.id = 'dLYeHIgbW5m' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[0-9]+$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_school_age_dependents,
        MAX(CASE WHEN de.id = 'Pt0rA8uace9' AND e.program_stage = 'Xd5D2XCaPZH' AND dv.value ~ '^[0-9]+$' THEN CAST(dv.value AS INTEGER) END) as post_intervention_school_attendance,
        MAX(CASE WHEN de.id = 'Xg4WbsWBWvd' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_can_pay_education,
        MAX(CASE WHEN de.id = 'q72P7dX5la6' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_school_fees,
        MAX(CASE WHEN de.id = 'YUzsDhqu8qk' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_can_pay_medical,
        MAX(CASE WHEN de.id = 'u0k18gR6UeP' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_bank_account,
        MAX(CASE WHEN de.name = 'PS - Have you opened a bank / digital banking account since joining the WISALA?' THEN dv.value END) as post_opened_bank_account,
        MAX(CASE WHEN de.name = 'PS - Have you experienced any changes since you joined the WISALA?' THEN dv.value END) as changes_experienced,
        MAX(CASE WHEN de.name = 'PS - Were you able to purchase assets since joining your WISALA?' THEN dv.value END) as purchased_assets,
        MAX(CASE WHEN de.name = 'What assets have you been able to purchase? (select all that apply)' THEN dv.value END) as what_assets,
        MAX(CASE WHEN de.name = 'PS - Would you recommend the WISALA to other widows?' THEN dv.value END) as recommend_wisala,
        MAX(CASE WHEN de.name = 'PS -  What was the SECOND thing that you did with the money you borrowed from your WISALA?' THEN dv.value END) as second_money_use,
        MAX(CASE WHEN de.name = 'How did you learn about the WISALA?' THEN dv.value END) as how_learned_wisala,
        MAX(CASE WHEN de.name = 'GFW -Reason for joining WISALA- Other' THEN dv.value END) as reason_joining_other,
        MAX(CASE WHEN de.name = 'GFW -Reason for joining WISALA- Specify' THEN dv.value END) as reason_joining_specify,
        -- Baseline Expense Data
        MAX(CASE WHEN de.id = 'jGcxY3sxwKQ' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_bread,
        MAX(CASE WHEN de.id = 'JYT6vCeosTj' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_cereals,
        MAX(CASE WHEN de.id = 'XBhYXv3XSRB' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_meat,
        MAX(CASE WHEN de.id = 'xKrdsTYZYUP' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_housing,
        MAX(CASE WHEN de.id = 'c6RyAoD47m7' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_utilities,
        MAX(CASE WHEN de.id = 'MKz7tvJ8OvV' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_medical_adults,
        MAX(CASE WHEN de.id = 'GLUdhg9w9Tt' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_medical_children,
        MAX(CASE WHEN de.id = 'vBfZS1txgQp' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_medicine_adults,
        MAX(CASE WHEN de.id = 'qD0ADXxxYJd' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_expense_medicine_children,
        
        -- Post Intervention Expense Data
        MAX(CASE WHEN de.id = 'jGcxY3sxwKQ' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_bread,
        MAX(CASE WHEN de.id = 'JYT6vCeosTj' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_cereals,
        MAX(CASE WHEN de.id = 'XBhYXv3XSRB' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_meat,
        MAX(CASE WHEN de.id = 'xKrdsTYZYUP' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_housing,
        MAX(CASE WHEN de.id = 'c6RyAoD47m7' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_utilities,
        MAX(CASE WHEN de.id = 'MKz7tvJ8OvV' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_medical_adults,
        MAX(CASE WHEN de.id = 'GLUdhg9w9Tt' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_medical_children,
        MAX(CASE WHEN de.id = 'vBfZS1txgQp' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_medicine_adults,
        MAX(CASE WHEN de.id = 'qD0ADXxxYJd' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_expense_medicine_children,
        
        -- Post Intervention Food Security
        MAX(CASE WHEN de.id = 'XUKGIGjlS04' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_food_worry,
        MAX(CASE WHEN de.id = 'idK1WA0I6lj' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_skip_meals,
        MAX(CASE WHEN de.id = 'h9RwWr2rgO4' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_whole_day_no_food,
        
        -- Meat Consumption Frequency
        MAX(CASE WHEN de.id = 'YF6VOJJsoFZ' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_meat_consumption_frequency,
        MAX(CASE WHEN de.id = 'DHLgUqTRFOH' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_meat_consumption_frequency,
        
        -- Expense in Food (only exists in baseline)
        MAX(CASE WHEN de.id = 'OikdE5316F5' AND dv.value ~ '^[0-9]+\.?[0-9]*$' THEN CAST(dv.value AS NUMERIC) END) as baseline_expense_food,
        
        -- Medical Expenses
        MAX(CASE WHEN de.id = 'GhqBTq0eSty' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_medical_expenses,
        MAX(CASE WHEN de.id = 'GhqBTq0eSty' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_medical_expenses,
        
        -- Ability to Pay for Housing Needs (only exists in post-intervention)
        MAX(CASE WHEN de.id = 'WX4O5IMxYAH' THEN dv.value END) as post_intervention_ability_pay_housing,
        
        -- Violence Experience
        MAX(CASE WHEN de.id = 'JcAcUNwBKWU' AND e.program_stage = 'glKRXmp3I9k' THEN dv.value END) as baseline_violence_experience,
        MAX(CASE WHEN de.id = 'kKUOjTevGLo' AND e.program_stage = 'Xd5D2XCaPZH' THEN dv.value END) as post_intervention_violence_experience,
        
        MAX(CASE WHEN de.name = 'A change in community behavior' THEN dv.value END) as change_community_behavior,
        MAX(CASE WHEN de.name = 'A change in dress' THEN dv.value END) as change_dress,
        MAX(CASE WHEN de.name = 'A change in eating habits' THEN dv.value END) as change_eating_habits,
        MAX(CASE WHEN de.name = 'A change in freedom of movement in your community' THEN dv.value END) as change_freedom_movement,
        MAX(CASE WHEN de.name = 'An increase in violence' THEN dv.value END) as change_increase_violence
    FROM events e
    JOIN data_values dv ON e.event = dv.event
    JOIN data_elements de ON dv.data_element = de.id
    GROUP BY e.enrollment
) edv ON ea.enrollment = edv.enrollment

LEFT JOIN org_units ou ON ea.org_unit = ou.id
LEFT JOIN org_units parent1 ON ou.parent_id = parent1.id
LEFT JOIN org_units parent2 ON parent1.parent_id = parent2.id
LEFT JOIN org_units parent3 ON parent2.parent_id = parent3.id

WHERE ea.enrollment IS NOT NULL