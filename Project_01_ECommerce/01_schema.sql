-- 01_schema.sql: Creating the schema for the e-commerce database.
DROP TABLE IF EXISTS store_financials CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(50),  
    country VARCHAR(100),
    joined_date DATE
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    department VARCHAR(100),
    salary DECIMAL(10,2),
    manager_id INT REFERENCES employees(employee_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(100),
    cost_price DECIMAL(10,2), 
    retail_price DECIMAL(10,2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    employee_id INT REFERENCES employees(employee_id), 
    order_date DATE,
    order_status VARCHAR(50)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price DECIMAL(10,2)
);

CREATE TABLE store_financials (
    financial_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_type VARCHAR(100), 
    amount DECIMAL(10,2),
    description TEXT
);