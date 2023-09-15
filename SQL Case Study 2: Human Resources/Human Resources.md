**Schema (PostgreSQL v15)**

    -- Create 'departments' table
    CREATE TABLE departments (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50),
        manager_id INT
    );
    
    -- Create 'employees' table
    CREATE TABLE employees (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50),
        hire_date DATE,
        job_title VARCHAR(50),
        department_id INT REFERENCES departments(id)
    );
    
    -- Create 'projects' table
    CREATE TABLE projects (
        id SERIAL PRIMARY KEY,
        name VARCHAR(50),
        start_date DATE,
        end_date DATE,
        department_id INT REFERENCES departments(id)
    );
    
    -- Insert data into 'departments'
    INSERT INTO departments (name, manager_id)
    VALUES ('HR', 1), ('IT', 2), ('Sales', 3);
    
    -- Insert data into 'employees'
    INSERT INTO employees (name, hire_date, job_title, department_id)
    VALUES ('John Doe', '2018-06-20', 'HR Manager', 1),
           ('Jane Smith', '2019-07-15', 'IT Manager', 2),
           ('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
           ('Bob Miller', '2021-04-30', 'HR Associate', 1),
           ('Charlie Brown', '2022-10-01', 'IT Associate', 2),
           ('Dave Davis', '2023-03-15', 'Sales Associate', 3);
    
    -- Insert data into 'projects'
    INSERT INTO projects (name, start_date, end_date, department_id)
    VALUES ('HR Project 1', '2023-01-01', '2023-06-30', 1),
           ('IT Project 1', '2023-02-01', '2023-07-31', 2),
           ('Sales Project 1', '2023-03-01', '2023-08-31', 3);
           
           UPDATE departments
    SET manager_id = (SELECT id FROM employees WHERE name = 'John Doe')
    WHERE name = 'HR';
    
    UPDATE departments
    SET manager_id = (SELECT id FROM employees WHERE name = 'Jane Smith')
    WHERE name = 'IT';
    
    UPDATE departments
    SET manager_id = (SELECT id FROM employees WHERE name = 'Alice Johnson')
    WHERE name = 'Sales';
    
    

---

**Query #1**

    SELECT name,
           AGE(end_date , start_date) days
    FROM projects
    GROUP BY name, end_date, start_date
    LIMIT 1;

| name         | days            |
| ------------ | --------------- |
| HR Project 1 | [object Object] |

---
**Query #2**

    SELECT id, 
           name
    FROM employees 
    WHERE job_title NOT LIKE '%Manager%';

| id  | name          |
| --- | ------------- |
| 4   | Bob Miller    |
| 5   | Charlie Brown |
| 6   | Dave Davis    |

---
**Query #3**

    SELECT e.name
    FROM employees e
    JOIN projects p 
    USING (department_id)
    WHERE hire_date > start_date;

| name       |
| ---------- |
| Dave Davis |

---
**Query #4**

    SELECT name,
           hire_date,
           RANK() OVER(ORDER BY hire_date DESC) AS rnk
    FROM employees;

| name          | hire_date                | rnk |
| ------------- | ------------------------ | --- |
| Dave Davis    | 2023-03-15T00:00:00.000Z | 1   |
| Charlie Brown | 2022-10-01T00:00:00.000Z | 2   |
| Bob Miller    | 2021-04-30T00:00:00.000Z | 3   |
| Alice Johnson | 2020-01-10T00:00:00.000Z | 4   |
| Jane Smith    | 2019-07-15T00:00:00.000Z | 5   |
| John Doe      | 2018-06-20T00:00:00.000Z | 6   |

---
**Query #5**

    WITH cte AS (
      SELECT name,
             hire_date,
             RANK() OVER(PARTITION BY department_id ORDER BY hire_date DESC) AS rnk
      FROM employees)
      
    SELECT name,
           hire_date,
           AGE(hire_date, LAG(hire_date) OVER(PARTITION BY rnk)) AS difference
    FROM cte;

| name          | hire_date                | difference      |
| ------------- | ------------------------ | --------------- |
| Bob Miller    | 2021-04-30T00:00:00.000Z |                 |
| Charlie Brown | 2022-10-01T00:00:00.000Z | [object Object] |
| Dave Davis    | 2023-03-15T00:00:00.000Z | [object Object] |
| John Doe      | 2018-06-20T00:00:00.000Z |                 |
| Jane Smith    | 2019-07-15T00:00:00.000Z | [object Object] |
| Alice Johnson | 2020-01-10T00:00:00.000Z | [object Object] |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/xckGL9ZW73A6FWhsmPogm7/66)
