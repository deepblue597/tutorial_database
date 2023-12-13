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
WHERE state IN ('VA' , 'FA' , 'GA')  ; -- or or 
 


