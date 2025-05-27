SQL_Project1 – Retail Sales Analysis

📌 Project Overview

This project involves performing end-to-end data analysis using SQL on a fictional retail sales dataset. The objective is to clean, explore, and analyze the data to uncover key business insights that can help decision-makers improve performance in areas such as sales strategy, customer targeting, inventory planning, and operational efficiency.

🎯 Project Goals

•		Create and manage a retail sales database using SQL.

•		Clean and prepare data for analysis (e.g., handling NULLs).

•		Explore key metrics such as sales volume, customer count, and product categories.

•		Analyze trends in sales performance, customer behavior, and product demand.

•		Answer business-critical questions through SQL queries using functions, aggregations, filters, window functions, and CTEs.

🧰 Tools & Techniques Used
•		SQL Database (PostgreSQL or compatible system)
•		DDL & DML commands: To create tables and manage data.
•		Data Cleaning: Handled missing values to ensure data integrity.
•		Analytical Functions: Used RANK(), EXTRACT(), COUNT(), AVG(), SUM() etc.
•		Common Table Expressions (CTEs): Used for modular and readable query structures.
•		Groupings and Aggregations: To summarize performance metrics by category, customer, time, etc.

📁 Dataset Description

•		The retail_sales table contains transaction-level data with the following fields:

•		transactions_id: Unique identifier for each transaction

•		sale_date and sale_time: Timestamp of the sale

•		customer_id: ID of the customer making the purchase

•		gender and age: Demographic information

•		category: Product category (e.g., Clothing, Beauty, etc.)

•		quantity: Number of items purchased

•		price_per_unit: Cost per item

•		total_sale: Final transaction amount


📊 Key Deliverables

•		Database and table setup with appropriate schema.

•		Data cleaning operations to remove or correct invalid records.

•		Exploratory queries to understand the shape and scale of the data.

•		Business problem-solving using real-world retail scenarios:

•		Top-selling products and categories

•		Peak sales periods and shiftsHigh-value customersCustomer segmentation by gender, age, and category

•		Summarized insights to help guide business decisions.


📈 Outcome
By the end of this project, we have:

•		A fully functional retail sales database.

•		Clear and concise SQL queries answering 10 business questions.

•		Practical insights about sales performance, customer behavior, and product trends.

•		Reusable SQL logic for similar retail or transaction-based datasets.


-- SQL Retail Sales Analysis - P1
1.  Database Creation
Created a new database named: sql_project_p2
```sql
Create database sql_project_p2;
```


 2. Table Setup
Table: retail_sales
Includes fields like transactions_id, sale_date, sale_time, customer_id, gender, category, quantity, price_per_unit, cogs, and total_sale.
```sql
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,	
			sale_time TIME, 	
			customer_id INT,
			gender VARCHAR(15),	
			age INT,
			category VARCHAR(15),	
			quantity INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
			);
```
```sql
SELECT *
FROM retail_sales;
```
3. Data Cleaning
Checked for NULL values in transactions_id and other key columns.
Removed all rows where essential fields were NULL.

```sql
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;
```
```sql
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```
4. DATA EXPLORATION

-- 1. How many sales we have?
``` sql
SELECT COUNT (*) AS total_sale 
FROM retail_sales;
```

-- 2. How many customer we have?
``` sql
SELECT COUNT (DISTINCT customer_id) AS total_sale 
FROM retail_sales;
SELECT DISTINCT category
FROM retail_sales
```
5. DATA ANALYSIS and BUSINESS KEY PROBLEMS and ANSWERS

-- Question 1. Write a SQL query to retrieve all columns for sales made on 2022-11-05
``` sql
SELECT *
FROM retail_sales
w8here sale_date = '2022-11-5';
```
 
-- Question 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-22
``` sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	and to_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 4;
```
-- Question 3. Write a SQL Query to calculate the total sales for each category
``` sql
SELECT category,
SUM(total_sale) AS net_sale,
COUNT (*) as total_orders
FROM retail_sales
GROUP BY 1;
```
-- Question 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
``` sql
SELECT 
	ROUND(AVG(age), 2) as average_age
FROM retail_sales
WHERE category = 'Beauty'
```
-- Question 5. Write a SQL query to find all transactions where the total saleis greater than 1000
``` sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```
-- Question 6. Write a SQL query to find the total number of transactions made by each gender in each category.
``` sql
SELECT category, gender, 
	COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1;
```
-- Question 7. Write a SQL query to calculate the average sale for each month. FInd out best selling month in each yeah
``` sql
SELECT 
	year,
	month,
	average_sale
FROM
(
SELECT 
	EXTRACT (YEAR FROM sale_date) as year,
	EXTRACT (MONTH FROM sale_date) as month,
	AVG(total_sale) as average_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
)as t1
where rank = 1
```
-- Question 8. Write a SQL query to find the top 5 customers based on the highest total sales
``` sql
SELECT customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
--Question 9. Write a SQL query to find the number of unique customers who purchased items from each category
``` sql
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category
```
-- Question 10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, Evening > 17)
``` sql
WITH hourly_sale
AS(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
```
