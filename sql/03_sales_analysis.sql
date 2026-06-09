-- ============================================
-- SALES ANALYSIS
-- ============================================

-- ============================================
-- TOTAL REVENUE BY CATEGORY
-- ============================================

SELECT
    p.category,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


-- ============================================
-- TOP 5 PRODUCTS BY REVENUE
-- ============================================

SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;


-- ============================================
-- TOP 5 PRODUCTS BY QUANTITY SOLD
-- ============================================

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 5;


-- ============================================
-- NUMBER OF ORDERS PER MONTH
-- ============================================

SELECT
    TO_CHAR(order_date,'YYYY-MM') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


-- ============================================
-- MONTHLY REVENUE
-- ============================================

SELECT
    TO_CHAR(o.order_date,'YYYY-MM') AS month,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;


-- ============================================
-- AVERAGE REVENUE PER ORDER
-- ============================================

SELECT
    ROUND(
        SUM(oi.quantity * p.price)
        /
        COUNT(DISTINCT o.order_id)
    ,2) AS avg_revenue_per_order
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================
-- DAILY SALES
-- ============================================

SELECT
    o.order_date,
    ROUND(SUM(oi.quantity * p.price),2) AS daily_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;


-- ============================================
-- REVENUE CONTRIBUTION BY CATEGORY
-- ============================================

SELECT
    p.category,
    ROUND(
        100.0 * SUM(oi.quantity * p.price)
        /
        (
            SELECT SUM(oi2.quantity * p2.price)
            FROM order_items oi2
            JOIN products p2
                ON oi2.product_id = p2.product_id
        ),
        2
    ) AS revenue_percentage
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue_percentage DESC;


-- ============================================
-- HIGHEST VALUE ORDER
-- ============================================

SELECT
    o.order_id,
    ROUND(SUM(oi.quantity * p.price),2) AS order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_id
ORDER BY order_value DESC
LIMIT 1;


-- ============================================
-- LOWEST VALUE ORDER
-- ============================================

SELECT
    o.order_id,
    ROUND(SUM(oi.quantity * p.price),2) AS order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_id
ORDER BY order_value ASC
LIMIT 1;