-- Food Delivery KPI Project: table creation (SQL Server / T-SQL)
IF DB_ID('food_delivery_db') IS NULL
    CREATE DATABASE food_delivery_db;
GO

USE food_delivery_db;
GO

-- Drop tables (child tables first) so this script can be re-run safely
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS delivery_partners;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS customers;
GO

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(100),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    rating DECIMAL(3,2)
);

CREATE TABLE delivery_partners (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(100),
    vehicle_type VARCHAR(30)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    partner_id INT,
    order_date DATETIME2,
    delivery_time_minutes INT,
    order_amount DECIMAL(10,2),
    order_status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id),
    FOREIGN KEY (partner_id) REFERENCES delivery_partners(partner_id)
);
GO
