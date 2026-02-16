{% macro clean_date_all(column_name) %}
-- -----------------------------------------------------------------------------
-- Macro: clean_date_all
--
-- Purpose:
-- Standardizes inconsistent date formats into proper DATE type.
--
-- Handles:
-- - NULL values
-- - Placeholder strings ('N/A', '-', '', 'NULL')
-- - ISO format: 'YYYY-MM-DD'
-- - Text format: 'Mon DD, YYYY'
--
-- Examples:
-- '2022-05-14'    → 2022-05-14
-- 'Jan 15, 2022'  → 2022-01-15
-- 'N/A'           → NULL
--
-- Any unrecognized format returns NULL to avoid incorrect casting.
--
-- Intended Use:
-- - Raw ingestion layer (staging)
-- - Release date cleaning
--
-- -----------------------------------------------------------------------------

CASE
    WHEN {{ column_name }} IS NULL
    OR TRIM(CAST({{ column_name }} AS TEXT)) IN ('N/A', '-', '', 'NULL') THEN NULL
    WHEN TRIM(CAST({{ column_name }} AS TEXT)) ~ '^\d{4}-\d{2}-\d{2}$' 
    THEN TRIM(CAST({{ column_name }} AS TEXT))::DATE
    WHEN TRIM(CAST({{ column_name }} AS TEXT)) ~ '^[A-Za-z]{3} [0-9]{2}, [0-9]{4}$'
    THEN TO_DATE(TRIM(CAST({{ column_name }} AS TEXT)), 'Mon DD, YYYY')
    ELSE NULL
END

{% endmacro %}