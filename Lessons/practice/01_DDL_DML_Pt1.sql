-- HOW TO RUN IN DUCKDB:
-- 1. Start DuckDB in the jobs_mart database: duckdb jobs_mart.duckdb
-- 2. Run this file: .read Lessons/practice/01_DDL_DML_Pt1.sql
--
-- DuckDB database-lifecycle equivalent:
-- ATTACH opens or creates an attached database; DETACH removes it from the
-- current session. DETACH does not delete a database file from disk.
ATTACH IF NOT EXISTS ':memory:' AS practice_db;

-- Show the active jobs_mart database and the temporary practice database.
SHOW DATABASES;

-- jobs_mart is already the active database because it was selected when
-- DuckDB started. Remove only the temporary database from the session.
DETACH practice_db;

SHOW DATABASES;

-- ---------------------------------------------------------------------------
-- 1. DISCOVER THE CURRENT CATALOG
-- ---------------------------------------------------------------------------

SELECT '01 - Discovering the current database and schemas' AS step;

-- List databases attached to the current DuckDB session.
SELECT
    database_name,
    path
FROM duckdb_databases()
ORDER BY database_name;

-- List schemas available in the connected database.
SELECT
    catalog_name,
    schema_name
FROM information_schema.schemata
ORDER BY schema_name;

-- Confirm whether the staging schema already exists.
SELECT
    schema_name
FROM information_schema.schemata
WHERE schema_name = 'staging';

-- ---------------------------------------------------------------------------
-- 2. CREATE THE STAGING SCHEMA
-- ---------------------------------------------------------------------------

SELECT '02 - Rebuilding the staging schema' AS step;

-- Rebuild only this lesson's schema so the script is safe to rerun and does
-- not duplicate the demonstration rows.
DROP SCHEMA IF EXISTS staging CASCADE;

CREATE SCHEMA IF NOT EXISTS staging;

-- ---------------------------------------------------------------------------
-- 3. CREATE A TABLE WITH DDL
-- ---------------------------------------------------------------------------

SELECT '03 - Creating the preferred_role table' AS step;

-- Use the correct spelling: preferred_role.
CREATE TABLE IF NOT EXISTS staging.preferred_role (
    role_id INTEGER,
    role VARCHAR
);

SELECT '03a - Table created: current rows' AS step;
SELECT * FROM staging.preferred_role ORDER BY role_id;

-- Inspect the table definition through information_schema.
SELECT
    table_schema,
    table_name,
    table_type
FROM information_schema.tables
WHERE table_schema = 'staging'
ORDER BY table_name;

-- ---------------------------------------------------------------------------
-- 4. INSERT AND READ ROWS WITH DML
-- ---------------------------------------------------------------------------

SELECT '04 - Inserting, updating, and deleting role data' AS step;

INSERT INTO staging.preferred_role (role_id, role)
VALUES
    (1, 'Data Engineer'),
    (2, 'Analytics Engineer'),
    (3, 'Data Analyst');

SELECT
    role_id,
    role
FROM staging.preferred_role
ORDER BY role_id;

-- Update one existing row using its key.
UPDATE staging.preferred_role
SET role = 'Senior Data Engineer'
WHERE role_id = 1;

SELECT '04a - After UPDATE: role_id 1 changed' AS step;
SELECT * FROM staging.preferred_role ORDER BY role_id;

-- Delete one row using its key.
DELETE FROM staging.preferred_role
WHERE role_id = 3;

SELECT '04b - After DELETE: role_id 3 removed' AS step;
SELECT * FROM staging.preferred_role ORDER BY role_id;

-- ---------------------------------------------------------------------------
-- 5. EVOLVE THE TABLE WITH ALTER TABLE
-- ---------------------------------------------------------------------------

SELECT '05 - Adding and populating the boolean role flag' AS step;

-- Add a boolean flag to identify the preferred role. IF NOT EXISTS keeps the
-- schema change safe when the lesson is run more than once.
ALTER TABLE staging.preferred_role
ADD COLUMN IF NOT EXISTS is_preferred_role BOOLEAN DEFAULT FALSE;

SELECT '05a - After ALTER: boolean column added' AS step;
DESCRIBE staging.preferred_role;
SELECT * FROM staging.preferred_role ORDER BY role_id;

UPDATE staging.preferred_role
SET is_preferred_role = TRUE
WHERE role_id = 1;

SELECT '05b - After UPDATE: preferred flag populated' AS step;
SELECT * FROM staging.preferred_role ORDER BY role_id;

-- Confirm the final table contents after the DML operations.
SELECT
    role_id,
    role,
    is_preferred_role
FROM staging.preferred_role
ORDER BY role_id;

-- ---------------------------------------------------------------------------
-- 6. UPSERT DATA WITH MERGE
-- ---------------------------------------------------------------------------

SELECT '06 - Merging role updates into the target table' AS step;

-- Create a small source table containing one existing role and one new role.
CREATE TABLE staging.preferred_role_updates (
    role_id INTEGER,
    role VARCHAR
);

INSERT INTO staging.preferred_role_updates (role_id, role)
VALUES
    (1, 'Lead Data Engineer'),
    (4, 'Analytics Engineer');

SELECT '06a - MERGE source rows' AS step;
SELECT * FROM staging.preferred_role_updates ORDER BY role_id;

-- MERGE updates the matching role and inserts the new role in one statement.
MERGE INTO staging.preferred_role AS target
USING staging.preferred_role_updates AS source
    ON target.role_id = source.role_id
WHEN MATCHED THEN
    UPDATE SET role = source.role
WHEN NOT MATCHED THEN
    INSERT (role_id, role)
    VALUES (source.role_id, source.role);

SELECT
    role_id,
    role,
    is_preferred_role
FROM staging.preferred_role
ORDER BY role_id;

-- ---------------------------------------------------------------------------
-- 7. RENAME THE TABLE AND EVOLVE THE COLUMN
-- ---------------------------------------------------------------------------

SELECT '07 - Renaming the table and converting the priority column' AS step;

-- Rename the table from preferred_role to priority_roles.
ALTER TABLE staging.preferred_role
RENAME TO priority_roles;

SELECT '07a - After ALTER: table renamed to priority_roles' AS step;
SELECT * FROM staging.priority_roles ORDER BY role_id;

-- Add a boolean column before demonstrating a column rename and type change.
ALTER TABLE staging.priority_roles
ADD COLUMN IF NOT EXISTS preferred_role BOOLEAN DEFAULT FALSE;

SELECT '07b - After ALTER: preferred_role boolean column added' AS step;
DESCRIBE staging.priority_roles;
SELECT * FROM staging.priority_roles ORDER BY role_id;

UPDATE staging.priority_roles
SET preferred_role = TRUE
WHERE role_id = 1;

SELECT '07c - After UPDATE: preferred_role values populated' AS step;
SELECT * FROM staging.priority_roles ORDER BY role_id;

-- Rename preferred_role to priority_lvl. The final name uses the correct
-- spelling and a single underscore for a clean production-style identifier.
ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

SELECT '07d - After ALTER: column renamed to priority_lvl' AS step;
DESCRIBE staging.priority_roles;
SELECT * FROM staging.priority_roles ORDER BY role_id;

-- Convert TRUE/FALSE to integer priority values: TRUE becomes 1 and FALSE 0.
ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl SET DATA TYPE INTEGER
USING CASE WHEN priority_lvl THEN 1 ELSE 0 END;

SELECT '07e - After ALTER: priority_lvl converted to INTEGER' AS step;
DESCRIBE staging.priority_roles;

SELECT
    role_id,
    role,
    is_preferred_role,
    priority_lvl
FROM staging.priority_roles
ORDER BY role_id;

-- ---------------------------------------------------------------------------
-- 8. CLEAN UP THE PRACTICE OBJECTS
-- ---------------------------------------------------------------------------

SELECT '08 - Cleaning up practice tables' AS step;

DROP TABLE IF EXISTS staging.priority_roles;
DROP TABLE IF EXISTS staging.preferred_role_updates;

-- Verify that the practice table has been removed.
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'staging'
ORDER BY table_name;