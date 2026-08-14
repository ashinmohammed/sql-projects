-- most demand skill for data analytics job role in India?
SELECT
    skills,
    count(skills_job_dim.job_id) as skill_count
FROM
    job_postings_fact
LEFT JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_country = 'India' AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT 5
