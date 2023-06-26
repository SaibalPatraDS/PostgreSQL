-- Windows Function

SELECT * 
FROM public.employee;


-- 1. Compare the difference between highest employee salary with each individual employee salary. 
--    and categorise them either as highest paid or just employeer.
SELECT p.*,
       MAX(salary) OVER(PARTITION BY dept_name) AS max_salary,
       MAX(salary) OVER(PARTITION BY dept_name) - p.salary AS salary_diff,
	   CASE
	       WHEN (MAX(salary) OVER(PARTITION BY dept_name) - p.salary = 0) THEN 'Highest Paid Employeer'
		   ELSE 'Employeer'
	   END AS employeer_category
FROM public.employee p;


-- ROW_NUMBER(), RANK(), DENSE(), LAG(), LEAD()

-- ROW_NUMBER()

SELECT * ,
ROW_NUMBER() OVER() as rn
FROM public.employee
ORDER BY emp_id;

-- USE CASE
-- 2. Select those employeers from each department who has joined the company first.

-- Hint : whose emp_id is lesser has to be considered they are the oldest employees of the company.

SELECT * FROM (
	SELECT *,
		  ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY emp_id) AS rn
	FROM public.employee) AS p
WHERE p.rn = 1;


-- 3. Find out the top 3 employees of each department earning max salary. 

SELECT *
FROM(
	SELECT * ,
	RANK() OVER(PARTITION BY dept_name ORDER BY salary DESC) AS emp_sal_rank
	FROM public.employee) AS p
WHERE p.emp_sal_rank < 4;


-- Difference between ROW_NUMBER(), RANK(), DENSE_RANK()

SELECT * ,
      ROW_NUMBER() OVER(PARTITION BY dept_name ORDER BY salary) AS rn,
	  RANK() OVER(PARTITION BY dept_name ORDER BY salary) AS rnk,
	  DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY salary) AS dn_rnk
FROM public.employee;



--- LAG() and LEAD()

SELECT * ,
      lAG(salary, 1, 0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS prev_lag_col,
      lEAD(salary, 1, 0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS next_lead_col
FROM public.employee;

-- What `lag()` function will do is fetching the previous rows result and 
-- lag() function can have three attricutes, 
-- first 'column' you want to apply, second no of rows back you want to fetch,
-- third if the value is NULL, substitute that will a value(as per your choice)

-- Same with LEAD() function

-- 4. Find out whether the salary of employess are higher than their co-workers or not.
SELECT emp_id, 
       dept_name,
      CASE 
	       WHEN (prev_emp_salary = 0) THEN 'No Comments'
	       WHEN (prev_emp_salary < salary) THEN 'More Paid'
	       WHEN (prev_emp_salary = salary) THEN 'Equal Paid'
	       ELSE 'Lower Paid'
	  END AS emp_category_1,
	  CASE 
	       WHEN (next_emp_salary = 0) THEN 'No Comments'
	       WHEN (next_emp_salary < salary) THEN 'More Paid'
	       WHEN (next_emp_salary = salary) THEN 'Equal Paid'
	       ELSE 'Lower Paid'
	  END AS emp_category_2
FROM(	  
	SELECT *,
		 LAG(salary, 1, 0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS prev_emp_salary,
	     LEAD(salary, 1, 0) OVER(PARTITION BY dept_name ORDER BY emp_id) AS next_emp_salary
	FROM public.employee) p;



























