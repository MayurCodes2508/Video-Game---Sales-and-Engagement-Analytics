{{ config(materialized = "table") }}

SELECT DISTINCT exploded_genre AS genre_name
FROM {{ ref("int_genre_exploded") }}
