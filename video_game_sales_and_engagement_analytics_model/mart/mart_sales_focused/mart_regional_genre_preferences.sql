{{ config(materialized = "table") }}

SELECT d_reg.region,
       d_rel.genre,
	   SUM(f.sales) AS total_sales
FROM {{ ref("dim_region") }} d_reg
JOIN {{ ref("fact_sales_by_region") }} f
ON d_reg.region_id = f.region_id
JOIN {{ ref("dim_release") }} d_rel
ON f.release_id = d_rel.release_id
WHERE d_rel.genre IS NOT NULL
GROUP BY d_reg.region,
         d_rel.genre
         