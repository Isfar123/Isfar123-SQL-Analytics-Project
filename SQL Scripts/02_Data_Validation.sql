/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script validates data quality by identifying missing
records, orphaned relationships, duplicate entries,
payment inconsistencies, and other integrity issues before
performing business analysis.

============================================================
*/

SELECT 
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    op.payment_type,
    op.payment_value
FROM dbo.orders_clean o
LEFT JOIN dbo.olist_order_items_dataset oi
    ON o.order_id = oi.order_id
LEFT JOIN dbo.olist_order_payments_dataset op
    ON o.order_id = op.order_id
WHERE oi.order_item_id IS NULL
  AND o.order_status IN ('created', 'invoiced', 'shipped')
ORDER BY op.payment_value DESC;

--Find orders with no payment record
SELECT *
FROM orders_clean oc
LEFT JOIN dbo.olist_order_payments_dataset op ON oc.order_id=op.order_id
WHERE op.order_id IS NULL

-- check wheather the customer with id '86dc2ffce2dfff336de2f386a786e574' has other orders
SELECT *
FROM orders_clean 
WHERE customer_id='86dc2ffce2dfff336de2f386a786e574'

--DOCUMENT: 1 delivered order was found without a corresponding payment record. The customer associated with this order has no other orders, 
--indicating this is an isolated data-quality anomaly rather than a broader customer-level payment issue.
--The order should be excluded from payment-based revenue validation unless the missing payment can be recovered from the source system.
