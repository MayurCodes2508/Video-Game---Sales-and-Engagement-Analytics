{{ config(materialized = "table") }}

SELECT d.publisher,
       SUM(f.sales) AS total_sales
FROM {{ ref("fact_sales_by_region") }} f
JOIN {{ ref("dim_release") }} d
ON f.release_id = d.release_id
WHERE d.publisher IS NOT NULL
GROUP BY d.publisher
