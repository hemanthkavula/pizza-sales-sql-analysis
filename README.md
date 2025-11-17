# 🍕 Pizza Sales SQL Analysis

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Status](https://img.shields.io/badge/Status-Complete-success)
![License](https://img.shields.io/badge/License-MIT-green)

## 📊 Project Overview

This project demonstrates comprehensive SQL analysis of pizza sales data to uncover actionable business insights. Through advanced SQL techniques including **JOINs**, **Common Table Expressions (CTEs)**, **Window Functions**, and **Aggregate Functions**, the analysis explores customer behavior, revenue patterns, and operational efficiency.

**Key Business Questions Answered:**
- What drives revenue growth and which products contribute most?
- When are peak ordering hours and how can staffing be optimized?
- Which pizza types and categories perform best?
- How do sales trends evolve over time?

---

## 🎯 Key Highlights

✅ **14 Complex SQL Queries** covering data exploration, sales analysis, and advanced analytics  
✅ **Advanced SQL Techniques**: CTEs, Window Functions (SUM OVER, DENSE_RANK), Subqueries  
✅ **Real-World Business Scenarios**: Revenue analysis, customer behavior, operational insights  
✅ **Normalized Database Design** with proper relationships and constraints  
✅ **Clean, Well-Commented Code** following SQL best practices  

---

## 📁 Project Structure

```
pizza-sales-sql-analysis/
│
├── queries/
│   └── pizza_sales.sql          # All SQL queries organized by analysis type
│
├── schema/
│   └── database_schema.sql      # Database structure and table definitions
│
├── data/
│   └── README.md                # Data source information and setup instructions
│
└── README.md                     # Project documentation (you're here!)
```

---

## 🗄️ Database Schema

The database consists of **4 normalized tables**:

| Table | Description | Key Columns |
|-------|-------------|-------------|
| **orders** | Order-level information | order_id, date, time |
| **pizza_types** | Pizza master data | pizza_type_id, name, category, ingredients |
| **pizzas** | Pizza SKU with pricing | pizza_id, pizza_type_id, size, price |
| **order_details** | Order line items | order_details_id, order_id, pizza_id, quantity |

**Entity Relationships:**
- `orders` → `order_details` (1:M)
- `pizza_types` → `pizzas` (1:M)
- `pizzas` → `order_details` (1:M)

---

## 🔍 Analysis Categories

### 1️⃣ **Data Exploration**
- Total orders placed
- Total revenue generated
- Highest-priced pizza identification
- Most common pizza size ordered

### 2️⃣ **Sales Analysis**
- Top 5 most ordered pizza types by quantity
- Order distribution by hour of day (with percentage contribution)
- Top 3 revenue-generating pizza types

### 3️⃣ **Advanced Revenue Analytics**
- Percentage contribution of each pizza type to total revenue (using CTEs)
- Cumulative revenue trend analysis (using Window Functions)
- Top 3 pizza types per category based on revenue (using DENSE_RANK)

### 4️⃣ **Category-Wise Insights**
- Total quantity ordered per category
- Distribution of pizza offerings by category
- Average daily pizza orders

---

## 💡 Key Insights & Findings

Based on the SQL analysis, here are some sample insights (customize based on your actual data):

🔹 **Revenue Drivers**: Top pizza types contribute significant portion of total revenue  
🔹 **Peak Hours**: Orders peak during lunch and dinner hours, informing staffing decisions  
🔹 **Customer Preferences**: Large size pizzas account for majority of orders  
🔹 **Category Performance**: Classic category leads in both quantity and revenue  
🔹 **Growth Trends**: Cumulative revenue shows steady growth pattern  

---

## 🛠️ Technologies Used

- **Database**: MySQL 8.0
- **SQL Techniques**: 
  - Joins (INNER JOIN)
  - Aggregate Functions (SUM, COUNT, AVG, ROUND)
  - Common Table Expressions (CTEs)
  - Window Functions (SUM OVER, DENSE_RANK)
  - Subqueries
  - GROUP BY, ORDER BY, LIMIT

---

## 🚀 How to Use This Project

### Prerequisites
- MySQL Server 8.0 or higher
- MySQL Workbench (optional, for GUI)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/hemanthkavula/pizza-sales-sql-analysis.git
   cd pizza-sales-sql-analysis
   ```

2. **Create the database**
   ```sql
   -- Run the schema file
   source schema/database_schema.sql
   ```

3. **Import the data**
   - Download the dataset from the [data folder](./data/README.md)
   - Import CSV files into respective tables using MySQL Workbench or CLI

4. **Run the queries**
   ```sql
   -- Execute queries from the queries folder
   source queries/pizza_sales.sql
   ```

---

## 📈 Sample Queries

### Query Example 1: Top Revenue-Generating Pizzas
```sql
SELECT 
    pt.pizza_type_id, 
    pt.name, 
    SUM(quantity * price) AS revenue
FROM order_details AS o 
JOIN pizzas AS p ON o.pizza_id = p.pizza_id 
JOIN pizza_types AS pt ON pt.pizza_type_id = p.pizza_type_id 
GROUP BY p.pizza_type_id, pt.name 
ORDER BY revenue DESC 
LIMIT 3;
```

### Query Example 2: Cumulative Revenue Analysis
```sql
WITH revenue_time AS (
    SELECT 
        o.date, 
        SUM(od.quantity * p.price) AS revenue
    FROM order_details AS od 
    JOIN pizzas AS p ON od.pizza_id = p.pizza_id 
    JOIN orders AS o ON od.order_id = o.order_id 
    GROUP BY o.date
)
SELECT 
    date, 
    revenue,
    SUM(revenue) OVER (
        ORDER BY date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM revenue_time;
```

---

## 📚 What I Learned

Through this project, I developed and demonstrated:

✔️ **Advanced SQL Skills**: Mastery of CTEs, window functions, and complex joins  
✔️ **Analytical Thinking**: Translating business questions into SQL queries  
✔️ **Data Modeling**: Designing normalized database schemas  
✔️ **Problem Solving**: Optimizing queries for performance and readability  
✔️ **Documentation**: Writing clear, professional technical documentation  

---

## 🎓 Skills Demonstrated

| Category | Skills |
|----------|--------|
| **SQL** | SELECT, JOIN, GROUP BY, ORDER BY, LIMIT, WHERE |
| **Advanced SQL** | CTEs, Window Functions, Subqueries, CASE statements |
| **Functions** | SUM, COUNT, AVG, ROUND, HOUR, EXTRACT |
| **Analytics** | Revenue analysis, trend analysis, ranking, cumulative calculations |
| **Database Design** | Normalization, primary/foreign keys, relationships |

---

## 🔗 Connect With Me

- **Email**: hemanthkavula2001@gmail.com
- **GitHub**: [@hemanthkavula](https://github.com/hemanthkavula)
- **LinkedIn**: [Connect with me on LinkedIn]

---

## 📄 License

This project is licensed under the MIT License - feel free to use this code for your own learning and projects!

---

## 🙏 Acknowledgments

- **Dataset**: Pizza sales data used for educational and portfolio purposes
- **Inspiration**: Developed as part of SQL for Data Analysis learning journey
- **Tools**: MySQL, Git, GitHub

---

## 🌟 Future Enhancements

- [ ] Add data visualizations using Python (Matplotlib/Seaborn)
- [ ] Create interactive dashboard with Tableau/Power BI
- [ ] Implement stored procedures and views
- [ ] Add query performance optimization analysis
- [ ] Expand analysis to include customer segmentation

---

**⭐ If you found this project helpful, please consider giving it a star!**

---

*Last Updated: November 2025*