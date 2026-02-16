{{ config(materialized = "table") }}

SELECT dg.genre_name,
       COUNT(b.game_id) AS game_count
FROM {{ ref("bridge_game_genre") }} b
JOIN {{ ref("dim_genre") }} dg
ON b.genre_name = dg.genre_name
WHERE dg.genre_name IS NOT NULL
GROUP BY dg.genre_name