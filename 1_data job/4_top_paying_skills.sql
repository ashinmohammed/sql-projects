-- which are the top paying skills in India for DA?
SELECT
    skills,
    round(avg(salary_year_avg),0) as avg_salary
from
    job_postings_fact
LEFT JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_country = 'India' 
    AND job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    and skills IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC, 
    skills
LIMIT 10;

