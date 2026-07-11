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

-- Fastest reminder Below Steps Following

-- -- CTE STARTS HERE
-- WITH top_paying_jobs AS (

--     -- Temporary Result Set (CTE)
--     -- Find Top 10 highest-paying remote Data Analyst jobs

--     SELECT
--         job_id,
--         job_title_short AS job_title,
--         job_location,
--         job_schedule_type,
--         salary_year_avg,
--         job_posted_date,
--         name AS company_name
--     FROM job_postings_fact
--     LEFT JOIN company_dim
--         ON job_postings_fact.company_id = company_dim.company_id
--     WHERE
--         job_title_short = 'Data Analyst'
--         AND job_location = 'Anywhere'
--         AND salary_year_avg IS NOT NULL
--     ORDER BY salary_year_avg DESC
--     LIMIT 10

-- ) 
-- -- CTE ENDS HERE


-- -- MAIN QUERY STARTS HERE
-- -- Use the temporary CTE table created above

-- SELECT
--     top_paying_jobs.*,
--     skills
-- FROM top_paying_jobs

-- -- Join CTE with skills table
-- INNER JOIN skills_job_dim
--     ON top_paying_jobs.job_id = skills_job_dim.job_id

-- -- Get skill names
-- INNER JOIN skills_dim
--     ON skills_job_dim.skill_id = skills_dim.skill_id

-- ORDER BY salary_year_avg DESC;


    
    

