-- LESSON 07: WINDOW FUNCTIONS
-- Goal: rank rows while keeping row-level detail in the result.

WITH skill_demand AS (
    SELECT
        sd.skills,
        COUNT(*) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE jpf.job_title_short = 'Data Engineer'
      AND jpf.job_work_from_home = TRUE
    GROUP BY sd.skills
)
SELECT
    skills,
    demand_count,
    RANK() OVER (ORDER BY demand_count DESC) AS demand_rank,
    ROUND(100.0 * demand_count / SUM(demand_count) OVER (), 2) AS share_of_skill_mentions_pct
FROM skill_demand
ORDER BY demand_rank
LIMIT 25;

-- ROW_NUMBER gives each company one deterministic top posting after sorting.
SELECT
    company_id,
    job_id,
    salary_year_avg,
    ROW_NUMBER() OVER (
        PARTITION BY company_id
        ORDER BY salary_year_avg DESC NULLS LAST, job_id
    ) AS salary_position_at_company
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer';

-- Practice: use LAG to compare a salary row with the previous salary row
-- within each company after adding a posting-date column if available.
