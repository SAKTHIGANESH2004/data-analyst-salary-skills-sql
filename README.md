# 📊 SQL Data Analyst Job Market Analysis

> Exploring the 2023 Data Analyst job market through SQL — uncovering top-paying roles, the most in-demand skills, and what it takes to land a high-salary remote position.

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen?style=flat)
![Year](https://img.shields.io/badge/Data-2023-skyblue?style=flat)

---

## 📌 Table of Contents

- [1. Introduction](#1-introduction)
- [2. Background](#2-background)
- [3. Tools I Used](#3-tools-i-used)
- [4. The Analysis](#4-the-analysis)
- [5. What I Learned](#5-what-i-learned)
- [6. Conclusion](#6-conclusion)

---

## 1. Introduction

This project dives deep into the **Data Analyst job market** using structured SQL queries to answer key career questions:

- 💰 Which Data Analyst roles offer the **highest salaries**?
- 🛠️ What **skills** do the top-paying jobs require?
- 🌐 Which skills are most in demand for **remote Data Analyst roles**?
- 📅 What salary trends exist across **Q1 2023** job postings?

By querying real-world job posting data with SQL, this project transforms raw records into **actionable career intelligence** — the kind that helps job seekers understand exactly where to focus their learning.

---

## 2. Background

The Data Analyst role has grown rapidly across industries, but the skills employers want — and the salaries they offer — vary enormously. A junior analyst and a Principal Data Analyst can sit in roles with nearly identical titles but salaries that differ by hundreds of thousands of dollars.

This project was built to answer a simple but powerful question: **what separates the top-paying Data Analyst roles from the rest?**

Using a dataset of job postings enriched with skill tags, company data, salary ranges, and remote-work flags, I used SQL to systematically surface the most valuable and marketable skills in the 2023 job market.

**The dataset includes:**
- Job postings with title, location, salary, and remote-work flags
- A skills dimension table mapping skills to specific job postings
- Monthly partitioned posting tables for Q1 2023 (January, February, March)

**Core questions driving this analysis:**

| # | Question |
|---|----------|
| 1 | What are the top 10 highest-paying Data Analyst roles? |
| 2 | What skills are required by those top-paying jobs? |
| 3 | Which skills appear most in remote Data Analyst postings? |
| 4 | What salary threshold defines a competitive Q1 2023 offer? |

---

## 3. Tools I Used

| Tool | Purpose |
|------|---------|
| **PostgreSQL** | Core relational database engine for all queries |
| **SQL** | Primary language for extraction, filtering, and aggregation |
| **CTEs** | Organizing complex multi-step logic into readable named blocks |
| **INNER JOIN** | Linking job postings, skills, and company dimension tables |
| **UNION / UNION ALL** | Combining monthly job posting tables into quarterly datasets |
| **Subqueries** | Inline table creation for filtered aggregations |
| **GROUP BY + ORDER BY** | Ranking skills and salaries by demand and value |
| **Python (Matplotlib)** | Visualizing query results as clean horizontal bar charts |
| **Git & GitHub** | Version control and public portfolio publishing |

---

## 4. The Analysis

Each query was built **incrementally** — starting with a simple structure and adding layers of filters, joins, and aggregations until the final answer emerged. Below is every analysis performed, with full SQL and findings.

---

### 🔍 Query 1 — Top 10 Highest-Paying Data Analyst Jobs

**Objective:** Find the 10 Data Analyst roles with the highest average yearly salary, focusing on remote positions.

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

**Results:**

![Average Salary Distribution](./images/salary_distribution_skyblue.png)

**Key Findings:**
- The highest-paying "Data Analyst" role reached **~$650,000/year** — an outlier driven by seniority and equity compensation
- **Director of Analytics** ranks second at ~$340,000, confirming management-track roles command a significant premium
- Every role in the top 10 exceeds **$190,000/year**, creating a clear salary floor for senior-level positions
- Remote and hybrid roles appear multiple times in the top 10 — confirming that flexible work does **not** reduce compensation at the top tier

---

### 🔍 Query 2 — Skills Required by the Top-Paying Jobs

**Objective:** For the top 10 highest-paying Data Analyst roles, identify which skills are most commonly required.

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

**Results:**

![Skill Count for Top 10 Paying Data Analyst Jobs in 2023](./images/skill_count_chart_skyblue.png)

**Key Findings:**

| Rank | Skill | Frequency | Insight |
|------|-------|-----------|---------|
| 1 | **SQL** | 8 / 10 jobs | The non-negotiable foundation — appears in almost every top role |
| 2 | **Python** | 7 / 10 jobs | Required for automation, scripting, and advanced analysis |
| 3 | **Tableau** | 6 / 10 jobs | Data visualization is expected at the highest compensation levels |
| 4 | **R** | 4 / 10 jobs | Statistical modeling remains valued at the senior tier |
| 5 | **Snowflake** | 3 / 10 jobs | Cloud data warehousing is now a mainstream requirement |
| 5 | **Pandas** | 3 / 10 jobs | Python ecosystem depth matters beyond just knowing the language |
| 5 | **Excel** | 3 / 10 jobs | Still present even at the highest salary levels |
| 8 | **Azure** | 2 / 10 jobs | Cloud platform fluency is a clear differentiator |
| 8 | **Bitbucket** | 2 / 10 jobs | Version control appears at senior data team levels |
| 8 | **Go** | 2 / 10 jobs | Engineering-adjacent skills emerge at the highest pay bands |

> 💡 **SQL + Python + Tableau** form the core skill stack demanded by the highest-paying Data Analyst roles in 2023.

---

### 🔍 Query 3 — Top 5 In-Demand Skills for Remote Data Analyst Roles

**Objective:** Identify the 5 most frequently requested skills across all remote Data Analyst postings — across the full market, not just top-paying roles.

This query was developed in 5 progressive steps, validating output at each stage before moving forward.

**Final Query:**

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

**Finding:** SQL, Python, and Tableau dominate both the highest-paying roles and the broadest remote job market — confirming these three skills are the highest-priority investments for any Data Analyst career.

---

### 🔍 Query 4 — Q1 2023 Data Analyst Jobs Paying Above $70,000

**Objective:** Combine January, February, and March 2023 job postings into a unified quarterly dataset and surface Data Analyst roles with above-average salaries.

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

**Why `UNION ALL` and not `UNION`?**
`UNION ALL` preserves every row including duplicates — correct here because each job posting is a distinct record that should appear in salary rankings. `UNION` would silently remove postings that happen to share identical values, distorting the results.

---

## 5. What I Learned

This project sharpened both SQL technique and the ability to translate data into meaningful career insights.

**CTEs transform complex queries into readable logic** — Breaking the remote skill analysis into a named CTE (`remote_job_skills`) made each step transparent and easy to debug. The equivalent nested subquery would have been far harder to read and maintain.

**Strategic JOINs unlock cross-table insights** — Linking `job_postings_fact` → `skills_job_dim` → `skills_dim` required understanding how each table related to the others. Getting this right turned raw job IDs into readable skill names with salary context attached.

**`UNION ALL` vs `UNION` is a precision decision** — Running both versions showed exactly why the choice matters. `UNION` deduplicates (correct for distinct job counts); `UNION ALL` keeps everything (correct for salary rankings and frequency counts). Using the wrong one silently corrupts results.

**Incremental query building is a professional discipline** — Every final query started simple — one table, one column — and grew step by step. Validating each intermediate output before adding the next layer eliminated bugs early and built confidence in the final result.

**SQL is a storytelling tool, not just a retrieval tool** — The most valuable output of this project is not the queries themselves — it's the insight that **SQL + Python + Tableau** unlocks the highest-paying Data Analyst roles. That is a career-actionable finding produced entirely through structured querying.

---

## 6. Conclusion

This project set out to answer what separates a $70,000 Data Analyst offer from a $650,000 one — and the SQL data tells a clear story.

**Summary of key findings:**

✅ **SQL is non-negotiable** — appears in 8 of 10 top-paying roles and leads demand across all remote postings

✅ **Python is the essential second skill** — 7 of the top 10 jobs require it, bridging analysis and engineering-level automation

✅ **Tableau completes the core trio** — visualization skills are expected at the highest compensation levels, not treated as optional

✅ **Senior titles command dramatically higher pay** — Director-level and Principal roles cluster between $200,000–$340,000, far above the market average

✅ **Remote work does not reduce compensation** — hybrid and fully remote roles appear consistently at the top of the salary distribution

For anyone building a Data Analyst career, the data is clear: **master SQL first, then Python, then Tableau** — and layer in cloud platforms like Snowflake and Azure as you advance into senior roles.

---

## 📁 Project Structure

```
📂 sql-data-analyst-job-market/
│
├── 📄 special_m_session.sql            # Remote skills CTE + UNION quarterly analysis
├── 🖼️ salary_distribution_skyblue.png  # Top 10 paying roles — salary chart
├── 🖼️ skill_count_chart_skyblue.png    # Top 10 skills frequency chart
└── 📄 README.md                        # Project documentation
```

---

## 🚀 How to Run

**Prerequisites:** PostgreSQL with the following tables loaded:

```
job_postings_fact   →  Core job postings with salary and remote-work flags
company_dim         →  Company name lookup
skills_job_dim      →  Bridge table linking jobs to skills
skills_dim          →  Skill name lookup
january_jobs        →  January 2023 postings partition
february_jobs       →  February 2023 postings partition
march_jobs          →  March 2023 postings partition
```

1. Clone this repository
2. Load the dataset into your PostgreSQL instance
3. Open `special_m_session.sql` in pgAdmin, DBeaver, or psql
4. Run queries sequentially and review the output

---

*Built with SQL · Visualized with Python · Published on GitHub*
