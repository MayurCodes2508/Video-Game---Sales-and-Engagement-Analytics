{{ config(materialized = "table") }}

SELECT {{ dbt_utils.generate_surrogate_key(['name', 'platform', 'year']) }} AS release_id,
       name,
       platform,
	   year,
	   genre,
	   publisher
FROM {{ ref("stg_sales_focused_grain") }}
