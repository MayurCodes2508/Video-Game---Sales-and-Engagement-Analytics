{{ config(materialized = "table") }}

SELECT DISTINCT game_id,
       exploded_team AS team_name
FROM {{ ref("int_team_exploded") }}