-- Query 1:

/*Write a SQL query to fetch all the duplicate records from a table.*/

--Tables Structure:

drop table IF EXISTS users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

SELECT * 
FROM (
SELECT user_id, user_name, email, 
       ROW_NUMBER() OVER(PARTITION BY user_name, email) AS rn
FROM users) AS sub
WHERE rn >1;	



-- Query 2:

/*Write a SQL query to fetch the second last record from a employee table.*/

--Tables Structure:

drop table IF EXISTS employee;
create table employee
( emp_ID int primary key
, emp_NAME varchar(50) not null
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);

-- Query 2:

/*Write a SQL query to fetch the second last record from a employee table.*/

SELECT * FROM employee
ORDER BY emp_ID;

SELECT emp_ID, emp_name, dept_name, salary
FROM (
SELECT *,
       ROW_NUMBER() OVER(ORDER BY emp_ID DESC) AS rn
FROM employee) AS sub
WHERE rn = 2;	

--- alternate solution
SELECT emp_ID, emp_name, dept_name, salary
FROM (
SELECT *,
       ROW_NUMBER() OVER(ORDER BY emp_ID DESC) AS rn
FROM employee) AS sub
WHERE rn > 1
LIMIT 1;	
