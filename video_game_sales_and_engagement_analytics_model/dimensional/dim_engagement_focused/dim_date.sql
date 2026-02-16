{{ config(materialized = "table") }}

SELECT DISTINCT release_date AS date,
       EXTRACT(YEAR FROM release_date):: int AS year,
	   EXTRACT(MONTH FROM release_date):: int AS month,
	   EXTRACT(DAY FROM release_date):: int AS day
FROM {{ ref("stg_engagement_focused") }}
WHERE release_date IS NOT NULL