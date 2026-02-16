{{ config(materialized = "table") }}

SELECT game_id,
       TRIM(exploded_team) AS exploded_team
FROM {{ ref("stg_engagement_focused") }}
CROSS JOIN UNNEST(string_to_array(REPLACE(REPLACE(REPLACE(team, '[', ''), ']', ''), '''', ''), ',')) AS exploded_team
WHERE team IS NOT NULL AND
      TRIM(exploded_team) <> ''