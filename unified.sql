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
    edv.baseline_bank_account,
    edv.baseline_ability_pay,
    edv.baseline_school_attendance,
    edv.baseline_school_fees,
    edv.baseline_can_pay_education,
    edv.baseline_food_worry,
    edv.baseline_skip_meals,
    edv.baseline_whole_day_no_food,
    edv.baseline_ate_less,
    edv.baseline_can_pay_medical,
    edv.baseline_afford_medical,
    edv.baseline_can_pay_housing,
    edv.baseline_violence,
    edv.baseline_feel_safe,
    edv.baseline_community_belonging,
    edv.baseline_happiness,
    edv.baseline_control_decisions,
    edv.baseline_feel_respected,
    edv.baseline_money_decisions,
    edv.baseline_constitution_knowledge,
    edv.baseline_gender_equality_knowledge,
    edv.baseline_customary_laws_knowledge,
    edv.baseline_succession_laws_knowledge,
    edv.baseline_matrimonial_laws_knowledge,
    edv.baseline_legal_empowerment,
    edv.post_income,
    edv.post_bank_account,
    edv.post_opened_bank_account,
    edv.post_violence,
    edv.changes_experienced,
    edv.purchased_assets,
    edv.what_assets,
    edv.recommend_wisala,
    edv.second_money_use,
    edv.how_learned_wisala,
    edv.reason_joining_other,
    edv.reason_joining_specify,
    edv.post_reduced_violence_vulnerability,
    
    -- Expense Data
    edv.expense_bread,
    edv.expense_cereals,
    edv.expense_meat,
    edv.expense_housing,
    edv.expense_utilities,
    edv.expense_medical_adults,
    edv.expense_medical_children,
    edv.expense_medicine_adults,
    edv.expense_medicine_children,
    
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
        MAX(CASE WHEN de.name = 'Are you currently engaged in any income-generation activities?' THEN dv.value END) as baseline_income_activities,
        MAX(CASE WHEN de.name = 'Do you have an account with a commercial bank or at the post office? عندك حساب في بنك أو في البريد/البوسطة؟' THEN dv.value END) as baseline_bank_account,
        MAX(CASE WHEN de.name = 'Do you now feel that you have ability to pay for things that you had been wanting or saving for ?' THEN dv.value END) as baseline_ability_pay,
        MAX(CASE WHEN de.name = 'How many of them are attending school regularly? كم عددهم يذهبون إلى المدرسة بانتظام؟' THEN dv.value END) as baseline_school_attendance,
        MAX(CASE WHEN de.name = 'BL-How much do you spend on school fees per month?' THEN dv.value END) as baseline_school_fees,
        MAX(CASE WHEN de.name = 'Are you able to pay for the fees surrounding the education of your dependents?' THEN dv.value END) as baseline_can_pay_education,
        MAX(CASE WHEN de.name = ' Not having  enough to eat "كنت أنت أو أي شخص آخر في أسرتك قلقون بشأن عدم توافر الطعام الكافي  بسبب عدم توفر النقود الكافية أو المصادر الأخرى للحصول على الطعام؟"' THEN dv.value END) as baseline_food_worry,
        MAX(CASE WHEN de.name = '"Skip a meal?" "هل مر وقت اضطررت فيه أنت أو غيرك من أفراد أسرتك أن تتخلوا عن وجبة طعام  بسبب عدم توفر النقود الكافية أو المصادر الأخرى للحصول على الطعام؟"' THEN dv.value END) as baseline_skip_meals,
        MAX(CASE WHEN de.name = '"Went without eating for a whole day" "هل حدث مرة أن بقيت أنت أو أي شخص آخر في أسرتك دون تناول الطعام ليوم كامل  بسبب عدم توفر النقود الكافية أو المصادر الأخرى للحصول على الطعام؟"' THEN dv.value END) as baseline_whole_day_no_food,
        MAX(CASE WHEN de.name = '"Ate less ?"أيضاً ، بالتفكير حول ال 12 شهراً الماضية، هل حدث وأن أكلت أنت أو أي شخص  آخر في أسرتك أقل مما اعتقدتم أنكم يجب أن تأكلوا بسبب عدم توفر النقود الكافية أو المصادر  الأخرى للحصول على الطعام؟"' THEN dv.value END) as baseline_ate_less,
        MAX(CASE WHEN de.name = 'Are you able to pay for the fees surrounding the medical needs of yourself and your dependents?' THEN dv.value END) as baseline_can_pay_medical,
        MAX(CASE WHEN de.name = 'Can you afford to pay for your and your family''s medical needs?  هل تستطيعين دفع مصروفات الاحتياجات الطبية لك ولمن معك؟' THEN dv.value END) as baseline_afford_medical,
        MAX(CASE WHEN de.name = 'Are you able to pay for the fees surrounding the housing needs of yourself and your dependents?' THEN dv.value END) as baseline_can_pay_housing,
        MAX(CASE WHEN de.name = 'Did you experience violence related to your widowhood?' THEN dv.value END) as baseline_violence,
        MAX(CASE WHEN de.name = 'Do you feel safe in your home and community? هل تشعر بالأمان في منزلك ومجتمعك؟' THEN dv.value END) as baseline_feel_safe,
        MAX(CASE WHEN de.name = 'Do you feel like you''re a part of your community? هل تشعرين بالانتماء للمجتمع ؟' THEN dv.value END) as baseline_community_belonging,
        MAX(CASE WHEN de.name = 'How happy to you feel?' THEN dv.value END) as baseline_happiness,
        MAX(CASE WHEN de.name = 'Do you feel that you have control over decisions that impact your everyday life? (1-5)' THEN dv.value END) as baseline_control_decisions,
        MAX(CASE WHEN de.name = 'How respected do you feel?' THEN dv.value END) as baseline_feel_respected,
        MAX(CASE WHEN de.name = 'Do you feel you have the ability to decide how money in your house is spent?' THEN dv.value END) as baseline_money_decisions,
        MAX(CASE WHEN de.name = 'I am knowledgeable of the national constitution' THEN dv.value END) as baseline_constitution_knowledge,
        MAX(CASE WHEN de.name = 'I know specific provisions in the constitution related to gender equality.' THEN dv.value END) as baseline_gender_equality_knowledge,
        MAX(CASE WHEN de.name = 'I understand the implications of customary laws regarding harmful traditional practices in my country' THEN dv.value END) as baseline_customary_laws_knowledge,
        MAX(CASE WHEN de.name = 'I know the laws of succession in my country and their relevance in property inheritance matters.' THEN dv.value END) as baseline_succession_laws_knowledge,
        MAX(CASE WHEN de.name = 'I am knowledgeable about matrimonial property laws in my country' THEN dv.value END) as baseline_matrimonial_laws_knowledge,
        MAX(CASE WHEN de.name = 'Do you feel empowered to pursue legal action to claim your husband''s inheritance and/or confront the perpetrators of violence against you ?' THEN dv.value END) as baseline_legal_empowerment,
        MAX(CASE WHEN de.name = 'PS- Specify - Income' THEN dv.value END) as post_income,
        MAX(CASE WHEN de.name = 'PS - Do you own a bank/mobile banking account?' THEN dv.value END) as post_bank_account,
        MAX(CASE WHEN de.name = 'PS - Have you opened a bank / digital banking account since joining the WISALA?' THEN dv.value END) as post_opened_bank_account,
        MAX(CASE WHEN de.name = 'PS -  Have you experienced violence related to your widowhood in the past 2 months?' THEN dv.value END) as post_violence,
        MAX(CASE WHEN de.name = 'PS - Have you experienced any changes since you joined the WISALA?' THEN dv.value END) as changes_experienced,
        MAX(CASE WHEN de.name = 'PS - Were you able to purchase assets since joining your WISALA?' THEN dv.value END) as purchased_assets,
        MAX(CASE WHEN de.name = 'What assets have you been able to purchase? (select all that apply)' THEN dv.value END) as what_assets,
        MAX(CASE WHEN de.name = 'PS - Would you recommend the WISALA to other widows?' THEN dv.value END) as recommend_wisala,
        MAX(CASE WHEN de.name = 'PS -  What was the SECOND thing that you did with the money you borrowed from your WISALA?' THEN dv.value END) as second_money_use,
        MAX(CASE WHEN de.name = 'How did you learn about the WISALA?' THEN dv.value END) as how_learned_wisala,
        MAX(CASE WHEN de.name = 'GFW -Reason for joining WISALA- Other' THEN dv.value END) as reason_joining_other,
        MAX(CASE WHEN de.name = 'GFW -Reason for joining WISALA- Specify' THEN dv.value END) as reason_joining_specify,
        MAX(CASE WHEN de.name = 'PS -  Do you feel that your current status of income and wealth has reduced your vulnerability to violence?' THEN dv.value END) as post_reduced_violence_vulnerability,
        MAX(CASE WHEN de.name = 'Amount spent on bread المبلغ الذي تم إنفاقه على الخبز' THEN dv.value END) as expense_bread,
        MAX(CASE WHEN de.name = 'Amount spent on cereals, such as rice or pasta المبلغ الذي تم إنفاقه على الحبوب، مثل الأرز أو المعكرونة' THEN dv.value END) as expense_cereals,
        MAX(CASE WHEN de.name = 'Amount spent on meat المبلغ الذي تم إنفاقه على اللحوم' THEN dv.value END) as expense_meat,
        MAX(CASE WHEN de.name = 'Amount of rent or other housing costs, including repairs مبلغ الإيجار أو تكاليف السكن الأخرى، بما في ذلك الإصلاحات' THEN dv.value END) as expense_housing,
        MAX(CASE WHEN de.name = 'Amount of Utilities (water, gas, electricity) كمية المرافق (المياه والغاز والكهرباء)' THEN dv.value END) as expense_utilities,
        MAX(CASE WHEN de.name = 'Amount spent on doctor, clinic, hospital or other medical service fees for adults المبلغ الذي تم إنفاقه على رسوم الطبيب أو العيادة أو المستشفى أو الخدمات الطبية الأخرى للبالغين' THEN dv.value END) as expense_medical_adults,
        MAX(CASE WHEN de.name = 'Amount spent on doctor, clinic, hospital or other medical service fees for children المبلغ الذي تم إنفاقه على رسوم الطبيب أو العيادة أو المستشفى أو الخدمات الطبية الأخرى للأطفال' THEN dv.value END) as expense_medical_children,
        MAX(CASE WHEN de.name = 'Amount spent on medicines for adults المبلغ الذي تم إنفاقه على الأدوية للبالغين' THEN dv.value END) as expense_medicine_adults,
        MAX(CASE WHEN de.name = 'Amount spent on Medicines for children المبلغ المنفق على أدوية الأطفال' THEN dv.value END) as expense_medicine_children,
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