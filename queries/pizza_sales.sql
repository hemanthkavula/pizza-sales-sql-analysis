-- ====================================================================
-- PIZZA SALES ANALYSIS - SQL QUERIES
-- ====================================================================
-- Author: Hemanth Kavula
-- Database: MySQL
-- Purpose: Comprehensive analysis of pizza sales data to derive 
--          business insights on revenue, customer behavior, and operations
-- ====================================================================

USE pizza_sales;

-- ====================================================================
-- SECTION 1: DATA EXPLORATION
-- ====================================================================

-- View all tables
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;
SELECT * FROM order_details;

-- QUERY 1: Retrieve the total number of orders placed
SELECT COUNT(*) AS total_orders 
FROM orders;

-- QUERY 2: Calculate the total revenue generated from pizza sales
SELECT ROUND(SUM(quantity * price), 2) AS total_revenue 
FROM order_details AS o 
JOIN pizzas AS p ON o.pizza_id = p.pizza_id;

-- QUERY 3: Identify the highest-priced pizza
SELECT 
    p.pizza_id, 
    p.pizza_type_id, 
    pt.name, 
    p.size, 
    p.price 
FROM pizzas AS p 
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id 
ORDER BY price DESC 
LIMIT 1;

-- QUERY 4: Identify the most common pizza size ordered
SELECT 
    p.size, 
    COUNT(*) AS pizza_total
FROM order_details AS o 
JOIN pizzas AS p ON o.pizza_id = p.pizza_id 
GROUP BY p.size 
ORDER BY pizza_total DESC 
LIMIT 1;

-- ====================================================================
-- SECTION 2: SALES ANALYSIS
-- ====================================================================

-- QUERY 5: List the top 5 most ordered pizza types along with their quantities
SELECT 
    pt.pizza_type_id, 
    pt.name, 
    SUM(o.quantity) AS quantity
FROM order_details AS o 
JOIN pizzas AS p ON o.pizza_id = p.pizza_id
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id 
GROUP BY pt.pizza_type_id, pt.name 
ORDER BY quantity DESC 
LIMIT 5;

-- QUERY 6: Determine the distribution of orders by hour of the day
SELECT 
    HOUR(time) AS hour, 
    COUNT(*) AS total_orders 
FROM orders 
GROUP BY HOUR(time) 
ORDER BY total_orders DESC;

-- QUERY 7: Hourly order distribution with percentage contribution
SELECT 
    hour, 
    hourly_orders, 
    SUM(hourly_orders) OVER () AS total_orders,
    ROUND(100 * hourly_orders / SUM(hourly_orders) OVER (), 2) AS contribution_percent
FROM (
    SELECT 
        HOUR(time) AS hour, 
        COUNT(*) AS hourly_orders
    FROM orders 
    GROUP BY HOUR(time)
) AS a
ORDER BY hourly_orders DESC;

-- QUERY 8: Determine the top 3 most ordered pizza types based on revenue
SELECT 
    pt.pizza_type_id, 
    pt.name, 
    SUM(quantity * price) AS revenue
FROM order_details AS o 
JOIN pizzas AS p ON o.pizza_id = p.pizza_id 
JOIN pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id 
GROUP BY p.pizza_type_id, pt.name 
ORDER BY revenue DESC 
LIMIT 3;

-- ====================================================================
-- SECTION 3: ADVANCED ANALYTICS - REVENUE ANALYSIS
-- ====================================================================

-- QUERY 9: Calculate the percentage contribution of each pizza type to total revenue
WITH revenue_cte AS (
    SELECT 
        p.pizza_type_id, 
        pt.name,
        SUM(price * quantity) AS pizza_type_revenue
    FROM order_details AS o 
    JOIN pizzas AS p ON o.pizza_id = p.pizza_id 
    JOIN pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id 
    GROUP BY p.pizza_type_id, pt.name
)
SELECT 
    pizza_type_id, 
    name,
    pizza_type_revenue,
    SUM(pizza_type_revenue) OVER() AS total_revenue,
    ROUND(100 * (pizza_type_revenue / SUM(pizza_type_revenue) OVER()), 2) AS percentage_contribution
FROM revenue_cte
ORDER BY pizza_type_revenue DESC;

-- QUERY 10: Analyze the cumulative revenue generated over time
WITH revenue_time AS (
    SELECT 
        o.date, 
        SUM(od.quantity * p.price) AS revenue
    FROM order_details AS od 
    JOIN pizzas AS p ON od.pizza_id = p.pizza_id 
    JOIN orders AS o ON od.order_id = o.order_id 
    GROUP BY o.date
)
SELECT 
    date, 
    revenue,
    SUM(revenue) OVER (
        ORDER BY date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM revenue_time;

-- QUERY 11: Determine the top 3 most ordered pizza types based on revenue for each category
WITH rev_cte AS (
    SELECT 
        pt.category, 
        pt.pizza_type_id, 
        pt.name, 
        SUM(quantity * price) AS rev_pizza_type
    FROM order_details AS od 
    JOIN pizzas AS p ON od.pizza_id = p.pizza_id 
    JOIN pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id 
    GROUP BY pt.category, pt.pizza_type_id, pt.name
),
rev_cte2 AS (
    SELECT *,
        DENSE_RANK() OVER (
            PARTITION BY category 
            ORDER BY rev_pizza_type DESC
        ) AS rn
    FROM rev_cte
)
SELECT * 
FROM rev_cte2 
WHERE rn <= 3;

-- ====================================================================
-- SECTION 4: CATEGORY-WISE ANALYSIS
-- ====================================================================

-- QUERY 12: Find the total quantity of each pizza category ordered
SELECT 
    pt.category, 
    SUM(od.quantity) AS total_quantity
FROM order_details AS od 
JOIN pizzas AS p ON od.pizza_id = p.pizza_id 
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id 
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- QUERY 13: Find the category-wise distribution of pizzas
SELECT 
    pt.category, 
    COUNT(p.pizza_id) AS distribution
FROM pizzas AS p 
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id 
GROUP BY pt.category
ORDER BY distribution DESC;

-- QUERY 14: Calculate the average number of pizzas ordered per day
WITH avg_cte AS (
    SELECT 
        o.date, 
        SUM(od.quantity) AS sum_pizzas
    FROM order_details AS od 
    JOIN orders AS o ON od.order_id = o.order_id 
    GROUP BY o.date
)
SELECT 
    ROUND(AVG(sum_pizzas), 2) AS avg_pizzas_per_day
FROM avg_cte;

-- ====================================================================
-- END OF QUERIES
-- ====================================================================