-- What are the optimal skills to learn (aka it's  in high demand and a high-paying skills?
-- Conecentartes on remote positions with specified salries
-- Why? targrt skills that offer job security (high-demand) and financial benifits (High-salaries),
-- offering the strategic insights for career development in data analysis




ans:
-- Why retervies the Top 5 skills the highest
-- --ANalyst asking the suggestion for ChatgptThat AI suggested  igh Demand forBig Data & ML skills: Top salaries
-- Software Develoopment & Deployment proeffiency
-- Cloud Computing Expertises : familiriaty with cloud


WITH skills_demand AS (

SELECT
     skills_dim.skill_id,
     skills_dim.skills,
     COUNT(skills_job_dim.job_id) AS demand_count

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
job_title_short = 'Data Analyst' 
AND salary_year_avg IS NOT NULL
AND job_work_from_home = TRUE
GROUP BY
      skills_dim.skill_id
)

,average_salary AS (
SELECT 
     skills_job_dim.skill_id,
  
     ROUND(AVG(salary_year_avg),2) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
job_title_short = 'Data Analyst'
AND salary_year_avg IS NOT NULL
AND
job_work_from_home = TRUE
GROUP BY
      skills_job_dim.skill_id
)

SELECT 
     skills_demand.skill_id,
     skills_demand.skills,
     demand_count,
     avg_salary
FROM
     skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count >10

ORDER BY 
     avg_salary DESC,

       demand_count DESC
  
LIMIT 25

Rewriting this same query more consisely

SELECT 
      skills_dim.skill_id,
      skills_dim.skills,
      COUNT(skills_job_dim.job_id) AS demand_count,
      ROUND(AVG(job_postings_fact.salary_year_avg),0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON  skills_job_dim.skill_id = skills_dim.skill_id
WHERE     
     job_title_short = 'Data Analyst'
     AND salary_year_avg IS NOT NULL
     AND job_work_from_home =TRUE
GROUP BY
     skills_dim.skill_id
HAVING 
      COUNT(skills_job_dim.job_id) >10
ORDER BY
     avg_salary DESC,
     demand_count DESC
LIMIT 25;