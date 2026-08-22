# Warehouse and Analytical Marts

A production-minded extension of the job-postings database. The project creates reusable analytical tables from the normalized warehouse model.

![Pipeline](../../Resources/pipeline.svg)

## Objective

Give analysts simple, stable tables for skill demand, salary benchmarking, and remote-role exploration without repeating complex joins in every report.

## Build Sequence

1. Run [`01_create_marts.sql`](01_create_marts.sql) to rebuild the marts idempotently.
2. Run [`02_verify_marts.sql`](02_verify_marts.sql) to check row counts and key coverage.
3. Query the marts directly from a BI tool or DuckDB.

## Marts

| Mart | Grain | Use |
| --- | --- | --- |
| `skills_demand_mart` | skill + role | Compare demand by role and remote status |
| `salary_benchmark_mart` | role + skill | Compare median and average salary |
| `company_hiring_mart` | company + role | Identify hiring concentration |

## Engineering Practices

- Explicit column lists and clear grain definitions
- `DROP TABLE IF EXISTS` for repeatable builds
- Aggregation only after the correct bridge-table join
- Verification queries for row volume and unmatched dimensions
