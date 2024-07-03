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
