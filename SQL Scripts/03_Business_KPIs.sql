/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script calculates the core business KPIs used to
evaluate overall business performance, including total
revenue, total orders, average order value (AOV),
and customer metrics.

============================================================
*/




--Does the payment amount for an order match the value of the products purchased?
WITH OrderValue AS (
SELECT order_id,SUM(price) as product_value,SUM(price + freight_value) as final_product_value
FROM olist_order_items_dataset
GROUP BY order_id
),

PaymentValue AS (
SELECT order_id,SUM(payment_value) as total_payment
FROM olist_order_payments_dataset
GROUP BY order_id
),

PaymentComparison AS (
SELECT o.order_id,o.product_value,o.final_product_value,p.total_payment
FROM OrderValue o
LEFT JOIN PaymentValue p ON o.order_id=p.order_id
),

PaymentDifference AS (
SELECT *,final_product_value - total_payment AS payment_difference
FROM PaymentComparison

),
PaymentCategory AS (
SELECT  order_id,
    final_product_value,
    total_payment,
    payment_difference,
CASE 
    WHEN total_payment IS NULL THEN 'No Payment'
    WHEN payment_difference = 0 THEN 'Match'
    WHEN payment_difference > 0 THEN 'Underpayment'
    ELSE 'Payment exceeds order value'
END AS payment_category
FROM PaymentDifference 
),

--How many orders fall into each payment category?
OrdersPerPaymentCategory AS (
SELECT payment_category,COUNT(*) as number_of_orders
FROM PaymentCategory
GROUP BY payment_category
)