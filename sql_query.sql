-- SQL Retail Sale Analysis - P1

-- Create Table
CREATE TABLE retail_sale(
			transactions_id	INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,	
			customer_id	INT,
			gender VARCHAR(15),
			age	INT,
			category VARCHAR(15),	
			quantiy	INT,
			price_per_unit FLOAT,	
			cogs	FLOAT,
			total_sale FLOAT
);

SELECT * FROM retail_sale
LIMIT 10

-- display total record entered
SELECT 
	COUNT(*) 
FROM retail_sale

-- DATA CLEANING

-- Identify if there are any NUll values
SELECT * FROM retail_sale
WHERE transactions_id IS NULL
-- no records with transactions_id are NUL

SELECT * FROM retail_sale
WHERE sale_date IS NULL
-- any

SELECT * FROM retail_sale
WHERE sale_time IS NULL
-- any

-- check for all null values at the same time
SELECT * FROM retail_sale
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- delete columns with null values
DELETE FROM retail_sale
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- DATA EXPLORATION

-- How many sales we have
SELECT COUNT(*) as total_sale FROM retail_sale

-- How many unique customers we have 
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sale

-- How many categories we have
SELECT DISTINCT category FROM retail_sale

-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sale
WHERE sale_date = '2022-11-05'

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and
--the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sale
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4

--3. Write a SQL query to calculate the total sales (total_sale) for 
--each category.:
SELECT
	category,
	SUM(total_sale) AS net_sale,
	COUNT(*) AS total_orders	-- total orden done for each category
FROM retail_sale
GROUP BY 1 --group by category

--4. Write a SQL query to find the average age of customers 
--who purchased items from the 'Beauty' category.:
SELECT 
	category,
	ROUND(AVG(age),2) AS avg_age
FROM retail_sale
WHERE category = 'Beauty'
GROUP BY category
----
SELECT 
	ROUND(AVG(age),2) AS avg_age
FROM retail_sale
WHERE category = 'Beauty'

--Conclusion: The second query is the more appropriate way to answer the question
--since the category filter (WHERE category = 'Beauty') ensures that only Beauty 
--category data is considered. The GROUP BY is redundant because there's only one 
--category being analyzed.

--5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

--6.Write a SQL query to find the total number of transactions (transaction_id) made by each 
--gender in each category
SELECT category, gender,
	COUNT(transactions_id) AS total_transactions
FROM retail_sale
GROUP BY category, gender
ORDER BY 1;

--7. Write a SQL query to calculate the average sale for each month. Find out best selling month
--in each year:
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sale
GROUP BY 1, 2
) as t1
WHERE rank = 1
--ORDER BY 1, 3 DESC;	

--8.Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sale
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sale
GROUP BY 1

--10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sale
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift























