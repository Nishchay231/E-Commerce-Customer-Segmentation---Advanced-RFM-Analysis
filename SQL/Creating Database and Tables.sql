CREATE DATABASE olist_ecommerce;
USE olist_ecommerce;

select * from customers;

select * from order_items;

select * from orders;

select * from order_payments;

describe orders;

-- Altering the order_delivered column of the orders table to DATETIME
ALTER TABLE orders MODIFY order_delivered_carrier_date DATETIME ;