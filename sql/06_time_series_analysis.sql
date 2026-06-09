-- ============================================
-- TIME SERIES ANALYSIS
-- ============================================


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
-- MONTHLY NUMBER OF ORDERS
-- ============================================

SELECT
    TO_CHAR(order_date,'YYYY-MM') AS month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;


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
-- RUNNING TOTAL REVENUE
-- ============================================

WITH monthly_sales AS
(
    SELECT
        TO_CHAR(o.order_date,'YYYY-MM') AS month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    SUM(revenue)
    OVER(ORDER BY month) AS running_total_revenue
FROM monthly_sales;


-- ============================================
-- PREVIOUS MONTH SALES USING LAG()
-- ============================================

WITH monthly_sales AS
(
    SELECT
        TO_CHAR(o.order_date,'YYYY-MM') AS month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    LAG(revenue)
    OVER(ORDER BY month) AS previous_month_revenue
FROM monthly_sales;


-- ============================================
-- MONTH-OVER-MONTH GROWTH
-- ============================================

WITH monthly_sales AS
(
    SELECT
        TO_CHAR(o.order_date,'YYYY-MM') AS month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    LAG(revenue)
    OVER(ORDER BY month) AS previous_revenue,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER(ORDER BY month)
        )
        /
        LAG(revenue) OVER(ORDER BY month)
        * 100,
        2
    ) AS growth_percent
FROM monthly_sales;


-- ============================================
-- 3-MONTH MOVING AVERAGE
-- ============================================

WITH monthly_sales AS
(
    SELECT
        TO_CHAR(o.order_date,'YYYY-MM') AS month,
        SUM(oi.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY month
)

SELECT
    month,
    revenue,
    ROUND(
        AVG(revenue)
        OVER(
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_average
FROM monthly_sales;