use star_schema;


--**********************************

-- Create the dimension tables
CREATE TABLE product_dim (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

---**********************************************
CREATE TABLE customer_dim (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

----*********************************************
CREATE TABLE store_dim (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

---*************************************
CREATE TABLE time_dim (
    date_id INT PRIMARY KEY,
    date DATE,
    day_of_week VARCHAR(20),
    month VARCHAR(20),
    year INT
);
---***************************************
-- Create the fact table: parent table
CREATE TABLE sales_fact (
    transaction_id INT PRIMARY KEY,
    product_id INT,--must be primary key (PK) in the child table.
    customer_id INT,
    store_id INT,
    date_id INT,
    quantity INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES product_dim(product_id),
    FOREIGN KEY (customer_id) REFERENCES customer_dim(customer_id),
    FOREIGN KEY (store_id) REFERENCES store_dim(store_id),
    FOREIGN KEY (date_id) REFERENCES time_dim(date_id)
);
---******************************************************************************Inserting values*******

-- Insert data into product_dim table
INSERT INTO product_dim (product_id, product_name, category, price) VALUES
    (1, 'Laptop', 'Electronics', 1000.00),
    (2, 'Smartphone', 'Electronics', 700.00),
    (3, 'Desk Chair', 'Furniture', 150.00),
    (4, 'Coffee Table', 'Furniture', 250.00),
    (5, 'Running Shoes', 'Sports', 80.00),
    (6, 'Basketball', 'Sports', 30.00),
    (7, 'T-shirt', 'Apparel', 20.00),
    (8, 'Jeans', 'Apparel', 50.00),
    (9, 'Headphones', 'Electronics', 120.00),
    (10, 'Desk Lamp', 'Furniture', 40.00);
	
INSERT INTO product_dim (product_id, product_name, category, price) VALUES
     (11, 'Laptop-Type1', 'Electronics', 1200.00);




------**************************************************
-- Insert data into customer_dim table
INSERT INTO customer_dim (customer_id, customer_name, city, country) VALUES
    (1, 'John Smith', 'New York', 'USA'),
    (2, 'Alice Johnson', 'Los Angeles', 'USA'),
    (3, 'Emily Brown', 'London', 'UK'),
    (4, 'Michael Davis', 'Paris', 'France'),
    (5, 'Sophia Martinez', 'Berlin', 'Germany'),
    (6, 'Daniel Wilson', 'Sydney', 'Australia'),
    (7, 'Emma Taylor', 'Tokyo', 'Japan'),
    (8, 'William Garcia', 'Mexico City', 'Mexico'),
    (9, 'Olivia Lopez', 'Toronto', 'Canada'),
    (10, 'James Hernandez', 'São Paulo', 'Brazil');
	  

------********************************************************
-- Insert data into store_dim table
INSERT INTO store_dim (store_id, store_name, city, country) VALUES
    (1, 'Electronics Emporium', 'New York', 'USA'),
    (2, 'Gadgets Galore', 'Los Angeles', 'USA'),
    (3, 'Furniture World', 'London', 'UK'),
    (4, 'Sports Superstore', 'Paris', 'France'),
    (5, 'Apparel Avenue', 'Berlin', 'Germany'),
    (6, 'Tech Haven', 'Sydney', 'Australia'),
    (7, 'Gizmo Paradise', 'Tokyo', 'Japan'),
    (8, 'Electronics Mart', 'Mexico City', 'Mexico'),
    (9, 'Furniture Depot', 'Toronto', 'Canada'),
    (10, 'Sports City', 'São Paulo', 'Brazil');

--------************************************************************************
-- Insert data into time_dim table
INSERT INTO time_dim (date_id, date, day_of_week, month, year) VALUES
    (1, '2024-03-01', 'Monday', 'March', 2024),
    (2, '2024-03-02', 'Tuesday', 'March', 2024),
    (3, '2024-03-03', 'Wednesday', 'March', 2024),
    (4, '2024-03-04', 'Thursday', 'March', 2024),
    (5, '2024-03-05', 'Friday', 'March', 2024),
    (6, '2024-03-06', 'Saturday', 'March', 2024),
    (7, '2024-03-07', 'Sunday', 'March', 2024),
    (8, '2024-03-08', 'Monday', 'March', 2024),
    (9, '2024-03-09', 'Tuesday', 'March', 2024),
    (10, '2024-03-10', 'Wednesday', 'March', 2024);
------***********************************************************************************fact table insert
-- Insert data into sales_fact table
INSERT INTO sales_fact (transaction_id, product_id, customer_id, store_id, date_id, quantity, amount) VALUES
    (1, 1, 1, 1, 1, 2, 2000.00), -- John Smith buys 2 laptops from Electronics Emporium on 2024-03-01
    (2, 2, 2, 2, 2, 3, 2100.00), -- Alice Johnson buys 3 smartphones from Gadgets Galore on 2024-03-02
    (3, 3, 3, 3, 3, 1, 150.00),   -- Emily Brown buys 1 desk chair from Furniture World on 2024-03-03
    (4, 4, 4, 4, 4, 2, 500.00),   -- Michael Davis buys 2 coffee tables from Sports Superstore on 2024-03-04
    (5, 5, 5, 5, 5, 4, 320.00),   -- Sophia Martinez buys 4 running shoes from Apparel Avenue on 2024-03-05
    (6, 6, 6, 6, 6, 1, 30.00),    -- Daniel Wilson buys 1 basketball from Tech Haven on 2024-03-06
    (7, 7, 7, 7, 7, 5, 100.00),   -- Emma Taylor buys 5 t-shirts from Gizmo Paradise on 2024-03-07
    (8, 8, 8, 8, 8, 2, 100.00),   -- William Garcia buys 2 jeans from Electronics Mart on 2024-03-08
    (9, 9, 9, 9, 9, 3, 360.00),   -- Olivia Lopez buys 3 headphones from Furniture Depot on 2024-03-09
    (10, 10, 10, 10, 10, 1, 40.00); -- James Hernandez buys 1 desk lamp from Sports City on 2024-03-10

-----------------------------------------Joining all the dimensions and a fact table-----

--For joining the fact and dinension table, we generally use the inner joining................
SELECT 
    s.transaction_id,
    p.product_name,
    p.category,
    c.customer_name,
    c.city AS customer_city,
    c.country AS customer_country,
    st.store_name,
    st.city AS store_city,
    st.country AS store_country,
    t.date AS transaction_date,
    t.day_of_week,
    t.month,
    t.year,
    s.quantity,
    s.amount
	INTO joined_star_schema
FROM 
    sales_fact AS s
JOIN 
    product_dim AS p ON s.product_id = p.product_id
JOIN 
    customer_dim AS c ON s.customer_id = c.customer_id
JOIN 
    store_dim AS st ON s.store_id = st.store_id
JOIN 
    time_dim AS t ON s.date_id = t.date_id;



select * from [dbo].[joined_star_schema];

select * from [dbo].[customer_dim];

Select * from product_dim_modified;

	
Select * from product_dim;


	----------------------

INSERT INTO product_dim (product_id, product_name, category, price) VALUES
     (11, 'Laptop-Type1', 'Electronics', 1200.00);

UPDATE product_dim set product_name = 'Laptop1' Where product_id = 11;

Delete From product_dim where product_id = 11;

ALTER TABLE product_dim ADD description VARCHAR(200);

ALTER TABLE product_dim Drop column description;

ALTER TABLE product_dim ADD descriptions VARCHAR(200);

UPDATE product_dim set product_name = 'Laptop1' Where product_id = 11;

Select * from product_dim;


-- Update descriptions for products in product_dim table
UPDATE product_dim
SET descriptions = 
    CASE 
        WHEN product_id = 1 THEN 'High-performance laptop suitable for gaming and productivity tasks.'
        WHEN product_id = 2 THEN 'Latest smartphone with advanced features and excellent camera quality.'
        WHEN product_id = 3 THEN 'Ergonomic desk chair for comfortable seating during long working hours.'
        WHEN product_id = 4 THEN 'Stylish coffee table perfect for living room decor.'
        WHEN product_id = 5 THEN 'Quality running shoes designed for comfort and durability.'
        WHEN product_id = 6 THEN 'Durable basketball for indoor and outdoor play.'
        WHEN product_id = 7 THEN 'Casual and comfortable t-shirt available in various colors.'
        WHEN product_id = 8 THEN 'Classic pair of jeans suitable for everyday wear.'
        WHEN product_id = 9 THEN 'Noise-canceling headphones with excellent sound quality.'
        WHEN product_id = 10 THEN 'Adjustable desk lamp for reading and studying.'
        WHEN product_id = 11 THEN 'Description for Laptop11'
        -- Add more WHEN clauses for additional products as needed
    END;

Select * from product_dim;

--create a new table called product_dim_modified with the same structure and data as the product_dim table--

SELECT * INTO product_dim_modified
FROM product_dim;


Select * from product_dim_modified;


--Adding NULL values 
INSERT INTO product_dim_modified values (11, 'Laptop', 'Electronics', Null, 'This is a New generation Laptop')
 SELECT * FROM product_dim_modified;


--Data
Select * from product_dim;

select * from [dbo].[joined_star_schema];

select * from [dbo].[customer_dim];


Select * from product_dim_modified;






 ----QUESTIONS:
--Sales Analysis:

--What are the total sales for each product category?

SELECT CATEGORY, SUM(AMOUNT) AS Total_Sales 
INTO sum_sales
FROM joined_star_schema 
GROUP BY CATEGORY

select * from sum_sales;

SELECT SUM(AMOUNT) FROM [dbo].[joined_star_schema];

INSERT INTO sum_sales VALUES ('TOTAL',5700 ) 

select * from sum_sales;

--alternative: just for getting the total sales values--scalar quatity-- using the function

CREATE FUNCTION TOTAL_SALES_AMOUNT()
RETURNS DECIMAL(18,2)

AS

BEGIN
DECLARE @TOTAL  DECIMAL(18,2)
  SELECT @TOTAL = SUM(AMOUNT)
  FROM [dbo].[joined_star_schema]
  RETURN @TOTAL;
END;

SELECT dbo.TOTAL_SALES_AMOUNT();
 







--What are the total sales for each store location?

select * from [dbo].[joined_star_schema];

SELECT STORE_CITY, SUM(AMOUNT) AS TOTAL_SALES FROM [dbo].[joined_star_schema] GROUP BY STORE_CITY;

--Alternative using store procedure:

CREATE PROCEDURE sales_by_location

AS
BEGIN  
    SELECT STORE_CITY, SUM(AMOUNT) AS TOTAL_SALES 
    FROM [dbo].[joined_star_schema] 
    GROUP BY STORE_CITY;
END

EXEC sales_by_location;


--What is the average sales amount for each product?

select * from [dbo].[joined_star_schema];

select product_name, avg(amount) AS AVG_AMT from [dbo].[joined_star_schema] GROUP BY [product_name];

select product_name, COUNT(amount) AS count_product from [dbo].[joined_star_schema] GROUP BY [product_name];

--Customer Analysis:

--How many customers have made purchases in each month and year?
select * from [dbo].[joined_star_schema];

SELECT [customer_name],MONTH, YEAR, COUNT(customer_name) AS COUNT_CUSTOMER 
FROM [dbo].[joined_star_schema] 
GROUP BY [customer_name], MONTH, YEAR


--USE THE STORE PROCEDURE FOR COMPLEX/LONG QUERIES ( LIKE BUSINESS LOGIC RETURNING A TABLE).

--USE FUNCTION FOR SIMPLE/ QUERIES ( LIKE GETTING SCALAR VALUES--AREA OF RECTANGLE).

--IN THIS CASE, WE ARE GETTING A TABLE ( NOT A SINGLE VALUE). SO BETTER TO USE THE STORE PROCEDURE THAN THE FUNCTION.

--note: FUNCTION USES A RETURN KEYWORD, BUT STORE PROCEDURE DOES NOT.

--PYTHON FUNCTION ARE SIMLAR TO THE SQL FUNCTION.

--VIEWS ARE REUSABLE CODES FOR VIRTUAL TABLE, USED FOR REPORTING, DATA ACCESS, DATA ABSTRACTION (LIKE ENCAPSULATION).

--
--Alternative: USING FUNCTION

CREATE FUNCTION CUSTOMER_COUNT_BY_MON_YEAR ()

RETURNS TABLE
AS
RETURN
(
    SELECT [customer_name], 
           MONTH(transaction_date) AS [MONTH], 
           YEAR(transaction_date) AS [YEAR], 
           COUNT(customer_name) AS COUNT_CUSTOMER 
    FROM [dbo].[joined_star_schema] 
    GROUP BY [customer_name], MONTH(transaction_date), YEAR(transaction_date)
);

SELECT * FROM CUSTOMER_COUNT_BY_MON_YEAR();



--AlternaTIVE: VIEW--Virtual Table

CREATE VIEW customers_per_month_view AS 
SELECT YEAR(transaction_date) AS year, 
       MONTH(transaction_date) AS month, 
       COUNT(DISTINCT transaction_id) AS customer_count 
FROM  joined_star_schema
GROUP BY YEAR(transaction_date), MONTH(transaction_date);

select * from customers_per_month_view 

--What is the distribution of customers by country?


select * from [dbo].[joined_star_schema];




SELECT [store_country], COUNT(*) AS CUSTOMER_COUNT FROM [dbo].[joined_star_schema] GROUP BY [store_country]

--What are the total sales amounts for each customer?
select * from [dbo].[joined_star_schema];

SELECT [customer_name], SUM([amount]) AS AMOUNT_BY_EACH_CUSTOMER FROM [dbo].[joined_star_schema] GROUP BY [customer_name]


--Product Analysis:

--What are the top-selling products in each product category? idea of CTE-temporary table

--The WITH clause defines a common table expression (CTE) named ProductRank.
--The WITH clause, also known as a Common Table Expression (CTE), allows us to define temporary result sets 
--that can be referenced within the scope of a single SQL statement, such as a SELECT, INSERT, UPDATE, or DELETE statement.

-- Starting with the "SELECT", the body of the CTE table starts.


select * from [dbo].[joined_star_schema];

WITH ProductRank AS (
    SELECT 
        product_name, 
        category,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY product_name) AS product_rank
    FROM 
        dbo.joined_star_schema)

SELECT product_name,category FROM ProductRank WHERE product_rank = 1;

----------------------------------------------------------------------------------------
WITH ProductRank AS (
    SELECT 
        product_name, 
        category,
        amount,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY amount DESC) AS product_rank
    FROM 
        dbo.joined_star_schema)

SELECT product_name, category, amount 
FROM ProductRank 
WHERE product_rank = 1;









--How many units of each product were sold in each month?
select * from [dbo].[joined_star_schema];

SELECT 
    [product_name], 
    COUNT([product_name]) AS product_count,
    MONTH([transaction_date]) AS transaction_month
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    [product_name], 
    MONTH([transaction_date]);


--What is the revenue generated by each product?

select * from [dbo].[joined_star_schema];

SELECT [product_name],[category] ,SUM([amount]) AS PRODUCT_REVENUE
FROM [dbo].[joined_star_schema] GROUP BY [product_name],[category]

--Time Analysis:

--What are the total sales amounts for each year?
select * from [dbo].[joined_star_schema];

SELECT YEAR([transaction_date]) AS YEARS, SUM([amount]) AS TOTAL_AMOUNT, SUM([quantity]) AS TOTAL_SALES
FROM [dbo].[joined_star_schema]
GROUP BY YEAR([transaction_date])
--How do sales vary by day of the week?
select * from [dbo].[joined_star_schema];

SELECT [day_of_week] AS WEEK_DAYS, SUM([amount]) AS TOTAL_AMOUNT, SUM([quantity]) AS TOTAL_SALES
FROM [dbo].[joined_star_schema]
GROUP BY [day_of_week]

--What are the monthly sales trends over the past year?

SELECT 
    YEAR(transaction_date) AS sales_year,
    MONTH(transaction_date) AS sales_month,
    SUM(amount) AS total_sales
FROM 
    joined_star_schema
WHERE 
    transaction_date >= DATEADD(YEAR, -1, GETDATE()) -- Filter data for the past year
--DATEADD(YEAR, -1, GETDATE()) returns the date exactly one year ago from the current date.
GROUP BY 
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY 
    YEAR(transaction_date),
    MONTH(transaction_date);



--Geographical Analysis:
select * from [dbo].[joined_star_schema];
--What are the sales amounts for each product category in each country?


SELECT SUM([amount]) AS total_sales_amount, [product_name], [customer_country] 
FROM [dbo].[joined_star_schema]
GROUP BY [customer_country],[product_name]


--alternative:


--What are the top-selling products in each region?
select * from [dbo].[joined_star_schema];
------------------------------------------
WITH TopSellingProducts AS (
    SELECT 
        product_name,
        category,
        store_city,
        store_country,
        SUM(quantity) AS total_quantity_sold,
        ROW_NUMBER() OVER (PARTITION BY store_city, store_country ORDER BY SUM(quantity) DESC) AS rank
    FROM 
        joined_star_schema
    GROUP BY 
        product_name,
        category,
        store_city,
        store_country
)
SELECT 
    product_name,
    category,
    store_city,
    store_country,
    total_quantity_sold
FROM 
    TopSellingProducts
WHERE 
    rank = 1;


--How does sales performance vary across different store locations?


select * from [dbo].[joined_star_schema];
------------------------------------------
SELECT 
    store_city,
    store_country,
    SUM(amount) AS total_sales_amount,
    SUM(quantity) AS total_quantity_sold
FROM 
    joined_star_schema
GROUP BY 
    store_city,
    store_country
ORDER BY 
    total_sales_amount DESC;

----------------------------------

-- Calculate predicted sales value and compare with actual sales amount for each item
WITH avg_sales AS (
    SELECT 
        PRODUCT_NAME,
        transaction_date,
        AMOUNT,
        AVG(AMOUNT) OVER (PARTITION BY PRODUCT_NAME ORDER BY transaction_date ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS moving_avg_price
    FROM 
        [dbo].[joined_star_schema]
)
SELECT 
    a.PRODUCT_NAME,
    a.transaction_date,
    a.AMOUNT AS actual_price,
    a.moving_avg_price AS predicted_price,
    ABS(a.AMOUNT - a.moving_avg_price) AS variance
FROM 
    avg_sales a
ORDER BY 
    a.PRODUCT_NAME, a.transaction_date;

--Performance Analysis:



-- Calculate total sales revenue for each month

select * from [dbo].[joined_star_schema];
--..................................................
SELECT 
    MONTH(transaction_date) AS month,
    YEAR(transaction_date) AS year,
    SUM(amount) AS total_sales_revenue
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    MONTH(transaction_date),
    YEAR(transaction_date)
ORDER BY 
    year, month;






--What is the trend in sales performance over time?
SELECT 
    YEAR(transaction_date) AS sales_year,
    MONTH(transaction_date) AS sales_month,
    SUM(amount) AS total_sales_revenue
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY 
    sales_year, sales_month;



--Which products or categories are underperforming compared to others?
SELECT 
    product_name,
    SUM(amount) AS total_sales_revenue,
    AVG(amount) AS average_sales_revenue
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    product_name
ORDER BY 
    total_sales_revenue ASC;



-- Calculate total sales revenue by product category
select * from [dbo].[joined_star_schema];
----------
SELECT 
    category,
    store_city,
    store_country, 
    SUM(amount) AS total_sales_revenue
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    category,
    store_city,
    store_country
ORDER BY 
    total_sales_revenue;


--Profitability Analysis:
--What is the profit margin for each product?

SELECT 
    product_name,
    SUM(amount) AS total_sales_amount,
    CASE 
        WHEN SUM(amount) > 0 THEN (SUM(amount) / NULLIF(SUM(amount), 0)) * 100
        ELSE NULL
    END AS pseudo_profit_margin
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    product_name;


--Which products contribute the most to overall profit?
SELECT 
    product_name,
    SUM(amount) AS total_sales_amount,
    CASE 
        WHEN SUM(amount) > 0 THEN (SUM(amount) / NULLIF(SUM(amount), 0)) * 100
        ELSE NULL
    END AS pseudo_profit_margin,
    SUM(amount) * (CASE WHEN SUM(amount) > 0 THEN (SUM(amount) / NULLIF(SUM(amount), 0)) ELSE 0 END) / 100 AS estimated_profit
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    product_name
ORDER BY 
    estimated_profit DESC;


--How does profitability vary across different customer segments?

select * from [dbo].[joined_star_schema];
-----------------
SELECT 
    customer_city,customer_country,
    SUM(amount) AS total_sales_amount,
    CASE 
        WHEN SUM(amount) > 0 THEN (SUM(amount) / NULLIF(SUM(amount), 0)) * 100
        ELSE NULL
    END AS profit_margin,
    SUM(amount) * (CASE WHEN SUM(amount) > 0 THEN (SUM(amount) / NULLIF(SUM(amount), 0)) ELSE 0 END) / 100 AS total_profit
FROM 
    [dbo].[joined_star_schema]
GROUP BY 
    customer_city,customer_country
ORDER BY 
    total_profit DESC;
