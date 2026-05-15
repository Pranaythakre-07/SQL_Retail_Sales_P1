
-- SQL Retail Sales Analysis - P1

create database sql_project_p1;

-- Create Table
create table Retail_Sales
                       (
							transactions_id	INT,
							sale_date DATE,
							sale_time TIME,
							customer_id INT,
							gender VARCHAR(15),
							age	INT,
							category VARCHAR(20),
							quantiy INT,
							price_per_unit FLOAT,
							cogs FLOAT,
							total_sale FLOAT
						);
						
---- ALL data check---------
select * from Retail_Sales;

--- Count check number of Rows ----

select count(*) from Retail_Sales;

---- Find NULL Value-----------

select *  from Retail_Sales
where 
	customer_id is null
	or 
	gender is null
	or 
	category is null
	or
	quantiy is null 
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--- Delate NULL Value--------

delete from Retail_Sales
where 
	customer_id is null
	or 
	gender is null
	or 
	category is null
	or
	quantiy is null 
	or 
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--- How many sales We have-------

select count(*) as total_sales from Retail_Sales;

--- how many uniuque customers we have-------

select count(DISTINCT customer_id) as total_sales  from Retail_Sales;


-----------------------------------
--Q.1 Write a SQL query to retrieve all columns for sales mode on '2022-11-05'

	SELECT * 
	FROM Retail_Sales
	WHERE sale_date = '2022-11-05';

--Q.2 Write a SQl query to retrieve all transaction where the category is 'Clothing' and the quantity sold is more than 4 in
--    the month of Nov-2022

	select * from Retail_Sales
	where category = 'Clothing'
	and to_char(sale_date, 'YYYY-MM') = '2022-11' -- to_char se type change kar rahe hai
	and quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

	SELECT category,
	SUM(total_sale) AS Net_sales,
	count (*) as total_people
	FROM Retail_Sales
	GROUP BY category;

-- Q.4 Write a SQL Query to find the average age of customer who purchased items from the 'Beauty' category.

select 
	Round(avg(age), 2) as AVG_age
from Retail_Sales
where category ='Beauty'

--Q.5 Write a SQL query to find all transaction where the total_sale is greater than 1000.

select * from  Retail_Sales
where total_sale >= 1000

--Q.6 Write a SQL Query to find the total number of transaction (transaction_id) made by each gender in each category.

select 
	category,
	gender,
	count(*) as total_trans
from retail_sales
group
	by 
	category,
	gender
order by category asc;

--Q.7 Write a SQL Query to calculate the average sale for each month. Find out best selling month in each year

select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg (total_sale) as avg_sale,
	rank()over(partition by extract(year from sale_date) order by avg(total_sale)DESC)
from retail_sales
group by 1, 2

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

Select
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 DESC
limit 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select
	category,
	count(DISTINCT customer_id) as Unique_Customer
from retail_sales
group by category

--Q.10 Write a SQL query to create each shift and number of orders(Example Morning<=12, Afternoon Between 12 & 17, Evening >17)

With hourly_sale
As
(
select *,
	case
		When Extract(hour from sale_time)< 12 then 'Morning'
		When Extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		Else 'Evening'
	end as shift
from retail_sales
)
Select
	shift,
	count(*) as total_orders
from hourly_sale
Group by shift