{{ config(materialized = "table") }}

SELECT d.region,
       SUM(f.sales) AS total_sales
FROM {{ ref("fact_sales_by_region") }} f
JOIN {{ ref("dim_region") }} d
ON f.region_id = d.region_id
GROUP BY d.region
