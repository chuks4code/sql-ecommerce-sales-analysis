-- ============================================
-- RFM ANALYSIS
-- ============================================

-- ============================================
-- CALCULATE RECENCY, FREQUENCY AND MONETARY
-- ============================================

WITH customer_rfm AS
(
    SELECT
        c.customer_id,
        c.customer_name,

        MAX(o.order_date) AS last_order_date,

        CURRENT_DATE - MAX(o.order_date) AS recency_days,

        COUNT(DISTINCT o.order_id) AS frequency,

        ROUND(SUM(oi.quantity * p.price),2) AS monetary_value

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT *
FROM customer_rfm
ORDER BY monetary_value DESC;


WITH customer_rfm AS
(
    SELECT
        c.customer_id,
        c.customer_name,
        CURRENT_DATE - MAX(o.order_date) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.quantity * p.price) AS monetary_value

    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id

    GROUP BY
        c.customer_id,
        c.customer_name
)

SELECT
    customer_name,
    recency_days,
    frequency,
    monetary_value,

    NTILE(4)
    OVER(ORDER BY recency_days ASC) AS recency_score,

    NTILE(4)
    OVER(ORDER BY frequency DESC) AS frequency_score,

    NTILE(4)
    OVER(ORDER BY monetary_value DESC) AS monetary_score

FROM customer_rfm;


WITH customer_rfm AS
(
    SELECT
        c.customer_name,
        CURRENT_DATE - MAX(o.order_date) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.quantity * p.price) AS monetary_value

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
    recency_days,
    frequency,
    monetary_value,

    CASE
        WHEN monetary_value >= 2000 AND frequency >= 5
            THEN 'Champions'

        WHEN monetary_value >= 1000
            THEN 'Loyal Customers'

        WHEN frequency = 1
            THEN 'New Customers'

        ELSE 'Regular Customers'

    END AS customer_segment

FROM customer_rfm
ORDER BY monetary_value DESC;