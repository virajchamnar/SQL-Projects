CREATE DATABASE air_cargo ;
USE air_cargo ;

SELECT * FROM air_cargo.customer;
DESCRIBE customer;

SELECT * FROM air_cargo.passengers_on_flights;
DESCRIBE passengers_on_flights;

SELECT * FROM air_cargo.routes;
DESCRIBE routes;

SELECT * FROM air_cargo.ticket_details;
DESCRIBE ticket_details;

/*
1.	Create an ER diagram for the given airlines database.
Attached in PDF
*/

/*
2.	Write a query to create a route_details table using suitable data types for the fields,
such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles.
Implement the check constraint for the flight number and unique constraint for the route_id fields.
Also, make sure that the distance miles field is greater than 0. 
*/
CREATE TABLE route_details (
    route_id INT UNIQUE,
    flight_num VARCHAR(10) NOT NULL,
    origin_airport VARCHAR(50) NOT NULL,
    destination_airport VARCHAR(50) NOT NULL,
    aircraft_id VARCHAR(20) NOT NULL,
    distance_miles DECIMAL(10,2) CHECK (distance_miles > 0),
    CHECK (CHAR_LENGTH(flight_num) >= 3)
);
DESCRIBE route_details;


/*
3.	Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. 
Take data from the passengers_on_flights table.
*/
SELECT 
    customer_id, route_id
FROM
    passengers_on_flights
WHERE
    route_id BETWEEN 01 AND 25
ORDER BY route_id DESC;

/*
4.	Write a query to identify the number of passengers and total revenue 
in business class from the ticket_details table.
*/
SELECT 
    COUNT(customer_id) AS number_of_passengers,
    SUM(price_per_ticket * no_of_tickets) AS total_revenue
FROM ticket_details
WHERE class_id = 'bussiness';

/*
5.	Write a query to display the full name of the customer 
by extracting the first name and last name from the customer table.
*/
SELECT 
    customer_id,
    CONCAT_WS(' ', TRIM(first_name), TRIM(last_name)) AS 'full_name',
    gender
FROM
    customer
ORDER BY full_name;
-- Using CONCAT_WS instead of CONCAT allows handling nulls gracefully

/*
6.	Write a query to extract the customers who have registered and booked a ticket. 
Use data from the customer and ticket_details tables.
*/
SELECT 
    c.customer_id,
    CONCAT(TRIM(c.first_name), ' ', TRIM(c.last_name)) AS full_name,
    c.gender,
    td.no_of_tickets
FROM
    customer c
        INNER JOIN
    ticket_details td ON c.customer_id = td.customer_id
ORDER BY full_name;


/*
7.	Write a query to identify the customer’s first name and last name 
based on their customer ID and brand (Emirates) from the ticket_details table.
*/
SELECT 
    td.customer_id,
    CONCAT_WS(' ', TRIM(c.first_name), TRIM(c.last_name)) AS full_name,
    td.brand
FROM
    ticket_details td
        INNER JOIN
    customer c ON c.customer_id = td.customer_id
WHERE
    td.brand = 'Emirates'
ORDER BY full_name;

/*
8.	Write a query to identify the customers who have travelled by Economy Plus class
using Group By and Having clause on the passengers_on_flights table. 
*/
SELECT 
    pf.customer_id,
    CONCAT(TRIM(c.first_name), ' ', TRIM(c.last_name)) AS full_name,
    COUNT(*) AS total_flights
FROM
    passengers_on_flights pf
        INNER JOIN
    customer c ON pf.customer_id = c.customer_id
GROUP BY pf.customer_id , full_name
HAVING SUM(pf.class_id = 'economy plus');


/*
9.	Write a query to identify whether the revenue has crossed 10000
using the IF clause on the ticket_details table.
*/
SELECT 
    SUM(price_per_ticket * no_of_tickets) AS total_revenue,
    IF(SUM(price_per_ticket * no_of_tickets) > 10000,
        'Revenue has crossed 10000',
        'Revenue has not crossed 10000') AS revenue_status
FROM
    ticket_details;
    
    
/*
10.	Write a query to create and grant access to a new user to perform operations on a database.
*/
CREATE USER 'aircargo_user'@'localhost' IDENTIFIED BY 'AirCargo@123';
GRANT ALL PRIVILEGES ON air_cargo.* TO 'aircargo_user'@'localhost';
FLUSH PRIVILEGES;

/*
11.	Write a query to find the maximum ticket price for each class
using window functions on the ticket_details table. 
*/
SELECT 
    class_id, price_per_ticket, 
    MAX(price_per_ticket) OVER (PARTITION BY class_id) AS 'max_ticket_price'
FROM
    ticket_details;

/*
12.	Write a query to extract the passengers 
whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.
*/
SELECT * 
FROM passengers_on_flights
WHERE route_id = 4;

CREATE INDEX idx_route_id ON passengers_on_flights(route_id);
SELECT * 
FROM passengers_on_flights
WHERE route_id = 4;

/*
13.	 For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
*/
EXPLAIN SELECT * 
FROM passengers_on_flights
WHERE route_id = 4;

/*
14.	Write a query to calculate the total price of all tickets booked by a customer
across different aircraft IDs using rollup function. 
*/
SELECT 
    customer_id,
    aircraft_id,
    SUM(no_of_tickets * price_per_ticket) AS total_price
FROM
    ticket_details
GROUP BY customer_id , aircraft_id WITH ROLLUP;

/*
15.	Write a query to create a view with only
business class customers along with the brand of airlines. 
*/
CREATE VIEW business_class_cust AS
    SELECT 
        customer_id, class_id AS 'Class', brand
    FROM
        ticket_details
    WHERE
        class_id = 'bussiness';
        
SELECT * FROM business_class_cust;

/*
16.	Write a query to create a stored procedure to get the details of 
all passengers flying between a range of routes defined in run time. 
Also, return an error message if the table doesn't exist.
*/
DELIMITER //
CREATE PROCEDURE get_passenger_details(IN start_route INT, IN end_route INT)
BEGIN
    IF (SELECT COUNT(*) 
        FROM passengers_on_flights) >= 0 THEN
        
        SELECT *
        FROM passengers_on_flights
        WHERE route_id BETWEEN start_route AND end_route;

    ELSE
        SELECT 'Error: Table passengers_on_flights does not exist' AS message;
    END IF;
END //
DELIMITER ;
CALL get_passenger_details(5, 10);

/*
17.	Write a query to create a stored procedure that extracts all the details
from the routes table where the travelled distance is more than 2000 miles.
*/
DELIMITER //
CREATE PROCEDURE get_routes_over_2000()
BEGIN
	SELECT *
	FROM routes
	WHERE distance_miles > 2000
    ORDER BY distance_miles DESC;
END //
DELIMITER ;
CALL get_routes_over_2000();

/*
18.	Write a query to create a stored procedure that groups the distance
travelled by each flight into three categories. The categories are,
short distance travel (SDT) for >=0 AND <= 2000 miles, 
intermediate distance travel (IDT) for >2000 AND <=6500, 
and long-distance travel (LDT) for >6500.
*/
DELIMITER //
CREATE PROCEDURE categorised_flight_distance ()
BEGIN
    SELECT 
        flight_num, 
        distance_miles, 
        CASE
            WHEN distance_miles >= 0 AND distance_miles <= 2000 THEN 'SDT'
            WHEN distance_miles > 2000 AND distance_miles <= 6500 THEN 'IDT'
            ELSE 'LDT'
        END AS 'distance_category'
    FROM routes
    ORDER BY distance_miles;
END //
DELIMITER ;
CALL categorised_flight_distance();

/*
19.	Write a query to extract ticket purchase date, customer ID, class ID
and specify if the complimentary services are provided for the specific class
using a stored function in stored procedure on the ticket_details table. 
Condition: 
●	If the class is Business and Economy Plus,
then complimentary services are given as Yes, else it is No
*/
# Creating Function:
DELIMITER //
CREATE FUNCTION check_complimentary_services(class_name VARCHAR(50))
RETURNS VARCHAR(5)
DETERMINISTIC
BEGIN
    DECLARE service_status VARCHAR(5);
    IF class_name IN ('bussiness', 'economy plus') THEN
        SET service_status = 'Yes';
    ELSE
        SET service_status = 'No';
    END IF;
    RETURN service_status;
END //
DELIMITER ;

# Creating Procedure:
DELIMITER //
CREATE PROCEDURE get_ticket_service_status()
BEGIN
    SELECT 
        p_date,
        customer_id,
        class_id,
        check_complimentary_services(class_id) AS complimentary_service
    FROM ticket_details;
END //
DELIMITER ;

CALL get_ticket_service_status();

/*
20.	Write a query to extract the first record of the customer
whose last name ends with Scott using a cursor from the customer table.

Cursor operations were not covered during Live Class; hence this query was not implemented
*/
    
    
    

