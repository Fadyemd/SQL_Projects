create database if not exists salesdatawalmart;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    Branch varchar(5) not null,
    City varchar(30) not null,
    Customer_type varchar(30) not null,
	Gender varchar(10) not null,
	Product_Line varchar(100) not null,
    Unit_Price decimal(10,2) not null,
    Quantity int not null,
    VAT float(6,4) not null,
    Total decimal(15,2) not null,
    Date datetime not null,
    Time time not null,
    Payment_Method varchar(15) not null,
    COGS decimal(10,2) not null,
    Gross_Margin_PCT float(11,9),
    Gross_Income decimal(12,2) not null,
    Rating float(2,1)
);

select* from salesdatawalmart.sales;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------- Feature Engineering --------------------------------------------------------------------------------------------------------------

-- Time_of_Day
-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
select* from salesdatawalmart.sales;

-- Day_Name
select
	Date,
    dayname(Date)
from sales;

alter table sales add column Day_Name varchar(10);
update sales
set Day_Name = dayname(Date);
select* from salesdatawalmart.sales;

-- Month_Name
select
	Date,
    monthname(Date)
from sales;

alter table sales add column Month_Name varchar(10);
update sales
set Month_Name = monthname(Date);
select* from salesdatawalmart.sales;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------- Generic --------------------------------------------------------------------------------------------------------------

-- how many unique cities does the data have?
select distinct city
from sales;

-- in which city is each branch?
select distinct City, Branch
from sales;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------- Product --------------------------------------------------------------------------------------------------------------

-- How Many Unique Product Line does the data have?
select count(distinct Product_line)
from sales;

-- What is the most common payment method?
select Payment_Method, count(Payment_method) as CNT
from sales
group by Payment_Method
order by CNT desc;

-- what is the most selling product line?
select product_line, count(product_line) as CNT
from sales
group by Product_Line
order by CNT desc;

--  what is the total revenue by month?
select month_name as Month, sum(total) as Total_Revenue
from sales
group by month_name
order by Total_Revenue desc;

-- what month had the largest COGS?
select month_name as Month, sum(Cogs) as COGS
from sales 
group by Month_name
order by COGS desc;

-- what Product line had the largest revenue?
select Product_line, sum(total) as Total_Revenue
from sales
group by Product_Line
order by Total_Revenue desc;

-- what is the city with largest revenue?
select city, Branch, sum(total) as Total_Revenue
from sales
group by city, Branch
order by Total_Revenue desc;

-- what product line had the largest VAT?
select product_line, Avg(vat) as AVG_VAT
from sales
group by Product_Line
order by AVG_VAT desc;

-- fetch each product line and add a column to those product line showing "good","bad"
-- good it its greater than average sales
SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- which branch sold more products than average product sold?
select branch, sum(quantity) as QTY
from sales 
group by Branch
having sum(quantity) > (select avg(quantity)from sales)
order by QTY desc;

-- what is the most common product line by gender?
select gender, Product_Line, count(gender) Total_CNT
from sales 
group by Gender, Product_Line
order by Total_CNT desc;

-- what is the average rating of each product line?
select product_line, round(avg(rating),2) as AVG_Rating
from sales 
group by Product_Line
order by AVG_Rating desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------- Sales ----------------------------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weeked
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
select customer_type, sum(total) as Total_Revenue
from sales
group by Customer_type
order by Total_Revenue desc;

-- which city has the largest tax percent/VAT (Value Added Tax)?
select city, avg(Vat) As VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?
select customer_type , avg(vat) as VAT
from sales
group by Customer_type
order by VAT desc;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------- Customer ----------------------------------------------------------------------------------------------------------------

-- How many unique customer types does the data have?
select customer_type, count(customer_type) as Customer_Count
from sales 
group by Customer_type;

-- how many unique Payment method does the data have?
select payment_method,count(Payment_Method)
from sales
group by Payment_Method;

-- what is the most common customer type?
select customer_type, count(customer_type) as Customer_Count
from sales 
group by Customer_type
order by Customer_Count desc;

-- which customer type buys the most?
select customer_type,count(customer_type) as Customer_Count, sum(total) as Total_sales
from sales 
group by Customer_type
order by Total_sales desc;

-- what is the gender of most of the customers?
select gender, count(*) as gender_count
from sales
group by gender
order by gender_count desc;

-- what is the gender distribution per branch?
select Branch, gender, count(*) as gender_count
from sales
group by Branch,gender
order by Branch;

-- which time of the day do customer give most ratings?
select time_of_day, count(rating) as count_Rating, avg(rating) as AVG_Rating
from sales
group by time_of_day
order by AVG_Rating desc;

-- which time of the day do customer give most ratings per branch?
select Branch, time_of_day, count(rating) as count_Rating, avg(rating) as AVG_Rating
from sales
group by branch,time_of_day
order by Branch, AVG_Rating desc;

-- which day of the week has the best avg rating?
select Day_name, avg(rating) as  AVG_Rating
from sales
group by Day_Name
order by AVG_Rating desc;

-- which day of the week has the best avg rating per branch ?

select Day_name,branch, avg(rating) as  AVG_Rating
from sales
group by Day_Name, Branch
order by Day_Name, AVG_Rating desc;




