{{ config(materialized = "table") }}

WITH genre_stats AS (
SELECT dg.genre_name,
       AVG(f.plays) AS avg_plays,
	   COUNT(DISTINCT f.game_id) AS game_count
FROM {{ ref("fact_engagement") }} f
JOIN {{ ref("bridge_game_genre") }} b
ON f.game_id = b.game_id
JOIN {{ref("dim_genre") }} dg
ON b.genre_name = dg.genre_name
WHERE dg.genre_name IS NOT NULL
GROUP BY dg.genre_name
),

ranking AS (
SELECT *,
       DENSE_RANK() OVER(ORDER BY avg_plays DESC, game_count DESC) AS genre_ranking
FROM genre_stats
)

SELECT *
FROM ranking
WHERE game_count >= 3