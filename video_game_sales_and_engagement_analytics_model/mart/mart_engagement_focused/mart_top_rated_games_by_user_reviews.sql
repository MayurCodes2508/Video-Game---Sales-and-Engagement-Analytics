{{ config(materialized = "table") }}

WITH title_stats AS (
SELECT d.title,
       SUM(f.rating * f.number_of_reviews) / NULLIF(SUM(f.number_of_reviews), 0) AS weighted_rating,
	   SUM(f.number_of_reviews) AS total_reviews
FROM {{ ref("fact_engagement") }} f
JOIN {{ ref("dim_title") }} d
ON f.game_id = d.game_id
WHERE d.title IS NOT NULL AND
      f.rating IS NOT NULL AND
	  f.number_of_reviews IS NOT NULL
GROUP BY d.title
),

ranking AS (
SELECT *,
	   DENSE_RANK() OVER(ORDER BY weighted_rating DESC, total_reviews DESC) AS title_ranking
FROM title_stats
)

SELECT *
FROM ranking
WHERE total_reviews >= 50