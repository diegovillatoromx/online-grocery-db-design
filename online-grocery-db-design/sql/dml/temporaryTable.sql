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
