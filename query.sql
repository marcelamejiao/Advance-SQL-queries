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

-- Create a list of employees and their immediate managers.
SELECT emp.firstName, emp.lastName, man.firstName, man.lastName
FROM employee AS emp
INNER JOIN employee AS man
WHERE emp.managerId=man.managerId;