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
