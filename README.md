# Online Grocery DB Design

This repository contains the design and development of a database for an online grocery business, reorganized from spreadsheet data. The goal is to support the business's expansion by providing an efficient and scalable database structure.

## Overview

This repository contains the design and development of a database for an online grocery business, reorganized from spreadsheet data. The goal is to support the business's expansion by providing an efficient and scalable database structure.

## Project Scenario

The online grocery business is growing rapidly, and there is a need to transition from spreadsheet-based data management to a robust database system. The database will manage products, inventory, sales, and vendor information, facilitating efficient business operations and data-driven decision-making.

## EER Diagram

![EER Diagram](diagrams/EER_diagram.png)

The EER diagram provides a visual representation of the database structure, showcasing the relationships between different entities such as products, inventory, sales, vendors, and customers.

## Repository Structure

```plaintext
online-grocery-db-design/
├── datasets/
│   └── GreenspotDataset.csv     # Dataset
├── diagrams/
│   └── EER_diagram.png          # EER (Entity-Relationship) diagram
├── sql/
│   ├── ddl/
│   │   └── create_tables.sql    # SQL script to create database tables
│   ├── dml/
│   │   └── insert_data.sql      # SQL script to insert data into tables
│   └── queries/
│       ├── inventory_queries.sql     # SQL queries related to inventory management
│       ├── sales_queries.sql         # SQL queries related to sales analysis
│       └── vendor_queries.sql        # SQL queries related to vendor analysis
└── visualizations/
    ├── inventory_trends.png     # Graph showing inventory trends
    ├── sales_figures.png        # Graph showing sales figures
    └── vendor_performance.png   # Graph showing vendor performance
```

## SQL Scripts

### Create Database and Tables

```sql
-- Create the database
CREATE DATABASE OnlineGroceryDB;

-- Use the database
USE OnlineGroceryDB;

-- Create the Items table
CREATE TABLE Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    item_type VARCHAR(50) NOT NULL,
    unit VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL
);

-- Create the Vendors table
CREATE TABLE Vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_name VARCHAR(255) NOT NULL,
    vendor_address VARCHAR(255) NOT NULL DEFAULT 'Unknown Address'
);

-- Create the Inventory table
CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    quantity_on_hand INT NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    purchase_date DATE NOT NULL,
    vendor_id INT,
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Create the Customers table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255) NOT NULL DEFAULT 'Unknown Contact'
);

-- Create the Sales table
CREATE TABLE Sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT,
    date_sold DATE NOT NULL,
    customer_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
```

### Insert Data into Tables

To populate the tables, we first import the CSV data into a temporary table, and then transfer the data to the normalized tables.

```sql 
-- Create a temporary table to load CSV data
CREATE TABLE TemporaryTable (
    item_num VARCHAR(255),
    description VARCHAR(255),
    quantity_on_hand INT,
    cost DECIMAL(10, 2),
    purchase_date DATE,
    vendor VARCHAR(255),
    price DECIMAL(10, 2),
    date_sold DATE,
    cust VARCHAR(255),
    quantity INT,
    item_type VARCHAR(50),
    location VARCHAR(50),
    unit VARCHAR(50)
);

-- Import CSV data into the TemporaryTable using MySQL Workbench's Data Import Wizard

-- Insert data into Items table
INSERT INTO Items (description, item_type, unit, location)
SELECT DISTINCT description, item_type, unit, location
FROM TemporaryTable;

-- Insert data into Vendors table
INSERT INTO Vendors (vendor_name, vendor_address)
SELECT DISTINCT vendor, 'Unknown Address'
FROM TemporaryTable;

-- Insert data into Inventory table
INSERT INTO Inventory (item_id, quantity_on_hand, cost, purchase_date, vendor_id)
SELECT i.item_id, t.quantity_on_hand, t.cost, t.purchase_date, v.vendor_id
FROM TemporaryTable t
JOIN Items i ON t.description = i.description
JOIN Vendors v ON t.vendor = v.vendor_name;

-- Insert data into Customers table
INSERT INTO Customers (customer_name, contact_info)
SELECT DISTINCT cust, 'Unknown Contact'
FROM TemporaryTable;

-- Insert data into Sales table
INSERT INTO Sales (item_id, date_sold, customer_id, quantity, price)
SELECT i.item_id, t.date_sold, c.customer_id, t.quantity, t.price
FROM TemporaryTable t
JOIN Items i ON t.description = i.description
JOIN Customers c ON t.cust = c.customer_name;
```

After populating the normalized tables, you can optionally drop the temporary table:

```sql
DROP TABLE TemporaryTable;
```
