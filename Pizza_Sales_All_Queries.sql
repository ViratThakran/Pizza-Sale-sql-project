-- PIZZA SALES ANALYSIS PROJECT

-- DATABASE SETUP
CREATE DATABASE pizza_sales_db;

-- TOTAL ORDERS
SELECT COUNT(*) AS total_orders
FROM orders;

-- TOTAL REVENUE
SELECT ROUND(SUM(od.quantity * p.price),2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- AVERAGE ORDER VALUE
SELECT ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id),2) AS avg_order_value
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- TOTAL PIZZAS SOLD
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;

-- HIGHEST PRICED PIZZA
SELECT pt.name, p.price
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- MOST COMMON PIZZA SIZE
SELECT p.size, COUNT(*) AS total_orders
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_orders DESC;

-- TOP 10 MOST ORDERED PIZZAS
SELECT pt.name, SUM(od.quantity) AS quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY quantity_sold DESC
LIMIT 10;

-- REVENUE BY CATEGORY
SELECT pt.category,
ROUND(SUM(od.quantity*p.price),2) revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id=p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- ORDERS BY HOUR
SELECT EXTRACT(HOUR FROM time) AS order_hour,
COUNT(*) AS orders_count
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

-- DAILY SALES
SELECT o.date,
ROUND(SUM(od.quantity*p.price),2) AS revenue
FROM orders o
JOIN order_details od ON o.order_id=od.order_id
JOIN pizzas p ON od.pizza_id=p.pizza_id
GROUP BY o.date;

-- MONTHLY REVENUE TREND
SELECT EXTRACT(MONTH FROM o.date) AS month,
ROUND(SUM(od.quantity*p.price),2) revenue
FROM orders o
JOIN order_details od ON o.order_id=od.order_id
JOIN pizzas p ON od.pizza_id=p.pizza_id
GROUP BY month
ORDER BY month;

-- TOP 5 REVENUE GENERATING PIZZAS
SELECT pt.name,
ROUND(SUM(od.quantity*p.price),2) revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id=p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 5;

-- CATEGORY CONTRIBUTION PERCENTAGE
SELECT pt.category,
ROUND(SUM(od.quantity*p.price)*100/
(SUM(SUM(od.quantity*p.price)) OVER()),2) AS contribution_pct
FROM order_details od
JOIN pizzas p ON od.pizza_id=p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id=pt.pizza_type_id
GROUP BY pt.category;
