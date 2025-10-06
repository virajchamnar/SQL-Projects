# ScienceQtech Employee Performance Mapping

## Problem Statement
ScienceQtech, a data science startup, wants to analyze employee performance and project contributions to support the HR appraisal cycle. As a Junior Database Administrator, the task is to analyze employee data, project details, and performance ratings to generate insights on salaries, bonuses, and role appropriateness.

## Objective
- Map employee performance using ratings and project data.  
- Calculate maximum, minimum, and average salaries by role and location.  
- Identify training needs and optimize organizational decisions.  
- Implement database concepts like views, stored procedures, stored functions, indexes, and ranking.

## Tools & Technologies
- SQL (MySQL)  
- Database concepts: Views, Stored Procedures, Stored Functions, Indexing  
- Dataset: `emp_record_table.xlsx` (used for query execution)  
- ER Diagram tools for database design  

## Key Tasks / Queries Implemented
1. Create database and import datasets (`data_science_team.csv`, `proj_table.csv`, `emp_record_table.csv`).  
2. Create an ER diagram representing the employee database structure.  
3. Fetch employee details with filters on department, rating, and experience.  
4. Concatenate first and last names for employees in Finance.  
5. Identify employees who have direct reports.  
6. Use `UNION` to combine specific departmental employee lists.  
7. Aggregate employee ratings by department.  
8. Calculate min/max salaries by role.  
9. Assign ranks to employees based on experience.  
10. Create views to filter high-salary employees by country.  
11. Use nested queries for experience-based filters.  
12. Implement stored procedures to fetch employee details.  
13. Implement stored functions to validate job profiles.  
14. Create indexes to optimize query performance.  
15. Calculate bonuses based on salary and performance rating.  
16. Analyze salary distribution by continent and country.

## Files
- `ScienceQtech Employee Performance Mapping_Project.sql` – SQL scripts for all queries listed above  
- `emp_record_table.xlsx` – Dataset used for analysis
- `ScienceQtech Employee Performance Mapping.pdf` – Optional, includes outputs of executed queries  

## Key Learnings
- Practical application of SQL for employee performance mapping  
- Advanced SQL concepts: views, stored procedures, stored functions, indexing  
- Data aggregation, filtering, and ranking  
- Translating business requirements into database queries  

## Conclusion
This project demonstrates how SQL can be applied to real-world HR and organizational scenarios. By executing queries, creating views, and implementing stored procedures, the project highlights the ability to extract meaningful insights, optimize database performance, and facilitate data-driven decision-making.




