{{ config(materialized = "table") }}

WITH region_name AS (
SELECT 'NA' AS region
UNION ALL

SELECT 'EU'
UNION ALL

SELECT 'JP'
UNION ALL

SELECT 'Other'
)

SELECT {{ dbt_utils.generate_surrogate_key(['region']) }} AS region_id,
       region
FROM region_name