{{ config(materialized = "table") }}

SELECT DISTINCT game_id,
       exploded_genre AS genre_name
FROM {{ ref("int_genre_exploded") }}