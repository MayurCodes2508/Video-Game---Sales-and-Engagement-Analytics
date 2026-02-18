{{ config(materialized = "table") }}

WITH platform_sales_ranking AS (
SELECT d.platform,
       d.name,
       SUM(f.sales) AS total_sales,
	   DENSE_RANK() OVER(PARTITION BY platform ORDER BY SUM(sales) DESC) AS platform_ranking
FROM {{ ref("fact_sales_by_region") }} f
JOIN {{ ref("dim_release") }} d
ON f.release_id = d.release_id
GROUP BY d.platform,
         d.name
)

SELECT *
FROM platform_sales_ranking
WHERE platform_ranking <= 5