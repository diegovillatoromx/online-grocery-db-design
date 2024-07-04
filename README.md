# Online Grocery DB Design 

This repository contains the design and development of a database for an online grocery business, reorganized from spreadsheet data. The goal is to support the business's expansion by providing an efficient and scalable database structure.    
 
## Overview 

This repository contains the design and development of a database for an online grocery business, reorganized from spreadsheet data. The goal is to support the business's expansion by providing an efficient and scalable database structure.  

## Project Scenario 

The online grocery business is growing rapidly, and there is a need to transition from spreadsheet-based data management to a robust database system. The database will manage products, inventory, sales, and vendor information, facilitating efficient business operations and data-driven decision-making.

## EER Diagram

![EER Diagram](https://github.com/diegovillatoromx/online-grocery-db-design/blob/main/online-grocery-db-design/diagrams/EER.png)

The EER diagram provides a visual representation of the database structure, showcasing the relationships between different entities such as products, inventory, sales, vendors, and customers.

## Repository Structure

```plaintext
online-grocery-db-design/
├── datasets/
│   └── GreenspotDataset.csv          # Dataset
├── diagrams/
│   └── EER_diagram.png               # EER (Entity-Relationship) diagram
├── sql/
│   ├── ddl/
│   │   └── create_tables.sql         # SQL script to create database tables
│   ├── dml/
│       ├── temporaryTable.sql        # Create Temporary Table
│       ├── insert_data.sql           # Populate Tables 
│       └── droptemporaryTable.sql    # Drop Temporary Table
│   └── queries/
│       ├── inventory_queries.sql     # SQL queries related to inventory management
│       ├── sales_queries.sql         # SQL queries related to sales analysis
│       └── vendor_queries.sql        # SQL queries related to vendor analysis
└── visualizations/
    ├── inventory_trends.png          # Graph showing inventory trends
    ├── sales_figures.png             # Graph showing sales figures
    └── vendor_performance.png        # Graph showing vendor performance
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

## Queries in SQL

### Inventory Queries
```sql
-- inventory_queries.sql

-- 1. Current inventory of each item
SELECT 
    i.description AS ItemDescription,
    SUM(iv.quantity_on_hand) AS TotalQuantityOnHand
FROM 
    Inventory iv
JOIN 
    Items i ON iv.item_id = i.item_id
GROUP BY 
    i.description
ORDER BY 
    TotalQuantityOnHand DESC;

-- 2. Inventory by location
SELECT 
    i.location AS Location,
    i.description AS ItemDescription,
    SUM(iv.quantity_on_hand) AS TotalQuantityOnHand
FROM 
    Inventory iv
JOIN 
    Items i ON iv.item_id = i.item_id
GROUP BY 
    i.location, i.description
ORDER BY 
    i.location, TotalQuantityOnHand DESC;
```
####  Explanation:

1. Current inventory of each item:

* **Objective**: To determine the total inventory quantity for each item.
* **Description**: This query calculates the total quantity of each item available in the inventory. It joins the `Inventory` table with the `Items` table on `item_id`, groups the results by the item description, and sorts them in descending order of total quantity on hand.

2. Inventory by location:

* **Objective**: To understand the distribution of inventory across different locations.
* **Description**: This query provides a detailed view of the current inventory of each item by location. It joins the `Inventory` table with the `Items` table on `item_id`, groups the results by both location and item description, and orders them first by location and then by the total quantity on hand in descending order.

### Sales Queries

```sql
-- sales_queries.sql

-- 1. Best-selling items
SELECT 
    i.description AS ItemDescription,
    SUM(s.quantity) AS TotalSold
FROM 
    Sales s
JOIN 
    Items i ON s.item_id = i.item_id
GROUP BY 
    i.description
ORDER BY 
    TotalSold DESC;

-- 2. Total revenue generated by each item
SELECT 
    i.description AS ItemDescription,
    SUM(s.quantity * s.price) AS TotalRevenue
FROM 
    Sales s
JOIN 
    Items i ON s.item_id = i.item_id
GROUP BY 
    i.description
ORDER BY 
    TotalRevenue DESC;

-- 3. Customers with the most purchases
SELECT 
    c.customer_name AS CustomerName,
    COUNT(s.sale_id) AS NumberOfPurchases
FROM 
    Sales s
JOIN 
    Customers c ON s.customer_id = c.customer_id
GROUP BY 
    c.customer_name
ORDER BY 
    NumberOfPurchases DESC;

-- 4. Items not sold in the last 6 months
SELECT 
    i.description AS ItemDescription
FROM 
    Items i
LEFT JOIN 
    Sales s ON i.item_id = s.item_id AND s.date_sold >= CURDATE() - INTERVAL 6 MONTH
WHERE 
    s.sale_id IS NULL;
```

#### Explanation:

1. Best-selling items:

* **Objective**: To identify the top-selling items.
* **Description**: This query calculates the total quantity sold for each item. It joins the `Sales` table with the `Items` table on `item_id`, groups the results by item description, and orders them by the total quantity sold in descending order.

2. Total revenue generated by each item:

* **Objective**: To determine the revenue generated by each item.
* **Description**: This query calculates the total revenue generated by each item by multiplying the quantity sold by the sale price. It joins the `Sales` table with the `Items` table on `item_id`, groups the results by item description, and orders them by total revenue in descending order.

3. Customers with the most purchases:

* **Objective**: To identify the customers with the highest number of purchases.
* **Description**: This query counts the number of sales transactions for each customer. It joins the `Sales` table with the `Customers` table on `customer_id`, groups the results by customer name, and orders them by the number of purchases in descending order.

4. Items not sold in the last 6 months:

* **Objective**: To find items that have not been sold in the last 6 months.
* **Description**: This query identifies items that have not had any sales in the past six months. It uses a left join between the `Items` and `Sales` tables on `item_id`, with an additional condition to only include sales within the last six months. Items with no matching sales records in this period are selected.


### Vendors Queries

```sql
-- vendor_queries.sql

-- 1. Total inventory cost per vendor
SELECT 
    v.vendor_name AS VendorName,
    SUM(iv.cost * iv.quantity_on_hand) AS TotalInventoryCost
FROM 
    Inventory iv
JOIN 
    Vendors v ON iv.vendor_id = v.vendor_id
GROUP BY 
    v.vendor_name
ORDER BY 
    TotalInventoryCost DESC;
```

#### Explanation:

1. Total inventory cost per vendor:
* **Objective**: To calculate the total inventory cost associated with each vendor.
* ***Description**: This query sums the total cost of inventory supplied by each vendor by multiplying the cost by the quantity on hand for each item. It joins the `Inventory` table with the `Vendors` table on `vendor_id`, groups the results by vendor name, and orders them by total inventory cost in descending order.
