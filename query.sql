SELECT firstName, lastName, title
FROM employee
LIMIT 5;

SELECT model, EngineType
FROM model
LIMIT 5;

-- Visualize the schema table
SELECT sql
FROM sqlite_schema
WHERE name = 'employee';


-- 1. Create a list of employees and their immediate managers.
SELECT emp.firstName, emp.lastName, man.firstName, man.lastName
FROM employee AS emp
INNER JOIN employee AS man
WHERE emp.managerId=man.managerId;


-- 2. Get a list of people with zero sales
SELECT emp.firstName, emp.lastName, sal.salesAmount, emp.title, sal.employeeId
FROM employee emp
LEFT JOIN sales sal
ON emp.employeeId = sal.employeeId
WHERE emp.title = 'Sales Person' 
AND sal.salesId IS NULL;


-- 3. List all customers & their sales, even if some data is gone
-- UNION WILL COMBINE ALL THE 3 QUERIES IN ONE TABLE
SELECT cus.firstName, cus.lastName, cus.email, sal.salesAmount, sal.soldDate
FROM customer cus
INNER JOIN sales sal
ON cus.customerId = sal.customerId
UNION
-- UNION WITH CUSTOMERS WHO HAVE NO SALES
SELECT cus.firstName, cus.lastName, cus.email, sal.salesAmount, sal.soldDate
FROM customer cus
LEFT JOIN sales sal
ON cus.customerId = sal.customerId
WHERE sal.salesId IS NULL
UNION
-- UNION WITH SALES MISSING CUSTOMER DATA
SELECT cus.firstName, cus.lastName, cus.email, sal.salesAmount, sal.soldDate
FROM sales sal
LEFT JOIN customer cus
ON cus.customerId = sal.customerId
WHERE cus.customerId IS NULL;


-- 4. How many cars has been sold per employee
SELECT emp.employeeId, emp.firstName, emp.lastName, count(*) as CarsSoldPerEmployee
FROM sales as sal
INNER JOIN employee as emp
ON sal.employeeId=emp.employeeId
GROUP BY emp.employeeId, emp.firstName, emp.lastName
ORDER BY CarsSoldPerEmployee DESC;


-- 5. The least and most expensive cars sold by each employee this year(for this eg. current year is 2023)
SELECT 
  emp.employeeId, 
  emp.firstName, 
  emp.lastName, 
  MIN(salesAmount) as CheapestCar, 
  MAX(salesAmount) as MostExpensiveCar
FROM sales as sal
INNER JOIN employee as emp
ON sal.employeeId = emp.employeeId
WHERE sal.soldDate >= '2023-01-01'
GROUP BY emp.employeeId, emp.firstName, emp.lastName


-- 6. Employees that have made more than 5 sales this year
SELECT 
  emp.employeeId, emp.firstName, emp.lastName,
  count(*) as CarsSoldPerEmployee,
  MIN(salesAmount) as CheapestCar, 
  MAX(salesAmount) as MostExpensiveCar
FROM sales as sal
INNER JOIN employee as emp
ON sal.employeeId = emp.employeeId
WHERE sal.soldDate >= '2023-01-01'
GROUP BY emp.employeeId, emp.firstName, emp.lastName
HAVING count(*) > 5

-- 7. Common Table Expression CTE: allows us to break the queries into sections
-- Create a report showing the total sales per year
-- Summarise sales per year

-- We are using the strftime() function that returns the date in a string that is specified in the first argument

WITH cte AS (
SELECT strftime('%Y', soldDate) AS soldYear, salesAmount
FROM sales
)
SELECT soldYear, FORMAT('$%.2f', sum(salesAmount)) AS AnnualSales
FROM cte
GROUP BY soldYear
ORDER BY soldYear









