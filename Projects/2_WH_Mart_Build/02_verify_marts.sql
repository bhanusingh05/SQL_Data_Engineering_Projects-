-- PROJECT 2: MART VERIFICATION
-- These checks make the build observable before a dashboard consumes it.

SELECT 'skills_demand_mart' AS mart_name, COUNT(*) AS row_count
FROM skills_demand_mart
UNION ALL
SELECT 'salary_benchmark_mart', COUNT(*)
FROM salary_benchmark_mart
UNION ALL
SELECT 'company_hiring_mart', COUNT(*)
FROM company_hiring_mart;

SELECT
    COUNT(*) AS salary_rows,
    COUNT(*) FILTER (WHERE median_salary IS NULL) AS missing_median_rows,
    COUNT(*) FILTER (WHERE posting_count <= 0) AS invalid_count_rows
FROM salary_benchmark_mart;
