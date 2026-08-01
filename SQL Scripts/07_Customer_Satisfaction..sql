/*
============================================================
Project  : Sales Analytics SQL Project
Author   : Isfar Hafiz Khan
Database : Olist E-commerce Dataset
Platform : Microsoft SQL Server

Description:
This script investigates the relationship between
delivery performance and customer satisfaction by
comparing delivery categories with customer review
scores to determine whether shipping delays impact
customer experience.

============================================================
*/





--Do late deliveries lead to lower customer review scores?
WITH DeliveryAnalysis AS (
SELECT 
order_id, DATEDIFF(day,order_delivered_customer_date,order_estimated_delivery_date) as delivery_variance_days
FROM orders_clean
WHERE order_delivered_customer_date IS NOT NULL
AND order_status='delivered'
),

DeliveryCategoryAnalysis AS (
SELECT order_id,delivery_variance_days,
CASE WHEN delivery_variance_days<0 THEN 'Early'
WHEN delivery_variance_days>0 THEN 'Late'
ELSE 'On Time'
END AS 'delivery_category'
FROM DeliveryAnalysis 
)
SELECT d.delivery_category,AVG(review_score) as 'Average Review Score', COUNT(review_score) as 'Total Reviews'
FROM DeliveryCategoryAnalysis d
JOIN olist_order_reviews_dataset r ON d.order_id=r.order_id
GROUP BY d.delivery_category
ORDER BY
    CASE d.delivery_category
        WHEN 'Early' THEN 1
        WHEN 'On Time' THEN 2
        WHEN 'Late' THEN 3
    END;