{% macro clean_date_int(column_name) %}
-- -----------------------------------------------------------------------------
-- Macro: clean_date_int
--
-- Purpose:
-- Standardizes integer-based date values stored as messy text.
--
-- Handles:
-- - NULL values
-- - Placeholder strings ('N/A', '-', '', 'NULL')
-- - Removes all non-numeric characters
-- - Casts cleaned value to INT
--
-- Examples:
-- '2020'        → 2020
-- ' 2021 '      → 2021
-- 'Year: 2022'  → 2022
-- 'N/A'         → NULL
--
-- Intended Use:
-- - Year columns
-- - Integer date fragments
-- - Numeric date extractions
--
-- -----------------------------------------------------------------------------

CASE
    WHEN {{ column_name }} IS NULL
    OR TRIM(CAST({{ column_name }} AS TEXT)) IN ('N/A', '-', '', 'NULL') THEN NULL
    ELSE REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9]', '', 'g')::INT
END

{% endmacro %}