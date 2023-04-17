-- Dataset link:
-- https://bit.io/emiliano/Capstone_Project

-- Q1.	How many customers do we have in the data?
SELECT COUNT(customer_id)
FROM customers;
-- Q2.	What was the city with the most profit for the company in 2015?
-- Q3.	In 2015, what was the most profitable city's profit?
SELECT SUM(order_profits), shipping_city, 
    DATE_PART('year',order_date) AS year
FROM orders
JOIN order_details
ON orders.order_id = order_details.order_id
WHERE DATE_PART('year',order_date) = 2015
GROUP BY 2, 3
ORDER BY 1 DESC
LIMIT 1;
-- Q4.	How many different cities do we have in the data?
SELECT COUNT(DISTINCT(shipping_city))
FROM orders;
-- Q5.	Show the total spent by customers from low to high.
SELECT customer_name, o.customer_id, SUM(order_sales) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY 1, 2
ORDER BY 3;
-- Q6.	What is the most profitable city in the State of Tennessee?
SELECT SUM(order_profits) total_profit, shipping_city, shipping_state
FROM orders o 
JOIN order_details od
ON o.order_id = od.order_id
WHERE shipping_state = 'Tennessee'
GROUP BY 2,3
ORDER BY 1 DESC
LIMIT 1;
-- Q7.	What’s the average annual profit for that city across all years?
SELECT AVG(order_profits)::numeric(10,2) total_profit, shipping_city
FROM order_details od
JOIN orders o
ON od.order_id = o.order_id
WHERE shipping_city = 'Lebanon'
GROUP BY 2;
-- Q8.	What is the distribution of customer types in the data?
SELECT COUNT(customer_id), customer_segment
FROM customers
GROUP BY 2;
-- Q9.	What’s the most profitable product category on average in Iowa across all years?
SELECT AVG(order_profits)::numeric(10,2) avg_profit, product_category, shipping_state
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN product p
ON p.product_id = od.product_id
WHERE shipping_state = 'Iowa'
GROUP BY 2, 3
ORDER BY 1 DESC
LIMIT 1;
-- Q10.	What is the most popular product in that category across all states in 2016?
SELECT  COUNT(o.order_id) total_orders, product_name,
    product_category
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
JOIN product p
ON p.product_id = od.product_id
WHERE product_category = 'Furniture'
AND DATE_PART('year', order_date) = 2016
GROUP BY 2, 3
ORDER BY 1 DESC;
-- Q11.	Which customer got the most discount in the data? (in total amount)
SELECT customer_name, c.customer_id, SUM(order_discount)::numeric(10,2) total_discount
FROM customers c
JOIN orders o 
ON o.customer_id = c.customer_id
JOIN order_details od
ON od.order_id = o.order_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;
-- Q12.	How widely did monthly profits vary in 2018?
SELECT SUM(order_profits)::numeric(10,2) total_profits,
    DATE_PART('month', order_date) AS month
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
WHERE DATE_PART('year', order_date) = 2018
GROUP BY 2
ORDER BY 2;
-- Q13.	Which order was the highest in 2015?
SELECT o.order_id, quantity, order_profits
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
WHERE DATE_PART('year', order_date) = 2015
ORDER BY 2 DESC;
-- Q14.	What was the rank of each city in the East region in 2015?
SELECT SUM(quantity) order_count, shipping_city
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
WHERE DATE_PART('year', order_date) = 2015
AND shipping_region = 'East'
GROUP BY 2
ORDER BY 1 DESC;
-- Q15.	Display customer names for customers who are in the segment ‘Consumer’ or ‘Corporate.’ How many customers are there in total?
SELECT customer_name, customer_segment
FROM customers
WHERE customer_segment = 'Consumer' 
    OR customer_segment = 'Corporate' 
-- Q16.	Calculate the difference between the largest and smallest order quantities for product id ‘100.’
SELECT MAX(quantity) - MIN(quantity) difference
FROM order_details
WHERE product_id = '100'
-- Q17.	Calculate the percent of products that are within the category ‘Furniture.’ 
SELECT ((
    SELECT COUNT(product_id)
    FROM product 
    WHERE product_category = 'Furniture'
    ) * 100.0 / COUNT(product_id))::numeric(10,2) AS percentage
FROM product
-- Q18.	Display the number of duplicate products based on their product manufacturer. Example: A product with an identical product manufacturer can be considered a duplicate.
SELECT COUNT(*), product_manufacturer
FROM product
GROUP BY 2;
-- Q19.	Show the product_subcategory and the total number of products in the subcategory. Show the order from most to least products and then by product_subcategory name ascending.
SELECT product_subcategory, COUNT(product_subcategory) total_product_count
FROM product
group by 1
ORDER BY 2 DESC, 1;
-- Q20.	Show the product_id(s), the sum of quantities, where the total sum of its product quantities is greater than or equal to 100.
SELECT product_id, quantity
FROM order_details 
WHERE quantity >= 100
-- Q21.	Join all database tables into one dataset that includes all unique columns and download it as a .csv file.
SELECT *
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN product p
ON od.product_id = p.product_id;
