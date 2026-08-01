Title : Sales Analytics SQL Project

1) Project Overview

This project analyzes the Brazilian Olist E-commerce dataset using Microsoft SQL Server to generate business insights from real-world transactional data.

The project follows a complete analytics workflow, starting with data cleaning and validation before progressing to business KPI reporting, payment verification, delivery performance analysis, sales trend evaluation, and customer satisfaction analysis.

The objective is to demonstrate practical SQL skills while answering business-focused questions that support data-driven decision making in an e-commerce environment.

2)  Project Objectives

* Clean and prepare raw e-commerce data for analysis.
* Validate data quality and identify inconsistencies.
* Calculate key business performance indicators (KPIs).
* Analyze monthly sales performance and growth trends.
* Evaluate payment accuracy across customer orders.
* Measure delivery performance against promised delivery dates.
* Investigate the relationship between delivery performance and customer satisfaction.
* Produce actionable business insights using SQL.

3)  Dataset

This project uses the "Olist Brazilian E-commerce Public Dataset", which contains transactional data from a Brazilian online marketplace.

The dataset includes information on:

* Customers
* Orders
* Order Items
* Products
* Sellers
* Payments
* Reviews

The data covers the complete order lifecycle, from purchase and payment to delivery and customer reviews, making it suitable for end-to-end business analysis.

Source: Kaggle – Olist Brazilian E-commerce Public Dataset

4) Database Schema

The analysis uses the following primary tables:

| Table                        | Description                                 |
| ---------------------------- | ------------------------------------------- |
| orders_clean                 | Cleaned order information used for analysis |
| olist_customers_dataset      | Customer information                        |
| olist_order_items_dataset    | Individual products purchased in each order |
| olist_order_payments_dataset | Payment information                         |
| olist_products_dataset       | Product information                         |
| olist_order_reviews_dataset  | Customer review ratings                     |
| olist_sellers_dataset        | Seller information                          |

5)SQL Skills Demonstrated

Throughout this project, the following SQL concepts were applied:

* Common Table Expressions (CTEs)
* INNER JOIN and LEFT JOIN
* Aggregate Functions
* Window Functions (LAG)
* CASE Expressions
* GROUP BY and HAVING
* Data Cleaning and Validation
* Date Functions (DATEDIFF, YEAR, MONTH, DATENAME)
* Business KPI Calculations
* Trend Analysis

6)  Business Questions Answered

The project answers several practical business questions, including:

1. Is the dataset clean and suitable for analysis?
2. Are there missing records or data integrity issues?
3. What are the company's key business KPIs?
4. Do customer payments match the value of purchased products?
5. How well is the company meeting promised delivery dates?
6. How has monthly sales performance changed over time?
7. Do late deliveries result in lower customer review scores?

7) Key Insights

* Most delivered orders arrived before the estimated delivery date.
* Revenue growth was primarily driven by changes in monthly order volume rather than average order value.
* Payment validation identified matching payments, underpayments, overpayments, and a very small number of orders without payment records.
* Delivery performance showed a measurable relationship with customer review scores, indicating that logistics performance influences customer satisfaction.
* Data validation revealed several data quality issues that were addressed before analysis.

8)  Repository Structure


Sales-Analytics-SQL-Project/
│
├── SQL Scripts/
│   ├── 01_Data_Preparation.sql
│   ├── 02_Data_Validation.sql
│   ├── 03_Business_KPI_Analysis.sql
│   ├── 04_Payment_Analysis.sql
│   ├── 05_Delivery_Performance.sql
│   ├── 06_Sales_Trend.sql
│   └── 07_Customer_Satisfaction.sql
│
├── Documentation/
│
├── Dataset/
│
├── Images/
│
└── README.md

9) How to Run

1. Download the Olist Brazilian E-commerce dataset.
2. Import the CSV files into Microsoft SQL Server.
3. Execute the SQL scripts in numerical order.
4. Review the generated outputs and business insights.

10)  Future Improvements

Possible extensions of this project include:

* Interactive Power BI dashboard
* Exploratory Data Analysis using Python (Pandas)
* Customer segmentation using RFM analysis
* Product category profitability analysis
* Sales forecasting using machine learning

