/*
1.	Create a database named employee,
then import data_science_team.csv proj_table.csv and emp_record_table.csv 
into the employee database from the given resources.
*/
CREATE DATABASE employee ;
USE employee ;
SELECT * FROM employee.data_science_team;
SELECT * FROM employee.emp_record_table;
SELECT * FROM employee.proj_table;

/*
2.	Create an ER diagram for the given employee database.
ER Diagram is attached as a screenshot in word file
*/

/*
3.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT
from the employee record table, 
and make a list of employees and details of their department.
*/
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT
FROM
    emp_record_table
ORDER BY DEPT;

/*
4.	Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, 
and EMP_RATING if the EMP_RATING is: 
●	less than two
●	greater than four 
●	between two and four
*/
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'Department',
    EMP_RATING
FROM
    employee.emp_record_table
WHERE
    EMP_RATING < 2
ORDER BY 1 ;
    
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'Department',
    EMP_RATING
FROM
    employee.emp_record_table
WHERE
    EMP_RATING > 4
ORDER BY 1 ;
    
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT AS 'Department',
    EMP_RATING
FROM
    employee.emp_record_table
WHERE
    EMP_RATING BETWEEN 2 AND 4
ORDER BY 6 ;


/*
5.	Write a query to concatenate the FIRST_NAME and the LAST_NAME 
of employees in the Finance department from the employee table 
and then give the resultant column alias as NAME.
*/
SELECT 
    EMP_ID,
    DEPT,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS 'Name',
    GENDER
FROM
    emp_record_table
WHERE
    DEPT = 'Finance'
ORDER BY 1;


/*
6.	Write a query to list only those employees who have someone reporting to them. 
Also, show the number of reporters (including the President).
*/
SELECT 
    e2.EMP_ID 'Manager_IDs',
    e2.FIRST_NAME AS 'Manager_Name',
    COUNT(e1.EMP_ID) AS 'Number_of_Reportees'
FROM
    emp_record_table e1
        INNER JOIN
    emp_record_table e2 ON e1.MANAGER_ID = e2.EMP_ID
GROUP BY 1 , 2;

/*
7.	Write a query to list down all the employees 
from the healthcare and finance departments using union.
Take data from the employee record table.
*/
SELECT 
    EMP_ID,
    DEPT AS 'Department',
    UPPER(CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME))) AS 'Name'
FROM
    emp_record_table
WHERE
    dept IN ('Finance' , 'Healthcare')
ORDER BY 2;


/*
8.	Write a query to list down employee details 
such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
Also include the respective employee rating along with the max emp rating for the department.
*/
SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING,
    MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS 'Maximum_dept_rating'
FROM
    emp_record_table;


/*
9.	Write a query to calculate the minimum and the maximum salary of the employees in each role. 
Take data from the employee record table.
*/
-- Option 1
SELECT EMP_ID, concat(trim(FIRST_NAME), ' ', trim(LAST_NAME)) AS 'NAME', ROLE, SALARY,
MIN(SALARY) OVER (PARTITION BY ROLE) AS 'Dept_Min_salary',
MAX(SALARY) OVER (PARTITION BY ROLE) AS 'Dept_Max_salary'
FROM emp_record_table ;

-- Option 2 (More precise as per the question)
SELECT ROLE, MIN(SALARY) AS 'Dept_Min_salary',
MAX(SALARY) AS 'Dept_Max_salary'
FROM emp_record_table 
GROUP BY 1;

/*
10.	Write a query to assign ranks to each employee based on their experience.
Take data from the employee record table.
*/
SELECT EMP_ID, CONCAT(TRIM(FIRST_NAME), ' ', trim(LAST_NAME)) AS 'NAME', EXP,
DENSE_RANK () OVER (ORDER BY EXP DESC) as 'Rank_as_per_Exp'
FROM emp_record_table ;


/*
11.	Write a query to create a view that displays employees in various countries
whose salary is more than six thousand. 
Take data from the employee record table.
*/
CREATE VIEW employee.employee_view AS
    SELECT 
        EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
    FROM
        emp_record_table
    WHERE
        SALARY > 6000
	ORDER BY COUNTRY;

SELECT * FROM employee_view;


/*
12.	Write a nested query to find employees with experience of more than ten years.
Take data from the employee record table.
*/

-- Subquery --
SELECT EMP_ID FROM emp_record_table WHERE EXP > 10;
    
-- Main query --
SELECT 
    *
FROM
    emp_record_table
WHERE
    EMP_ID IN (SELECT 
            EMP_ID
        FROM
            emp_record_table
        WHERE
            EXP > 10);
            
            
/*
13.	Write a query to create a stored procedure to retrieve the details of the employees
whose experience is more than three years.
Take data from the employee record table.
*/
DELIMITER //
CREATE PROCEDURE Experienced_emp ()
BEGIN
SELECT *
FROM emp_record_table
WHERE EXP > 3 ;
END //
DELIMITER ;

CALL Experienced_emp ;


/*
14.	Write a query using stored functions in the project table
to check whether the job profile assigned to each employee 
in the data science team matches the organization’s set standard.

The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.
*/
DELIMITER $$
CREATE FUNCTION ASSIGNED_JOB_PROFILES (Exp_in_years INT)
RETURNS VARCHAR (50)
DETERMINISTIC
BEGIN
DECLARE job_profile VARCHAR (50) ;
IF Exp_in_years <= 2 THEN SET job_profile = 'JUNIOR DATA SCIENTIST';
ELSEIF Exp_in_years <= 5 THEN SET job_profile = 'ASSOCIATE DATA SCIENTIST';
ELSEIF Exp_in_years <= 10 THEN SET job_profile = 'SENIOR DATA SCIENTIST';
ELSEIF Exp_in_years <= 12 THEN SET job_profile = 'LEAD DATA SCIENTIST';
ELSE SET job_Profile = 'MANAGER';
END IF;
RETURN job_profile ;
END $$
DELIMITER ;

SELECT EMP_ID,EXP, ASSIGNED_JOB_PROFILES(13)
FROM data_science_team ;


/*
15.	Create an index to improve the cost and performance of the query 
to find the employee whose FIRST_NAME is ‘Eric’ in the employee table 
after checking the execution plan.
*/
SELECT * FROM employee.emp_record_table
WHERE FIRST_NAME = 'ERIC' ;

CREATE INDEX idx_firstname ON emp_record_table (FIRST_NAME(50));

SELECT * FROM employee.emp_record_table
WHERE FIRST_NAME = 'ERIC' ;


/*
16.	Write a query to calculate the bonus for all the employees,
based on their ratings and salaries.
(Use the formula: 5% of salary * employee rating).
*/
SELECT 
    EMP_ID,
    CONCAT(TRIM(FIRST_NAME), ' ', TRIM(LAST_NAME)) AS NAME,
    SALARY,
    EMP_RATING,
    (SALARY * 0.05 * EMP_RATING) AS BONUS
FROM 
    emp_record_table
ORDER BY BONUS DESC;


/*
17.	Write a query to calculate the average salary distribution based on the continent and country.
Take data from the employee record table.
*/
SELECT 
    CONTINENT, COUNTRY, ROUND(AVG(SALARY), 2) AS 'Avg_sal'
FROM
    employee.emp_record_table
GROUP BY CONTINENT , COUNTRY
ORDER BY CONTINENT , COUNTRY;
