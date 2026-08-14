-- what are the most optimal skills to learn (high demand and high paying) in India for DA
SELECT
    skills,
    count(job_postings_fact.job_id) as  demand,
    round(avg(salary_year_avg),0) as salary
FROM
    job_postings_fact
JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_country = 'India'
GROUP BY
    skills
HAVING
    round(avg(salary_year_avg),0) is not null
    and count(job_postings_fact.job_id) >100
ORDER BY
    salary DESC