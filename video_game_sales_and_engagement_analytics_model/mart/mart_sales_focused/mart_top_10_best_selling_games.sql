{{ config(materialized = "table") }}

WITH game_sales AS (
SELECT d.name,
       SUM(f.sales) AS total_sales,
	   DENSE_RANK() OVER(ORDER BY SUM(f.sales) DESC) AS game_ranking
FROM {{ ref("fact_sales_by_region") }} f
JOIN {{ ref("dim_release") }} d
ON f.release_id = d.release_id
GROUP BY d.name
)

SELECT *
FROM game_sales
WHERE game_ranking <= 10