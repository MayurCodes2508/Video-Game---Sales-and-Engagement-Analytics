{{ config(materialized = "table") }}

SELECT d_reg.region,
       d_rel.year,
	   SUM(f.sales) AS total_sales
FROM {{ ref("dim_release") }} d_rel
JOIN {{ ref("fact_sales_by_region") }} f
ON d_rel.release_id = f.release_id
JOIN {{ ref("dim_region") }} d_reg
ON f.region_id = d_reg.region_id
GROUP BY d_reg.region,
         d_rel.year
