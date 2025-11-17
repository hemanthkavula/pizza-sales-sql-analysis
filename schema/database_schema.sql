-- ====================================================================
-- PIZZA SALES DATABASE SCHEMA
-- ====================================================================
-- Database: pizza_sales
-- DBMS: MySQL
-- ====================================================================

CREATE DATABASE IF NOT EXISTS pizza_sales;
USE pizza_sales;

-- ====================================================================
-- TABLE 1: orders
-- Purpose: Stores order-level information
-- ====================================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    date DATE NOT NULL,
    time TIME NOT NULL
);

-- ====================================================================
-- TABLE 2: pizza_types
-- Purpose: Master table for pizza type information
-- ====================================================================
CREATE TABLE IF NOT EXISTS pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ingredients TEXT
);

-- ====================================================================
-- TABLE 3: pizzas
-- Purpose: Stores pizza variants with pricing information
-- ====================================================================
CREATE TABLE IF NOT EXISTS pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50) NOT NULL,
    size VARCHAR(10) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types(pizza_type_id)
);

-- ====================================================================
-- TABLE 4: order_details
-- Purpose: Stores order line items (many-to-many relationship)
-- ====================================================================
CREATE TABLE IF NOT EXISTS order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

-- ====================================================================
-- ENTITY RELATIONSHIP
-- ====================================================================
-- orders (1) ---< (M) order_details
-- pizza_types (1) ---< (M) pizzas
-- pizzas (1) ---< (M) order_details
--
-- This schema follows a normalized structure with:
-- - orders: Temporal and transactional data
-- - pizza_types: Master data for pizza categories
-- - pizzas: SKU-level data with pricing
-- - order_details: Transaction line items
-- ====================================================================