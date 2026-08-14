/*
which are the top paying companies that provide data analyst jobs in India?
*/

SELECT
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
LIMIT 50;