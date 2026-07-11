/*
Question: What are the highest-paying skills for data engineers?

. Calculate the median salary for each skill required in data engineer
positions

. Focus on remote positions with specified salaries

. Include skill frequency to identify both salary and demand

· Why?

    o Helps identify which skills command the highest compensation
    while also showing how common those skills are, providing a more
    complete picture for skill development priorities.

    o The median is used instead of the average to reduce the impact of
    outlier salaries.

*/

/*
--just example
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 25;
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
ORDER BY
    demand_count DESC
LIMIT 25;




SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
ORDER BY
    median_salary DESC
LIMIT 25;



SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
Key insights:

    • Rust has the highest median salary at $210,000, showing strong compensation 
    for specialized systems programming skills.

    • Terraform provides the strongest combination of salary and demand, 
    with a median salary of $184,000 and 3,248 job postings, indicating high market value.

    • Backend development and cloud infrastructure skills dominate the highest-paying list, 
    including Golang,Spring, GraphQL, FastAPI, and Terraform.

    • High-paying skills are not always the most demanded. Rust ranks first in salary but 
    has only 232 job postings, while Terraform has much higher demand.

    • Specialized technologies such as Neo4j and GraphQL achieve high salaries despite 
    lower demand, suggesting companies pay more for niche expertise.

    • The top 10 skills all exceed $157,000 median salary, indicating that advanced 
    technical skills in modern software architecture are highly valued.


Summary:

The analysis shows that specialized backend, cloud, and DevOps technologies dominate the list 
of highest-paying skills. Rust offers the highest median salary at $210,000, while Terraform 
provides an attractive balance of high salary and strong market demand. Overall, employers offer 
premium compensation for professionals with expertise in scalable systems, cloud infrastructure, 
and modern backend technologies.

The analysis indicates that high-paying data engineering roles require a combination of 
cloud infrastructure, programming, and data management expertise. Terraform demonstrates 
strong market value by combining high salary with significant demand, while technologies 
such as Airflow highlight the importance of scalable data pipeline management. 
Specialized programming languages and database technologies offer premium compensation, 
although their demand is more limited compared to widely adopted data engineering tools

┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ django     │      155000.0 │          265 │
│ bitbucket  │      155000.0 │          478 │
│ crystal    │      154224.0 │          129 │
│ c          │      151500.0 │          444 │
│ atlassian  │      151500.0 │          249 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ ruby       │      150000.0 │          736 │
│ css        │      150000.0 │          262 │
│ airflow    │      150000.0 │         9996 │
│ node       │      150000.0 │          179 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
├────────────┴───────────────┴──────────────┤
│ 25 rows                         3 columns │
└───────────────────────────────────────────┘
*/