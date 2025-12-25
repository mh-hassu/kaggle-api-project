Use master;

Select * From dbo.df_orders;
--Total sales and profit per region
Select 
     region,
     SUM(sale_price) as total_sales,
	 SUM(profit) as total_profit
From df_orders
Group BY region
--Top 5 most profitable products overall
Select 
   MAX(product_id) as Products,
   SUM(profit)as Total_profit
From df_orders
Group BY product_id
Order BY Total_profit DESC;
--Total quantity sold per category
SELECT
    category,
    SUM(quantity) AS total_quantity_sold
FROM df_orders
GROUP BY category;
--Average discount offered per sub-category
Select 
     sub_category,
	 AVG(discount) AS Avg_discount_price
FROM dbo.df_orders
Group BY sub_category ;
--Number of orders per ship mode
Select 
      ship_mode,
	  COUNT(order_id) as no_order
FROM dbo.df_orders
Group BY ship_mode;
-----------------------Intermediate Quries-------------------------------------
select * from df_orders;
--Monthly sales trend for 2023
SELECT 
      MONTH(order_date) as sales_month,
	  SUM(sale_price) as total_price
FROM df_orders
WHERE YEAR (order_date) = 2023 
GROUP BY MONTH  (order_date)
ORDER BY sales_month;
---Top 3 States with Highest Revenue
Select  TOP 3
        state,
		SUM(sale_price) as total_revenue
FROM df_orders
GROUP BY state
ORDER BY total_revenue;
---Profit Margin per Category
SELECT 
      category,
	  SUM(profit) as discount_price,
	  SUM(sale_price) as total_sales,
	  ROUND(SUM(profit)*1.0/SUM(sale_price),2) as profit_margin
FROM df_orders
GROUP BY category ;
--City with Highest Average Order Value
SELECT 
     city,
	 AVG(order_id) as total_orders
FROM df_orders
--WHERE (order_id) >= 9000
GROUP BY city
order by total_orders DESC;
--Percentage Contribution of Each Category to Total Sales
WITH cte AS (
    SELECT SUM(sale_price) AS total_sales
    FROM df_orders
)
SELECT
    category,
    SUM(sale_price) AS category_sales,
    ROUND(
        (SUM(sale_price) * 100.0) / total_sales, 
        2
    ) AS sales_percentage
FROM df_orders 
CROSS JOIN cte 
GROUP BY category, total_sales
ORDER BY sales_percentage DESC;
-------------------------ADVANCE TASKS------------------------------
select * FROM df_orders;
--Month-over-month growth in profit for each category (2022 vs 2023)
WITH CTE as(
SELECT
    category,
    MONTH(order_date) AS sales_month,
    SUM(CASE WHEN YEAR(order_date) = 2022 THEN profit END) AS profit_2022,
    SUM(CASE WHEN YEAR(order_date) = 2023 THEN profit END) AS profit_2023
    
FROM df_orders
WHERE YEAR(order_date) IN (2022, 2023)
GROUP BY category, MONTH(order_date)
) 
SELECT 
   category,
   profit_2022,
   profit_2023,
   profit_2023 - profit_2022 AS profit_growth
FROM CTE
ORDER BY category, sales_month ;

--Top 3 Products with Highest YoY Increase in Quantity Sold
SELECT TOP 3
    product_id,
    SUM(CASE WHEN YEAR(order_date) = 2023 THEN quantity ELSE 0 END)
  - SUM(CASE WHEN YEAR(order_date) = 2022 THEN quantity ELSE 0 END) AS qty_increase
FROM df_orders
WHERE YEAR(order_date) IN (2022, 2023)
GROUP BY product_id
ORDER BY qty_increase DESC;
--Sub-category with highest discount impact on sales
SELECT TOP 1
    order_id,
    sub_category,
    SUM(quantity * sale_price) - SUM(quantity * sale_price * (1 - discount)) AS discount_impact
FROM df_orders
GROUP BY sub_category,order_id
ORDER BY discount_impact DESC;
--Region wise top selling sub-category per quarter
WITH cte AS (
    SELECT
        region,
        sub_category,
        DATEPART(QUARTER, order_date) AS quarter,
        SUM(sale_price) AS total_sales
    FROM df_orders
    GROUP BY region, sub_category, DATEPART(QUARTER, order_date)
),
ranked_sales AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY region, quarter
            ORDER BY total_sales DESC
        ) AS rn
    FROM cte
)
SELECT
    region,
    quarter,
    sub_category,
    total_sales
FROM ranked_sales
WHERE rn = 1
ORDER BY region, quarter;
---Segment contributing most profit in each region
WITH cte AS (
    SELECT
        region,
        segment,
        SUM(profit) AS total_profit
    FROM df_orders
    GROUP BY region, segment
),
ranked_segments AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY region
            ORDER BY total_profit DESC
        ) AS rn
    FROM cte
)
SELECT
    region,
    segment,
    total_profit
FROM ranked_segments
WHERE rn = 1;

--find top 10 highest reveue generating products 
select top 10 product_id,sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc

--find top 5 highest selling products in each region
with cte as (
select 
      region,
      product_id,
      sum(sale_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=5

--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as (
select 
       year(order_date) as order_year,
	   month(order_date) as order_month,
       sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
--order by year(order_date),month(order_date)
	)
select 
      order_month, 
      sum(case when order_year=2022 then sales else 0 end) as sales_2022, 
	  sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month

--for each category which month had highest sales 
with cte as (
select 
      category,
	  format(order_date,'yyyyMM') as order_year_month,
	  sum(sale_price) as sales 
from df_orders
group by category,format(order_date,'yyyyMM')
--order by category,format(order_date,'yyyyMM')
)
select * from (
select *,
         row_number() over(partition by category order by sales desc) as rn
from cte
) a
where rn=1

--which sub category had highest growth by profit in 2023 compare to 2022
with cte as (
select sub_category,year(order_date) as order_year,
sum(sale_price) as sales
from df_orders
group by sub_category,year(order_date)
--order by year(order_date),month(order_date)
	)
, cte2 as (
select sub_category
, sum(case when order_year=2022 then sales else 0 end) as sales_2022
, sum(case when order_year=2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
select top 1 *
,(sales_2023-sales_2022)
from  cte2
order by (sales_2023-sales_2022) desc