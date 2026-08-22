-- LEGACY NOTE: use Lessons/05_relational_joins.sql for the structured course.
SELECT jpf.*, cd.*
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
LIMIT 10;

SELECT jpf.job_id, jpf.job_title_short, jpf.company_id, cd.company_id
FROM job_postings_fact AS jpf
LEFT JOIN company_dim AS cd ON jpf.company_id = cd.company_id
LIMIT 10;