---Identify New and Repeated Customers Using Subquery----
-----Identify New and Repeated Customers Using Using CTE (Common Table Expression)----

-------------------Identify New and Repeated Customers Using Join-------------
--All three approaches will provide the same results.

--DROP TABLE IF EXISTS customer_orders;


CREATE TABLE customer_orders (
    application_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    application_date DATE,
    loan_amount INTEGER
);

INSERT INTO customer_orders (application_id, customer_id, application_date, loan_amount) VALUES
(1, 100, '2024-03-01', 1000),
(2, 200, '2024-03-01', 1500),
(3, 300, '2024-03-01', 2000),
(4, 100, '2024-03-02', 2500),
(5, 400, '2024-03-02', 3000),
(6, 500, '2024-03-02', 3500),
(7, 100, '2024-03-03', 4000),
(8, 400, '2024-03-03', 4500),
(9, 600, '2024-03-03', 5000),
(10, 100, '2024-03-03', 5500),
(11, 600, '2024-03-03', 6000),
(12, 700,'2024-03-03', 6500);

SELECT * FROM customer_orders;


---Identify New and Repeated Customers Using Subquery----



SELECT DISTINCT customer_id,
    CASE 
        WHEN application_count = 1 THEN 'NEW CUSTOMER'
        ELSE 'REPEATED CUSTOMER'
    END AS customer_type
FROM (
    SELECT customer_id, COUNT(*) AS application_count
    FROM customer_orders
    GROUP BY customer_id
) AS subquery;


---------------Identify New and Repeated Customers Using Using CTE (Common Table Expression)----


SELECT CUSTOMER_ID , COUNT(*) AS APPLICATION_COUNT
FROM CUSTOMER_ORDERS
GROUP BY CUSTOMER_ID;

-------------------------------------------------
WITH CUSTOMER_COUNTS AS (

	SELECT CUSTOMER_ID , COUNT(*) AS APPLICATION_COUNT
	FROM CUSTOMER_ORDERS
	GROUP BY CUSTOMER_ID)


SELECT DISTINCT CUSTOMER_ID,
	CASE 
		WHEN APPLICATION_COUNT = 1 THEN 'NEW_CUSTOMER'
		ELSE 'REPEATED CUSTOMER'
		END AS CUSTOMER_TYPE
	FROM CUSTOMER_COUNTS;


-------------------Identify New and Repeated Customers Using Join-------------



--DEFINING CUSTOMER COUNT (CC) AND DEFINING CUSTOMER ORDERS (CO)
SELECT CUSTOMER_ID, COUNT(*) AS APPLICATION_COUNT
FROM CUSTOMER_ORDERS
GROUP BY CUSTOMER_ID;

----------------------------------------------

SELECT DISTINCT CO.CUSTOMER_ID,
	CASE
		WHEN CC.APPLICATION_COUNT = 1 THEN 'NEW_CUSTOMER'
		ELSE 'REPEATED CUSTOMER'
	END AS CUSTOMER_TYPE
FROM CUSTOMER_ORDERS CO
JOIN (
	SELECT CUSTOMER_ID, COUNT(*) AS APPLICATION_COUNT
	FROM CUSTOMER_ORDERS
	GROUP BY CUSTOMER_ID)
	AS CC
ON CO.CUSTOMER_ID = CC.CUSTOMER_ID;




---------------------------------------------------

SELECT customer_id,
    CASE 
        WHEN application_count = 1 THEN 'NEW CUSTOMER'
        ELSE 'REPEATED CUSTOMER'
    END AS customer_type
FROM (
    SELECT customer_id, COUNT(*) AS application_count
    FROM customer_orders
    GROUP BY customer_id
) AS subquery;

-------------------------------------
WITH customer_counts AS (
    SELECT customer_id, COUNT(*) AS application_count
    FROM customer_orders
    GROUP BY customer_id
)
SELECT customer_id,
    CASE 
        WHEN application_count = 1 THEN 'NEW CUSTOMER'
        ELSE 'REPEATED CUSTOMER'
    END AS customer_type
FROM customer_counts;

----------------------------------------------

SELECT co.customer_id,
    CASE 
        WHEN cc.application_count = 1 THEN 'NEW CUSTOMER'
        ELSE 'REPEATED CUSTOMER'
    END AS customer_type
FROM customer_orders co
JOIN (
    SELECT customer_id, COUNT(*) AS application_count
    FROM customer_orders
    GROUP BY customer_id
) AS cc
ON co.customer_id = cc.customer_id
GROUP BY co.customer_id, cc.application_count;


