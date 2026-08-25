USE recruiting;

-- Standardizing categories
-- Recruitment sources
SELECT
    Recruitment_Source,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Recruitment_Source
ORDER BY Recruitment_Source;

-- Dept
SELECT
    Department,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Department
ORDER BY Department;

-- Candidate status
SELECT
    Candidate_Status,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Candidate_Status
ORDER BY Candidate_Status DESC;

-- Educational level
SELECT
    Education_Level,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Education_Level
ORDER BY Education_Level;

-- Experience level
SELECT
    Experience_Level,
    COUNT(*) AS candidate_count
FROM recruitment
GROUP BY Experience_Level
ORDER BY Experience_Level;

-- checking if the date columns are formated as dates
SELECT
    Candidate_ID,
    Application_Date,
    Screening_Date,
    Interview_Date,
    Offer_Date,
    Hire_Date
FROM recruitment
WHERE
    Screening_Date = ''
    OR Interview_Date = ''
    OR Offer_Date = ''
    OR Hire_Date = '';   -- NOT Formated
    
SELECT DISTINCT Screening_Date
FROM recruitment
ORDER BY Screening_Date;

SELECT DISTINCT Interview_Date
FROM recruitment
ORDER BY Interview_Date;

SELECT DISTINCT Offer_Date
FROM recruitment
ORDER BY Offer_Date;

SELECT DISTINCT Hire_Date
FROM recruitment
ORDER BY Hire_Date;  

DESCRIBE recruitment;

-- Confirming the text date format
SELECT
    Application_Date,
    Screening_Date,
    Interview_Date,
    Offer_Date,
    Hire_Date
FROM recruitment
LIMIT 10;

DESCRIBE recruitment;

-- Create a cleaned table. Note: Dates are stored as text here
CREATE TABLE recruitment_cleaned AS

SELECT
    Candidate_ID,
    Job_ID,

    /* =========================
       STANDARDIZE TEXT FIELDS
       ========================= */

    TRIM(Recruitment_Source) AS Recruitment_Source,
    TRIM(Department) AS Department,
    TRIM(Job_Role) AS Job_Role,
    TRIM(Location) AS Location,
    TRIM(Education_Level) AS Education_Level,
    TRIM(Experience_Level) AS Experience_Level,
    TRIM(Recruiter) AS Recruiter,

    /* =========================
       CONVERT TEXT TO DATE
       ========================= */

    STR_TO_DATE(
        NULLIF(TRIM(Application_Date), ''),
        '%Y-%m-%d'
    ) AS Application_Date,

    STR_TO_DATE(
        NULLIF(TRIM(Screening_Date), ''),
        '%Y-%m-%d'
    ) AS Screening_Date,

    STR_TO_DATE(
        NULLIF(TRIM(Interview_Date), ''),
        '%Y-%m-%d'
    ) AS Interview_Date,

    STR_TO_DATE(
        NULLIF(TRIM(Offer_Date), ''),
        '%Y-%m-%d'
    ) AS Offer_Date,

    STR_TO_DATE(
        NULLIF(TRIM(Hire_Date), ''),
        '%Y-%m-%d'
    ) AS Hire_Date,
    /* =========================
       CANDIDATE OUTCOME
       ========================= */

    TRIM(Candidate_Status) AS Candidate_Status,
    TRIM(Rejection_Reason) AS Rejection_Reason,

    /* =========================
       FINANCIAL FIELDS
       ========================= */

    Offered_Salary_EUR,
    Hiring_Cost_EUR,

    /* Keep original duration fields
       for comparison/validation */

    Time_to_Screen_Days,
    Time_to_Interview_Days,
    Time_to_Offer_Days,
    Time_to_Hire_Days
FROM recruitment;

SELECT *
FROM recruitment_cleaned
LIMIT 10;

DESCRIBE recruitment_cleaned;

-- Validate the converted dates
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
FROM recruitment_cleaned;

-- creating the calculated fields
ALTER TABLE recruitment_cleaned

ADD COLUMN Application_to_Screen_Days INT,

ADD COLUMN Screen_to_Interview_Days INT,

ADD COLUMN Interview_to_Offer_Days INT,

ADD COLUMN Offer_to_Hire_Days INT,

ADD COLUMN Calculated_Time_to_Hire_Days INT,

ADD COLUMN Reached_Screening INT,

ADD COLUMN Reached_Interview INT,

ADD COLUMN Received_Offer INT,

ADD COLUMN Hired_Flag INT;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Candidate_ID) AS unique_candidates
FROM recruitment_cleaned;

SHOW INDEX FROM recruitment_cleaned;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT Candidate_ID) AS unique_candidate_ids,
    COUNT(Candidate_ID) AS non_null_candidate_ids
FROM recruitment_cleaned;

ALTER TABLE recruitment_cleaned
MODIFY Candidate_ID VARCHAR(50) NOT NULL;

ALTER TABLE recruitment_cleaned
ADD PRIMARY KEY (Candidate_ID);

-- Populate
UPDATE recruitment_cleaned
SET
    Application_to_Screen_Days = CASE WHEN Screening_Date IS NOT NULL THEN DATEDIFF(Screening_Date, Application_Date) ELSE NULL END,
    Screen_to_Interview_Days = CASE WHEN Interview_Date IS NOT NULL AND Screening_Date IS NOT NULL 
    THEN DATEDIFF(Interview_Date, Screening_Date) ELSE NULL END,
    Interview_to_Offer_Days = CASE WHEN Offer_Date IS NOT NULL AND Interview_Date IS NOT NULL
            THEN DATEDIFF(Offer_Date, Interview_Date) ELSE NULL  END,
    Offer_to_Hire_Days = CASE WHEN Hire_Date IS NOT NULL AND Offer_Date IS NOT NULL
            THEN DATEDIFF(Hire_Date, Offer_Date) ELSE NULL END,
    Calculated_Time_to_Hire_Days = CASE WHEN Hire_Date IS NOT NULL THEN DATEDIFF(Hire_Date, Application_Date) ELSE NULL END,
    Reached_Screening = CASE WHEN Screening_Date IS NOT NULL THEN 1 ELSE 0 END,
    Reached_Interview = CASE WHEN Interview_Date IS NOT NULL THEN 1 ELSE 0 END,
    Received_Offer = CASE WHEN Offer_Date IS NOT NULL THEN 1 ELSE 0 END,
    Hired_Flag = CASE WHEN Candidate_Status = 'Hired' THEN 1 ELSE 0 END
WHERE Candidate_ID >= '';

-- Check the row count and funnel
SELECT
    COUNT(*) AS total_rows,
    SUM(Reached_Screening) AS screened,
    SUM(Reached_Interview) AS interviewed,
    SUM(Received_Offer) AS offers,
    SUM(Hired_Flag) AS hired
FROM recruitment_cleaned;

-- Check the calculated time-to-hire
SELECT
    MIN(Calculated_Time_to_Hire_Days) AS minimum_time_to_hire,
    MAX(Calculated_Time_to_Hire_Days) AS maximum_time_to_hire,
    AVG(Calculated_Time_to_Hire_Days) AS average_time_to_hire
FROM recruitment_cleaned
WHERE Hired_Flag = 1;     

-- Check for any negative calculated durations
  SELECT COUNT(*) AS invalid_durations
FROM recruitment_cleaned
WHERE Application_to_Screen_Days < 0
   OR Screen_to_Interview_Days < 0
   OR Interview_to_Offer_Days < 0
   OR Offer_to_Hire_Days < 0
   OR Calculated_Time_to_Hire_Days < 0; 
   
-- Check the data types one last time
DESCRIBE recruitment_cleaned;
