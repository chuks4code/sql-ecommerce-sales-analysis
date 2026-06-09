-- ============================================
-- EXPLORATORY DATA ANALYSIS
-- ============================================


-- ============================================
-- TOTAL CUSTOMERS
-- ============================================

SELECT COUNT(*) AS total_customers
FROM customers;


-- ============================================
-- TOTAL PRODUCTS
-- ============================================

SELECT COUNT(*) AS total_products
FROM products;


-- ============================================
-- TOTAL ORDERS
-- ============================================

SELECT COUNT(*) AS total_orders
FROM orders;


-- ============================================
-- TOTAL UNITS SOLD
-- ============================================

SELECT SUM(quantity) AS total_units_sold
FROM order_items;


-- ============================================
-- TOTAL REVENUE
-- ============================================

SELECT
ROUND(SUM(oi.quantity * p.price),2) AS total_revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;


-- ============================================
-- AVERAGE PRODUCT PRICE
-- ============================================

SELECT
ROUND(AVG(price),2) AS average_product_price
FROM products;


-- ============================================
-- AVERAGE ORDER VALUE
-- ============================================

SELECT
ROUND(
SUM(oi.quantity * p.price)
/
COUNT(DISTINCT oi.order_id)
,2) AS average_order_value
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;


-- ============================================
-- NUMBER OF CUSTOMERS BY CITY
-- ============================================

SELECT
city,
COUNT(*) AS number_of_customers
FROM customers
GROUP BY city
ORDER BY number_of_customers DESC;


-- ============================================
-- PRODUCTS BY CATEGORY
-- ============================================

SELECT
category,
COUNT(*) AS number_of_products
FROM products
GROUP BY category
ORDER BY number_of_products DESC;


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
-- TOP 5 MOST EXPENSIVE PRODUCTS
-- ============================================

SELECT
product_name,
price
FROM products
ORDER BY price DESC
LIMIT 5;


-- ============================================
-- TOP 5 PRODUCTS BY UNITS SOLD
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