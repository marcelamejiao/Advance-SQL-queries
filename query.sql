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


-- 8. Create a report that shows the amount of sales per employee for each month in 2021
SELECT emp.lastName, emp.firstName,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '01'
        THEN salesAmount END) AS JanSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '02'
        THEN salesAmount END) AS FebSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '03'
        THEN salesAmount END) AS MarSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '04'
        THEN salesAmount END) AS AprSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '05'
        THEN salesAmount END) AS MaySales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '06'
        THEN salesAmount END) AS JunSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '07'
        THEN salesAmount END) AS JulSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '08'
        THEN salesAmount END) AS AugSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '09'
        THEN salesAmount END) AS SepSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '10'
        THEN salesAmount END) AS OctSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '11'
        THEN salesAmount END) AS NovSales,
  SUM(CASE 
        WHEN strftime('%m', soldDate) = '12'
        THEN salesAmount END) AS DecSales
FROM sales sal
INNER JOIN employee emp 
  ON sal.employeeId = emp.employeeId
WHERE sal.soldDate 
  BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY emp.lastName, emp.firstName
ORDER BY emp.lastName, emp.firstName


-- 9. Find the sales of cars that are electric by using a Subquery
SELECT sal.salesId, sal.salesAmount, inv.colour, inv.year
FROM sales sal 
INNER JOIN inventory inv
      ON sal.inventoryId = inv.inventoryId
WHERE inv.modelId IN (
      SELECT modelId
      FROM model
      WHERE EngineType = 'Electric'
)


-- 10. For each sales person , rank the car models they have sold the most
-- For this query we need to use the rank() window function, the OVER clause and PARTITION BY subclause
SELECT emp.firstName, emp.lastName, mod.model,
      count(model) AS NumberSold,
      rank() OVER (PARTITION BY sal.employeeId
                  ORDER BY count(model) desc) AS Rank
FROM sales sal
INNER JOIN employee emp
      ON sal.employeeId = emp.employeeId
INNER JOIN inventory inv
      ON inv.inventoryId = sal.inventoryId
INNER JOIN model mod
      ON mod.modelId = inv.modelId
GROUP BY emp.firstName, emp.lastName, mod.model










