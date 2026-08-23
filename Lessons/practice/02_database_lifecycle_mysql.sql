-- PRACTICE 02: DATABASE LIFECYCLE IN MYSQL
-- Goal: demonstrate database-level DDL safely and explicitly.
--
-- This file is intentionally MySQL-specific. Run it with a MySQL client, not
-- DuckDB, because DuckDB uses database files and does not support CREATE
-- DATABASE or DROP DATABASE as MySQL does.
--
-- HOW TO RUN:
-- mysql -u <username> -p < Lessons/practice/02_database_lifecycle_mysql.sql

-- ---------------------------------------------------------------------------
-- 1. RESET THE PRACTICE DATABASE
-- ---------------------------------------------------------------------------

-- WARNING: DROP DATABASE permanently removes the database and its objects.
-- Use this only for a disposable practice database.
DROP DATABASE IF EXISTS jobs_mart;

-- ---------------------------------------------------------------------------
-- 2. CREATE AND VERIFY THE DATABASE
-- ---------------------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS jobs_mart;

-- Confirm that jobs_mart exists after creation.
SHOW DATABASES;

-- Select the database for the remainder of this script.
USE jobs_mart;

-- ---------------------------------------------------------------------------
-- 3. CREATE AND INSPECT A SCHEMA
-- ---------------------------------------------------------------------------

-- In MySQL, SCHEMA is an alias for DATABASE. This command demonstrates
-- schema-level organization while remaining inside jobs_mart.
CREATE SCHEMA IF NOT EXISTS staging;

SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name IN ('jobs_mart', 'staging')
ORDER BY schema_name;

-- ---------------------------------------------------------------------------
-- 4. CLEAN UP THE PRACTICE DATABASE
-- ---------------------------------------------------------------------------

-- WARNING: This removes jobs_mart and everything inside it.
DROP DATABASE IF EXISTS jobs_mart;

-- Verify that the practice database is no longer listed.
SHOW DATABASES;
