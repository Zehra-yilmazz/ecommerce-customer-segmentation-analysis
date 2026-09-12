#Create Database

CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;

#Create Tables

#orders table

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

#Customer table

CREATE TABLE customers (
customer_id VARCHAR(50) PRIMARY KEY,
customer_unique_id VARCHAR(50),
customer_zip_code_prefix VARCHAR(10),
customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);


#order_items table

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

#Note: Composite Key & Foreign Key

#Composite Key: One order can have multiple products, so order_id alone repeats 
#across rows in order_items (not unique). Combining order_id + order_item_id
# together creates a unique pair for each row — this combination is called 
#a composite key.

#Foreign Key: FOREIGN KEY (order_id) REFERENCES orders(order_id) ensures every 
#order_id in order_items actually exists in the orders table.
# This prevents inserting items linked to a non-existent order, keeping data
# consistent .

# order_payments table

CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

#Note: Composite Key in order_payments
#Similar reasoning applies here — a single order can have multiple payment records 
#(e.g., a customer splitting payment between a credit card and a voucher,
# or paying in installments). This means order_id alone repeats across 
 #rows and isn't unique.

#products table

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

#product_category_name_translation table

CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);




#This loads the orders CSV file into the orders table, but handles a specific
# problem: some date columns in the CSV are empty (not delivered yet), 
#and MySQL's DATETIME type can't accept an empty string '' —
# it needs either a valid date or NULL.

#How it solves this:

#Column list with @variables:

#Instead of loading the date columns directly into the table, MySQL first reads
 #them into temporary variables (marked with @). order_id, customer_id, 
 #order_status load normally since they don't have this problem.

#The SET clause:
#NULLIF(value, '') checks: "if this value equals an empty string,
#replace it with NULL — otherwise keep it as is." This runs for each date column, 
#then the cleaned result gets written into the actual table column.



LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv"
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, @order_purchase_timestamp, @order_approved_at, @order_delivered_carrier_date, @order_delivered_customer_date, @order_estimated_delivery_date)
SET
    order_purchase_timestamp = NULLIF(@order_purchase_timestamp, ''),
    order_approved_at = NULLIF(@order_approved_at, ''),
    order_delivered_carrier_date = NULLIF(@order_delivered_carrier_date, ''),
    order_delivered_customer_date = NULLIF(@order_delivered_customer_date, ''),
    order_estimated_delivery_date = NULLIF(@order_estimated_delivery_date, '');
   
   #row  count
    SELECT COUNT(*) FROM orders;
    
#Load order_items

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


#Load customers

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Load order_payments

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv"
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE olist_customers_dataset;
DROP TABLE olist_order_items_dataset;

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category_name, @product_name_lenght, @product_description_lenght, @product_photos_qty, @product_weight_g, @product_length_cm, @product_height_cm, @product_width_cm)
SET
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');
    
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv"
INTO TABLE product_category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



















