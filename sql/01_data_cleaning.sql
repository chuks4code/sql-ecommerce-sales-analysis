-- ============================================
-- DATA CLEANING & QUALITY CHECKS
-- ============================================

-- 1. Count rows in each table

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_products
FROM products;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT COUNT(*) AS total_order_items
FROM order_items;


-- ============================================
-- CHECK NULL VALUES
-- ============================================

SELECT *
FROM customers
WHERE customer_id IS NULL
   OR customer_name IS NULL
   OR email IS NULL
   OR city IS NULL
   OR country IS NULL
   OR signup_date IS NULL;


SELECT *
FROM orders
WHERE order_id IS NULL
   OR customer_id IS NULL
   OR order_date IS NULL;


SELECT *
FROM products
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR price IS NULL;


SELECT *
FROM order_items
WHERE order_item_id IS NULL
   OR order_id IS NULL
   OR product_id IS NULL
   OR quantity IS NULL;


-- ============================================
-- CHECK DUPLICATES
-- ============================================

SELECT
customer_id,
COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


SELECT
order_id,
COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;


SELECT
product_id,
COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- ============================================
-- CHECK INVALID VALUES
-- ============================================

SELECT *
FROM products
WHERE price <= 0;


SELECT *
FROM order_items
WHERE quantity <= 0;


-- ============================================
-- REFERENTIAL INTEGRITY CHECKS
-- ============================================

-- Orders with missing customers

SELECT *
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- Order items with missing orders

SELECT *
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Order items with missing products

SELECT *
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;