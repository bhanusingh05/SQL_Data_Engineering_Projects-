-- LEGACY NOTE: use Lessons/02_schema_and_quality.sql for the structured course.
-- The original examples are retained in a compact, readable form.
SELECT job_id, job_title_short, salary_year_avg, company_id
FROM job_postings_fact
LIMIT 10;

SELECT * FROM company_dim LIMIT 10;

SELECT table_name FROM information_schema.tables ORDER BY table_name;