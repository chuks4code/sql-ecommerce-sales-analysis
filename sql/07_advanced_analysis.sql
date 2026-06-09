-- ============================================
-- ADVANCED ANALYSIS
-- ============================================


-- ============================================
-- CUSTOMER LIFETIME VALUE RANKING
-- ============================================

WITH customer_sales AS
(
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
)

SELECT
    customer_name,
    total_spent,
    RANK() OVER(ORDER BY total_spent DESC) AS customer_rank
FROM customer_sales;


-- ============================================
-- TOP 3 CUSTOMERS PER COUNTRY
-- ============================================

WITH customer_sales AS
(
    SELECT
        c.country,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.country, c.customer_name
)

SELECT *
FROM
(
    SELECT
        *,
        ROW_NUMBER()
        OVER(
            PARTITION BY country
            ORDER BY total_spent DESC
        ) AS rn
    FROM customer_sales
) ranked_customers
WHERE rn <= 3;


-- ============================================
-- PRODUCT REVENUE RANKING
-- ============================================

WITH product_sales AS
(
    SELECT
        p.product_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_name
)

SELECT
    product_name,
    revenue,
    DENSE_RANK()
    OVER(ORDER BY revenue DESC) AS revenue_rank
FROM product_sales;


-- ============================================
-- TOP PRODUCT IN EACH CATEGORY
-- ============================================

WITH category_sales AS
(
    SELECT
        p.category,
        p.product_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
)

SELECT *
FROM
(
    SELECT
        *,
        ROW_NUMBER()
        OVER(
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS rn
    FROM category_sales
) ranked_products
WHERE rn = 1;


-- ============================================
-- CUSTOMER SEGMENTATION
-- ============================================

WITH customer_value AS
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
)

SELECT
    customer_name,
    total_spent,
    CASE
        WHEN total_spent >= 2000 THEN 'High Value'
        WHEN total_spent >= 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS segment
FROM customer_value;


-- ============================================
-- CUSTOMER REVENUE CONTRIBUTION %
-- ============================================

WITH customer_sales AS
(
    SELECT
        c.customer_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_name
)

SELECT
    customer_name,
    revenue,
    ROUND(
        revenue * 100.0 /
        SUM(revenue) OVER(),
        2
    ) AS revenue_percentage
FROM customer_sales
ORDER BY revenue DESC;


-- ============================================
-- PARETO ANALYSIS (80/20 RULE)
-- ============================================

WITH customer_sales AS
(
    SELECT
        c.customer_name,
        SUM(oi.quantity * p.price) AS revenue
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY c.customer_name
),

ranked_customers AS
(
    SELECT
        customer_name,
        revenue,
        SUM(revenue)
        OVER(ORDER BY revenue DESC) AS cumulative_revenue,
        SUM(revenue)
        OVER() AS total_revenue
    FROM customer_sales
)

SELECT
    customer_name,
    revenue,
    ROUND(
        cumulative_revenue * 100.0 /
        total_revenue,
        2
    ) AS cumulative_percentage
FROM ranked_customers
ORDER BY revenue DESC;


-- ============================================
-- MOST POPULAR CATEGORY
-- ============================================

SELECT
    p.category,
    SUM(oi.quantity) AS units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY units_sold DESC;


-- ============================================
-- CUSTOMER RECENCY
-- ============================================

SELECT
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY last_order_date DESC;


-- ============================================
-- CUSTOMER FREQUENCY
-- ============================================

SELECT
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS order_frequency
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY order_frequency DESC;