{{ config(materialized = "table") }}

SELECT game_id,
       TRIM(exploded_genre) AS exploded_genre
FROM {{ ref("stg_engagement_focused") }}
CROSS JOIN UNNEST(string_to_array(REPLACE(REPLACE(REPLACE(genres, '[', ''), ']', ''), '''', ''), ',')) AS exploded_genre
WHERE genres IS NOT NULL AND
      TRIM(exploded_genre) <> ''