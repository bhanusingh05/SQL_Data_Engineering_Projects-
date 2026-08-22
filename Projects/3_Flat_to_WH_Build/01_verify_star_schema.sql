-- PROJECT 3: STAR-SCHEMA VERIFICATION CONTRACT
-- Run after the flat-to-warehouse load has been implemented.

-- Every fact row should resolve to a company dimension row when company_id
-- is populated.
SELECT COUNT(*) AS unmatched_company_keys
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
WHERE jpf.company_id IS NOT NULL
  AND cd.company_id IS NULL;

-- Every bridge row should resolve to both parent tables.
SELECT COUNT(*) AS unmatched_skill_bridge_rows
FROM skills_job_dim AS sjd
LEFT JOIN job_postings_fact AS jpf ON sjd.job_id = jpf.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE jpf.job_id IS NULL OR sd.skill_id IS NULL;

-- Duplicate bridge pairs would inflate skill-demand metrics.
SELECT job_id, skill_id, COUNT(*) AS duplicate_count
FROM skills_job_dim
GROUP BY job_id, skill_id
HAVING COUNT(*) > 1;
