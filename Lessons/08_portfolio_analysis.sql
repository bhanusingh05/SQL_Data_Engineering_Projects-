-- LESSON 08: PORTFOLIO ANALYSIS
-- Goal: turn the learned patterns into a decision-ready analysis.
-- Question: which skills are practical priorities for a Data Engineer?

WITH remote_salary_jobs AS (
    SELECT job_id, salary_year_avg
    FROM job_postings_fact
    WHERE job_title_short = 'Data Engineer'
      AND job_work_from_home = TRUE
      AND salary_year_avg IS NOT NULL
),
skill_metrics AS (
    SELECT
        sd.skills,
        COUNT(*) AS demand_count,
        ROUND(MEDIAN(rsj.salary_year_avg), 0) AS median_salary
    FROM remote_salary_jobs AS rsj
    INNER JOIN skills_job_dim AS sjd ON rsj.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    GROUP BY sd.skills
    HAVING COUNT(*) >= 100
),
scored_skills AS (
    SELECT
        skills,
        demand_count,
        median_salary,
        ROUND((LN(demand_count) * median_salary) / 1000000, 2) AS optimal_score
    FROM skill_metrics
)
SELECT
    skills,
    demand_count,
    median_salary,
    optimal_score,
    CASE
        WHEN demand_count >= 500 AND median_salary >= 135000 THEN 'Core priority'
        WHEN optimal_score >= 0.70 THEN 'Strong secondary'
        ELSE 'Specialized option'
    END AS learning_priority
FROM scored_skills
ORDER BY optimal_score DESC
LIMIT 25;

-- Interpretation prompt:
-- 1. Which skills are both broad and well-paid?
-- 2. Which high-salary skills need more evidence because demand is lower?
-- 3. How would your recommendation change if the minimum demand were 250?
