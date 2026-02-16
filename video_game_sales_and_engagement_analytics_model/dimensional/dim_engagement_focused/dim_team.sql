{{ config(materialized = "table") }}

SELECT DISTINCT exploded_team AS team_name
FROM {{ ref("int_team_exploded") }}