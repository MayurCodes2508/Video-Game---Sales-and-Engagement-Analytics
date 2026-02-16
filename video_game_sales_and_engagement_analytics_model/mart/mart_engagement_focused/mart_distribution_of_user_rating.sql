{{ config(materialized = "table") }}

SELECT CASE
           WHEN rating >= 2 AND rating < 3 THEN '2-3'
		   WHEN rating >= 3 AND rating < 4 THEN '3-4'
		   WHEN rating >= 4 AND rating <= 5 THEN '4-5'
	  END AS rating_bucket,
	  COUNT(game_id) AS game_count
FROM {{ ref("fact_engagement") }}
WHERE rating IS NOT NULL  AND
      rating >= 2
GROUP BY rating_bucket