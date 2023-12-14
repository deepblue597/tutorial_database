-- USE sql_store ; # select database 

/*
SELECT *   
FROM customers #select all columns from the customer database
-- WHERE customer_id = 1 #take the customer with id = 1 
ORDER BY first_name  ; #sort by name 
-- the order of the instruction matters 
-- white spaces are ignored
*/

SELECT 
	last_name, 
    first_name , 
    points , 
    (points + 10) * 100 AS 'discount factor' -- artihemitc expression AS : name of the column  
FROM customers  ; 

SELECT DISTINCT state -- unique list of states. Remove duplicates  
FROM customers  ; 

SELECT 
	name, 
    unit_price,
    unit_price * 1.1 AS 'new price' 
FROM products ; 

SELECT * 
FROM customers 
WHERE points > 3000 ; -- condition 

SELECT * 
FROM customers 
WHERE state = 'VA' ; 
 
SELECT * 
FROM customers 
WHERE state != 'VA' ; 

SELECT * 
FROM customers 
WHERE birth_date > '1990-01-01';  -- default format for date

SELECT * 
FROM  orders 
WHERE order_date >= '2019-01-01' ; -- order date after 2019 

SELECT * 
FROM customers  
WHERE birth_date > '1990-01-01'  OR 
points > 1000 AND state = 'VA' ; -- && also works 

SELECT * 
FROM customers  
WHERE NOT (birth_date > '1990-01-01'  OR  points > 1000) ; -- && also works 

SELECT * 
FROM order_items 
WHERE order_id = 6 AND ( quantity * unit_price ) > 30 ; 

SELECT * 
FROM customers 
WHERE state NOT IN ('VA' , 'FA' , 'GA')  ; -- or or

SELECT * 
FROM products 
WHERE quantity_in_stock IN (49 , 38 , 72 ) ;  

SELECT * 
FROM customers
WHERE points BETWEEN 1000 AND 3000;  -- between to values (from to) <= >= 

SELECT * 
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01' ; 

SELECT * 
FROM customers
WHERE last_name LIKE 'b%' ;  -- last name starts with b and then any character does not matter upper or lower case 

SELECT * 
FROM customers 
WHERE last_name LIKE '_____y' ;  -- they must have 5 chars and then y 

SELECT * 
FROM customers 
WHERE address LIKE '%trail%' OR 
	  address LIKE  '%avenue%' ;

SELECT * 
FROM customers
WHERE phone NOT LIKE '%9' ; 

SELECT * 
FROM customers 
WHERE last_name REGEXP 'field|mac|rose'  ; -- same as LIKE '%field%' 
-- ^field --> last name must start with field (beginning of a sting) 
-- field$ --> end of a string
-- 'field|mac' field or mac in the last name  
-- '[gim]e' bfore e g i or m in their last name 

SELECT * 
FROM customers 
WHERE last_name REGEXP '[a-h]e' ; 
-- [a-h] --> a to h 

SELECT * 
FROM customers 
WHERE first_name REGEXP 'elka|ambur' ; 

SELECT * 
FROM customers
WHERE last_name REGEXP 'ey$|on$' ; 

SELECT * 
FROM customers 
WHERE last_name REGEXP '^my|se' ; 

SELECT * 
FROM customers 
WHERE last_name REGEXP 'b[ru]' ; 

SELECT * 
FROM customers 
WHERE phone IS NULL ; -- phone is null 

SELECT * 
FROM orders 
WHERE shipped_date IS NULL ; 

SELECT first_name , last_name 
FROM customers 
ORDER BY state ,first_name DESC ;  -- descending order

SELECT * , quantity * unit_price AS total_price
FROM order_items 
WHERE order_id = 2 
ORDER BY total_price DESC ; 

SELECT * 
FROM customers 
LIMIT 6 , 3  ; -- BRING THE 3 customers
-- 6 , 3 --> skip the first 6 and take the 3

SELECT * 
FROM customers 
ORDER BY points DESC  
LIMIT 3 ; 

SELECT order_id , c.customer_id , first_name , last_name
FROM orders o -- abriviation 
JOIN customers c
	ON o.customer_id = c.customer_id  ; -- join them based on customer_id

SELECT order_id , name , quantity , o.unit_price
FROM order_items o 
JOIN products p 
	ON p.product_id = o.product_id ;  

SELECT * 
FROM order_items oi 
JOIN sql_inventory.products p 
	ON 	oi.product_id = p.product_id  ;  -- join across mulitple databases 

USE sql_hr ; 
    
SELECT e.employee_id , e.first_name , m.first_name AS manager
FROM employees e  
JOIN employees m 
	ON e.reports_to = m.employee_id ; -- self call in the same table 

-- JOINING MULTIPLE TABLES -- 
USE sql_store ; 
 
SELECT order_id , order_date , first_name , last_name , name AS status 
FROM orders o 
JOIN customers c 
	ON o.customer_id = c.customer_id 
JOIN order_statuses os 
	ON o.status = os.order_status_id ; 


-- excercise -- 

-- payments inside have the client_id (join with clients for the name) 
-- payment methods table join (name) 
-- join payments with payments method and clients 

USE sql_invoicing ;  

SELECT c.name AS client_name , pm.name AS method, p.amount , p.date , p.invoice_id  
FROM payments p  
JOIN payment_methods pm  
	ON  pm.payment_method_id = p.payment_method 
JOIN clients c 
	ON p.client_id = c.client_id ; 
    
-- compound join conditions -- 
-- for asthenis ontoties 

USE sql_store ; 

SELECT * 
FROM order_items oi 
JOIN order_item_notes oin 
	ON oi.order_id = oin.order_id 
    AND oi.order_id = oin.product_id ;  

-- implicit joint syntax

SELECT * 
FROM orders o, customers c 
WHERE o.customer_id = c.customer_id ;  -- not suggested  

-- outer join 
-- to see all the customers wether they have a order or not 
-- LEFT --> Customers are returned (all)  
-- RGIHT orders are returned (all) 

SELECT c.customer_id , c.first_name , o.order_id
FROM customers c 
LEFT JOIN orders o 
	ON c.customer_id = o.customer_id 
ORDER BY c.customer_id ; 

-- join products with order items i need products without being ordered 

SELECT p.product_id , p.name , oi.quantity 
FROM products p  
LEFT JOIN order_items oi  
	ON p.product_id = oi.product_id ; 
    
-- outer join between multiple tables 
-- avoid using right join 

SELECT c.customer_id , c.first_name , o.order_id , sh.name AS shipper
FROM customers c 
LEFT JOIN orders o 
	ON c.customer_id = o.customer_id 
LEFT JOIN shippers sh 
ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id ; 

-- order date order id first_name of customer shipper (have null) status 

SELECT o.order_id , o.order_date , c.first_name , sh.name , os.name
FROM orders o  
JOIN customers c 
	ON o.customer_id = c.customer_id  
LEFT JOIN shippers sh 
	ON o.shipper_id = sh.shipper_id 
JOIN order_statuses os
	ON os.order_status_id = o.status ; 
    
-- Self outer joins -- 

USE sql_hr ; 

SELECT e.employee_id , e.first_name , m.first_name AS manager
FROM employees e 
LEFT JOIN employees m 
	ON e.reports_to = m.employee_id ; 
    
-- using close 

SELECT 
	o.order_id ,
    c.first_name , 
    sh.name
FROM orders o 
JOIN customers c
	USING(customer_id) -- when the name is the same on both sides
LEFT JOIN shippers sh 
	USING(shipper_id) ; 
    
SELECT * 
FROM order_items oi 
JOIN order_item_notes oin 
	USING(order_id , product_id) ; 
    
-- query to select payments from paymetns tabe
-- date client amount payment method 

USE sql_invoicing  ; 

SELECT p.date , c.name , p.amount , pm.name AS payment_method 
FROM payments p
JOIN clients C 
	USING (client_id) 
JOIN payment_methods pm 
	ON p.payment_method = pm.payment_method_id  ; 
    
-- Natural join (not recommended) 

USE sql_store ; 

SELECT o.order_id , c.first_name 
FROM orders o 
NATURAL JOIN customers c ;  -- it will join them based in the same column (the code does it) 

-- Cross JOIN -- 
-- combine every record form the first table with every on the 2nd table 
-- table of sizes (like small medium large) and a table of colors 

SELECT c.first_name AS customer, p.name AS product 
FROM customers c 
CROSS JOIN products p  -- we dont have a condition 
ORDER BY c.first_name ; 

-- cross join between shippers and products 

SELECT sh.name AS shipper , p.name AS product 
FROM shippers sh 
CROSS JOIN products p ; 

-- Unions 
-- for combining rows 

SELECT order_id , order_date , 'Active' AS status 
FROM orders  
WHERE order_date >= '2019-01-01' 

UNION

SELECT order_id , order_date , 'Archived' AS status 
FROM orders  
WHERE order_date < '2019-01-01' ; 

SELECT first_name
FROM customers  
UNION 
SELECT name 
FROM shippers ; 

-- customer id , first name , points , type 
-- <2000 bronze >2000 <3000 Silver >3000 Gold 

SELECT customer_id , first_name , points , 'Bronze' as type 
FROM customers 
WHERE points < 2000  

UNION 

SELECT customer_id , first_name , points , 'Silver' as type 
FROM customers 
WHERE points BETWEEN 2000 AND 3000 

UNION 

SELECT customer_id , first_name , points , 'Gold' as type 
FROM customers 
WHERE points > 3000
ORDER BY first_name ;   
 
-- column attributes 

-- insert row 

INSERT INTO customers ( first_name , last_name , birth_date , address , city , state) 
VALUES(
		'Jason' , 
        'Kakandris' , 
        '1990-01-01' , 
         'address 7' , 
         'city', 
         'CA'  
         ) ; -- default for auto increment  
         
-- inserting multiple rows 

INSERT INTO shippers ( name )
VALUES ('Shipper1'), 
	    ('Shipper2'), 
        ('Shipper3') ; 


-- execrcise  insert in products 

INSERT INTO products 
VALUES (DEFAULT , 'asparagus' , 10 , 7.34), 
		(DEFAULT , 'pepper' , 5 , 3.14), 
        (DEFAULT , 'pickle' , 7 , 2.34) ; 

-- inserting hierarchical rows -- 
-- order parent order items children baseically a 1:N relation 

INSERT INTO orders ( customer_id , order_date , status)
VALUES  ( 1 , '2019-01-02' , 1 ) ; 
-- built in function 
INSERT INTO order_items
VALUES(LAST_INSERT_ID() , 1 , 1 , 2.95  ), 
		(LAST_INSERT_ID() , 2 , 1 , 2.95  ) ; 
-- new record 

-- creating a copy of a table -- 
-- not update the pk 
CREATE TABLE orders_archived AS 
SELECT * FROM orders ;

INSERT INTO orders_archived
SELECT * 
FROM orders 
WHERE order_date < '2019-01-01' ; 

-- invoices 
-- create a copy of the invoices into invoice archived not the client id but the client name 
-- copy only the invoices that do have a payment date 

USE sql_invoicing ;

CREATE TABLE archived_invoices AS
 SELECT i.invoice_id , i.number , i.invoice_total , i.payment_total , i.invoice_date  ,
		i.due_date , i.payment_date , c.name  
 FROM invoices i 
 JOIN clients c 
	USING (client_id)  
WHERE i.payment_date IS NOT NULL ; 

-- updating row -- 
USE sql_invoicing ; 

UPDATE invoices 
SET payment_total = invoice_total * 0.5 , 
	payment_date = due_date 
WHERE invoice_id = 3 ; 

-- update multiple rows -- 

UPDATE invoices 
SET payment_total = invoice_total * 0.5 , 
	payment_date = due_date 
WHERE client_id = 3 ;  -- safe update will haev an error  we go to edit --> preferences --> sql editor --> last checkbox 


-- give the customers born bef 1990 50 extra points 

USE sql_store ; 

UPDATE customers  
SET points = points + 50 
WHERE birth_date < '1990-01-01' ; 

-- Using subqueries in update 
USE sql_invoicing ; 

UPDATE invoices 
SET payment_total = invoice_total * 0.5 , 
	payment_date = due_date 
WHERE client_id IN -- = IF 1  

		( SELECT client_id  
		FROM clients 
		WHERE state IN ('CA' , 'NY') ) ; -- = if 1  

-- ex
-- update the comments for customers more than 3000 points 'gold customer' 

USE sql_store ; 

UPDATE orders  
SET comments = 'gold customer' 
WHERE customer_id IN 
	( SELECT customer_id 
	FROM customers  
	WHERE points > 3000 ) ; 
    
-- delete rows 
USE sql_invoicing ; 

DELETE FROM invoices 
WHERE client_id = ( 
	SELECT client_id  
	FROM clients 
	WHERE name = 'Myworks' ) ; 
    
-- restoring the database 

