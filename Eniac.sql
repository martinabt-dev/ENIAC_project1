USE magist;

--    1. How many orders are there in the dataset? The orders table contains a row for each order, so this should be easy to find out!
-- A: 99,441

SELECT COUNT(1)
FROM orders;	
	
--    2. Are orders actually delivered? Look at the columns in the orders table: one of them is called order_status. 
--     Most orders seem to be delivered, but some aren’t. Find out how many orders are delivered and how many are cancelled, unavailable, or in any other status by grouping and aggregating this column.
-- A: delivered: 96,478 | 97,02%

SELECT order_status, COUNT(1)
FROM orders
GROUP BY order_status;

SELECT ROUND(((
	SELECT COUNT(1)
    FROM orders
	WHERE order_status = 'delivered') * 100) / (
    SELECT COUNT(1)
	FROM orders), 2);  
	
--	3. Is Magist having user growth? A platform losing users left and right isn’t going to be very useful to us. 
-- It would be a good idea to check for the number of orders grouped by year and month. 
-- Tip: you can use the functions YEAR() and MONTH() to separate the year and the month of the order_purchase_timestamp.
    
SELECT YEAR(order_purchase_timestamp), COUNT(1)
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) desc;

SELECT YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp), COUNT(1)
FROM orders
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY YEAR(order_purchase_timestamp) desc, MONTH(order_purchase_timestamp) desc;     

SELECT YEAR(order_purchase_timestamp) as year, MONTH(order_purchase_timestamp) as Month, COUNT(order_id)
FROM orders
WHERE order_status = 'delivered'
GROUP BY YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
ORDER BY year, month;

SELECT *
FROM orders
ORDER BY order_purchase_timestamp DESC;

SELECT *
FROM orders
ORDER BY order_purchase_timestamp;
	
--	4. How many products are there on the products table? (Make sure that there are no duplicate products.)

SELECT *
FROM products;

SELECT p1.product_id product1, p2.product_id product2
FROM products p1
JOIN products p2
ON p1.product_weight_g = p2.product_weight_g
AND p1.product_length_cm = p2.product_length_cm
AND p1.product_height_cm = p2.product_height_cm
AND p1.product_width_cm = p2.product_width_cm
AND p1.product_id < p2.product_id;    

SELECT *
FROM products
WHERE product_weight_g = 300
AND product_length_cm = 20
AND product_height_cm = 16
AND product_width_cm = 16;

SELECT COUNT(1), product_weight_g, product_length_cm, product_height_cm, product_width_cm
FROM products
GROUP BY product_weight_g, product_length_cm, product_height_cm, product_width_cm
HAVING COUNT(1) > 1;

SELECT COUNT(1)
FROM products p1
JOIN products p2
ON p1.product_weight_g = p2.product_weight_g
AND p1.product_length_cm = p2.product_length_cm
AND p1.product_height_cm = p2.product_height_cm
AND p1.product_width_cm = p2.product_width_cm
AND p1.product_id < p2.product_id;    

SELECT COUNT(1)
FROM products;

SELECT COUNT(DISTINCT(product_id))
FROM products;

SELECT
    product_id,
    COUNT(1) AS occurrences
FROM products
GROUP BY product_id
HAVING COUNT(1) > 1
ORDER BY occurrences DESC;
	
--	5. Which are the categories with the most products? Since this is an external database and has been partially anonymized, we do not have the names of the products. 
-- But we do know which categories products belong to. This is the closest we can get to knowing what sellers are offering in the Magist marketplace. 
-- By counting the rows in the products table and grouping them by categories, we will know how many products are offered in each category. 
-- This is not the same as how many products are actually sold by category. To acquire this insight we will have to combine multiple tables together: we’ll do this in the next lesson.

SELECT product_category_name_english, COUNT(1)
FROM products
JOIN product_category_name_translation
USING (product_category_name)
GROUP BY product_category_name_english
ORDER BY COUNT(1) DESC;

SELECT DISTINCT COUNT(product_id) as Product_per_category, Product_category_name_english, ROUND(AVG(price),2) as average_product_price, ROUND(COUNT(product_id) * (AVG(price)),2) AS Revenue_per_product
FROM products as P
	LEFT JOIN product_category_name_translation as PCT USING(product_category_name)
		LEFT JOIN order_items USING(product_id)
GROUP BY product_category_name_english
ORDER BY Revenue_per_product DESC;

SELECT COUNT(1)
FROM product_category_name_translation;

SELECT product_category_name_english, COUNT(1)
FROM order_items
LEFT JOIN products
USING (product_id)
LEFT JOIN product_category_name_translation
USING (product_category_name)
GROUP BY product_category_name_english
ORDER BY COUNT(1) DESC;   
	
-- 6. How many of those products were present in actual transactions? The products table is a “reference” of all the available products. 
-- Have all these products been involved in orders? Check out the order_items table to find out!

SELECT product_id, COUNT(1)
FROM products
LEFT JOIN order_items
USING (product_id)
GROUP BY product_id
ORDER BY COUNT(1) DESC;

SELECT (
	SELECT COUNT(1) 
    FROM products) -
    (SELECT COUNT(DISTINCT product_id)
    FROM order_items) unordered_products;

SELECT COUNT(DISTINCT product_id)
FROM products
LEFT JOIN order_items
USING (product_id); 

SELECT COUNT(DISTINCT product_id)
FROM products
JOIN order_items
USING (product_id);      
	
--	7. What’s the price for the most expensive and cheapest products? Sometimes, having a broad range of prices is informative. 
-- Looking for the maximum and minimum values is also a good way to detect extreme outliers.

SELECT MAX(price), MIN(price), ROUND(Max(price) - MIN(price), 2) pricerange, ROUND(AVG(price))
FROM order_items;    
	
--	8. What are the highest and lowest payment values? Some orders contain multiple products. What’s the highest someone has paid for an order? Look at the order_payments table and try to find it out.

SELECT ROUND(MAX(order_price), 2), ROUND(MIN(order_price), 2)
FROM (
SELECT order_id, SUM(price) order_price
FROM order_items
GROUP BY order_id) ImJustAName;

SELECT MAX(payment_value), MIN(payment_value)
FROM order_payments;

SELECT MAX(payment_value), MIN(payment_value)
FROM order_payments
WHERE payment_value > 0;

SELECT COUNT(order_id), ROUND(SUM(price)) as SUM_revenue_per_category,
CASE
WHEN payment_value BETWEEN 0 AND 1 THEN '0super_low_price(0 to 1)'
WHEN payment_value BETWEEN 1 AND 50 THEN '1low_price(1 to 50)'
WHEN payment_value BETWEEN 50 AND 500 THEN '2low_to_medium_price(51 to 500)'
WHEN payment_value BETWEEN 500 AND 1500 THEN '3medium_price(501 to 1500)'
WHEN payment_value BETWEEN 1500 AND 5000 THEN '4medium_to_high_price(1500 to 5000)'
ELSE '5high_price(5001+)'
END AS price_category
FROM orders JOIN order_payments USING(order_id) JOIN order_items USING(order_id)
GROUP BY price_category
ORDER BY price_category;

-- Revenue April 2017 - March 2018

SELECT ROUND(SUM(price), 2)
FROM order_items
JOIN orders
USING (order_id)
WHERE order_purchase_timestamp BETWEEN "2017-04-01" AND "2018-03-31";

SELECT *
FROM products
JOIN product_category_name_translation
USING (product_category_name)
;

-- AVG monthly revenue

SELECT ROUND(SUM(price) / 12, 2)
FROM order_items
JOIN orders
USING (order_id)
WHERE order_purchase_timestamp BETWEEN "2017-04-01" AND "2018-03-31";

-- AVG order price

SELECT ROUND(AVG(price))
FROM order_items;

SELECT ROUND(AVG(price))
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ("computers_accessories");

-- AVG Item Price

SELECT ROUND(AVG(avg_price))
FROM (
SELECT product_id, AVG(price) avg_price
FROM order_items
GROUP BY product_id) ImJustAName;

SELECT ROUND(AVG(avg_price))
FROM (
	SELECT AVG(price) avg_price
	FROM order_items
	JOIN products
	USING (product_id)
	JOIN product_category_name_translation
	USING (product_category_name)
	WHERE product_category_name_english IN ("computers_accessories")
	GROUP BY product_id) ImJustAName;