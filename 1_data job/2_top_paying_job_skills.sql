-- which skills are required for top paying data analyst job in India?

WITH top_paying_data_jobs AS (
    SELECT
        job_id,
        name as company_name,
        job_title,
        job_location,
        job_country,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst'
        AND job_country = 'India'
        AND salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_data_jobs.*,
    skills

from
    top_paying_data_jobs
left JOIN skills_job_dim on top_paying_data_jobs.job_id = skills_job_dim.job_id
left JOIN skills_dim on skills_job_dim.skill_id= skills_dim.skill_id
ORDER BY
        salary_year_avg DESC;
