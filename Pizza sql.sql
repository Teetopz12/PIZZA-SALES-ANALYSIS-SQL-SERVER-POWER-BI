USE [Pizza sales]
-- KPIs

-- 1) Total Revenue (How much money did we make this year?)
SELECT *
FROM pizzas
WHERE pizza_id = 'big_meat_s'


SELECT  
 round(SUM(quantity * price), 2) AS [Total Revenue]
FROM order_details AS o
 JOIN pizzas AS p 
 ON o.pizza_id = p.pizza_id


-- 2) Average Order Value
SELECT 
 SUM(quantity * price)/ COUNT(DISTINCT order_id) AS [Average Order Value]
FROM order_details AS o
 JOIN pizzas AS p 
 ON o.pizza_id = p.pizza_id

-- 3) Total Pizzas Sold
select
SUM(quantity) AS [Total Pizzas Sold]
FROM
  order_details


-- 4) Total Orders
select
  COUNT(DISTINCT order_id) AS [Total Orders]
FROM
  order_details
-- 5) Average Pizzas per Order
SELECT
  ROUND(SUM(quantity)/COUNT(DISTINCT order_id),2) AS [Average Pizzas Per Order]
FROM
  order_details


-- QUESTIONS TO ANSWER 

-- 1) Daily Trends for Total Orders
SELECT 
 FORMAT(date, 'dddd') AS DayOfWeek
 ,COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY FORMAT(date, 'dddd')
ORDER BY total_orders DESC


-- 2) Hourly Trend for Total Orders
SELECT 
    DATEPART(HOUR, time) AS [Hour]
	,COUNT(DISTINCT order_id) AS Total_Orders
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY [Hour]

-- 3) Percentage of Sales by Pizza Category
SELECT *
FROM 
pizzas
SELECT 
    category,
    ROUND(SUM(quantity * price), 2) AS revenue,
    ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    category;

-- 4) Percentage of Sales by Pizza Size
SELECT 
    size
    ,ROUND(SUM(quantity * price), 2) AS revenue
    ,ROUND(SUM(quantity * price) * 100.0 / (SELECT SUM(quantity * price) FROM pizzas AS p2 JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_of_sales
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY 
    size;

-- 5) Total Pizzas Sold by Pizza Category
SELECT
 category
 ,SUM(quantity) AS quantity_sold
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category;

-- 6) Top 5 Best Sellers by Total Pizzas Sold
SELECT top 5
  name
  ,SUM(quantity) AS total_quantity_sold
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity_sold DESC;

-- 7) Bottom 5 Worst Sellers by Total Pizzas Sold
SELECT top 5
  name
  ,SUM(quantity) AS total_quantity_sold
FROM 
    pizzas AS p
JOIN 
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_quantity_sold ASC;
