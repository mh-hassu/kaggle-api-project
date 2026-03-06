# Kaggle API Retail Orders Analytics Project

A data engineering project that demonstrates data extraction from Kaggle API, data transformation with Python/Pandas, and SQL-based analytics.

## Project Overview

This project downloads retail orders data from Kaggle, processes it using Python and Pandas, loads it into SQL Server, and performs various analytical queries to derive business insights.

## Dataset

The dataset used is **[Retail Orders](https://www.kaggle.com/datasets/ankitbansal06/retail-orders)** from Kaggle, containing retail order information including:
- Order details (ID, date, ship mode)
- Customer information (segment, location)
- Product information (category, sub-category, pricing)
- Financial metrics (cost price, list price, discount, profit)

## Project Structure

```
kaggle api project/
|   data _analytics.ipynb    # Jupyter notebook for data extraction and transformation
|   orders.csv                # Downloaded dataset
|   project sql code.sql      # SQL queries for data analysis
```

## Requirements

- Python 3.x
- Pandas
- Kaggle API (`pip install kaggle`)
- SQL Server
- SQLAlchemy
- ODBC Driver 17 for SQL Server

## Kaggle API Setup

1. Create a Kaggle account at https://www.kaggle.com
2. Go to Account settings > API > Create New API Token
3. Place the `kaggle.json` file in `~/.kaggle/` (Linux/Mac) or `C:\Users\<username>\.kaggle\` (Windows)

## Data Pipeline

### 1. Data Extraction
- Downloads orders dataset from Kaggle using the Kaggle API
- Extracts the zipped CSV file

### 2. Data Transformation
- Handles missing values (`Not Available`, `unknown`)
- Standardizes column names (lowercase, underscores)
- Calculates derived metrics:
  - `discount` = list_price × discount_percent × 0.01
  - `sale_price` = list_price - discount
  - `profit` = sale_price - cost_price
- Converts date columns to proper datetime format
- Removes unnecessary columns

### 3. Data Loading
- Loads transformed data into SQL Server using SQLAlchemy

## SQL Analytics

The project includes three levels of SQL queries:

### Basic Queries
- Total sales and profit per region
- Top 5 most profitable products
- Total quantity sold per category
- Average discount per sub-category
- Number of orders per ship mode

### Intermediate Queries
- Monthly sales trend for 2023
- Top 3 states with highest revenue
- Profit margin per category
- City with highest average order value
- Percentage contribution of each category to total sales

### Advanced Queries
- Month-over-month growth comparison (2022 vs 2023)
- Top 3 products with highest YoY quantity increase
- Sub-category with highest discount impact
- Region-wise top selling sub-category per quarter
- Segment contributing most profit in each region
- Top 10 highest revenue generating products
- Top 5 highest selling products in each region
- Category-wise highest sales month identification
- Sub-category with highest profit growth (2023 vs 2022)

## Key Findings

The analysis reveals insights such as:
- Regional sales performance and profitability
- Top-performing products and categories
- Seasonal trends and growth patterns
- Customer segment profitability by region
- Impact of discounts on sales

## Usage

1. Configure Kaggle API credentials
2. Update SQL Server connection string in the notebook
3. Run the Jupyter notebook cells sequentially
4. Execute SQL queries in SQL Server Management Studio or your preferred SQL client

## License

The dataset is licensed under CC0-1.0 (Creative Commons Zero).