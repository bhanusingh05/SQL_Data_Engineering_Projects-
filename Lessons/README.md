# SQL Data Engineering Lesson Collection

A practical SQL curriculum built around the same job-postings data model used by the EDA project. Each lesson introduces one production-relevant SQL concept, explains why it matters, and ends with a business question or reusable query pattern.

## Learning Path

| Order | Lesson | SQL topics | Portfolio signal |
| --- | --- | --- | --- |
| 01 | [SQL Foundations](01_sql_foundations.sql) | `SELECT`, aliases, `LIMIT`, `DISTINCT` | Inspect and sample a fact table |
| 02 | [Schema Discovery and Data Quality](02_schema_and_quality.sql) | `information_schema`, `NULL`s, completeness checks | Profile an unfamiliar warehouse |
| 03 | [Filtering and CASE Logic](03_filtering_and_case_logic.sql) | `WHERE`, `ILIKE`, `BETWEEN`, `CASE` | Define a trustworthy analysis population |
| 04 | [Aggregations and KPI Design](04_aggregations_and_kpis.sql) | `COUNT`, `AVG`, `MEDIAN`, `GROUP BY`, `HAVING` | Build market-level KPIs |
| 05 | [Relational Joins](05_relational_joins.sql) | `INNER JOIN`, `LEFT JOIN`, bridge tables | Combine fact and dimension data correctly |
| 06 | [CTEs and Reusable Analysis](06_ctes_and_reusable_analysis.sql) | CTEs, layered transformations, ranking | Make complex analysis readable |
| 07 | [Window Functions](07_window_functions.sql) | `ROW_NUMBER`, `RANK`, `LAG`, running totals | Compare rows without losing detail |
| 08 | [Portfolio Analysis](08_portfolio_analysis.sql) | multi-step analysis, scoring, interpretation | Produce decision-ready insights |

## How to Use This Collection

1. Load the source tables into DuckDB or another SQL client.
2. Run the lessons in numerical order.
3. Read the comments before executing each query.
4. Change the filters and thresholds to test your own hypotheses.
5. Compare the final portfolio queries with the EDA analyses in [`../1_EDA/README.md`](../1_EDA/README.md).

## Data Model

- `job_postings_fact`: one row per job posting, including title, location, salary, and company ID
- `company_dim`: company attributes keyed by `company_id`
- `skills_job_dim`: many-to-many bridge between jobs and skills
- `skills_dim`: skill names keyed by `skill_id`

## SQL Dialect

The examples target DuckDB and use `ILIKE`, `MEDIAN`, `COUNT(*)`, and `information_schema`. Small syntax changes may be needed for PostgreSQL, BigQuery, Snowflake, or SQL Server.

## Suggested Interview Talking Points

- Explain why a bridge table is needed when one job can require many skills.
- Explain when a `LEFT JOIN` is safer than an `INNER JOIN` for completeness checks.
- Explain why median salary is often more robust than average salary.
- Explain how a window function differs from `GROUP BY`.
- Explain the tradeoff in using a logarithmic demand score for skill prioritization.
