USE recruiting;

select *
from recruitment;

/* =====================================================
   RECRUITMENT & HIRING FUNNEL ANALYTICS
   01 - DATA AUDIT
   Table: recruitment
   ===================================================== */

-- 1. Check the total number of records
  SELECT COUNT(*) AS total_rows
FROM recruitment;

-- 2. DUPLICATE CANDIDATE CHECK
SELECT
    Candidate_ID,
    COUNT(*) AS record_count
FROM recruitment
GROUP BY Candidate_ID
HAVING COUNT(*) > 1;

-- 3.Identify missing values 
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Candidate_ID IS NULL THEN 1 ELSE 0 END)
        AS missing_candidate_id,
    SUM(CASE WHEN Job_ID IS NULL THEN 1 ELSE 0 END)
        AS missing_job_id,
    SUM(CASE WHEN Application_Date IS NULL THEN 1 ELSE 0 END)
        AS missing_application_date,
    SUM(CASE WHEN Recruitment_Source IS NULL THEN 1 ELSE 0 END)
        AS missing_recruitment_source,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END)
        AS missing_department,
    SUM(CASE WHEN Recruiter IS NULL THEN 1 ELSE 0 END)
        AS missing_recruiter,
    SUM(CASE WHEN Screening_Date IS NULL THEN 1 ELSE 0 END)
        AS missing_screening_date,
    SUM(CASE WHEN Interview_Date IS NULL THEN 1 ELSE 0 END)
        AS missing_interview_date,
    SUM(CASE WHEN Offer_Date IS NULL THEN 1 ELSE 0 END)
        AS missing_offer_date,
    SUM(CASE WHEN Hire_Date IS NULL THEN 1 ELSE 0 END)
        AS missing_hire_date,
    SUM(CASE WHEN Candidate_Status IS NULL THEN 1 ELSE 0 END)
        AS missing_candidate_status
FROM recruitment;

-- 4. Check categorical values for inconsistencies  
--  Recruitment Sources 
SELECT
    Recruitment_Source,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Recruitment_Source
ORDER BY candidate_count DESC;

-- Departments 
SELECT
    Department,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Department
ORDER BY candidate_count DESC;

-- Candidate Status 
SELECT
    Candidate_Status,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Candidate_Status
ORDER BY candidate_count DESC;

-- Recruiters 
SELECT
    Recruiter,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Recruiter
ORDER BY candidate_count DESC;

-- 5. Period covered by the dataset
SELECT
    MIN(Application_Date) AS earliest_application,
    MAX(Application_Date) AS latest_application,
    MIN(Screening_Date) AS earliest_screening,
    MAX(Screening_Date) AS latest_screening,
    MIN(Interview_Date) AS earliest_interview,
    MAX(Interview_Date) AS latest_interview,
    MIN(Offer_Date) AS earliest_offer,
    MAX(Offer_Date) AS latest_offer,
    MIN(Hire_Date) AS earliest_hire,
    MAX(Hire_Date) AS latest_hire
FROM recruitment;

/* 6. DATE CONSISTENCY : Recruitment stages should follow a logical chronological sequence

   Application
        ↓
   Screening
        ↓
   Interview
        ↓
   Offer
        ↓
   Hire
   ===================================================== */

-- Screening should not happen before Application 
SELECT count(*)
FROM recruitment
WHERE Screening_Date < Application_Date;

-- Interview should not happen before Screening 
SELECT count(*)
FROM recruitment
WHERE Interview_Date < Screening_Date;

-- Offer should not happen before Interview 
SELECT count(*)
FROM recruitment
WHERE Offer_Date < Interview_Date;

-- Hire should not happen before Offer 
SELECT count(*)
FROM recruitment
WHERE Hire_Date < Offer_Date;

-- 7. CANDIDATE STATUS CONSISTENCY
-- Hired candidates should have a Hire Date 
SELECT *
FROM recruitment
WHERE Candidate_Status = 'Hired'
  AND Hire_Date IS NULL;

-- Non-hired candidates should not have a Hire Date 
SELECT count(*)
FROM recruitment
WHERE Candidate_Status <> 'Hired'
  AND Hire_Date IS NOT NULL;

-- Offer Declined candidates should have an Offer Date 
SELECT *
FROM recruitment
WHERE Candidate_Status = 'Offer Declined'
  AND Offer_Date IS NULL;


/* =====================================================
   8. FUNNEL CONSISTENCY
   Purpose: Check whether candidates progressed through
            the recruitment stages logically
   ===================================================== */
-- Interview should require a Screening Date 
SELECT *
FROM recruitment
WHERE Interview_Date IS NOT NULL
  AND Screening_Date IS NULL;

-- Offer should require an Interview Date 
SELECT *
FROM recruitment
WHERE Offer_Date IS NOT NULL
  AND Interview_Date IS NULL;

-- Hire should require an Offer Date 
SELECT *
FROM recruitment
WHERE Hire_Date IS NOT NULL
  AND Offer_Date IS NULL;
   
-- 9. Time durations cannot be negative
SELECT *
FROM recruitment
WHERE Time_to_Screen_Days < 0
   OR Time_to_Interview_Days < 0
   OR Time_to_Offer_Days < 0
   OR Time_to_Hire_Days < 0;


/* =====================================================
   10. TIME-TO-HIRE VALIDATION
   Purpose: Compare supplied Time_to_Hire_Days with
            the value calculated from the actual dates
   ===================================================== */
SELECT
    Candidate_ID,
    Application_Date,
    Hire_Date,
    Time_to_Hire_Days AS stored_time_to_hire,
    DATEDIFF(Hire_Date, Application_Date)
        AS calculated_time_to_hire
FROM recruitment
WHERE Hire_Date IS NOT NULL
  AND Time_to_Hire_Days <>
      DATEDIFF(Hire_Date, Application_Date);

/* =====================================================
   11. SALARY & COST VALIDATION
   Purpose: Identify impossible negative values
   ===================================================== */
SELECT *
FROM recruitment
WHERE Offered_Salary_EUR < 0
   OR Hiring_Cost_EUR < 0;

/* =====================================================
   12. RECRUITMENT FUNNEL VALIDATION
   Purpose: Validate progression through recruitment stages
   ===================================================== */  
SELECT 
    Candidate_Status,
    COUNT(*) AS total_applicants,
    SUM(CASE WHEN NULLIF(TRIM(Screening_Date), '') IS NOT NULL THEN 1 ELSE 0 END) AS screened,
    SUM(CASE WHEN NULLIF(TRIM(Interview_Date), '') IS NOT NULL THEN 1 ELSE 0 END) AS interviewed,
    SUM(CASE WHEN NULLIF(TRIM(Offer_Date), '') IS NOT NULL THEN 1 ELSE 0 END) AS offers,
    SUM(CASE WHEN NULLIF(TRIM(Hire_Date), '') IS NOT NULL THEN 1 ELSE 0 END) AS hired
FROM recruitment
GROUP BY Candidate_Status
ORDER BY total_applicants DESC;

/*
| Audit Check                  | Result | Interpretation                       |
| ---------------------------- | -----: | ------------------------------------ |
| Applicants                   | 10,000 | Total candidates                     |
| Reached Screening            |  2,770 | 27.7% of applicants                  |
| Reached Interview            |  1,484 | 53.6% of screened candidates         |
| Received Offer               |    526 | 35.4% of interviewed candidates      |
| Hired                        |    414 | 78.7% of candidates receiving offers |
| Rejected Offer			   |    112 | 21.3% of candidates receiving offers |
| Applicant-to-Hire Conversion |  4.14% | Overall funnel conversion            |

The missing recruitment-stage dates appear to represent structural missingness because candidates 
who did not progress to a particular recruitment stage appropriately lack a date for that stage. 
This was validated by comparing missing dates against Candidate_Status and the sequential recruitment stages. */

