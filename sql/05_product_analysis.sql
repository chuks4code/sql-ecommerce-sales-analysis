-- ============================================
-- PRODUCT ANALYSIS
-- ============================================


-- ============================================
-- TOP 5 PRODUCTS BY UNITS SOLD
-- ============================================

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 5;


-- ============================================
-- BOTTOM 5 PRODUCTS BY UNITS SOLD
-- ============================================

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY units_sold ASC
LIMIT 5;


-- ============================================
-- TOP PRODUCTS BY REVENUE
-- ============================================

SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


-- ============================================
-- REVENUE BY CATEGORY
-- ============================================

SELECT
    category,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY category
ORDER BY revenue DESC;


-- ============================================
-- AVERAGE QUANTITY SOLD PER PRODUCT
-- ============================================

SELECT
    p.product_name,
    ROUND(AVG(oi.quantity),2) AS avg_quantity_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY avg_quantity_sold DESC;


-- ============================================
-- MOST EXPENSIVE PRODUCTS
-- ============================================

SELECT
    product_name,
    category,
    price
FROM products
ORDER BY price DESC
LIMIT 5;


-- ============================================
-- LEAST EXPENSIVE PRODUCTS
-- ============================================

SELECT
    product_name,
    category,
    price
FROM products
ORDER BY price ASC
LIMIT 5;


-- ============================================
-- NUMBER OF PRODUCTS PER CATEGORY
-- ============================================

SELECT
    category,
    COUNT(*) AS total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;


-- ============================================
-- PRODUCT REVENUE RANKING
-- ============================================

SELECT
    p.product_name,
    ROUND(SUM(oi.quantity * p.price),2) AS revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;


-- ============================================
-- CATEGORY SHARE OF TOTAL REVENUE
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
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY revenue_percentage DESC;