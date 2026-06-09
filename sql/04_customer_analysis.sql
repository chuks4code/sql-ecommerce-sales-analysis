-- ============================================
-- CUSTOMER ANALYSIS
-- ============================================


-- ============================================
-- TOP 5 CUSTOMERS BY TOTAL SPENDING
-- ============================================

SELECT
    c.customer_id,
    c.customer_name,
    ROUND(SUM(oi.quantity * p.price),2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;


-- ============================================
-- TOTAL ORDERS PER CUSTOMER
-- ============================================

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_orders DESC;


-- ============================================
-- AVERAGE CUSTOMER SPEND
-- ============================================

SELECT
ROUND(
SUM(oi.quantity * p.price)
/ COUNT(DISTINCT c.customer_id),2
) AS avg_customer_spend
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================
-- REVENUE BY CITY
-- ============================================

SELECT
    c.city,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.city
ORDER BY revenue DESC;


-- ============================================
-- CUSTOMERS BY CITY
-- ============================================

SELECT
    city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY city
ORDER BY total_customers DESC;


-- ============================================
-- CUSTOMER LIFETIME VALUE
-- ============================================

SELECT
    c.customer_name,
    ROUND(SUM(oi.quantity * p.price),2) AS customer_lifetime_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY customer_lifetime_value DESC;


-- ============================================
-- NEW CUSTOMERS BY SIGNUP MONTH
-- ============================================

SELECT
    TO_CHAR(signup_date,'YYYY-MM') AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY signup_month
ORDER BY signup_month;


-- ============================================
-- CUSTOMER SEGMENTATION
-- ============================================

SELECT
    customer_name,
    total_spent,
    CASE
        WHEN total_spent >= 2000 THEN 'High Value'
        WHEN total_spent >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM
(
    SELECT
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_name
) customer_spending
ORDER BY total_spent DESC;


-- ============================================
-- REPEAT CUSTOMERS
-- ============================================

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;


-- ============================================
-- CUSTOMER COUNTRY DISTRIBUTION
-- ============================================

SELECT
    country,
    COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;