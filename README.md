# Food-Delivery-KPI-Analysis
# Food Delivery KPI Analysis (SQL Server)

An end-to-end SQL project that analyses a food delivery platform. It covers database design, sample data, and **25 business KPIs** written in T-SQL.

**Tools:** SQL Server, SQL Server Management Studio (SSMS)

---

## Business Problem

A food delivery company wants to understand how its business is performing. The questions it needs answered:

- How much revenue are we earning, and from which restaurants, cuisines and cities?
- How fast are deliveries, and how often are orders delayed or cancelled?
- When do customers order, and who are our best customers?

This project answers those questions using SQL only.

---


| Table | Description | Key columns |
|-------|-------------|-------------|
| `customers` | People who place orders | customer_id, customer_name, city, signup_date |
| `restaurants` | Restaurants on the platform | restaurant_id, restaurant_name, cuisine, city, rating |
| `delivery_partners` | Riders who deliver orders | partner_id, partner_name, vehicle_type |
| `orders` | One row per order | order_id, customer_id, restaurant_id, partner_id, order_date, delivery_time_minutes, order_amount, order_status |

`orders` links to the other three tables through foreign keys. Order status is one of `Delivered`, `Delayed` or `Cancelled`.

---

## Project Structure

| File | Purpose |
|------|---------|
| `SQLQuery1 (Schema)` | Creates the database and tables |
| `SQLQuery1 (Insert Data)` | Loads customers, restaurants, delivery partners and the first 5 orders |
| `SQLQuery1 (KPI Queries)` | All 25 KPI queries |

---

## How to Run

1. Open **SQL Server Management Studio** and connect to your server.
2. Open and execute the files in this order (press **F5**):
   1. `01_schema.sql`
   2. `02_insert_data.sql`
   3. `03_more_orders.sql`
   4. `04_kpi_queries.sql`
3. In `04_kpi_queries.sql`, highlight one query at a time and press **F5** to see its result.

To start over, run `01_schema.sql` again. It drops and recreates the tables, then reload files 02 and 03.

---

## KPIs Covered

**Business & Financial**
1. Total orders
2. Total revenue
3. Average order value (AOV)
4. Revenue by restaurant
5. Revenue by city
6. Top restaurants by orders and revenue
7. Highest revenue cuisine
8. Daily and monthly revenue trend
9. Restaurant market share

**Operational & Delivery Efficiency**

10. Average delivery time
11. On-time delivery rate
12. Delayed delivery rate
13. Cancellation rate
14. Delivery time by city
15. Delivery time by cuisine
16. Delivery partner performance
17. Average orders per delivery partner

**Time & Behavioural Patterns**

18. Orders by hour
19. Peak ordering hour
20. Orders and revenue by day of week

**Customer & Quality Analytics**

21. Top customers by spending
22. Customer retention rate
23. Repeat customer count
24. Customer lifetime value
25. Average restaurant rating

---

## Key Findings

Based on the sample data (45 orders):

- **Revenue:** 30,890 from completed orders, with an average order value of 792.05.
- **Restaurant concentration:** Sushi World earns about 48% of all revenue, almost as much as the other three restaurants combined.
- **Delivery quality:** 60% of orders were delivered on time, 26.7% were delayed and 13.3% were cancelled.
- **Slowest vehicle:** Bicycle deliveries average about 46 minutes, compared to about 36 minutes for bikes.
- **Peak demand:** 1 PM is the busiest hour of the day.
- **Customer value:** One customer (Rohan) accounts for about 38% of total revenue.

**Recommendations:** reduce delays on bicycle routes, and look at why the cancellation rate is so high.

---

## Assumptions

- **Completed orders** means every order that is not `Cancelled` (`Delivered` or `Delayed`). Revenue and AOV use completed orders only.
- **City** means the customer's city, where the order was delivered.
- On-time, delayed and cancellation rates are calculated against all orders, so they add up to 100%.
- Cancelled orders have no delivery time (`NULL`), so they are ignored in delivery time averages.

## Limitations

- The data is small and made up for practice, so results show the method rather than real business performance.
- Ratings are a single stored value per restaurant, not individual customer reviews.

---

## SQL Concepts Used

`SELECT` · `WHERE` · `ORDER BY` · `TOP` · `JOIN` · `GROUP BY` · `HAVING` · aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) · subqueries · `CASE` · date functions (`YEAR`, `MONTH`, `DATEPART`, `DATENAME`, `CAST`)

---

## Author

**Likhitha Tervati**
LinkedIn: https://www.linkedin.com/in/likhitha-tervati-7383a7294/
GitHub: add your link here
