
-- WHat are the requiered for the top-paying data analyst jobs?
-- --Use the top10 Highest paying Data Analayst jobs from first querey
-- --Add the specific skills requiered for these role
-- --Why? job seekers understand which skills to develop that alips with top salaries

-- # What are the top_paying data analyst jobs?
-- # _Idendtify the top 10 Highest_Paying DAta Analayst roles that are available remotely
-- # --Focus on job postings with specified salaries (remove nulls)
-- # --Why? Highlights the top paying oppturnities for Data Analysis,Ofering insights intoemployementS


WITH top_paying_jobs AS (

SELECT 
      job_id,
      job_title_short AS job_title,
      salary_year_avg,
      name AS company_name
FROM job_postings_fact
      job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title ='Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
salary_year_avg DESC
LIMIT 10
)
SELECT
      top_paying_jobs.*,
      skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
         salary_year_avg DESC
         
         
         
         
         
--SQL is leading with a bold Count 
--Python follows closely with a bold count of 7
--Tabelue is also highly sought after,with a bold count of 6.
--Other skills like R, Snowflake,Pandas, and Excel,show varying degrees of Demand


-- Probelm Statement :
-- WHat are the most in-demand skills for my role?
-- # Specificaly previous Solving the Demand Skills



WITH remote_job_skills AS (
    SELECT
         skill_id,
         COUNT(*) AS skill_count
    FROM
          skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
    WHERE 
          job_postings.job_work_from_home =TRUE 
          AND
          job_postings.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id
)
SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
     skill_count DESC
LIMIT 5;


