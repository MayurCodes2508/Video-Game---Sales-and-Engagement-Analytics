{{ config(materialized = "view") }}

SELECT CAST("Rank" AS INT) AS rank,
       TRIM(CAST("Name" AS TEXT)) AS name,
	   TRIM(CAST("Platform" AS TEXT)) AS platform,
	   {{ clean_date_int('"Year"') }} AS year,
	   TRIM(CAST("Genre" AS TEXT)) AS genre,
	   TRIM(CAST("Publisher" AS TEXT)) AS publisher,
	   {{ clean_numeric('"NA_Sales"') }} AS na_sales,
	   {{ clean_numeric('"EU_Sales"') }} AS eu_sales,
	   {{ clean_numeric('"JP_Sales"') }} AS jp_sales,
	   {{ clean_numeric('"Other_Sales"') }} AS other_sales,
	   {{ clean_numeric('"Global_Sales"') }} AS global_sales
FROM {{ source("raw_video_game", "vgsales") }}