-- 2.1. In relation to the products:

--    What categories of tech products does Magist have?
-- electronics, computers_accessories, pc_gamer, computers, watches_gifts, tablets_printing_image, telephony, consoles_games, audio, dvds_blu_ray

SELECT DISTINCT product_category_name_english
FROM product_category_name_translation;

--    How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
-- A: 22990 || 69,77%
SELECT ROUND(((
	SELECT COUNT(1)
	FROM order_items
	JOIN products
	USING (product_id)
	JOIN product_category_name_translation
	USING (product_category_name)
	WHERE product_category_name_english 
	IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")) * 100) / 
	(SELECT COUNT(1)
	FROM products), 2);
    
    SELECT COUNT(1)
    FROM products;
    
    SELECT COUNT(1)
	FROM order_items
	JOIN products
	USING (product_id)
	JOIN product_category_name_translation
	USING (product_category_name)
	WHERE product_category_name_english 
	IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray");


--    What’s the average price of the products being sold?
-- 132.22 €

SELECT ROUND(AVG(price), 2)
	FROM order_items
	JOIN products
	USING (product_id)
	JOIN product_category_name_translation
	USING (product_category_name)
	WHERE product_category_name_english 
	IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
    AND order_status = 'delivered';
    
    SELECT
    ROUND(AVG(oi.price), 2) AS average_product_price
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

SELECT
  t.product_category_name_english AS tech_category,
  ROUND(AVG(oi.price), 2) AS avg_price
FROM order_items AS oi
JOIN products AS p
  ON p.product_id = oi.product_id
JOIN product_category_name_translation AS t
  ON t.product_category_name = p.product_category_name
WHERE t.product_category_name_english IN (
  'watches_gifts',
  'telephony',
  'tablets_printing_image',
  'pc_gamer',
  'computers_accessories',
  'consoles_games',
  'computers',
  'electronics',
  'dvds_blu_ray',
  'audio'
)
GROUP BY t.product_category_name_english
ORDER BY avg_price DESC;

SELECT DISTINCT product_category_name_english , ROUND(AVG(price),2) as average_price, COUNT(DISTINCT(product_id)) AS product_count, ROUND(AVG(price) * COUNT(product_id),2)
FROM products as P
	LEFT JOIN product_category_name_translation as PCT USING(product_category_name)
		LEFT JOIN order_items USING(product_id)
WHERE product_category_name_english IN ('watches_gifts' , 'telephony' , 'tablets_printing_image' , 'pc_gamer' , 'computers_accessories' , 'consoles_games' , 'computers' , 'electronics' , 'dvds_blu_ray' , 'audio' )
GROUP BY product_category_name_english
ORDER BY average_price;

SELECT
  t.product_category_name_english AS tech_category,
  COUNT(DISTINCT(oi.product_id)) AS products_sold,
  ROUND(AVG(oi.price), 2) AS avg_price,
  ROUND(AVG(oi.price) * COUNT(oi.product_id), 2) AS revenue,
  CASE
    WHEN AVG(oi.price) >= 500 THEN 'High'
    WHEN AVG(oi.price) >= 100 THEN 'Mid'
    ELSE 'Low'
  END AS price_tier
FROM order_items AS oi
JOIN products AS p
  ON p.product_id = oi.product_id
JOIN product_category_name_translation AS t
  ON t.product_category_name = p.product_category_name
WHERE t.product_category_name_english IN (
  'watches_gifts',
  'telephony',
  'tablets_printing_image',
  'pc_gamer',
  'computers_accessories',
  'consoles_games',
  'computers',
  'electronics',
  'dvds_blu_ray',
  'audio'
)
GROUP BY t.product_category_name_english
ORDER BY avg_price DESC;

SELECT *
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english = "computers"
ORDER BY price;

SELECT MIN(avgprice), MAX(avgprice), ROUND(AVG(avgprice), 2)
FROM (
SELECT product_id, ROUND(AVG(price), 2) avgprice
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english = "watches_gifts"
GROUP BY product_id
ORDER BY AVG(price) DESC) ImJustAName;

SELECT ROUND(AVG(price), 2) avgprice
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english = "watches_gifts";

SELECT product_id, ROUND(AVG(price), 2) avgprice, COUNT(1)
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english = "watches_gifts"
GROUP BY product_id
ORDER BY AVG(price) DESC;

--    Are expensive tech products popular? *

SELECT *
FROM order_items
JOIN products
USING (product_id)	
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
ORDER BY price DESC
LIMIT 10712; -- middle 69,90 €

SELECT *
FROM order_items
JOIN products
USING (product_id)	
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
ORDER BY price DESC
LIMIT 5356; -- upper 1/4 149,90 €

SELECT *
FROM order_items
JOIN products
USING (product_id)	
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
ORDER BY price DESC
LIMIT 16068; -- lower 1/4 29,00 €

SELECT *
FROM order_items
JOIN products
USING (product_id)	
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
AND price > 500;

SELECT price_cat, COUNT(1)
FROM (
SELECT CASE
	WHEN price > 500 THEN "expensive > 500"
    WHEN price < 50 THEN "peanuts < 50"
    ELSE "cheap"
    END price_cat
FROM order_items
JOIN products
USING (product_id)	
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")) ImJustAName
GROUP BY price_cat;

SELECT DISTINCT product_category_name_english, AVG(Review_score)
FROM products as P
	LEFT JOIN product_category_name_translation as PCT USING(product_category_name)
		LEFT JOIN order_items USING(product_id)
			LEFT JOIN order_reviews USING(order_id)
WHERE product_category_name_english IN ('watches_gifts' , 'telephony' , 'tablets_printing_image' , 'pc_gamer' , 'computers_accessories' , 'consoles_games' , 'computers' , 'electronics' , 'dvds_blu_ray' , 'audio' )
GROUP BY product_category_name_english ;

SELECT *
FROM order_reviews;


-- * TIP: Look at the function CASE WHEN to accomplish this task.
-- 2.2. In relation to the sellers:

--    How many months of data are included in the magist database?

SELECT MAX(order_purchase_timestamp), MIN(order_purchase_timestamp), TIMESTAMPDIFF(month, MAX(order_purchase_timestamp), MIN(order_purchase_timestamp))
FROM orders; -- 25 months

--    How many sellers are there? 
-- A: 3095

SELECT COUNT(1) FROM sellers;

--    How many Tech sellers are there? 544

SELECT COUNT(1)
FROM (
SELECT seller_id 
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
JOIN sellers
USING (seller_id)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
GROUP BY seller_id) ImJustAName;

--    What percentage of overall sellers are Tech sellers? 16,48%

SELECT ROUND(((
SELECT COUNT(1)
FROM (
SELECT seller_id 
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
JOIN sellers
USING (seller_id)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
GROUP BY seller_id) ImJustAName) * 100) / (SELECT COUNT(1) FROM sellers), 2);

--    What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?

SELECT ROUND(SUM(price), 2)
FROM order_items; -- 13,591,643.70 € total

SELECT ROUND(SUM(price), 2)
FROM order_items
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray");
-- 3,047,064.86 € Tech earned

SELECT ROUND((3047064.86 * 100) / 13591643.7, 2);

--    Can you work out the average monthly income of all sellers? 

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS year_months,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.seller_id) AS active_sellers,
    ROUND(SUM(oi.price) / COUNT(DISTINCT oi.seller_id), 2) AS avg_revenue_per_seller
FROM order_items oi
JOIN orders o 
    ON o.order_id = oi.order_id
GROUP BY year_months
ORDER BY year_months DESC;

--   Can you work out the average monthly income of Tech sellers?

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS year_months,
    SUM(oi.price) AS total_revenue,
    COUNT(DISTINCT oi.seller_id) AS active_sellers,
    ROUND(SUM(oi.price) / COUNT(DISTINCT oi.seller_id), 2) AS avg_revenue_per_seller
FROM order_items oi
JOIN orders o 
    ON o.order_id = oi.order_id
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE product_category_name_english IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
GROUP BY year_months
ORDER BY year_months DESC;

-- 2.3. In relation to the delivery time:

--    What’s the average time between the order being placed and the product being delivered?
--    A: 12,50

SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2)
FROM orders;

--    How many orders are delivered on time vs orders delivered with a delay?

SELECT intime, COUNT(1)
FROM
(SELECT CASE
	WHEN order_estimated_delivery_date > order_delivered_customer_date THEN "Justin"
    ELSE "toolate"
    END intime
FROM orders
WHERE order_status = "delivered") ImJustAName
GROUP BY intime;

SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'on_time'
        ELSE 'delayed'
    END AS delivery_status,
    COUNT(*) AS orders_count
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_status = "delivered"
GROUP BY delivery_status;

--    Is there any pattern for delayed orders, e.g. big products being delayed more often?
--   A: Small items are delayed more often 6206 items / 8715 items (delayed) || small = under average lxhxw

SELECT *, (product_length_cm * product_height_cm * product_width_cm) cm3
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date;

SELECT AVG(product_length_cm * product_height_cm * product_width_cm)
FROM products;

SELECT COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date
AND product_length_cm * product_height_cm * product_width_cm < (SELECT AVG(product_length_cm * product_height_cm * product_width_cm)
FROM products);