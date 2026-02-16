{% macro clean_numeric(column_name) %}
-- -----------------------------------------------------------------------------
-- Macro: clean_numeric
--
-- Purpose:
-- Standardizes messy numeric text values into clean FLOAT numbers.
--
-- Handles:
-- - NULL values
-- - Placeholder strings ('N/A', '-', '', 'NULL')
-- - Abbreviations:
--     k = thousand
--     m = million
--     b = billion
-- - Removes non-numeric characters safely
--
-- Examples:
-- '1.2k'   → 1200
-- '3m'     → 3000000
-- '2.5b'   → 2500000000
-- '450'    → 450
-- 'N/A'    → NULL
--
-- -----------------------------------------------------------------------------

CASE
    WHEN {{ column_name }} IS NULL
    OR TRIM(CAST({{ column_name }} AS TEXT)) IN ('N/A', '-', '', 'NULL') THEN NULL
    WHEN TRIM(CAST({{ column_name }} AS TEXT)) ILIKE '%k%' THEN REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9.]', '', 'g')::FLOAT * 1000
    WHEN TRIM(CAST({{ column_name }} AS TEXT)) ILIKE '%m%' THEN REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9.]', '', 'g')::FLOAT * 1000000
    WHEN TRIM(CAST({{ column_name }} AS TEXT)) ILIKE '%b%' THEN REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9.]', '', 'g')::FLOAT * 1000000000
    ELSE REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9.]', '', 'g')::FLOAT
END

{% endmacro %}