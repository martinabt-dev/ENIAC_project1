-- DELAYED PRODUCTS

SELECT COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date; -- 8715 products delayed

SELECT AVG(product_weight_g) avg_weight_g, AVG(product_length_cm * product_height_cm * product_width_cm) avg_dimensions_cm3,
AVG(product_weight_g / (product_length_cm * product_height_cm * product_width_cm)) avg_density
FROM products; -- AVG dimensions of all products


SELECT COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date
AND product_weight_g < (SELECT AVG(product_weight_g)
FROM products); -- under AVG weight products delayed: 6715

SELECT COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date
AND product_length_cm * product_height_cm * product_width_cm < (SELECT AVG(product_length_cm * product_height_cm * product_width_cm)
FROM products); -- under AVG dimensions products delayed: 6206

SELECT COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date
AND product_weight_g / (product_length_cm * product_height_cm * product_width_cm) < (SELECT AVG(product_weight_g / (product_length_cm * product_height_cm * product_width_cm))
FROM products); -- density under AVG of delayed products: 6570

SELECT COUNT(1)
FROM orders
WHERE order_estimated_delivery_date < order_delivered_customer_date; -- 7827 orders delayed

SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year_months, COUNT(1)
FROM orders
WHERE order_estimated_delivery_date < order_delivered_customer_date
GROUP BY year_months
ORDER BY year_months DESC; -- delayed orders by month

SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year_months, COUNT(1)
FROM orders
GROUP BY year_months
ORDER BY year_months DESC; -- delayed orders by month

SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year_months,
    
    COUNT(*) AS total_orders,
    
    SUM(
        CASE 
            WHEN order_delivered_customer_date > order_estimated_delivery_date 
            THEN 1 
            ELSE 0 
        END
    ) AS delayed_orders,
    
    ROUND(
        SUM(
            CASE 
                WHEN order_delivered_customer_date > order_estimated_delivery_date 
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(*) * 100,
        2
    ) AS delay_percentage

FROM orders

WHERE order_delivered_customer_date IS NOT NULL

GROUP BY year_months
ORDER BY year_months DESC; -- delayed by month


SELECT ROUND(AVG(delayed_orders), 2)
FROM (
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS year_months, COUNT(1) delayed_orders
FROM orders
WHERE order_estimated_delivery_date < order_delivered_customer_date
GROUP BY year_months
ORDER BY year_months DESC) imjustaname; -- AVG delayed orders per month

SELECT ROUND(AVG(freight_value), 2), ROUND(AVG(price), 2)
FROM orders
JOIN order_items
USING (order_id)
WHERE order_estimated_delivery_date < order_delivered_customer_date; -- freight value and price of delayed orders

SELECT product_category_name_english, COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
WHERE order_estimated_delivery_date < order_delivered_customer_date
GROUP BY product_category_name_english
ORDER BY COUNT(1) DESC; -- categories with the most delayed products

SELECT product_category_name_english, COUNT(1)
FROM orders
JOIN order_items
USING (order_id)
JOIN products
USING (product_id)
JOIN product_category_name_translation
USING (product_category_name)
GROUP BY product_category_name_english
ORDER BY COUNT(1) DESC; -- categories with all sold products

SELECT 
    t.product_category_name_english,
    
    COUNT(*) AS total_sold_products,
    
    SUM(
        CASE 
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
            THEN 1 
            ELSE 0 
        END
    ) AS delayed_products,
    
    ROUND(
        SUM(
            CASE 
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(*) * 100,
        2
    ) AS delay_percentage
    
FROM orders o
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation t USING (product_category_name)

GROUP BY t.product_category_name_english
ORDER BY delay_percentage DESC; -- categories with the most delayed products in %


SELECT 
    t.product_category_name_english,
    
    COUNT(*) AS total_sold_products,
    
    SUM(
        CASE 
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
            THEN 1 
            ELSE 0 
        END
    ) AS delayed_products,
    
    ROUND(
        SUM(
            CASE 
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(*) * 100,
        2
    ) AS delay_percentage
    
FROM orders o
JOIN order_items oi USING (order_id)
JOIN products p USING (product_id)
JOIN product_category_name_translation t USING (product_category_name)
WHERE product_category_name_english 
IN ("electronics", "computers_accessories", "pc_gamer", "computers", "watches_gifts", "tablets_printing_image", "telephony", "consoles_games", "audio", "dvds_blu_ray")
GROUP BY t.product_category_name_english
ORDER BY delay_percentage DESC; -- categories most delayed tech products in %