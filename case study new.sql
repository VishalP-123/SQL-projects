create database sample;
use sample;

show tables;

#1. List all the orders placed in the month of February 2003.
SELECT * FROM Orders
WHERE OrderDate BETWEEN '2003-02-01' AND '2003-02-28';

#2. Calculate the number of days required in the month of August 2004 to ship the products.
SELECT OrderID, datediff(day, OrderDate, ShipDate) AS DaysToShip
FROM Orders
WHERE OrderDate BETWEEN '2004-08-01' AND '2004-08-31';

#3. List product details which have stock more than 6500.

SELECT * FROM Products 
WHERE quantityInStock > 6500;

#4. Display all the product names that don’t end with S.

SELECT productName FROM Products 
WHERE productName NOT LIKE '%S';

#5. List names of the employees in descending order of their office numbers

SELECT firstName FROM employees 
ORDER BY officeCode DESC;
select * from employees;
#6. List the names, job title and office no of everyone whose name falls in the alphabetical range ‘C’ to ‘L’

SELECT firstName, jobTitle, officeCode 
FROM employees 
WHERE firstName BETWEEN 'C' AND 'L';

#7. Display all the office cities which have NULL values in State.
SELECT city FROM Offices 
WHERE state IS NULL;

#8. List employee details working in Office Code 2, 3 or 5.
SELECT * FROM Employees 
WHERE officeCode IN (2, 3, 5);


#9. Display all the customers with no sales representative and they belong to either Singapore or Frankfurt cities.

SELECT * FROM Customers 
WHERE salesRepEmployeeNumber IS NULL AND (city = 'Singapore' OR city = 'Frankfurt');

#10. Select the name of all employees who are Sales Representatives.

SELECT FirstName FROM Employees 
WHERE jobTitle = 'Sales Rep';

#11. Display all full names of the employees in the concatenated form.

SELECT CONCAT(firstName, ' ', lastName) AS fullName FROM Employees;

#12. Display the employee details in the following format: Diane Murphy works as a President.

SELECT CONCAT(firstName, ' ', lastName, ' works as a ', jobTitle) AS employeeDetails FROM Employees;

#13. Display order date, required date and shipped date from Orders table in the following format: 22nd Feb 2018

SELECT DATE_FORMAT(orderDate, '%D %b %Y') AS orderDate,
       DATE_FORMAT(requiredDate, '%D %b %Y') AS requiredDate,
       DATE_FORMAT(shippedDate, '%D %b %Y') AS shippedDate
FROM Orders;

#14. Display annual payments received by customers.

SELECT customerNumber, YEAR(paymentDate) AS paymentYear, SUM(amount) AS totalPayments 
FROM Payments 
GROUP BY customerNumber, YEAR(paymentDate);

#15. Display Product-wise order count.

SELECT productCode, COUNT(*) AS orderCount 
FROM OrderDetails 
GROUP BY productCode;

#16. Find the customer number with the highest average orders

SELECT customerNumber 
FROM Orders 
GROUP BY customerNumber 
ORDER BY AVG(orderNumber) DESC 
LIMIT 1;

#17. Display employees who have the same designation as Barry.

SELECT * FROM Employees 
WHERE jobTitle = (SELECT jobTitle FROM Employees WHERE firstName = 'Barry');

#18. Display employees who work in the Paris city office.

SELECT * FROM Employees 
WHERE officeCode = (SELECT officeCode FROM Offices WHERE city = 'Paris');

#19. Display customer information whose credit limit is equal to the maximum credit limit.

SELECT * FROM Customers 
WHERE creditLimit = (SELECT MAX(creditLimit) FROM Customers);

#20. Display all the categories that have a minimum buy price greater than that of Ships.


show tables;
#21. List Names of customers having living city Liverpool and office city London.
SELECT c.customerName
FROM customers c
JOIN offices o ON c.postalCode = o.officeCode
WHERE c.city = 'Liverpool'
AND o.city = 'London';
select * from customers;
#22. List order details with customer and product details.

SELECT o.orderNumber, c.customerName, p.productName, od.quantityOrdered, od.priceEach 
FROM Orders o
JOIN Customers c ON o.customerNumber = c.customerNumber
JOIN OrderDetails od ON o.orderNumber = od.orderNumber
JOIN Products p ON od.productCode = p.productCode;

#23. List customer-wise payments made to the company.
SELECT customerNumber, SUM(amount) AS totalPayments 
FROM Payments 
GROUP BY customerNumber;

#24. Display office wise employee counts.

SELECT officeCode, COUNT(*) AS employeeCount 
FROM Employees 
GROUP BY officeCode;

#25. Display customer name who has the same sales representative that of ‘Mini Auto Werke’ and having credit limit greater than 75,000

SELECT customerName 
FROM Customers 
WHERE salesRepEmployeeNumber = (SELECT salesRepEmployeeNumber FROM Customers WHERE customerName = 'Mini Auto Werke')
AND creditLimit > 75000;

#26. Create stored procedure to get the city and state of the customer based on the customer number provided.

delimiter $
CREATE PROCEDURE GetCustomerCityState(IN customerNum INT)
BEGIN
    SELECT city, state 
    FROM Customers 
    WHERE customerNumber = customerNum;
END$
call GetCustomerCityState(103);
#27. Create a stored procedure that selects offices located in a particular country.
delimiter $
CREATE PROCEDURE GetOfficesByCountry(IN countryName VARCHAR(50))
BEGIN
SELECT * FROM Offices 
    WHERE country = countryName;
END$
call GetOfficesByCountry('USA');
#28. Create a stored procedure returns the number of orders by order status.
delimiter $
CREATE PROCEDURE GetOrdersByStatus()
BEGIN
    SELECT status, COUNT(*) AS orderCount 
    FROM Orders 
    GROUP BY status;
END$
call GetOrdersByStatus();
#29. Create a stored procedure the accept two parameters customer number as input and customer level as output. The customer level depends upon the credit limit of the customer, 
#if the credit limit of the customer is greater than 50000, then the customer level will be returned as platinum, for credit limit between 50000 and 10000, customer level will be gold 
#and for less than 10000, it will be silver
delimiter $
CREATE PROCEDURE GetCustomerLevel(IN customerNum INT, OUT customerLevel VARCHAR(20))
BEGIN
    DECLARE creditLimit DECIMAL(10,2);
    SELECT creditLimit INTO creditLimit 
    FROM Customers 
    WHERE customerNumber = customerNum;
    
    IF creditLimit > 50000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF creditLimit BETWEEN 10000 AND 50000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
END$
select * from customers;
#30. Create a function to find the customer level based on the credit limit of the customer. The customer level should be display along with the credit limit
delimiter $
CREATE FUNCTION GetCustomerLevel(creditLimit DECIMAL(10,2)) 
RETURNS VARCHAR(20)
BEGIN
    DECLARE customerLevel VARCHAR(20);
    
    IF creditLimit > 50000 THEN
        SET customerLevel = 'Platinum';
    ELSEIF creditLimit BETWEEN 10000 AND 50000 THEN
        SET customerLevel = 'Gold';
    ELSE
        SET customerLevel = 'Silver';
    END IF;
    
    RETURN CONCAT('Credit Limit: ', creditLimit, ', Level: ', customerLevel);
END$
#31. Create a stored procedure named GetEmployeeSales that calculates and returns the total sales amount for each employee based on the orders they have handled. 
delimiter $
CREATE PROCEDURE GetEmployeeSales()
BEGIN
    SELECT e.employeeNumber, e.firstName, e.lastName, SUM(od.priceEach * od.quantityOrdered) AS totalSales 
    FROM Employees e
    JOIN Customers c ON e.employeeNumber = c.salesRepEmployeeNumber
    JOIN Orders o ON c.customerNumber = o.customerNumber
    JOIN OrderDetails od ON o.orderNumber = od.orderNumber
    GROUP BY e.employeeNumber, e.firstName, e.lastName;
END$

#32. Develop a stored procedure named GetProductsWithLowStock that retrieves product information, including product code, product name, and quantity in stock, for products with a quantityInStock less than a specified threshold.
delimiter $
CREATE PROCEDURE GetProductsWithLowStock(IN stockThreshold INT)
BEGIN
    SELECT productCode, productName, quantityInStock 
   FROM Products
    WHERE quantityInStock < stockThreshold;
END$

#33. Design a stored procedure named GetLateShipments that identifies and returns details of orders with a status of 'Shipped' but where the shippedDate is later than the requiredDate.
delimiter $
CREATE PROCEDURE GetLateShipments()
BEGIN
    SELECT orderNumber, orderDate, requiredDate, shippedDate 
    FROM Orders 
    WHERE status = 'Shipped' AND shippedDate > requiredDate;
END$

#34. Develop a stored procedure named GetOrderSummary that provides a summary of each order, including the order number, order date, total quantity of products ordered, and the total order amount. Use the orderdetails and orders tables.
delimiter $
CREATE PROCEDURE GetOrderSummary()
BEGIN
    SELECT o.orderNumber, o.orderDate, SUM(od.quantityOrdered) AS totalQuantity, SUM(od.priceEach * od.quantityOrdered) AS totalAmount 
    FROM Orders o
    JOIN OrderDetails od ON o.orderNumber = od.orderNumber
    GROUP BY o.orderNumber, o.orderDate;
END$

#35. Create a stored function named CalculateTotalSalesByCustomer that takes a customerNumber as input and returns the total amount of sales made by that customer.
DELIMITER $$

CREATE FUNCTION CalculateTotalSalesByCustomer(customerNumber INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE totalSales DECIMAL(10, 2);
    
    SELECT SUM(orderdetails.quantityOrdered * orderdetails.priceEach)
    INTO totalSales
    FROM orders
    INNER JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
    WHERE orders.customerNumber = customerNumber;

    RETURN totalSales;
END$$

DELIMITER ;


#36. Design a stored function named GetEmployeeManager that takes an employeeNumber as input and returns the name of the manager (if any) for the given employee. 

DELIMITER $$

CREATE FUNCTION GetEmployeeManager(employeeNumber INT)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE managerName VARCHAR(255);

    SELECT CONCAT(firstName, ' ', lastName)
    INTO managerName
    FROM employees
    WHERE employeeNumber = (
        SELECT reportsTo
        FROM employees
        WHERE employeeNumber = employeeNumber
    );

    RETURN managerName;
END$$

DELIMITER ;


#37. Create a stored function named CalculateOrderTotal that takes an orderNumber as input and returns the total amount for the given order
DELIMITER $$

CREATE FUNCTION CalculateOrderTotal(orderNumber INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE totalAmount DECIMAL(10, 2);
    
    SELECT SUM(quantityOrdered * priceEach)
    INTO totalAmount
    FROM orderdetails
    WHERE orderNumber = orderNumber;
    
    RETURN totalAmount;
END$$

DELIMITER ;
 
