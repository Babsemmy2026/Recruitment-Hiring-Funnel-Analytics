# Recruitment-Hiring-Funnel-Analytics
SQL and Power BI analysis of a 10,000-candidate recruitment funnel, identifying hiring bottlenecks, source performance, recruiter performance, time-to-hire, and recruitment costs.

# Project Overview

Recruitment teams need to understand where candidates are lost, which sourcing channels produce the strongest candidates, how long hiring takes, and where recruitment costs are highest.

This project analyzes a recruitment dataset of **10,000 candidates** to evaluate the hiring funnel, recruitment sources, departmental hiring efficiency, recruiter performance, hiring costs, and time-to-hire.

The analysis was performed using **MySQL for data auditing, cleaning, and analysis** and **Power BI for interactive dashboarding and visualization**.
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
# Dashboard Previews
## Page 1 — Recruitment & Hiring Funnel Overview
Focuses on pipeline volume, source performance, hiring speed, and recruiter conversion metrics.

<img width="596" height="338" alt="image" src="https://github.com/user-attachments/assets/99688a11-1c19-40c5-b780-42bd97e0ac04" />

## Page 2 — Recruitment Insights & Recommendations
Focuses on drop-off analysis, departmental cost distribution, and actionable recommendations.

<img width="590" height="334" alt="image" src="https://github.com/user-attachments/assets/f0b9b0a2-6ab0-4fef-b989-bc2843dbd173" />

---
# Summary of Analytical Insights
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

Barbara Dixon

Aspiring Data Analyst | SQL | Power BI | Data Analytics

This project is part of my data analytics portfolio and demonstrates my ability to work through a complete analytics workflow:

Business Problem → Data Audit → Data Cleaning → SQL Analysis → KPI Development → Power BI Dashboard → Business Recommendations
