# Air Cargo Analysis

## Problem Statement
Air Cargo, an aviation company, provides passenger and freight transportation services. The company wants to analyze regular passengers, busiest routes, ticket sales, and other operational data to improve customer experience, optimize aircraft allocation, and increase revenue.

## Objective
- Identify regular customers and provide targeted offers.  
- Analyze busiest routes to determine aircraft requirements.  
- Calculate ticket sales details and revenue per route/class.  
- Implement SQL database management with performance optimization.

## Tools & Technologies
- SQL (MySQL)  
- Database concepts: Views, Stored Procedures, Stored Functions, Indexing, Window Functions, Rollup  
- Dataset: `customer.csv`, `passengers_on_flights.csv`, `routes.csv`, `ticket_details.csv`  
- ER Diagram tools for database design  

## Key Tasks / Queries Implemented
1. Created ER diagram representing the airline database.  
2. Created tables with proper constraints and data types (route_details, customers, flights, tickets).  
3. Displayed passengers for routes 01–25.  
4. Calculated number of passengers and total revenue in business class.  
5. Extracted full names of customers.  
6. Identified customers who registered and booked tickets.  
7. Extracted customers by ID and airline brand.  
8. Analyzed Economy Plus class passengers using GROUP BY and HAVING.  
9. Checked if revenue crossed threshold using IF statements.  
10. Created new user with database access.  
11. Calculated maximum ticket price per class using window functions.  
12. Improved query performance using indexes; compared execution plans.  
13. Viewed execution plans for specific route queries.  
14. Calculated total ticket price per customer using ROLLUP.  
15. Created view for business class customers and airline brand.  
16. Created stored procedures for passengers between route ranges.  
17. Extracted routes with distance >2000 miles via stored procedure.  
18. Categorized flights into short, intermediate, and long distances via stored procedure.  
19. Used stored function in procedure to check complimentary services per class.  
20. (Optional) Cursor-based query for first customer with last name ending in 'Scott'.

## Files
- `Air_Cargo_Analysis_Project.sql` – SQL queries for analysis tasks  
- `air_cargo_schema.sql` – SQL schema creation  
- `Air Cargo Analysis.pdf` – Project report with results and explanation  
- `EER Diagram` – ER diagram of the database  
  - `Datasets/`  
  - `customer.csv`  
  - `passengers_on_flights.csv`  
  - `routes.csv`  
  - `ticket_details.csv`  

## Key Learnings
- Advanced SQL concepts: stored procedures, stored functions, indexing, window functions, rollup.  
- Performance optimization using indexes and execution plan analysis.  
- Data aggregation, filtering, and conditional logic in SQL.  
- Translating business objectives into database queries for reporting and analysis.

## Conclusion
This project demonstrates the practical application of SQL in airline operations. By implementing queries, views, and stored procedures, the project enables efficient passenger and route management, optimized resource allocation, and enhanced analytical reporting for better decision-making.

