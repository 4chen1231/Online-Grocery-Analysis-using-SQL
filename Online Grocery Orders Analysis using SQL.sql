


--Creat Table and Insert Data


CREATE TABLE departments 
(
	department_id INT NOT NULL,
	department varchar (50)
);
	
SELECT * FROM departments;


CREATE TABLE order_products_prior 
(
	order_id INT NOT NULL,
	product_id INT,
        add_to_cart_order INT, 
        reordered INT
);
	
SELECT * FROM order_products;



CREATE TABLE orders 
(
	order_id INT NOT NULL,
	user_id INT,
    	order_number INT,
   	order_dow INT,
   	order_hour_of_day INT,
    	days_since_prior_order FLOAT
);	
	
SELECT * FROM orders;



CREATE TABLE products 
(
	product_id INT NOT NULL,
	product_name VARCHAR(200),
    	department_id INT
);
	
SELECT * FROM products;





--Todal orders by day of week.


SELECT COUNT(order_id) as Total_orders,
(CASE
		WHEN order_dow = '0' THEN 'Sunday'
		WHEN order_dow = '1' THEN 'Monday'
		WHEN order_dow = '2' THEN 'Tuesday'
		WHEN order_dow = '3' THEN 'Wednesday'
		WHEN order_dow = '4' THEN 'Thursday'
		WHEN order_dow = '5' THEN 'Friday'
		WHEN order_dow = '6' THEN 'Saturday'
	END) as Day_of_Week
FROM orders
GROUP BY order_dow
ORDER BY Total_orders DESC;





--Todal orders by hour of day.


SELECT COUNT(order_id) as total_orders, order_hour_of_day as hour 
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day ASC;






--Top 10 popular products sold


SELECT COUNT(op.order_id) as Total_Orders, p.product_name as Top_10_Products
FROM order_products_prior as op
INNER JOIN products as p
ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Orders DESC
LIMIT 10;






--Most popular department sold


SELECT COUNT(op.order_id) as Total_Orders, ddp.department as Departments
FROM (
	SELECT d.department, d.department_id, p.product_id
	FROM departments as d	
	INNER JOIN products as p
	ON d.department_id = p.department_id) as ddp
INNER JOIN order_products_prior as op
on ddp.product_id = op.product_id
GROUP BY ddp.department
ORDER BY Total_Orders DESC;





--How Many Products Were Reordered

SELECT COUNT(DISTINCT(product_id))
FROM order_products_prior
WHERE reordered = 1;





--Ranking of products that added to cart first

SELECT product_id, COUNT(add_to_cart_order) as First_at_Cart
FROM (
	SELECT product_id, add_to_cart_order
	FROM order_products_prior
	WHERE add_to_cart_order = 1 ) as First_at_cart_Products
GROUP BY product_id
ORDER BY add_to_cart_order DESC;






--Average number of days from 1st purchase to 2nd purchase, to 3rd purchase to etc. 


SELECT order_number, ROUND(AVG(days_since_prior_order)) Next_Purchase_Day 
FROM orders
GROUP BY order_number
ORDER BY order_number ASC;





--Pandemic has also accelerated demand for online alcohol


CREATE VIEW order_products_depatrtments AS
SELECT p.department_id, p.product_id, op.order_id, dep.department, op.add_to_cart_order
FROM products as p
INNER JOIN order_products_prior as op on p.product_id = op.product_id
INNER JOIN departments as dep on p.department_id = dep.department_id


SELECT *
FROM order_products_depatrtments;




--Total number of orders with alcohol 

SELECT (SELECT COUNT(DISTINCT order_id) FROM order_products_depatrtments), COUNT(DISTINCT order_id)
FROM order_products_depatrtments
WHERE department='alcohol'
GROUP BY department;





--orders alcohol ordered first

CREATE VIEW alcohol_first_orders AS
SELECT order_id 
FROM order_products_depatrtments
WHERE department = 'alcohol' 
AND add_to_cart_order = 1;
 


