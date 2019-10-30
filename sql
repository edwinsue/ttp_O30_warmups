-- 1) Download and install the northwind database - northwind.sql - from here (https://github.com/pthom/northwind_psql)
-- install the database from:
-- Mac terminal: 
-- >> navigate to your download folder
-- >> type: createdb northwind -U postgres
-- >> type: psql northwind < northwind.sql
-- Windows:
-- >> We'll have to figure it out :) 

-- Once installed, run the query below (in psql or pgadmin4)

SELECT p.productid, o.orderid, p.unitprice, od.quantity
FROM orders as o
JOIN orderdetails as od ON o.orderid = od.orderid
JOIN products as p ON p.productid = od.productid

-- 2) Look at the query results, and modify the above query to get the order totals for each order.
-- IMPORTANT: Note that each order is broken up into multiple rows, so you'll need to group by order_id
-- ALSO IMPORTANT: You have to do some math here. How do you get the order total? You'll have to 
-- multiply the unit_price column by the quanity column, then SUM over each order_id

WITH order_totals AS (
SELECT p.productid, o.orderid, p.unitprice, od.quantity, p.unitprice * od.quantity AS order_total
FROM orders as o
JOIN orderdetails as od ON o.orderid = od.orderid
JOIN products as p ON p.productid = od.productid
)

SELECT 
orderid,
SUM(order_total)
FROM order_totals ot
GROUP BY orderid
ORDER BY orderid ASC

-- 3) Use the above query as a CTE, and use AVG, stddev_samp, and COUNT, to get the mean, standard deviation
-- of the orders, and how many orders there are total.

WITH ordertotals as (
SELECT o.orderid, SUM(p.unitprice*od.quantity) as total
FROM orders as o
JOIN orderdetails as od ON o.orderid = od.orderid
JOIN products as p ON p.productid = od.productid
GROUP BY o.orderid
)

SELECT 
ROUND(AVG(total)::integer,2), 
ROUND(stddev_samp(total)::integer,2), 
COUNT(total)
FROM ordertotals

-- 4) The CEO of your company announced the other week that the company's long run average sales per order is $1850! Do you believe him? Assuming the data in this database is only a subset of all the sales. Set up a hypothesis test based on suspicion that he's exaggerating. we're going to try to give compelling evidence that the sales are less than $1850. You want to bring this up to your boss ONLY if you really sure, like 95% sure.

-- Use the results of the last query to do this in excel.
-- What's the null hypothesis?
Null: the company's long run average sales per order is equal to 1850
-- What's the alternative hypothesis?
Alternate: the company's long run average sales per order is less than 1850
-- What's the significance level?
Alpha = 0.05
-- Is this a one or two tail test?
It is a one tail test. I believe the boss is exaggerating which means the true amount is actually less than that. 
-- What's the standard error for our sample?
73.933
-- What's the cutoff threshold for your decision?
1625.39
-- What's your p value?
0.0818 (which is greater than my alpha) 
-- WHat's your conclusion?
Not confident enough to tell my boss he is wrong.
