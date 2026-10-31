USE food_delivery_db;
GO


-- 1. Total orders 
SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Total revenue from completed orders 
SELECT SUM(order_amount) AS total_revenue
FROM orders
WHERE order_status <> 'Cancelled';

-- 3. Average order value (completed orders) 
SELECT ROUND(AVG(order_amount), 2) AS avg_order_value
FROM orders
WHERE order_status <> 'Cancelled';

-- 4. Revenue by restaurant 
SELECT r.restaurant_name,
       SUM(o.order_amount) AS revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status <> 'Cancelled'
GROUP BY r.restaurant_name
ORDER BY revenue DESC;

-- 5. Revenue by city 
SELECT c.city,
       SUM(o.order_amount) AS revenue
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.city
ORDER BY revenue DESC;

-- 6. Top 10 restaurants by order volume and revenue 
SELECT TOP 10
       r.restaurant_name,
       COUNT(o.order_id)   AS total_orders,
       SUM(o.order_amount) AS revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status <> 'Cancelled'
GROUP BY r.restaurant_name
ORDER BY total_orders DESC, revenue DESC;

-- 7. Highest revenue cuisine [BASIC]
SELECT r.cuisine,
       SUM(o.order_amount) AS revenue
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status <> 'Cancelled'
GROUP BY r.cuisine
ORDER BY revenue DESC;

-- 8a. Daily revenue trend [NEW: CAST to DATE]
SELECT CAST(order_date AS DATE) AS order_day,
       SUM(order_amount)        AS daily_revenue
FROM orders
WHERE order_status <> 'Cancelled'
GROUP BY CAST(order_date AS DATE)
ORDER BY order_day;

-- 8b. Monthly revenue trend [NEW: YEAR / MONTH functions]
SELECT YEAR(order_date)  AS order_year,
       MONTH(order_date) AS order_month,
       SUM(order_amount) AS monthly_revenue
FROM orders
WHERE order_status <> 'Cancelled'
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- 9. Restaurant market share (% of total revenue)
SELECT r.restaurant_name,
       SUM(o.order_amount) AS revenue,
       ROUND(100.0 * SUM(o.order_amount) /
             (SELECT SUM(order_amount) FROM orders WHERE order_status <> 'Cancelled'), 2)
             AS market_share_pct
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status <> 'Cancelled'
GROUP BY r.restaurant_name
ORDER BY market_share_pct DESC;

-- 10. Average delivery time in minutes
-- (cancelled orders have NULL time and are ignored by AVG automatically)
SELECT ROUND(AVG(delivery_time_minutes * 1.0), 1) AS avg_delivery_minutes
FROM orders;

-- 11. On-time delivery rate 
SELECT ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS on_time_rate_pct
FROM orders
WHERE order_status = 'Delivered';

-- 12. Delayed delivery rate 
SELECT ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS delayed_rate_pct
FROM orders
WHERE order_status = 'Delayed';

-- 13. Cancellation rate 
SELECT ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS cancellation_rate_pct
FROM orders
WHERE order_status = 'Cancelled';

-- 14. Delivery time by city 
SELECT c.city,
       ROUND(AVG(o.delivery_time_minutes * 1.0), 1) AS avg_delivery_minutes
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY avg_delivery_minutes;

-- 15. Delivery time by cuisine 
SELECT r.cuisine,
       ROUND(AVG(o.delivery_time_minutes * 1.0), 1) AS avg_delivery_minutes
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine
ORDER BY avg_delivery_minutes;

-- 16. Delivery partner performance
SELECT p.partner_name,
       p.vehicle_type,
       COUNT(o.order_id) AS total_orders,
       ROUND(AVG(o.delivery_time_minutes * 1.0), 1) AS avg_delivery_minutes,
       SUM(CASE WHEN o.order_status = 'Delayed'   THEN 1 ELSE 0 END) AS delayed_orders,
       SUM(CASE WHEN o.order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders
FROM orders o
JOIN delivery_partners p ON o.partner_id = p.partner_id
GROUP BY p.partner_name, p.vehicle_type
ORDER BY avg_delivery_minutes;

-- 17. Average orders per delivery partner 
SELECT COUNT(order_id) * 1.0 / COUNT(DISTINCT partner_id) AS avg_orders_per_partner
FROM orders;


-- 18. Orders by hour of day 
SELECT DATEPART(HOUR, order_date) AS order_hour,
       COUNT(*) AS total_orders
FROM orders
GROUP BY DATEPART(HOUR, order_date)
ORDER BY order_hour;

-- 19. Peak ordering hour 
SELECT TOP 1 WITH TIES
       DATEPART(HOUR, order_date) AS peak_hour,
       COUNT(*) AS total_orders
FROM orders
GROUP BY DATEPART(HOUR, order_date)
ORDER BY COUNT(*) DESC;

-- 20. Orders and revenue by day of week 
SELECT DATENAME(WEEKDAY, order_date) AS day_of_week,
       COUNT(*) AS total_orders,
       SUM(CASE WHEN order_status <> 'Cancelled' THEN order_amount ELSE 0 END) AS revenue
FROM orders
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY total_orders DESC;

-- 21. Top customers by spending 
SELECT TOP 10
       c.customer_name,
       COUNT(o.order_id)   AS total_orders,
       SUM(o.order_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- 22. Customer retention rate: % of customers with more than 1 order 
SELECT ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) AS retention_rate_pct
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS repeat_customers;

-- 23. Repeat order rate: how many customers ordered more than once 
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) AS repeat_customers;

-- 24. Customer lifetime value (per customer)
SELECT c.customer_name,
       c.city,
       COUNT(o.order_id)             AS total_orders,
       SUM(o.order_amount)           AS lifetime_value,
       ROUND(AVG(o.order_amount), 2) AS avg_order_value,
       MIN(o.order_date)             AS first_order,
       MAX(o.order_date)             AS last_order
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status <> 'Cancelled'
GROUP BY c.customer_name, c.city
ORDER BY lifetime_value DESC;

-- 25. Average restaurant rating (by restaurant, then by cuisine)
SELECT restaurant_name, cuisine, rating
FROM restaurants
ORDER BY rating DESC;

SELECT cuisine, ROUND(AVG(rating), 2) AS avg_rating
FROM restaurants
GROUP BY cuisine
ORDER BY avg_rating DESC;