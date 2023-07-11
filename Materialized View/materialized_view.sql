-- Materialized View

DROP TABLE IF EXISTS emp_table;

--- Creating table
CREATE TABLE emp_table (id INT,
				    salary FLOAT);

-- Inserting datapoints
INSERT INTO emp_table 
SELECT 1, random() FROM generate_series(1, 10000000);

INSERT INTO emp_table 
SELECT 2, random() FROM generate_series(1, 10000000);

-- Basic Operations

SELECT id,
       AVG(salary) AS avg_salary
FROM emp_table
GROUP BY id;


CREATE MATERIALIZED VIEW mv_emp_table
AS
SELECT id,
       AVG(salary) AS avg_salary
FROM emp_table
GROUP BY id;

SELECT * FROM mv_emp_table;


-- Deleting something 

DELETE FROM emp_table WHERE id = 2;


REFRESH MATERIALIZED VIEW mv_emp_table;
































































































