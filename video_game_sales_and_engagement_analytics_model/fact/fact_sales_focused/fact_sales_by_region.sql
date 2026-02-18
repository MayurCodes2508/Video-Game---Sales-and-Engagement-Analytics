{{ config(materialized = "table") }}

WITH region_sales AS (
SELECT name,
       platform,
	   year,
	   'NA' AS region,
	   na_sales AS sales
FROM stg_sales_focused_grain
UNION ALL

SELECT name,
       platform,
	   year,
	   'EU',
	   eu_sales
FROM stg_sales_focused_grain
UNION ALL

SELECT name,
       platform,
	   year,
	   'JP',
	   jp_sales
FROM stg_sales_focused_grain
UNION ALL

SELECT name,
       platform,
	   year,
	   'Other',
	   other_sales
FROM stg_sales_focused_grain
)

SELECT d_rel.release_id,
       d_reg.region_id,
	   rs.sales
FROM region_sales rs
JOIN {{ ref("dim_release") }} d_rel
ON rs.name = d_rel.name AND
   rs.platform = d_rel.platform AND
   rs.year = d_rel.year
JOIN {{ ref("dim_region") }} d_reg
ON rs.region = d_reg.region