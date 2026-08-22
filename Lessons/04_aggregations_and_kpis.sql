-- LESSON 04: AGGREGATIONS AND KPI DESIGN
-- Goal: summarize job-market behavior with defensible KPIs.

-- GROUP BY creates one result row per role.
SELECT
    job_title_short,
    COUNT(*) AS posting_count,
    COUNT(salary_year_avg) AS postings_with_salary,
    ROUND(AVG(salary_year_avg), 0) AS average_salary,
    ROUND(MEDIAN(salary_year_avg), 0) AS median_salary
FROM job_postings_fact
WHERE job_work_from_home = TRUE
GROUP BY job_title_short
HAVING COUNT(*) >= 100
ORDER BY posting_count DESC;

-- Aggregate skills after joining the bridge table to the skill dimension.
SELECT
    sd.skills,
    COUNT(*) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
  AND jpf.job_work_from_home = TRUE
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 15;

-- Practice: change the threshold in HAVING and describe the tradeoff between
-- including more roles and reducing small-sample noise.
