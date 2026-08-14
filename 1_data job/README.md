# Introduction

This is my first hands-on SQL project, built as part of my journey into data analytics. A huge thanks to **Luke Barousse**, whose SQL course gave me the foundation and confidence to take on a real-world analysis like this.

This project dives into the data analyst job market in **India**, focusing on two key questions:
- Which data analyst roles pay the most?
- What skills are most in demand for these top-paying positions?

By querying and analyzing real job posting data, this project aims to uncover insights that can help aspiring and current data analysts understand what the market values most — both in terms of compensation and technical skill sets.

🔍 SQL queries used in this project can be found in [sql_project](/1_data%20job/)

## Background

The data for this project was sourced from **Luke Barousse's** SQL course dataset, which contains real-world job posting data. You can access the dataset here: [Job Posting Data](https://drive.google.com/drive/folders/1egWenKd_r3LRpdCf4SsqTeFZ1ZdY3DNx).

Using this dataset, I wrote SQL queries to answer the following questions:

1. What are the top-paying data analyst roles and companies in India?
2. What skills are required for these top-paying roles?
3. What skills are most in demand for data analysts?
4. Which skills are associated with the highest salaries?
5. What are the optimal skills to learn — ones that offer both high demand and high salary?

## Tools Used

To carry out this analysis, I used the following tools:

- **SQL** – The core language used to query the database, extract insights, and answer the key questions of this project.
- **PostgreSQL** – The database management system used to store and manage the job posting dataset, and to execute all SQL queries.
- **Visual Studio Code (VS Code)** – Used as the primary code editor for writing, testing, and organizing SQL queries throughout the project.
- **Git & GitHub** – Used for version control and to host and share this project.

## Analysis

Each query in this project was designed to explore a different angle of the data analyst job market in India — from identifying the highest-paying roles and companies, to uncovering which skills are most in demand, which skills pay the most, and ultimately which skills offer the best balance of both. Below, each query is broken down with the SQL code used, the resulting insights, and a visualization of the findings.

### 1. Top Paying Data Analyst Role and Company in India

To find the top-paying data analyst roles in India, I filtered job postings for the `Data Analyst` title, limited to India, and excluded rows with missing salary data. The results were sorted by average yearly salary in descending order.

```sql
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
LIMIT 10;
```

**Insights:**
- The **Data Analyst** role tops the list by a significant margin, paying noticeably more than other roles in the top 10 — including more senior-sounding titles like Data Architect and Staff Applied Research Engineer.
- Several **Data Architect** variations (Data Architect, Data Architect - Data Migration, Data Architect 2023, Technical Data Architect - Healthcare) also feature prominently, suggesting architecture-focused roles are consistently well-compensated.
- **Mantys** offers the highest salary among companies, well ahead of others like Bosch Group and Eagle Genomics Ltd.
- The top-paying companies span diverse industries — from tech (ServiceNow, Srijan Technologies) to finance (Deutsche Bank) and consulting (ACA Group) — indicating that high-paying data analyst roles aren't confined to one sector.

**Top Paying Data Analyst Role:**
![Top Paying Data Analyst Role](/1_data%20job/images/top_paying_data_role.png)

**Top Paying Company:**
![Top Paying Company](/1_data%20job/images/Top_paying_company.png)

### 2. Skills Required for Top-Paying Data Analyst Roles

Building on the previous query, I used a CTE to first isolate the top 10 highest-paying data analyst jobs in India, then joined this with the skills tables to find out which skills were tied to these roles.

```sql
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
        salary_year_avg DESC
```

**Insights:**
- From the previous query, **Data Analyst** and **Staff Applied Research Engineer** stood out as the highest-paying roles — however, skills data for these specific postings wasn't available in the dataset, likely due to missing entries in the skills join tables.
- Among the roles where skills data *was* available, **SQL** was the most in-demand skill, appearing **5 times** across the top-paying job postings — reinforcing SQL as a foundational, non-negotiable skill for high-paying data roles.
- **MongoDB, Oracle, Power BI,** and **Python** followed closely behind, each appearing across multiple top-paying postings, suggesting that a mix of database knowledge, BI tools, and programming is highly valued.
- Cloud and big data skills — **AWS, Azure,** and **Spark** — also appear among the top requirements, indicating that even at the analyst level, familiarity with cloud platforms and distributed data processing is increasingly expected in high-paying roles.

**Skills Required for Top Paying Roles:**

![Skills Required for Top Paying Roles](/1_data%20job/images/repeated_skills.png)

### 3. Most In-Demand Skills for Data Analysts

To find out which skills are most sought-after for data analyst roles in India overall (not just top-paying ones), I counted how many job postings required each skill and took the top 5.

```sql
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
```

**Results:**

| Skill     | Job Count |
|-----------|-----------|
| SQL       | 3,167     |
| Python    | 2,207     |
| Excel     | 2,118     |
| Tableau   | 1,673     |
| Power BI  | 1,285     |

**Insights:**
- **SQL** is by far the most in-demand skill, appearing in **3,167** postings — significantly ahead of every other skill, confirming it as the single most essential skill for data analysts in India.
- **Python** ranks second with **2,207** mentions, showing that programming ability is expected in a large share of roles, not just niche technical ones.
- **Excel** remains highly relevant with **2,118** postings, proving that traditional spreadsheet skills are still widely valued despite the rise of more advanced tools.
- **Tableau** and **Power BI** round out the top 5, together highlighting strong demand for data visualization and BI tooling — with Tableau slightly ahead (1,673 vs. 1,285).
- Compared to the top-paying roles in Query 2 (which leaned toward MongoDB, Oracle, cloud, and big data skills), the overall market demand here is more centered around **SQL, Python, Excel, and BI tools** — suggesting a gap between what's most commonly required versus what pays the most.

### 4. Skills That Pay the Most

Next, I looked at which individual skills are associated with the highest average salaries for data analyst roles in India, regardless of how in-demand they are.

```sql
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
```

**Results:**

| Skill      | Avg. Salary ($) |
|------------|------------------|
| GitLab     | 165,000          |
| Linux      | 165,000          |
| MySQL      | 165,000          |
| PostgreSQL | 165,000          |
| PySpark    | 165,000          |
| GDPR       | 163,782          |
| Neo4j      | 163,782          |
| Airflow    | 138,088          |
| Databricks | 135,994          |
| MongoDB    | 135,994          |

**Insights:**
- **GitLab, Linux, MySQL, PostgreSQL,** and **PySpark** are tied at the top, each commanding an average salary of **$165,000** — notably, this group blends version control, systems administration, database, and big data processing skills, rather than any single category dominating.
- **GDPR** and **Neo4j** follow closely at **$163,782**, an interesting pairing of data privacy/compliance knowledge with graph database expertise — suggesting niche, specialized skills can be just as lucrative as core technical ones.
- **Airflow** ($138,088), **Databricks**, and **MongoDB** (both at $135,994) round out the list, reinforcing that workflow orchestration and big-data platform skills are also well-compensated.
- Compared to Query 3's most *in-demand* skills (SQL, Python, Excel, Tableau, Power BI), none of those appear in this top 10 — highlighting a clear divide: the most commonly *required* skills are not necessarily the highest-*paying* ones. High salaries here lean toward specialized backend, DevOps, and big-data tools rather than everyday analyst tools.

### 5. Optimal Skills to Learn (High Demand + High Salary)

For the final query, I combined demand and salary data for all skills (filtered to those with 100+ postings) to identify which skills strike the best balance between being widely required *and* well-paid — rather than just optimizing for one or the other.

```sql
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
```

**Insights:**

Looking across the full result set, a clear pattern emerges: the skills with the *absolute* highest salaries (MySQL, PySpark, Databricks, Scala, MongoDB — all above $135K) tend to have relatively **low demand**, appearing in fewer than 160 job postings. On the other end, the most in-demand skills like SQL (3,167 postings), Python (2,207), Excel (2,118), and Tableau (1,673) offer solid but more moderate salaries, generally between $88K–$96K.

The real "sweet spot" lies with skills that break this trade-off — showing up in a large number of postings *while still* commanding an above-average salary. **Power BI** stands out here, combining strong demand (1,285 postings) with one of the higher salaries among mainstream tools ($109,832). Similarly, **Spark** and **Snowflake** manage respectable demand (343 and 262 postings) alongside salaries well above $110K, making them strong "engineering-adjacent" skills for analysts to pick up.

| Skill      | Demand | Avg. Salary ($) |
|------------|--------|------------------|
| Power BI   | 1,285  | 109,832          |
| Spark      | 343    | 118,332          |
| Snowflake  | 262    | 111,213          |
| Python     | 2,207  | 95,933           |
| Tableau    | 1,673  | 95,103           |

**5 Best Skills to Learn (optimal demand + salary balance):**
1. **Power BI** – High demand (1,285 postings) paired with a strong salary ($109,832), making it one of the best all-round investments for a data analyst.
2. **Spark** – Lower demand than mainstream tools but a high salary ($118,332), ideal for analysts wanting to move toward data engineering.
3. **Snowflake** – Solid demand (262 postings) with one of the better salaries ($111,213), reflecting growing adoption of cloud data warehousing.
4. **Python** – The single most versatile skill, with very high demand (2,207 postings) and a comfortably above-average salary ($95,933).
5. **Tableau** – Strong demand (1,673 postings) with a competitive salary ($95,103), making it a safe, high-value visualization skill to learn.

## What I Learned

This project was my **first real dive into SQL**, and it turned out to be a lot more rewarding than I expected. Beyond just writing queries, it taught me how to think like a data analyst — asking the right questions and letting the data answer them. Here's a quick rundown of what I picked up along the way:

🧩 **Complex Query Building** — I learned how to combine multiple clauses like `WHERE`, `GROUP BY`, `HAVING`, and `ORDER BY` into meaningful, multi-step queries instead of just simple `SELECT` statements.

🔗 **Table Relationships & Joins** — Working across `job_postings_fact`, `company_dim`, `skills_job_dim`, and `skills_dim`, I got comfortable using `LEFT JOIN` and `JOIN` to pull related data scattered across multiple tables into a single, useful result.

📊 **Aggregation & Grouping** — I learned to use `COUNT()`, `AVG()`, and `ROUND()` alongside `GROUP BY` to turn raw job listings into real insights — like average salaries and skill demand counts.

🧠 **CTEs (Common Table Expressions)** — Writing my first `WITH` clause was a turning point. It helped me break down a complex problem (top-paying jobs → their required skills) into clean, readable, step-by-step logic.

## Conclusion

This project marks the beginning of my journey into data analytics, and working through it from start to finish — writing queries, debugging joins, and turning raw numbers into real insights — has given me a solid, hands-on foundation in SQL.

From the analysis, a few clear takeaways stand out about the data analyst job market in India:

- **Data Analyst** roles themselves top the pay scale, ahead of many senior-sounding titles, and companies like **Mantys** and **Bosch Group** lead the way in compensation.
- **SQL** remains the single most essential and in-demand skill, showing up far more often than any other tool across job postings.
- The **highest-paying** skills (like MySQL, PySpark, and Databricks) aren't always the **most in-demand** ones — and the reverse is true too. Real career value comes from finding the overlap between the two.
- Skills like **Power BI, Python, Tableau, Spark,** and **Snowflake** offer the best of both worlds — strong demand *and* strong pay — making them smart choices for anyone looking to grow in this field.

More than the specific numbers, this project taught me how to approach a real dataset with curiosity, break a big question down into smaller SQL queries, and let the data guide the story rather than assumptions.

A huge thanks again to **Luke Barousse** for the course that made this project possible — this is just the first step, and I'm looking forward to building on these skills with more projects ahead. 🚀