{{ config(materialized = "table") }}

WITH release_totals AS (
SELECT release_id,
       SUM(sales) AS total_release_sales
FROM {{ ref("fact_sales_by_region") }} f
GROUP BY release_id
)

SELECT d.publisher,
       AVG(rt.total_release_sales) AS avg_sales,
	   COUNT(DISTINCT rt.release_id) AS game_releases
FROM {{ ref("dim_release") }} d
JOIN release_totals rt
ON d.release_id = rt.release_id
WHERE d.publisher IS NOT NULL
GROUP BY d.publisher
HAVING COUNT(DISTINCT rt.release_id) > 8