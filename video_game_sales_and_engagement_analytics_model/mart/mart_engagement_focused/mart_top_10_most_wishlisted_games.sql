{{ config(materialized = "table") }}

WITH title_stats AS (
SELECT d.title,
       SUM(f.wishlist) AS total_wishlist
FROM {{ ref("fact_engagement") }} f
JOIN {{ ref("dim_title") }} d
ON f.game_id = d.game_id
WHERE d.title IS NOT NULL AND
      f.wishlist IS NOT NULL
GROUP BY d.title
),

wishlist_ranking AS (
SELECT *,
	   ROW_NUMBER() OVER(ORDER BY total_wishlist DESC) AS ranking
FROM title_stats
)

SELECT *
FROM wishlist_ranking
WHERE ranking <= 10
