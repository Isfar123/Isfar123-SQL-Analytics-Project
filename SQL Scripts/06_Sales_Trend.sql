/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script analyzes monthly sales performance by
calculating revenue, order volume, average order value
(AOV), and month-over-month growth trends to identify
business performance over time.

============================================================
*/




-- How much revenue did the business actually generate from completed sales? (product price + freight value)
--total_revenue
--total_orders
--total_customers
--average_order_value

SELECT SUM(oi.price + oi.freight_value) as total_revenue,COUNT(DISTINCT oc.order_id) as total_orders, COUNT(DISTINCT oc.customer_id) as total_customers,
SUM(oi.price + oi.freight_value)/COUNT(DISTINCT oc.order_id) as average_order_value
FROM orders_clean oc
JOIN olist_order_items_dataset oi ON oc.order_id=oi.order_id
WHERE oc.order_status='delivered'


-- Business Questions:
-- 1) How did the company's sales performance change over time?
-- 1) How did the company's sales performance change over time?
WITH MonthSales AS (
    SELECT
        YEAR(oc.order_purchase_timestamp) AS order_year,
        MONTH(oc.order_purchase_timestamp) AS order_month,
        SUM(oi.price + oi.freight_value) AS total_revenue,
        COUNT(DISTINCT oc.order_id) AS total_orders,
        SUM(oi.price + oi.freight_value) * 1.0
            / COUNT(DISTINCT oc.order_id) AS average_order_value
    FROM orders_clean oc
    JOIN olist_order_items_dataset oi
        ON oc.order_id = oi.order_id
    WHERE oc.order_status = 'delivered'
    GROUP BY
        YEAR(oc.order_purchase_timestamp),
        MONTH(oc.order_purchase_timestamp)
),

MonthlyTrend AS (
    SELECT
        *,
        LAG(total_revenue) OVER(ORDER BY order_year, order_month) AS previous_month_revenue,
        LAG(total_orders) OVER(ORDER BY order_year, order_month) AS previous_month_order,
        LAG(average_order_value) OVER(ORDER BY order_year, order_month) AS previous_month_AOV
    FROM MonthSales
)

SELECT
    order_year,
    DATENAME(month,order_month) AS month_name,
    total_revenue,

    CASE
        WHEN previous_month_revenue IS NULL THEN NULL
        ELSE ((total_revenue - previous_month_revenue)
              / previous_month_revenue) * 100.0
    END AS revenue_growth,

    total_orders,

    CASE
        WHEN previous_month_order IS NULL THEN NULL
        ELSE ((total_orders - previous_month_order)
              * 100.0 / previous_month_order)
    END AS order_growth,

    average_order_value,

    CASE
        WHEN previous_month_AOV IS NULL THEN NULL
        ELSE ((average_order_value - previous_month_AOV)
              * 100.0 / previous_month_AOV)
    END AS AOV_growth

FROM MonthlyTrend
ORDER BY
    order_year,
    order_month;
