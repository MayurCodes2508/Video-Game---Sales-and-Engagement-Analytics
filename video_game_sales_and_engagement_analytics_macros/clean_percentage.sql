{% macro clean_percentage(column_name) %}
-- ----------------------------------------------------------------------------
-- Macro: clean_percentage
--
-- Purpose:
-- Standardizes messy percentage inputs into numeric float values.
--
-- Handles:
-- - NULL values
-- - Placeholder strings ('N/A', '-', '', 'NULL')
-- - Values containing '%' symbols (converts to decimal)
-- - Removes non-numeric characters safely
--
-- Examples:
-- '75%'     → 0.75
-- '75'      → 75
-- ' 85 % '  → 0.85
-- 'N/A'     → NULL
--
-- -----------------------------------------------------------------------------

CASE
    WHEN {{ column_name }} IS NULL
    OR TRIM(CAST({{ column_name }} AS TEXT)) IN ('N/A', '-', '', 'NULL') THEN NULL
    WHEN TRIM(CAST({{ column_name }} AS TEXT)) LIKE '%\%%' THEN
    REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9.]', '', 'g')::FLOAT / 100
    ELSE REGEXP_REPLACE(TRIM(CAST({{ column_name }} AS TEXT)), '[^0-9.]', '', 'g')::FLOAT
END

{% endmacro %}