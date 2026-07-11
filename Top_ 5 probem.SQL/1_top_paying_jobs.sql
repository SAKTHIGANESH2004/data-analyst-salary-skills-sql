-- # What are the top_paying data analyst jobs?
-- # _Idendtify the top 10 Highest_Paying DAta Analayst roles that are available remotely
# --Focus on job postings with specified salaries (remove nulls)
# --Why? Highlights the top paying oppturnities for Data Analysis,Ofering insights intoemployementS

SELECT 
      job_id,
      job_title_short AS job_title,
      job_location,
      job_schedule_type,
      salary_year_avg,
      job_posted_date,
      name AS company_name
FROM
      job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title ='Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
salary_year_avg DESC
LIMIT 10


    
    

