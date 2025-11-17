# Dataset Information

## 💾 Data Source

This project uses pizza sales data containing transactional information from a pizza restaurant. The dataset includes:

- **Orders**: Date and time of each order
- **Pizza Types**: Menu items with categories and ingredients
- **Pizzas**: SKU-level data with sizes and pricing
- **Order Details**: Line items showing quantity ordered

---

## 📂 Dataset Files

The dataset should contain the following CSV files:

1. **orders.csv**
   - Columns: `order_id`, `date`, `time`
   - Description: Contains order-level information

2. **pizza_types.csv**
   - Columns: `pizza_type_id`, `name`, `category`, `ingredients`
   - Description: Master data for pizza types

3. **pizzas.csv**
   - Columns: `pizza_id`, `pizza_type_id`, `size`, `price`
   - Description: Pizza variants with pricing

4. **order_details.csv**
   - Columns: `order_details_id`, `order_id`, `pizza_id`, `quantity`
   - Description: Order line items

---

## 📥 How to Import Data

### Method 1: Using MySQL Workbench

1. Open MySQL Workbench and connect to your server
2. Create the database using the schema file: `schema/database_schema.sql`
3. Right-click on each table → **Table Data Import Wizard**
4. Select the corresponding CSV file
5. Map columns and import

### Method 2: Using MySQL Command Line

```sql
-- For orders table
LOAD DATA INFILE 'path/to/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Repeat for other tables: pizza_types, pizzas, order_details
```

### Method 3: Using Python (pandas)

```python
import pandas as pd
import mysql.connector

# Read CSV
df = pd.read_csv('orders.csv')

# Connect to MySQL
conn = mysql.connector.connect(
    host='localhost',
    user='your_username',
    password='your_password',
    database='pizza_sales'
)

# Import to table
df.to_sql('orders', conn, if_exists='append', index=False)
```

---

## ✅ Data Validation

After importing, verify the data:

```sql
-- Check record counts
SELECT 'orders' AS table_name, COUNT(*) AS record_count FROM orders
UNION ALL
SELECT 'pizza_types', COUNT(*) FROM pizza_types
UNION ALL
SELECT 'pizzas', COUNT(*) FROM pizzas
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details;

-- Verify relationships
SELECT COUNT(*) AS orphan_records
FROM order_details od
LEFT JOIN orders o ON od.order_id = o.order_id
WHERE o.order_id IS NULL;
```

---

## 📊 Dataset Statistics

- **Time Period**: [Specify the date range of your data]
- **Total Orders**: [Number of unique orders]
- **Total Products**: [Number of pizza SKUs]
- **Categories**: Classic, Veggie, Supreme, Chicken (example)

---

## 📝 Notes

- Ensure CSV files use UTF-8 encoding
- Date format should be YYYY-MM-DD
- Time format should be HH:MM:SS
- Price values should be decimal format (e.g., 12.50)
- Check for NULL values and duplicates before importing

---

## 🔒 Data Privacy

This dataset is used for educational and portfolio purposes. No personally identifiable information (PII) is included.

---

*For questions about the data, please open an issue in this repository.*