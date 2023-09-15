**Schema (PostgreSQL v15)**

    CREATE TABLE customers (
        customer_id integer PRIMARY KEY,
        first_name varchar(100),
        last_name varchar(100),
        email varchar(100)
    );
    
    CREATE TABLE products (
        product_id integer PRIMARY KEY,
        product_name varchar(100),
        price decimal
    );
    
    CREATE TABLE orders (
        order_id integer PRIMARY KEY,
        customer_id integer,
        order_date date
    );
    
    CREATE TABLE order_items (
        order_id integer,
        product_id integer,
        quantity integer
    );
    
    INSERT INTO customers (customer_id, first_name, last_name, email) VALUES
    (1, 'John', 'Doe', 'johndoe@email.com'),
    (2, 'Jane', 'Smith', 'janesmith@email.com'),
    (3, 'Bob', 'Johnson', 'bobjohnson@email.com'),
    (4, 'Alice', 'Brown', 'alicebrown@email.com'),
    (5, 'Charlie', 'Davis', 'charliedavis@email.com'),
    (6, 'Eva', 'Fisher', 'evafisher@email.com'),
    (7, 'George', 'Harris', 'georgeharris@email.com'),
    (8, 'Ivy', 'Jones', 'ivyjones@email.com'),
    (9, 'Kevin', 'Miller', 'kevinmiller@email.com'),
    (10, 'Lily', 'Nelson', 'lilynelson@email.com'),
    (11, 'Oliver', 'Patterson', 'oliverpatterson@email.com'),
    (12, 'Quinn', 'Roberts', 'quinnroberts@email.com'),
    (13, 'Sophia', 'Thomas', 'sophiathomas@email.com');
    
    INSERT INTO products (product_id, product_name, price) VALUES
    (1, 'Product A', 10.00),
    (2, 'Product B', 15.00),
    (3, 'Product C', 20.00),
    (4, 'Product D', 25.00),
    (5, 'Product E', 30.00),
    (6, 'Product F', 35.00),
    (7, 'Product G', 40.00),
    (8, 'Product H', 45.00),
    (9, 'Product I', 50.00),
    (10, 'Product J', 55.00),
    (11, 'Product K', 60.00),
    (12, 'Product L', 65.00),
    (13, 'Product M', 70.00);
    
    INSERT INTO orders (order_id, customer_id, order_date) VALUES
    (1, 1, '2023-05-01'),
    (2, 2, '2023-05-02'),
    (3, 3, '2023-05-03'),
    (4, 1, '2023-05-04'),
    (5, 2, '2023-05-05'),
    (6, 3, '2023-05-06'),
    (7, 4, '2023-05-07'),
    (8, 5, '2023-05-08'),
    (9, 6, '2023-05-09'),
    (10, 7, '2023-05-10'),
    (11, 8, '2023-05-11'),
    (12, 9, '2023-05-12'),
    (13, 10, '2023-05-13'),
    (14, 11, '2023-05-14'),
    (15, 12, '2023-05-15'),
    (16, 13, '2023-05-16');
    
    INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 1, 2),
    (1, 2, 1),
    (2, 2, 1),
    (2, 3, 3),
    (3, 1, 1),
    (3, 3, 2),
    (4, 2, 4),
    (4, 3, 1),
    (5, 1, 1),
    (5, 3, 2),
    (6, 2, 3),
    (6, 1, 1),
    (7, 4, 1),
    (7, 5, 2),
    (8, 6, 3),
    (8, 7, 1),
    (9, 8, 2),
    (9, 9, 1),
    (10, 10, 3),
    (10, 11, 2),
    (11, 12, 1),
    (11, 13, 3),
    (12, 4, 2),
    (12, 5, 1),
    (13, 6, 3),
    (13, 7, 2),
    (14, 8, 1),
    (14, 9, 2),
    (15, 10, 3),
    (15, 11, 1),
    (16, 12, 2),
    (16, 13, 3);
    

---

**Query #1**

    SELECT product_name,
           MAX(price) AS highest_price
    FROM products
    GROUP BY product_name
    ORDER BY highest_price DESC
    LIMIT 1;

| product_name | highest_price |
| ------------ | ------------- |
| Product M    | 70.00         |

---
**Query #2**

    SELECT c.customer_id,
           first_name || ' ' || last_name AS name,
           COUNT(order_id) AS total_orders
    FROM customers c 
    JOIN orders o 
    USING (customer_id)
    GROUP BY c.customer_id
    ORDER BY total_orders DESC
    LIMIT 1;

| customer_id | name       | total_orders |
| ----------- | ---------- | ------------ |
| 2           | Jane Smith | 2            |

---
**Query #3**

    SELECT p.product_id,
           product_name,
           SUM(price * quantity) AS total_revenue
    FROM products p 
    JOIN order_items i 
    USING (product_id) 
    GROUP BY product_id, product_name
    ORDER BY product_id;

| product_id | product_name | total_revenue |
| ---------- | ------------ | ------------- |
| 1          | Product A    | 50.00         |
| 2          | Product B    | 135.00        |
| 3          | Product C    | 160.00        |
| 4          | Product D    | 75.00         |
| 5          | Product E    | 90.00         |
| 6          | Product F    | 210.00        |
| 7          | Product G    | 120.00        |
| 8          | Product H    | 135.00        |
| 9          | Product I    | 150.00        |
| 10         | Product J    | 330.00        |
| 11         | Product K    | 180.00        |
| 12         | Product L    | 195.00        |
| 13         | Product M    | 420.00        |

---
**Query #4**

    SELECT TO_CHAR(order_date, 'YYYY-MM-DD') AS order_date,
           SUM(quantity * price) AS total_revenue
    FROM orders o 
    JOIN order_items i
    USING (order_id) 
    JOIN products p 
    USING (product_id) 
    GROUP BY order_date
    ORDER BY total_revenue DESC
    LIMIT 1;

| order_date | total_revenue |
| ---------- | ------------- |
| 2023-05-16 | 340.00        |

---
**Query #5**

    with first_order AS (
      SELECT c.customer_id,
             TO_CHAR(order_date, 'YYYY-MM-DD') AS order_date,
             RANK() OVER(PARTITION BY c.customer_id ORDER BY order_date) AS rnk
      FROM customers c
      JOIN orders o 
      USING (customer_id))
      
     SELECT customer_id,
            order_date
     FROM first_order 
     WHERE rnk = 1;

| customer_id | order_date |
| ----------- | ---------- |
| 1           | 2023-05-01 |
| 2           | 2023-05-02 |
| 3           | 2023-05-03 |
| 4           | 2023-05-07 |
| 5           | 2023-05-08 |
| 6           | 2023-05-09 |
| 7           | 2023-05-10 |
| 8           | 2023-05-11 |
| 9           | 2023-05-12 |
| 10          | 2023-05-13 |
| 11          | 2023-05-14 |
| 12          | 2023-05-15 |
| 13          | 2023-05-16 |

---
**Query #6**

    SELECT c.customer_id,
           STRING_AGG(DISTINCT product_name, ', ') AS products,
           COUNT(DISTINCT p.product_id) AS total_distinct_items
    FROM customers c 
    JOIN orders o 
    USING (customer_id)
    JOIN order_items i 
    USING (order_id)
    JOIN products p 
    USING (product_id) 
    GROUP BY c.customer_id
    ORDER BY total_distinct_items DESC
    LIMIT 3;

| customer_id | products                        | total_distinct_items |
| ----------- | ------------------------------- | -------------------- |
| 2           | Product A, Product B, Product C | 3                    |
| 3           | Product A, Product B, Product C | 3                    |
| 1           | Product A, Product B, Product C | 3                    |

---
**Query #7**

    SELECT p.product_id,
           product_name,
           COUNT(quantity) AS total_quantity
    FROM order_items i 
    JOIN products p 
    USING (product_id) 
    GROUP BY p.product_id, product_name
    ORDER BY total_quantity
    LIMIT 1;

| product_id | product_name | total_quantity |
| ---------- | ------------ | -------------- |
| 4          | Product D    | 2              |

---
**Query #8**

    SELECT PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY price) AS median_price
    FROM products;

| median_price |
| ------------ |
| 40           |

---
**Query #9**

    SELECT order_id,
           SUM(price * quantity) AS total_order_value,
           CASE WHEN SUM(price * quantity) > 300 THEN 'Expensive'
           WHEN SUM(price * quantity) > 100 THEN 'Affordable' 
           ELSE 'Cheap' END AS ordering_of_orders
    FROM order_items i 
    JOIN products p 
    USING (product_id)
    GROUP BY order_id;

| order_id | total_order_value | ordering_of_orders |
| -------- | ----------------- | ------------------ |
| 11       | 275.00            | Affordable         |
| 9        | 140.00            | Affordable         |
| 15       | 225.00            | Affordable         |
| 3        | 50.00             | Cheap              |
| 5        | 50.00             | Cheap              |
| 4        | 80.00             | Cheap              |
| 10       | 285.00            | Affordable         |
| 6        | 55.00             | Cheap              |
| 14       | 145.00            | Affordable         |
| 13       | 185.00            | Affordable         |
| 2        | 75.00             | Cheap              |
| 16       | 340.00            | Expensive          |
| 7        | 85.00             | Cheap              |
| 12       | 80.00             | Cheap              |
| 1        | 35.00             | Cheap              |
| 8        | 145.00            | Affordable         |

---
**Query #10**

    SELECT c.customer_id,
           first_name || ' ' || last_name AS name,
           price
    FROM customers c 
    JOIN orders o 
    USING (customer_id)
    JOIN order_items i
    USING (order_id)
    JOIN products p 
    USING (product_id)
    WHERE price = (SELECT MAX(price) 
                   FROM products);

| customer_id | name          | price |
| ----------- | ------------- | ----- |
| 8           | Ivy Jones     | 70.00 |
| 13          | Sophia Thomas | 70.00 |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/5NT4w4rBa1cvFayg2CxUjr/271)
