-- Recursive Query --

WITH [RECURSIVE] CTE_name AS(
	SELECT query (Non-Recursive QUERY OR BASE QUERY)
	UNION [ALL]
	SELECT query (RECURSIVE QUERY USING CTE_name)[with a TERMINATION CONDITION]
) 

SELECT * FROM CTE_name;

/*
-- Query Execution ->
   1. query goes through `RECURSIVE` and gets to know its a RECURSIVE query
   2. Base Query is executed and then the output works as an input to the Recursive Query
   3. Recursive query will check condt. of termination and if not meet then will query again
   4. And this time, the output of recursive query will work as an input for next recursive query
   5. And will continue untill termination condition is meet.
*/

SELECT * FROM emp_details;


-- QUERIES

-- Q1. Display numbers from 1 to 10, without using any built-in function.
-- Q2. Find the hierarcy of employees under a manager. 
-- Q3. Find the hierarcy of managers for a given employees.


-- Q1. Display numbers from 1 to 10, without using any built-in function.

WITH RECURSIVE nums AS(
	SELECT 1 AS numbers
	UNION
	SELECT numbers + 1
	FROM nums
	WHERE numbers < 10
)

SELECT * FROM nums;





-- Q2. Find the hierarcy of employees under a manager.


SELECT * FROM emp_details;



WITH RECURSIVE emp_hierarchy AS(
	SELECT id, name, manager_id, designation, 1 AS lvl
	FROM emp_details
	WHERE name = 'Asha'
	UNION 
	SELECT E.id, E.name, E.manager_id, E.designation, H.lvl + 1 AS lvl
	FROM emp_hierarchy H
	JOIN emp_details E
	ON H.id = E.manager_id
)

SELECT * FROM emp_hierarchy;



/*
WITH RECURSIVE emp_hierarchy AS(
	SELECT id, manager_id, name, designation, 1 AS lvl
	FROM emp_details
	UNION
	SELECT E.id, E.manager_id, E.name, E.designation, H.lvl+1 AS lvl
	FROM emp_hierarchy H
	JOIN emp_details E
	ON H.id = E.manager_id
)

SELECT E2.manager_id, E2.name AS manager_name, H2.name AS emp_name, H2.id AS emp_id, H2.lvl
FROM emp_hierarchy H2
JOIN emp_details E2
ON H2.manager_id = E2.id
ORDER BY E2.name;
*/




-- Q3. Find the hierarcy of managers for a given employees, 'David'.

SELECT * FROM emp_details;



WITH RECURSIVE emp_hierarchy AS(
	SELECT id, name, manager_id, designation, 1 AS lvl
	FROM emp_details
	WHERE name = 'David'
	UNION
	SELECT E.id, E.name, E.manager_id, E.designation, H.lvl + 1 AS lvl
	FROM emp_hierarchy H
	JOIN emp_details E
	ON H.manager_id = E.id
)

SELECT H2.manager_id AS manager_ID, H2.name AS emp_name, E2.name AS manager_name, lvl
FROM emp_hierarchy H2
JOIN emp_details E2
ON H2.manager_id = E2.id;





































