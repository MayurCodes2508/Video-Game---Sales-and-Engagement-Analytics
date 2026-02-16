{{ config(materialized = "view") }}

SELECT CAST("a" AS INT) AS game_id,
       TRIM(CAST("Title" AS TEXT)) AS title,
	   {{ clean_date_all('"Release Date"') }} AS release_date,
       TRIM(CAST("Team" AS TEXT)) AS team,
       {{ clean_numeric('"Rating"') }} AS rating,
       {{ clean_numeric('"Times Listed"') }} AS times_listed, 
	   {{ clean_numeric('"Number of Reviews"') }} AS number_of_reviews,  
	   TRIM(CAST("Genres" AS TEXT)) AS genres,
	   TRIM(CAST("Summary" AS TEXT)) AS summary,
	   TRIM(CAST("Reviews" AS TEXT)) AS reviews,
	   {{ clean_numeric('"Plays"') }} AS plays,  
	   {{ clean_numeric('"Playing"') }} AS playing,  
	   {{ clean_numeric('"Backlogs"') }} AS backlogs,  
	   {{ clean_numeric('"Wishlist"') }} AS wishlist
FROM {{ source("raw_video_game", "games") }}