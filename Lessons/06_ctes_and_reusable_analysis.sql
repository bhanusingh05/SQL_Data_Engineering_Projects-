-- LESSON 06: CTEs AND REUSABLE ANALYSIS
-- Goal: separate population definition, aggregation, and ranking.

WITH remote_data_engineer_jobs AS (
    SELECT
        job_id,
        salary_year_avg
    FROM job_postings_fact
    WHERE job_title_short = 'Data Engineer'
      AND job_work_from_home = TRUE
      AND salary_year_avg IS NOT NULL
),
skill_summary AS (
    SELECT
        sd.skills,
        COUNT(*) AS demand_count,
        MEDIAN(rdej.salary_year_avg) AS median_salary
    FROM remote_data_engineer_jobs AS rdej
    INNER JOIN skills_job_dim AS sjd ON rdej.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    GROUP BY sd.skills
    HAVING COUNT(*) >= 100
)
SELECT
    skills,
    ROUND(median_salary, 0) AS median_salary,
    demand_count,
    ROUND((LN(demand_count) * median_salary) / 1000000, 2) AS optimal_score
FROM skill_summary
ORDER BY optimal_score DESC
LIMIT 25;

-- CTEs make each business rule visible and easy to test independently.
-- Practice: add a company-level CTE and compare company demand with skill demand.
