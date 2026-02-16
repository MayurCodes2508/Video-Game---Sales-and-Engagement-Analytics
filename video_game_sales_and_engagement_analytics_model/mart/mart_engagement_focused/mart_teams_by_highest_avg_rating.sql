{{ config(materialized = "table") }}

WITH team_stats AS (
SELECT dt.team_name,
       ROUND(AVG(f.rating)::numeric, 1) AS avg_rating,
	   COUNT(DISTINCT f.game_id) AS game_count
FROM {{ ref("fact_engagement") }} f
JOIN {{ ref("bridge_game_team") }} b
ON f.game_id = b.game_id
JOIN {{ ref("dim_team") }} dt
ON b.team_name = dt.team_name
WHERE dt.team_name IS NOT NULL  AND
      f.rating IS NOT NULL
GROUP BY dt.team_name
),

ranking AS (
SELECT *,
	   DENSE_RANK() OVER(ORDER BY avg_rating DESC, game_count DESC) AS team_ranking
FROM team_stats
)

SELECT *
FROM ranking
WHERE game_count >= 3