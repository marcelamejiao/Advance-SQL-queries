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
SELECT cus.firstName, cus.lastName, cus.email, sls.salesAmount, sls.soldDate
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