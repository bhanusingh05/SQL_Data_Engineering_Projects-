-- LESSON 02: SCHEMA DISCOVERY AND DATA QUALITY
-- Goal: profile an unfamiliar database before trusting its metrics.

-- Discover tables and their columns through the standard information schema.
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_schema = 'main'
ORDER BY table_name, ordinal_position;

-- Check row volume and salary completeness in one pass.
SELECT
    COUNT(*) AS total_postings,
    COUNT(salary_year_avg) AS postings_with_salary,
    COUNT(*) - COUNT(salary_year_avg) AS postings_without_salary,
    ROUND(100.0 * COUNT(salary_year_avg) / NULLIF(COUNT(*), 0), 1) AS salary_completeness_pct
FROM job_postings_fact;

-- Look for duplicate job IDs, an important fact-table quality check.
SELECT
    job_id,
    COUNT(*) AS row_count
FROM job_postings_fact
GROUP BY job_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- Practice: add a quality check for missing company IDs.
