USE recruiting;
/*
Five business questions to be answered
1. Which recruitment source produces the best candidates?
2. What is the average time-to-hire?
3. Which interview/recruitment stage loses the most candidates?
4. Which department has the highest hiring cost?
5. Which recruiter performs best?
*/

-- Overall Recruitment KPIs
SELECT
    COUNT(*) AS Total_Applicants,
    SUM(Hired_Flag) AS Total_Hires,
    ROUND(SUM(Hired_Flag) / COUNT(*) * 100, 2) AS Overall_Hire_Rate,
    ROUND(SUM(Hired_Flag) / NULLIF(SUM(Received_Offer), 0) * 100, 2) AS Offer_Acceptance_Rate,
    ROUND(AVG(CASE WHEN Hired_Flag = 1 THEN Calculated_Time_to_Hire_Days END), 2) AS Average_Time_to_Hire,
    ROUND(SUM(CASE WHEN Hired_Flag = 1 THEN Hiring_Cost_EUR ELSE 0 END), 2) AS Total_Hiring_Cost,
    ROUND(AVG(CASE WHEN Hired_Flag = 1 THEN Hiring_Cost_EUR END), 2) AS Average_Cost_Per_Hire
FROM recruitment_cleaned;

-- Which recruitment source produces the best candidates?
SELECT
    Recruitment_Source,
    COUNT(*) AS Applicants,
    SUM(Hired_Flag) AS Hires,
    ROUND(SUM(Hired_Flag) / COUNT(*) * 100, 2) AS Hire_Rate_Percent,
    ROUND(AVG(CASE WHEN Hired_Flag = 1 THEN Calculated_Time_to_Hire_Days END), 2) AS Average_Time_to_Hire,
    ROUND(AVG(CASE WHEN Hired_Flag = 1 THEN Hiring_Cost_EUR END), 2) AS Average_Cost_Per_Hire
FROM recruitment_cleaned
GROUP BY Recruitment_Source
ORDER BY Hire_Rate_Percent DESC;

-- Rank recruitment sources using windows function
WITH source_performance AS (
    SELECT
        Recruitment_Source,
        COUNT(*) AS Applicants,
        SUM(Hired_Flag) AS Hires,
        ROUND(SUM(Hired_Flag) / COUNT(*) * 100, 2) AS Hire_Rate_Percent
    FROM recruitment_cleaned
    GROUP BY Recruitment_Source)
SELECT
    Recruitment_Source,
    Applicants,
    Hires,
    Hire_Rate_Percent,
    RANK() OVER (ORDER BY Hire_Rate_Percent DESC) AS Source_Rank
FROM source_performance
ORDER BY Source_Rank;
     
-- Average time-to-hire
SELECT
    COUNT(*) AS Total_Hires,
    ROUND(
        AVG(Calculated_Time_to_Hire_Days), 2        
    ) AS Average_Time_to_Hire_Days,
    MIN(Calculated_Time_to_Hire_Days) AS Fastest_Hire,
    MAX(Calculated_Time_to_Hire_Days) AS Slowest_Hire
FROM recruitment_cleaned
WHERE Hired_Flag = 1;

-- Time-to-hire by department
SELECT
    Department,
    COUNT(*) AS Hires,
    ROUND(
        AVG(Calculated_Time_to_Hire_Days),2
           ) AS Average_Time_to_Hire_Days,
    MIN(Calculated_Time_to_Hire_Days) AS Fastest_Hire,
    MAX(Calculated_Time_to_Hire_Days) AS Slowest_Hire
FROM recruitment_cleaned
WHERE Hired_Flag = 1
GROUP BY Department
ORDER BY Average_Time_to_Hire_Days DESC;

-- Which Stage Loses the Most Candidates? (Recruitment funnel)
WITH funnel AS (
    SELECT
        COUNT(*) AS Applicants,
        SUM(Reached_Screening) AS Screened,
        SUM(Reached_Interview) AS Interviewed,
        SUM(Received_Offer) AS Offers,
        SUM(Hired_Flag) AS Hired
    FROM recruitment_cleaned)
SELECT
    Applicants,
    Screened,
    Interviewed,
    Offers,
    Hired,
    ROUND(Screened / Applicants * 100, 2) AS Applicant_to_Screen_Percent,
    ROUND(Interviewed / Screened * 100, 2) AS Screen_to_Interview_Percent,
    ROUND(Offers / Interviewed * 100, 2) AS Interview_to_Offer_Percent,
    ROUND(Hired / Offers * 100, 2) AS Offer_to_Hire_Percent
FROM funnel;

SELECT 
    Candidate_Status,
    COUNT(Candidate_ID) AS candidate_count,
    ROUND(COUNT(Candidate_ID) * 100.0 / (SELECT COUNT(*) FROM recruitment), 2) AS pct_of_total
FROM recruitment
GROUP BY Candidate_Status
ORDER BY candidate_count DESC;

-- Which department has the highest hiring cost?
SELECT 
    Department,
    SUM(Hiring_Cost_EUR) AS total_hiring_cost_eur,
    SUM(CASE WHEN Candidate_Status = 'Hired' THEN 1 ELSE 0 END) AS total_hires,
    ROUND(AVG(CASE WHEN Candidate_Status = 'Hired' THEN Hiring_Cost_EUR END), 2) AS avg_cost_per_hire_eur
FROM recruitment
GROUP BY Department
ORDER BY total_hiring_cost_eur DESC;

-- Which recruiter performs best?
SELECT 
    Recruiter,
    COUNT(Candidate_ID) AS candidates_managed,
    SUM(CASE WHEN Candidate_Status = 'Hired' THEN 1 ELSE 0 END) AS total_hires,
    ROUND(SUM(CASE WHEN Candidate_Status = 'Hired' THEN 1.0 ELSE 0 END) / COUNT(Candidate_ID) * 100, 2) AS conversion_rate_pct,
    ROUND(AVG(CASE WHEN Candidate_Status = 'Hired' THEN Time_to_Hire_Days END), 2) AS avg_time_to_hire_days,
    ROUND(SUM(Hiring_Cost_EUR) / SUM(CASE WHEN Candidate_Status = 'Hired' THEN 1 ELSE 0 END), 2) AS avg_cost_per_hire_eur
FROM recruitment
GROUP BY Recruiter
ORDER BY total_hires DESC;

WITH recruiter_performance AS (
    SELECT
        Recruiter,
        COUNT(*) AS Candidates_Managed,
        SUM(Hired_Flag) AS Total_Hires,
        ROUND(SUM(Hired_Flag) / COUNT(*) * 100,  2) AS Conversion_Rate_Percent,
        ROUND(AVG(CASE WHEN Hired_Flag = 1 THEN Calculated_Time_to_Hire_Days END), 2) AS Avg_Time_to_Hire_Days,
        ROUND(AVG(CASE WHEN Hired_Flag = 1 THEN Hiring_Cost_EUR END), 2) AS Avg_Cost_Per_Hire_EUR
    FROM recruitment_cleaned
    GROUP BY Recruiter
    HAVING COUNT(*) >= 100
    ),
ranked_recruiters AS (
    SELECT
        *,        
        RANK() OVER (ORDER BY Conversion_Rate_Percent DESC) AS Conversion_Rank,
        RANK() OVER (ORDER BY Avg_Time_to_Hire_Days ASC) AS Time_Rank,
        RANK() OVER (ORDER BY Avg_Cost_Per_Hire_EUR ASC) AS Cost_Rank
    FROM recruiter_performance
    )
SELECT
    Recruiter,
    Candidates_Managed,
    Total_Hires,
    Conversion_Rate_Percent,
    Avg_Time_to_Hire_Days,
    Avg_Cost_Per_Hire_EUR,
    Conversion_Rank,
    Time_Rank,
    Cost_Rank
FROM ranked_recruiters
ORDER BY Conversion_Rank;

-- Monthly Hiring Trend 
SELECT
    YEAR(Hire_Date) AS Hire_Year,
    MONTH(Hire_Date) AS Hire_Month,
    COUNT(*) AS Total_Hires
FROM recruitment_cleaned
WHERE Hired_Flag = 1
GROUP BY YEAR(Hire_Date), MONTH(Hire_Date)
ORDER BY Hire_Year, Hire_Month;
