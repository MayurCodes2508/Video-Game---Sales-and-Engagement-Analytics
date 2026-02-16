{{ config(materialized = "table") }}

WITH team_stats AS (
SELECT dt.team_name,
       COUNT(DISTINCT f.game_id) AS game_count,
	   SUM(f.number_of_reviews) AS total_reviews,
	   AVG(f.rating) AS avg_rating
FROM {{ ref("fact_engagement") }} f
JOIN {{ ref("bridge_game_team") }} b
ON f.game_id = b.game_id
JOIN {{ ref("dim_team") }} dt
ON b.team_name = dt.team_name
WHERE dt.team_name IS NOT NULL
GROUP BY dt.team_name
),

ranking AS (
SELECT *,
       DENSE_RANK() OVER(ORDER BY game_count DESC) AS impact_rank,
	   DENSE_RANK() OVER(ORDER BY total_reviews DESC) AS productivity_rank,
	   DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS quality_rank
FROM team_stats
),

composite AS (
SELECT *,
       (impact_rank + productivity_rank + quality_rank) AS composite_score
FROM ranking
)

SELECT *,
       DENSE_RANK() OVER(ORDER BY composite_score ASC) AS final_rank
FROM composite