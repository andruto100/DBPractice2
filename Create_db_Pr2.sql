CREATE DATABASE IF NOT EXISTS my_opt_db;
USE my_opt_db;

CREATE TABLE IF NOT EXISTS my_clients (
    client_id CHAR(36) PRIMARY KEY,  
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    status ENUM('active', 'inactive') NOT NULL  
);

CREATE TABLE IF NOT EXISTS my_products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category ENUM('Electronics', 'Apparel', 'Home', 'Sports', 'Beauty') NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS my_orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    client_id CHAR(36),
    product_id INT,
    FOREIGN KEY (client_id) REFERENCES my_clients(client_id),
    FOREIGN KEY (product_id) REFERENCES my_products(product_id)
);
