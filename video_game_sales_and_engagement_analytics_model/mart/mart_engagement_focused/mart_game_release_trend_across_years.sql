{{ config(materialized = "table") }}

SELECT dd.year,
       COUNT(dt.game_id) AS game_count
FROM {{ ref("dim_title") }} dt
JOIN {{ ref("dim_date") }} dd
ON dt.release_date = dd.date
GROUP BY dd.year 