{{ config(materialized = "table") }}

SELECT game_id,
       title,
	   release_date,
	   summary,
	   reviews
FROM {{ ref("stg_engagement_focused") }}
