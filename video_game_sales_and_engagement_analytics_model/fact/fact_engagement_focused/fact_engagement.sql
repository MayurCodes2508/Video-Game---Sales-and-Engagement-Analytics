{{ config(materialized = "table") }}

SELECT game_id,
       rating,
	   times_listed,
	   number_of_reviews,
	   plays,
	   playing,
	   backlogs,
	   wishlist
FROM {{ ref("stg_engagement_focused") }}