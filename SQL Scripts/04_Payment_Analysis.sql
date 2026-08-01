/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script analyzes customer payments by comparing
order values with recorded payment amounts. It identifies
matching payments, underpayments, overpayments, and
missing payments to evaluate payment data accuracy.

============================================================
*/


SELECT
    payment_category,
    COUNT(*) AS number_of_orders,
    SUM(ABS(payment_difference)) AS total_difference
FROM PaymentCategory
GROUP BY payment_category;