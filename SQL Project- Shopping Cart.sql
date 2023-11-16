USE shopping_cart;

-- Data Exploration: (i) Customer Table

SELECT * FROM customers LIMIT 10;

-- Total number of customers:
SELECT COUNT(customer_id) AS total_customers 
FROM customers;

-- Average age of customers:
SELECT ROUND(AVG(age)) AS average_age 
FROM customers; 

-- Top 10 ages of customers:
SELECT age, 
COUNT(*) AS number_of_customers 
FROM customers 
GROUP BY age ORDER BY number_of_customers DESC 
LIMIT 10;

-- State with maximum customers:
SELECT state, 
COUNT(*) AS number_of_customers 
FROM customers 
GROUP BY state ORDER BY number_of_customers DESC 
LIMIT 1;

-- Top 10 cities with maximum customers:
SELECT city, 
COUNT(*) AS number_of_customers FROM customers 
GROUP BY city ORDER BY number_of_customers DESC 
LIMIT 10; 

-- Top 10 states with maximum customers:
SELECT state, 
COUNT(*) AS number_of_customers FROM customers 
GROUP BY state ORDER BY number_of_customers DESC 
LIMIT 10;

-- Different gender groups from which the customers are from:
SELECT DISTINCT gender 
FROM customers; 

-- Total number of customers from each gender group:
SELECT gender, 
COUNT(*) AS number_of_customers 
FROM customers 
GROUP BY gender; 

-- Data Exploration: (ii) Orders Table

SELECT * FROM orders LIMIT 10; 

-- Total number of orders:
SELECT COUNT(order_id) AS total_orders 
FROM orders;

-- Customer with maximum orders:
SELECT customer_id, 
COUNT(*) AS order_count 
FROM orders 
GROUP BY customer_id ORDER BY order_count DESC 
LIMIT 1;

-- Details of orders by the customer with maximum orders:
SELECT * FROM orders 
WHERE customer_id = 571; 

-- Total payment made by the customer with maximum orders:
SELECT SUM(payment) 
FROM orders 
WHERE customer_id= 571; 

-- Complete details of customers with top 10 orders:
SELECT customers.customer_id, customers.customer_name, customers.gender, customers.age, customers.home_address, customers.zip_code, customers.city, customers.state, customers.country
FROM(
SELECT customer_id 
FROM orders
GROUP BY customer_id
ORDER BY COUNT(*) DESC
LIMIT 10
) AS top_10_customers
JOIN customers ON top_10_customers.customer_id = customers.customer_id;

-- Month with maximum orders:
SELECT MONTH(order_date) AS order_month, 
COUNT(*) AS order_count 
from orders 
GROUP BY order_month ORDER BY order_count DESC 
LIMIT 1;

-- Month with least orders:
SELECT MONTH(order_date) AS order_month, 
COUNT(*) AS order_count 
from orders 
GROUP BY order_month ORDER BY order_count ASC 
LIMIT 1;

-- Average orders made:
SELECT AVG(order_count) AS avg_orders 
FROM (SELECT COUNT(*) AS order_count 
FROM orders 
WHERE YEAR(order_date) = 2021 
GROUP BY MONTH(order_date)) AS monthly_order_counts; 

-- Finding the number of days taken to deliver each order:
ALTER TABLE orders 
ADD COLUMN days_taken_for_delivery INT;
SET SQL_SAFE_UPDATES = 0;
UPDATE orders 
SET days_taken_for_delivery = DATEDIFF(delivery_date, order_date) 
WHERE delivery_date IS NOT NULL AND order_date IS NOT NULL;

-- Finding the average number of days taken for delivery:
SELECT ROUND(AVG(days_taken_for_delivery)) AS avg_number_of_days 
FROM orders; 

-- Total of payments made in each month:
SELECT MONTH(order_date) AS order_month, 
SUM(payment) AS total_payment 
FROM orders 
GROUP BY order_month ORDER BY order_month;

-- Month with largest payment:
SELECT MONTH(order_date) AS order_month, 
SUM(payment) AS total_payment 
FROM orders GROUP BY order_month ORDER BY total_payment DESC 
LIMIT 1;

-- Data Exploration: (iii) Products Table

SELECT * FROM products LIMIT 10;

-- Types of products:
SELECT DISTINCT(product_type) 
FROM products; 

-- Different products under each product type:
SELECT DISTINCT product_name 
FROM products 
WHERE product_type = "shirt";
SELECT DISTINCT product_name 
FROM products 
WHERE product_type = "jacket";
SELECT DISTINCT product_name 
FROM products 
WHERE product_type = "trousers";

-- Product with highest price:
SELECT product_name, price 
FROM products 
ORDER BY price DESC 
LIMIT 1;

-- Product with least price:
SELECT product_name, price 
FROM products ORDER BY price ASC 
LIMIT 1;

-- Highest sold product:
SELECT product_name, quantity 
FROM products ORDER BY quantity DESC 
LIMIT 1;

-- Least sold product:
SELECT product_name, quantity 
FROM products 
ORDER BY quantity ASC 
LIMIT 1;

-- Sales details of products:
SELECT products.product_ID, products.product_type, products.product_name, sales.quantity, sales.total_price, sales.sales_id
FROM 
sales
JOIN
products
ON
sales.product_id = products.product_id;

-- Data Exploration: (iv) Sales Table

SELECT * FROM sales LIMIT 10;

-- Total number of sales:
SELECT SUM(sales_id) AS total_sales 
FROM sales;

-- Total revenue generated:
 SELECT SUM(total_price) AS total_revenue 
 FROM sales;
 
  -- Highest revenue generating products:
 SELECT SUM(total_price) AS total_price, product_ID 
 FROM sales 
 GROUP BY product_id ORDER BY total_price DESC 
 LIMIT 10;

-- Lowest revenue generating products:
SELECT SUM(total_price) AS total_price, product_ID 
FROM sales 
GROUP BY product_id ORDER BY total_price ASC 
LIMIT 10;

-- Details of most expensive product:
SELECT
    sales.sales_id, sales.order_id, sales.product_id, sales.price_per_unit, sales.quantity, sales.total_price,
    products.product_name, products.product_type
FROM
    sales
JOIN
    products
ON
    sales.product_id = products.product_ID
WHERE
    sales.product_id = (
        SELECT product_id
        FROM sales
        GROUP BY product_id
        ORDER BY SUM(total_price) DESC
        LIMIT 1
)
LIMIT 1;