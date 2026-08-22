# SQL Data Engineering Projects

A portfolio of SQL work focused on analyzing Data Engineer job-market data with DuckDB. The repository combines a structured learning path with applied exploratory analysis.

## Start Here

- [SQL Lesson Collection](Lessons/README.md): eight sequenced lessons covering SQL foundations through portfolio analysis
- [EDA Project](1_EDA/README.md): demand, salary, and optimal-skill analysis for remote Data Engineer roles

## What This Demonstrates

- Querying and profiling relational data
- Filtering, conditional logic, aggregation, and KPI design
- Inner, left, and many-to-many bridge-table joins
- CTEs for layered, maintainable transformations
- Window functions for ranking and comparison
- Median salary analysis and logarithmic multi-factor scoring
- Translating query results into business recommendations

## Data Model

The SQL examples use a normalized job-postings model:

```text
job_postings_fact  --< skills_job_dim >-- skills_dim
        |
        +-- company_dim
```

The source data is not included. Load the four tables into DuckDB before running the queries.

## SQL Dialect

Examples target DuckDB and use functions including `ILIKE`, `MEDIAN`, and `information_schema`.
