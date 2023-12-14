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
	ON e.reports_to = m.employee_id
    
-- using close 

