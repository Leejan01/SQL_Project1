
-- SQL Retail Sales Analysis - P1
Create database sql_project_p2;

-- Create Table
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

SELECT *
FROM retail_sales;

--COUNT rows
SELECT COUNT(*)
FROM retail_sales;

-- DATA CLEANING

-- checking if there is NULL values in transactions_id column
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL;

-- checking if there is NULL values in all column
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

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- DATA EXPLORATION

-- 1. How many sales we have?
SELECT COUNT (*) AS total_sale 
FROM retail_sales;

-- 2. How many customer we have?
SELECT COUNT (DISTINCT customer_id) AS total_sale 
FROM retail_sales;
SELECT DISTINCT category
FROM retail_sales

-- DATA ANALYSIS and BUSINESS KEY PROBLEMS and ANSWERS
-- Question 1. Write a SQL query to retrieve all columns for sales made on 2022-11-05
SELECT *
FROM retail_sales
w8here sale_date = '2022-11-5';
 
-- Question 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-22
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	and to_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantity >= 4;

-- Question 3. Write a SQL Query to calculate the total sales for each category
SELECT category,
SUM(total_sale) AS net_sale,
COUNT (*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Question 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
	ROUND(AVG(age), 2) as average_age
FROM retail_sales
WHERE category = 'Beauty'

-- Question 5. Write a SQL query to find all transactions where the total saleis greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Question 6. Write a SQL query to find the total number of transactions made by each gender in each category.

SELECT category, gender, 
	COUNT(*) as total_transactions
FROM retail_sales
GROUP BY 
	category,
	gender
ORDER BY 1;

-- Question 7. Write a SQL query to calculate the average sale for each month. FInd out best selling month in each yeah 
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

-- Question 8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--Question 9. Write a SQL query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category

-- Question 10. Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon between 12 & 17, Evening > 17)
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


