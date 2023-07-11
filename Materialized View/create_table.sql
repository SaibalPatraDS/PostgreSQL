/* Materialized View */

DROP TABLE IF EXISTS emp_table;

--- Creating table
CREATE TABLE emp_table (id INT,
				    salary FLOAT);

-- Inserting datapoints
INSERT INTO emp_table 
SELECT 1, random() FROM generate_series(1, 10000000);

INSERT INTO emp_table 
SELECT 2, random() FROM generate_series(1, 10000000);
