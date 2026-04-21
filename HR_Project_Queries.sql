/* 
PROJECT 1: HR ANALYTICS DASHBOARD 
Goal: Identify drivers of employee attrition.
Author: [Your Name]
*/

-- Step 1: Data Transformation for Power BI
-- We create a View to clean labels and handle categories for visualization
DROP VIEW IF EXISTS public.vw_HR_Analytics_Cleaned;

CREATE OR REPLACE VIEW public.vw_HR_Analytics_Cleaned AS
SELECT 
    employeenumber,
    CASE 
        WHEN Age < 25 THEN '18-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+' 
    END AS AgeGroup,
    Gender,
    Department,
    EducationField,
    CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS AttritionCount,
    Attrition,
    COALESCE(OverTime, 'No') AS OverTimeStatus,
    MonthlyIncome,
    TotalWorkingYears,
    YearsAtCompany
FROM public.hr_data
WHERE employeenumber IS NOT NULL;

-- Step 2: Exploratory Analysis (Key Insights)
-- This query identifies the impact of Overtime on Attrition
SELECT 
    OverTime, 
    Attrition, 
    COUNT(*) as EmployeeCount
FROM public.hr_data
GROUP BY OverTime, Attrition
ORDER BY OverTime;

-- This query looks at Attrition across specific Age Groups
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 45 THEN '30-45'
        ELSE 'Over 45'
    END as AgeGroup,
    COUNT(*) as Total,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) as LeftCompany
FROM public.hr_data
GROUP BY AgeGroup;
