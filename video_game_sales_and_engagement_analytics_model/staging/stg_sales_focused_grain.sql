{{ config(materialized = "view") }}

SELECT name, 
       platform, 
       year, 
       genre, 
       publisher,
       SUM(na_sales) AS na_sales,
       SUM(eu_sales) AS eu_sales,
       SUM(jp_sales) AS jp_sales,
       SUM(other_sales) AS other_sales,
       SUM(na_sales + eu_sales + jp_sales + other_sales) AS global_sales
FROM {{ ref("stg_sales_focused") }}
GROUP BY name, platform, year, genre, publisher