# 📊 SQL Data Analyst Job Market Analysis

> **Exploring the Data Analyst job market through SQL** — uncovering top-paying roles, the most in-demand skills, and what it takes to land a high-salary remote position in 2023.

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat)
![Focus](https://img.shields.io/badge/Focus-Data%20Analyst%20Jobs-skyblue?style=flat)

---

## 📁 Table of Contents

- [1. Introduction](#1-introduction)
- [2. Background](#2-background)
- [3. Tools I Used](#3-tools-i-used)
- [4. The Analysis](#4-the-analysis)
- [5. What I Learned](#5-what-i-learned)
- [6. Conclusion](#6-conclusion)

---

## 1. Introduction

This project investigates the **2023 Data Analyst job market** using pure SQL. By querying a structured database of real job postings, this analysis answers three critical questions every aspiring data analyst asks:

- 💰 **Which Data Analyst roles pay the most?**
- 🛠️ **What skills do the highest-paying jobs require?**
- 🌐 **Which skills are most in demand for remote positions?**

The goal is not just to practice SQL — it's to produce **real, career-relevant insights** through structured querying, aggregation, and data storytelling.

---

## 2. Background

The data landscape is evolving fast. Companies are hiring Data Analysts across industries, but the skills they want — and the salaries they offer — vary enormously. A junior analyst and a Principal Data Analyst can sit in roles with nearly identical titles but salaries that differ by $400,000.

Understanding **what separates top-paying roles from average ones** is valuable intelligence. This project was built to surface that intelligence directly from job posting data using SQL — no dashboards, no drag-and-drop, just structured queries against a relational database.

The dataset includes:
- Job postings with title, location, salary, and remote-work flags
- A skills dimension table mapping skills to job postings
- Monthly partitioned posting tables for Q1 2023 (January, February, March)

**Core questions driving this analysis:**

| # | Question |
|---|----------|
| 1 | What are the top 10 highest-paying Data Analyst roles? |
| 2 | What skills are required by those top-paying jobs? |
| 3 | Which skills appear most in remote Data Analyst postings? |
| 4 | What salary thresholds define competitive Q1 2023 offers? |

---

## 3. Tools I Used

| Tool | Role in This Project |
|------|----------------------|
| **PostgreSQL** | Primary relational database engine |
| **SQL** | Querying, filtering, aggregating, and ranking job data |
| **CTEs** | Structuring complex multi-step logic cleanly |
| **INNER JOIN** | Linking job postings, skills, and company tables |
| **UNION / UNION ALL** | Combining monthly posting tables into quarterly datasets |
| **Subqueries** | Inline table creation for filtered aggregations |
| **GROUP BY + ORDER BY** | Ranking skills and salaries |
| **Python (matplotlib)** | Visualizing query results as charts |
| **Git & GitHub** | Version control and public portfolio sharing |

---

## 4. The Analysis

Each query in this project was built **incrementally** — starting with a basic structure and adding layers (filters, joins, aggregations) until the final answer was reached. This section documents every analysis performed.

---

### 🔍 Query 1 — Top 10 Highest-Paying Data Analyst Jobs

**Objective:** Find the 10 Data Analyst roles with the highest average yearly salary, including remote positions.

```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

**Results — Average Salary Distribution for Top 10 Paying Data Analyst Jobs:**

![Average Salary Distribution for Top 10 Paying Data Analyst Jobs in 2023](salary_distribution_skyblue.png)

**Key Findings:**
- The top-paying "Data Analyst" role reached **~$650,000/year** — a significant outlier driven by niche seniority or equity compensation
- **Director of Analytics** comes in second at ~$340,000, confirming that management-track roles command premium salaries
- All top 10 roles exceed **$190,000/year**, creating a clear salary floor for truly senior positions
- Remote and hybrid roles (flagged in job titles) appear multiple times in the top 10, confirming remote work does not penalize compensation

---

### 🔍 Query 2 — Skills Required by the Top-Paying Jobs

**Objective:** For the top 10 highest-paying Data Analyst roles identified above, find which skills are most commonly required.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```

**Results — Skill Count for Top 10 Paying Data Analyst Jobs:**

![Skill Count for Top 10 Paying Data Analyst Jobs in 2023](skill_count_chart_skyblue.png)

**Key Findings:**

| Rank | Skill | Frequency | Insight |
|------|-------|-----------|---------|
| 1 | **SQL** | 8/10 jobs | The non-negotiable foundation skill |
| 2 | **Python** | 7/10 jobs | Required for automation and advanced analysis |
| 3 | **Tableau** | 6/10 jobs | Data visualization is expected at the top tier |
| 4 | **R** | 4/10 jobs | Statistical modeling remains valued |
| 5 | **Snowflake** | 3/10 jobs | Cloud data warehousing is now mainstream |
| 5 | **Pandas** | 3/10 jobs | Python ecosystem depth matters |
| 5 | **Excel** | 3/10 jobs | Still present even at the highest salary levels |
| 8 | **Azure** | 2/10 jobs | Cloud platform fluency is a differentiator |
| 8 | **Bitbucket** | 2/10 jobs | Version control matters in data teams |
| 8 | **Go** | 2/10 jobs | Engineering-adjacent skills appear at senior levels |

> **SQL + Python + Tableau** form the core skill stack demanded by the highest-paying Data Analyst roles in 2023.

---

### 🔍 Query 3 — Top 5 In-Demand Skills for Remote Data Analyst Roles

**Objective:** Identify the 5 most frequently requested skills across all remote Data Analyst postings — not just the top 10, but the full market.

This query was built in 5 progressive steps:

**Step 1 — Basic skill-to-job mapping:**
```sql
SELECT
    skill_id,
    job_id
FROM
    skills_job_dim AS skills_to_job;
```

**Step 2 — Join job postings to skills:**
```sql
SELECT
    job_postings.job_id,
    skill_id
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id;
```

**Step 3 — Filter to remote jobs only:**
```sql
SELECT
    job_postings.job_id,
    skill_id,
    job_postings.job_work_from_home
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE;
```

**Step 4 — Aggregate skill counts for remote jobs:**
```sql
SELECT
    skill_id,
    COUNT(*) AS skill_count
FROM
    skills_job_dim AS skills_to_job
INNER JOIN job_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = TRUE
GROUP BY
    skill_id;
```

**Step 5 — Final CTE with skill names, filtered to Data Analyst, Top 5:**
```sql
WITH remote_job_skills AS (
    SELECT
        skill_id,
        COUNT(*) AS skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
        ON job_postings.job_id = skills_to_job.job_id
    WHERE
        job_postings.job_work_from_home = TRUE
        AND job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills
    ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;
```

**Finding:** SQL, Python, and Tableau dominate both the highest-paying roles and the broadest remote job market — confirming these are the core skills to prioritize.

---

### 🔍 Query 4 — Q1 2023 Data Analyst Jobs Paying Above $70,000

**Objective:** Combine job postings from January, February, and March 2023 into a unified quarterly dataset and surface Data Analyst roles with above-average salaries.

```sql
SELECT
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_via,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM (
    SELECT * FROM january_jobs
    UNION ALL
    SELECT * FROM february_jobs
    UNION ALL
    SELECT * FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000
    AND quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC;
```

**Why UNION ALL (not UNION)?**
`UNION ALL` preserves all rows including duplicates — correct here because we want every individual job posting counted, not a deduplicated set. `UNION` would silently drop legitimate duplicate postings from the salary ranking.

---

## 5. What I Learned

This project deepened both my SQL technique and my understanding of how to translate data into career insights.

**🧠 CTEs transform complex queries into readable logic**
Writing the remote skill analysis as a named CTE (`remote_job_skills`) made each step transparent and debuggable. The same result nested as a subquery would have been far harder to read and maintain.

**🔗 Strategic JOINs unlock cross-table insights**
Joining `job_postings_fact` → `skills_job_dim` → `skills_dim` required understanding how each table related to the others. Getting this right is what turned raw job IDs into readable skill names and salary figures.

**📦 UNION ALL vs UNION is a precision decision**
Running both versions revealed why the choice matters: `UNION` removes duplicates (useful for deduplication), while `UNION ALL` keeps everything (correct for salary ranking and counting). Using the wrong one silently corrupts results.

**🪜 Incremental query building is a professional discipline**
Every final query in this project started simple — one table, one column — and grew step by step. Validating each intermediate result before adding the next layer eliminated bugs early and built confidence in the final output.

**📊 SQL is a storytelling tool, not just a retrieval tool**
The most valuable output of this project isn't the queries themselves — it's the insight that **SQL + Python + Tableau** is the skill combination that unlocks the highest-paying Data Analyst roles. That's a career-actionable finding produced entirely through structured querying.

---

## 6. Conclusion

This project set out to answer what separates a $70,000 Data Analyst offer from a $650,000 one — and the SQL data tells a clear story.

**The findings in summary:**

✅ **SQL is non-negotiable** — it appears in 8 out of 10 top-paying Data Analyst jobs and leads demand across all remote postings

✅ **Python is the second must-have** — 7 of the top 10 jobs require it, and it's the bridge between data analysis and engineering-level automation

✅ **Tableau rounds out the core trio** — data visualization skills are expected at the highest compensation levels, not optional

✅ **Senior titles and cloud skills command premium pay** — Director-level roles and Snowflake/Azure fluency cluster around the $200,000–$340,000 band

✅ **Remote work doesn't reduce compensation** — hybrid and fully remote roles appear consistently at the top of the salary distribution

For anyone building a Data Analyst career in 2023 and beyond, the data is clear: **master SQL first, then Python, then Tableau** — and layer in cloud platforms and statistical tools as you advance.

---

## 📁 Project Structure

```
📂 sql-data-analyst-job-market/
│
├── 📄 special_m_session.sql          # Remote skills CTE + UNION quarterly analysis
├── 🖼️ salary_distribution_skyblue.png # Top 10 paying roles chart
├── 🖼️ skill_count_chart_skyblue.png   # Top 10 skills frequency chart
└── 📄 README.md                       # This file
```

---

## 🚀 How to Run

**Prerequisites:** PostgreSQL with the following tables loaded:

```
job_postings_fact    — Core job postings with salary and remote flags
company_dim          — Company name lookup
skills_job_dim       — Bridge table: job ↔ skill relationships
skills_dim           — Skill name lookup
january_jobs         — January 2023 postings partition
february_jobs        — February 2023 postings partition
march_jobs           — March 2023 postings partition
```

**Steps:**
1. Clone this repository
2. Load the dataset into your PostgreSQL instance
3. Run queries in `special_m_session.sql` sequentially in pgAdmin, DBeaver, or psql
4. Review output results or pipe into Python/matplotlib for chart reproduction

---

*Built with SQL · Visualized with Python · Published on GitHub*  
*Dataset: Luke Barousse's SQL Course Job Postings Dataset (2023)*
