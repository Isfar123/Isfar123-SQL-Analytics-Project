/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script prepares the raw e-commerce dataset for analysis.
It includes data cleaning, date format corrections, datatype
conversions, and the creation of cleaned tables used
throughout the project.

============================================================
*/


-- customers
SELECT 'customers' as table_name,COUNT(*) as total_rows
FROM dbo.olist_customers_dataset
UNION ALL
SELECT 'orders' as table_name, COUNT(*) as total_rows
FROM dbo.olist_orders_dataset
UNION ALL
SELECT 'order_items' as table_name, COUNT(*) as total_rows
FROM dbo.olist_order_items_dataset
UNION ALL
SELECT 'order_payments' as table_name, COUNT(*) as total_rows
FROM dbo.olist_order_payments_dataset
UNION ALL
SELECT 'products' as table_name, COUNT(*) as total_rows
FROM dbo.olist_products_dataset
UNION ALL
SELECT 'sellers' as table_name, COUNT(*) as total_rows
FROM dbo.olist_sellers_dataset
UNION ALL
SELECT 'order_reviews' as table_name, COUNT(*) as total_rows
FROM dbo.olist_order_reviews_dataset
-- Data Quality Inspect
-- Are there any duplicate order_id values in the order table?
SELECT order_id,COUNT(*) as no_of_rows
FROM dbo.olist_orders_dataset
GROUP BY order_id
HAVING COUNT(order_id)>1
-- Are there any orders that don't have a corresponding customer?
SELECT *
FROM dbo.olist_orders_dataset o
LEFT JOIN dbo.olist_customers_dataset c ON o.customer_id=c.customer_id
WHERE c.customer_id IS NULL

--Are there any orders that have no corresponding order items?
SELECT *
FROM dbo.olist_orders_dataset o
LEFT JOIN dbo.olist_order_items_dataset oi ON o.order_id=oi.order_id
WHERE oi.order_item_id IS NULL

-- Inspect orders that have no corresponding order items
SELECT o.order_status, COUNT(*) as orders_without_items
FROM dbo.olist_orders_dataset o
LEFT JOIN dbo.olist_order_items_dataset oi ON o.order_id=oi.order_id
WHERE oi.order_item_id IS NULL
GROUP BY o.order_status

-- For created,invoiced and shipped find their order ID 
SELECT o.order_id,o.order_status,o.order_purchase_timestamp
FROM dbo.olist_orders_dataset o
LEFT JOIN dbo.olist_order_items_dataset oi ON o.order_id=oi.order_id
WHERE oi.order_item_id IS NULL AND o.order_status IN ('shipped','created','invoiced') -- 8 orders

-- check if the above 8 orders appear in the order_payments table
--Did customers actually pay for orders that have no associated products?
SELECT o.order_id,o.order_status,o.order_purchase_timestamp,op.payment_type,op.payment_value,o.order_delivered_carrier_date,o.order_delivered_customer_date
FROM dbo.olist_orders_dataset o
LEFT JOIN dbo.olist_order_items_dataset oi ON o.order_id=oi.order_id
LEFT JOIN dbo.olist_order_payments_dataset op ON o.order_id=op.order_id
WHERE oi.order_item_id IS NULL AND o.order_status IN ('shipped','created','invoiced')
ORDER BY op.payment_value DESC

-- Check Date Range
SELECT MAX(order_purchase_timestamp) as latest_date,MIN(order_purchase_timestamp) as first_date
FROM orders

-- find number of orders per year
SELECT YEAR(order_purchase_timestamp) as order_year, COUNT(*) as total_orders_per_year
FROM orders
GROUP BY YEAR(order_purchase_timestamp)

SELECT *
FROM orders
SELECT 
    TRY_CONVERT(DATETIME2, order_purchase_timestamp, 103)
FROM orders;

SELECT
    order_id,
    customer_id,
    order_status,

    TRY_CONVERT(DATETIME2, order_purchase_timestamp, 103)
        AS order_purchase_timestamp,

    TRY_CONVERT(DATETIME2, order_approved_at, 103)
        AS order_approved_at,

    TRY_CONVERT(DATETIME2, order_delivered_carrier_date, 103)
        AS order_delivered_carrier_date,

    TRY_CONVERT(DATETIME2, order_delivered_customer_date, 103)
        AS order_delivered_customer_date,

    TRY_CONVERT(DATETIME2, order_estimated_delivery_date, 103)
        AS order_estimated_delivery_date

INTO orders_clean
FROM orders;
SELECT TOP 10
    order_id,
    order_purchase_timestamp
FROM orders

SELECT
    order_id,
    customer_id,
    order_status,

    TRY_CONVERT(
        DATETIME2,
        order_purchase_timestamp,
        105
    ) AS order_purchase_timestamp,

    TRY_CONVERT(
        DATETIME2,
        order_approved_at,
        105
    ) AS order_approved_at,

    TRY_CONVERT(
        DATETIME2,
        order_delivered_carrier_date,
        105
    ) AS order_delivered_carrier_date,

    TRY_CONVERT(
        DATETIME2,
        order_delivered_customer_date,
        105
    ) AS order_delivered_customer_date,

    TRY_CONVERT(
        DATETIME2,
        order_estimated_delivery_date,
        105
    ) AS order_estimated_delivery_date

INTO dbo.orders_clean

FROM orders;

SELECT TOP 10
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM dbo.orders_clean;

SELECT
    order_id,
    order_purchase_timestamp,
    TRY_PARSE(
        order_purchase_timestamp AS DATETIME2
        USING 'en-GB'
    ) AS converted_date
FROM orders;

SELECT
    order_id,
    customer_id,
    order_status,

    TRY_PARSE(
        order_purchase_timestamp AS DATETIME2
        USING 'en-GB'
    ) AS order_purchase_timestamp,

    TRY_PARSE(
        order_approved_at AS DATETIME2
        USING 'en-GB'
    ) AS order_approved_at,

    TRY_PARSE(
        order_delivered_carrier_date AS DATETIME2
        USING 'en-GB'
    ) AS order_delivered_carrier_date,

    TRY_PARSE(
        order_delivered_customer_date AS DATETIME2
        USING 'en-GB'
    ) AS order_delivered_customer_date,

    TRY_PARSE(
        order_estimated_delivery_date AS DATETIME2
        USING 'en-GB'
    ) AS order_estimated_delivery_date

INTO dbo.orders_clean

FROM orders;

SELECT TOP 10
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM dbo.orders_clean;


SELECT 
    MIN(order_purchase_timestamp) AS earliest_order,
    MAX(order_purchase_timestamp) AS latest_order
FROM dbo.orders_clean;

SELECT
    COUNT(*) AS total_orders,
    COUNT(order_purchase_timestamp) AS valid_purchase_dates,
    COUNT(*) - COUNT(order_purchase_timestamp) AS failed_purchase_dates
FROM dbo.orders_clean;