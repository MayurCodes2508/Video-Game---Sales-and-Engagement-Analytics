{{ config(materialized = "table") }}

SELECT d.title,
       f.backlogs,
	   f.wishlist,
	   ROUND((f.backlogs::numeric / NULLIF(f.wishlist::numeric, 0)), 1) AS backlog_ratio
FROM {{ ref("fact_engagement") }} f
JOIN {{ ref("dim_title") }} d
ON d.game_id = f.game_id
WHERE d.title IS NOT NULL AND
      f.backlogs IS NOT NULL AND
	  f.wishlist IS NOT NULL AND
	  f.wishlist >= 20