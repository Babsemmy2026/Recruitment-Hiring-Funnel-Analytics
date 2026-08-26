# Recruitment-Hiring-Funnel-Analytics

SQL and Power BI analysis of a 10,000-candidate recruitment funnel, identifying hiring bottlenecks, source performance, recruiter performance, time-to-hire, and recruitment costs.

# Project Overview

Recruitment teams need to understand where candidates are lost, which sourcing channels produce the strongest candidates, how long hiring takes, and where recruitment costs are highest.

This project analyzes a recruitment dataset of **10,000 candidates** to evaluate the hiring funnel, recruitment sources, departmental hiring efficiency, recruiter performance, hiring costs, and time-to-hire.

---
# Business Problem

The organization experienced pipeline drop-offs and needed visibility into recruitment duration and cost drivers. This project addresses six primary business questions:

- Which recruitment source yields the highest conversion rate?
- What is the overall and departmental average time-to-hire?
- Where is the largest candidate drop-off in the recruitment funnel?
- Which department has the highest hiring cost?
- Which recruiter performs best?
- How can recruitment efficiency be improved?/What strategic actions can optimize overall recruitment efficiency?
---

# Objective

The objective of this project is to analyze the end-to-end recruitment funnel and answer key business questions around:

Candidate conversion: Where do candidates drop out of the recruitment process?
Source effectiveness: Which recruitment channels generate the highest-quality candidates?
Hiring efficiency: How long does it take to move candidates from application to hire?
Cost efficiency: Which departments have the highest hiring costs?
Recruiter performance: Which recruiters achieve stronger conversion, speed, and cost outcomes?

The analysis uses SQL for data auditing, cleaning, transformation, and analysis, and Power BI to visualize the findings and communicate actionable insights to HR stakeholders.

---
## Dataset

The dataset contains **10,000 recruitment records** covering the candidate journey from application through hiring.

Key fields include:

- Candidate ID
- Application Date
- Screening Date
- Interview Date
- Offer Date
- Hire Date
- Candidate Status
- Recruitment Source
- Recruiter
- Department
- Hiring Cost
- Job Role
- Time-to-Hire
--- 
## Project Workflow

# 1. Data Audit

Before cleaning the data, an SQL audit was performed to assess data quality and consistency.

### Audit Results

| Audit Check | Result | Interpretation |
|---|---:|---|
| Total Rows | 10,000 | Dataset size confirmed |
| Duplicate Candidate IDs | 0 | No duplicate IDs identified |
| Missing Application Dates | 0 | Complete |
| Missing Screening Dates | 7,230 | Structural missingness |
| Missing Interview Dates | 1,286 | Structural missingness |
| Missing Offer Dates | 958 | Structural missingness |
| Missing Hire Dates | 112 | Structural missingness |
| Invalid Date Sequences | 0 | Chronology consistent |
| Negative Durations | 0 | No invalid durations |
| Negative Salary/Cost Values | 0 | No negative values identified |

Missing stage dates were treated as **structural missingness** because candidates who did not progress to a particular recruitment stage naturally had no corresponding date.

# 2. Data Cleaning

SQL was used to create a cleaned analytical table called:

`recruitment_cleaned`

The cleaning process included:

- Converting text-based date fields into valid date values
- Validating recruitment date sequences
- Checking for duplicate Candidate IDs
- Handling missing recruitment-stage dates
- Standardizing analytical fields
- Creating recruitment funnel flags
- Calculating recruitment-stage durations
- Creating a calculated time-to-hire field
- Creating a hired flag for analysis

### Derived Fields

The cleaned dataset contains additional analytical fields including:

- `Application_to_Screen_Days`
- `Screen_to_Interview_Days`
- `Interview_to_Offer_Days`
- `Offer_to_Hire_Days`
- `Calculated_Time_to_Hire_Days`
- `Reached_Screening`
- `Reached_Interview`
- `Received_Offer`
- `Hired_Flag`

# Key Performance Indicators

The overall recruitment performance was:

| KPI | Result |
|---|---:|
| Total Applicants | **10,000** |
| Total Hires | **414** |
| Overall Hire Rate | **4.14%** |
| Offer-to-Hire Rate | **78.71%** |
| Average Time-to-Hire | **33.08 days** |
| Total Hiring Cost | **€1,545,251** |
| Average Cost per Hire | **€3,732.49** |

> Note: Offer-to-Hire Rate is used as a proxy for offer acceptance/conversion because the dataset does not contain a separate offer acceptance field.
---
# Recruitment Funnel Analysis

The recruitment funnel shows significant candidate drop-off at multiple stages.

| Funnel Stage | Candidates | Conversion from Previous Stage |
|---|---:|---:|
| Applicants | 10,000 | — |
| Screening | 2,770 | 27.70% |
| Interview | 1,484 | 53.57% |
| Offer | 526 | 35.44% |
| Hired | 414 | 78.71% |

--- 

# Power BI Dashboard
## Page 1 — Recruitment & Hiring Funnel Overview
The first page provides an overall recruitment performance view.

### KPIs

- Total Applicants
- Total Hires
- Overall Hire Rate
- Average Time-to-Hire
- Average Cost per Hire

### Visuals

- Hiring Funnel
- Recruitment Source Performance
- Time-to-Hire by Department
- Recruiter Performance
- Monthly Hiring Trend

### Filters

- Department
- Recruitment Source
- Recruiter
- Job Role

<img width="596" height="338" alt="image" src="https://github.com/user-attachments/assets/99688a11-1c19-40c5-b780-42bd97e0ac04" />

------

## Page 2 — Recruitment Insights & Recommendations
The second page focuses on business interpretation and decision support.

### Key Visuals

- Recruitment Funnel Drop-off
- Average Cost per Hire by Department
- Recruitment Source Hire Rate
- Recruiter Performance
- Key Recruitment Recommendations

<img width="590" height="334" alt="image" src="https://github.com/user-attachments/assets/f0b9b0a2-6ab0-4fef-b989-bc2843dbd173" />

---
# Business Recommendations

## Funnel Drop-off Profile
The primary bottleneck occurs between Application and Screening, where 72.30% of candidates drop out (10,000 applicants $\rightarrow$ 2,770 screened). A secondary drop-off occurs between Interview and Offer, where 35.44% of interviewed candidates receive an offer. The strongest progression is observed between Offer and Hire at 78.71%.

## Sourcing Channel Efficacy
Employee Referral is the highest-converting sourcing channel with a 5.94% hire rate. While LinkedIn generates the highest volume of hires (103), its conversion rate (4.17%) is diluted by larger applicant volume. Broad job channels like Social Media yield the lowest conversion at 2.74%.

## Departmental Cost & Speed Dynamics
Cost: Operations incurs the highest average cost per hire at €4,082.12, compared to Technology at €3,412.77.

Speed: Time-to-hire across departments is relatively uniform, ranging from 31.78 days (Technology) to 34.48 days (Human Resources), indicating that process delays are driven by funnel bottlenecks rather than departmental variances.

## Recruiter Performance Benchmark
Michael Wagner demonstrated peak performance across all evaluated metrics (minimum 100 candidates managed), achieving a 4.88% hire rate, 31.84 days average time-to-hire, and an average cost per hire of €3,373.86.

# Strategic Recommendations
## Standardize Initial Candidate Screening: 
Address the 72.30% initial drop-off by refining role profiles and introducing automated pre-screening assessments to filter low-fit applications.

## Optimize Channel Budget Allocation: 
Shift recruitment spend toward high-yielding channels like Employee Referrals and review the cost-effectiveness of third-party agencies and low-converting broad job boards.

## Audit Operations Department Sourcing: 
Investigate sourcing channels and assessment workflows within Operations to align its €4,082.12 average cost per hire with the broader organizational baseline.

## Scale Recruiter Best Practices: 
Standardize candidate management and sourcing workflows modeled after top-performing recruiter practices across the broader hiring team.

---
# Tools & Technologies

- **MySQL** — Data auditing, cleaning, transformation and analysis
- **Power BI** — Interactive visual dashboards, DAX modeling, and custom recommendations panel
- **SQL** — CTEs, CASE WHEN, Aggregations, Window Functions, Date Calculations, Data Profiling
- **GitHub** — Project documentation and portfolio presentation
  
----

# Author

## Barbara Dixon

Data Analyst | SQL | Power BI | Data Analytics

This project is part of my data analytics portfolio and demonstrates my ability to work through a complete analytics workflow:

## Business Problem → Data Audit → Data Cleaning → SQL Analysis → KPI Development → Power BI Dashboard → Business Recommendations
