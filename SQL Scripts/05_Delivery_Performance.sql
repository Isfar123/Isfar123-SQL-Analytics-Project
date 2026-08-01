/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script evaluates delivery performance by measuring
delivery delays against estimated delivery dates. Orders
are classified as Early, On Time, or Late to assess
logistics efficiency.

============================================================
*/



--Investigate canceled orders with delivery dates
SELECT *
FROM orders_clean
WHERE order_status='canceled'
AND order_delivered_customer_date IS NOT NULL


--We need to check whether these canceled orders have:

--Order items
--Payments
SELECT oc.order_id,oc.order_status,COUNT(DISTINCT oi.order_item_id) as number_of_items,COUNT(DISTINCT op.payment_type) as number_of_payment_types
FROM orders_clean oc
LEFT JOIN olist_order_items_dataset oi ON oc.order_id=oi.order_id
LEFT JOIN olist_order_payments_dataset op ON oi.order_id=op.order_id
WHERE oc.order_status='canceled' AND oc.order_delivered_customer_date IS NOT NULL
GROUP BY oc.order_id,oc.order_status

--How well is the company meeting its promised delivery dates?
WITH OrderVariance AS (
SELECT order_id,order_delivered_customer_date,order_estimated_delivery_date,
DATEDIFF(
    day,
    order_estimated_delivery_date,
    order_delivered_customer_date
) AS delivery_variance_days 
FROM orders_clean
WHERE order_status='delivered'   AND order_delivered_customer_date IS NOT NULL
),
DeliveryCategory AS (
SELECT 
    *,
    CASE WHEN delivery_variance_days<0 THEN 'Early'
    WHEN delivery_variance_days>0 THEN 'Late'
    ELSE 'On Time'
    END as delivery_category
FROM OrderVariance
)

--What percentage of delivered orders arrived early, on time, or late?
SELECT delivery_category,COUNT(*) as delivery_category_total_rows,CAST(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
    AS DECIMAL(5,2)
) AS percentage_of_orders
FROM DeliveryCategory
GROUP BY delivery_category
