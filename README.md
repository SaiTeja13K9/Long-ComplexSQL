# Long-ComplexSQL
Solving Long and Complex SQL Queries Using CTEs for Real-World Reports

This project demonstrates how to write clean, modular, and complex SQL queries to answer real-world business questions using structured employee and salary history data. It walks through the process of creating the schema, loading sample data, and executing multi-step queries with Common Table Expressions (CTEs), window functions, conditional aggregations, and ranking logic.

---

## 🗂️ Table of Contents

- [Project Overview](#project-overview)
- [Schema Setup](#schema-setup)
- [Business Questions Solved](#business-questions-solved)
- [Technologies Used](#technologies-used)
- [Sample Output](#sample-output)
- [How to Run](#how-to-run)
- [Files Included](#files-included)

---

## 🧠 Project Overview

This project showcases:
- Use of **CTEs** for modular logic
- Calculation of metrics like **latest salary**, **promotion count**, **maximum salary hike**, **average time between salary hikes**, and **salary growth ranking**
- Application of **LEAD/LAG**, **ROW_NUMBER()**, **conditional aggregation**, and **ranking functions**
- Best practices for building **readable**, **reusable**, and **efficient** SQL for analytics reporting

---

## 🏗️ Schema Setup

Two tables are used:

1. **employees**
   - `employee_id`: INT (Primary Key)
   - `name`: VARCHAR
   - `join_date`: DATE
   - `department`: VARCHAR

2. **salary_history**
   - `employee_id`: INT (Foreign Key)
   - `change_date`: DATE
   - `salary`: DECIMAL
   - `promotion`: VARCHAR(3) — values: `'Yes'` or `'No'`

> Sample data includes 6 employees across departments, with varying salary changes and promotions over time.

---

## ❓ Business Questions Solved

| Q# | Business Question |
|----|-------------------|
| 1  | What is the **latest salary** for each employee? |
| 2  | How many **promotions** has each employee received? |
| 3  | What is the **maximum salary hike percentage** between any two consecutive changes per employee? |
| 4  | Which employees' salary has **never decreased** over time? |
| 5  | What is the **average time (in months)** between salary changes for each employee? |
| 6  | Rank employees by their **total salary growth rate** (from first to last recorded salary), breaking ties by **earliest join date** |

---

## 🛠️ Technologies Used

- SQL Server (T-SQL)
- SQL window functions (`ROW_NUMBER`, `RANK`, `LEAD`, `LAG`)
- Aggregates (`MAX`, `SUM`, `AVG`)
- Conditional logic (`CASE WHEN`)
- CTEs for progressive transformations

---

## 🖥️ Sample Output Fields

| Field Name                    | Description                                       |
|------------------------------|---------------------------------------------------|
| `employee_id`                | Unique employee identifier                        |
| `name`                       | Employee name                                     |
| `latest_salary`              | Most recent salary                                |
| `no_of_promotions`           | Total promotions received                         |
| `max_salary_growth`          | Maximum salary hike % between changes             |
| `never_decreased`            | Y/N flag for salary never decreasing              |
| `avg_months_between_changes` | Avg months between salary changes                 |
| `rank_by_growth`             | Rank by overall salary growth rate (highest first)|

---

## ▶️ How to Run

1. Run `Long_and_complex_DDL.sql` to create the database schema and populate data.
2. Execute `Long_and_complex_QAs.sql` or `Long_and_complex_QAs - Optimized.sql` to generate insights and reports.
3. Results will show a consolidated report with employee performance metrics.

---

## 📁 Files Included

| File Name                          | Description                                      |
|-----------------------------------|--------------------------------------------------|
| `Long_and_complex_DDL.sql`        | Creates `employees` and `salary_history` tables with sample data |
| `Long_and_complex_QAs.sql`        | Step-by-step query solving all 6 business questions |
| `Long_and_complex_QAs - Optimized.sql` | Streamlined version combining all logic for performance |

---

## 🙌 Credits

Built to demonstrate real-world SQL reporting and analytics using CTEs, window functions, and structured logic.

---
