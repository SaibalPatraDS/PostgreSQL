# Case Study Analysis

## Case Study Questions
The following questions can be considered key business questions and metrics that the Balanced Tree team requires for their monthly reports.

Each question can be answered using a single query - but as you are writing the SQL to solve each individual problem, 
keep in mind how you would generate all of these metrics in a single SQL script which the Balanced Tree team can run each month.


## 1. High Level Sales Analysis 
-----
1.1 What was the total quantity sold for all products?

---

**Query #1**

    SELECT SUM(qty) AS total_quantity
    FROM balanced_tree.sales;

| total_quantity |
| -------------- |
| 45216          |

---

1.2 What is the total generated revenue for all products before discounts?

---
**Query #2**

    SELECT ROUND(SUM(qty * price)/10E5, 2)|| ' M' AS total_revenue
    FROM balanced_tree.sales;

| total_revenue |
| ------------- |
| 1.29 M        |

---

1.3 What was the total discount amount for all products?

---
**Query #3**

    SELECT ROUND(SUM(qty * price * discount)/10E1, 3) AS total_discount
    FROM balanced_tree.sales;

| total_discount |
| -------------- |
| 156229.140     |

---

## 2. Transaction Analysis

----
2.1 How many unique transactions were there?

---
**Query #4**

    SELECT COUNT(DISTINCT txn_id) AS total_unique_txn
    FROM balanced_tree.sales;

| total_unique_txn |
| ---------------- |
| 2500             |

---

2.2 What is the average unique products purchased in each transaction?

---
**Query #5**

    SELECT product_name,
           ROUND(AVG(qty)::NUMERIC, 0) AS avg_no_of_products
    
    
    
    FROM balanced_tree.sales s
    INNER JOIN balanced_tree.product_details p 
    ON p.product_id = s.prod_id
    GROUP BY product_name;

| product_name                     | avg_no_of_products |
| -------------------------------- | ------------------ |
| White Tee Shirt - Mens           | 3                  |
| Navy Solid Socks - Mens          | 3                  |
| Grey Fashion Jacket - Womens     | 3                  |
| Navy Oversized Jeans - Womens    | 3                  |
| Pink Fluro Polkadot Socks - Mens | 3                  |
| Khaki Suit Jacket - Womens       | 3                  |
| Black Straight Jeans - Womens    | 3                  |
| White Striped Socks - Mens       | 3                  |
| Blue Polo Shirt - Mens           | 3                  |
| Indigo Rain Jacket - Womens      | 3                  |
| Cream Relaxed Jeans - Womens     | 3                  |
| Teal Button Up Shirt - Mens      | 3                  |

---

2.3 What are the 25th, 50th and 75th percentile values for the revenue per transaction?

---
**Query #6**

    WITH revenue AS (
    	SELECT prod_id,
    		   (qty * price) AS revenue
    	FROM balanced_tree.sales)
    
    SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue) AS twenty_fifth_percentile,
           PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY revenue) AS fiftyth_percentile,
    	   PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY revenue) AS seventy_fifth_percentile
    FROM revenue;

| twenty_fifth_percentile | fiftyth_percentile | seventy_fifth_percentile |
| ----------------------- | ------------------ | ------------------------ |
| 38                      | 65                 | 38                       |

---

2.4 What is the average discount value per transaction?

---
**Query #7**

    SELECT ROUND(AVG(price * discount)/10E1, 2) AS avg_discount
    FROM balanced_tree.sales;

| avg_discount |
| ------------ |
| 3.45         |

---

2.5 What is the percentage split of all transactions for members vs non-members?

---
**Query #8**

    SELECT CASE WHEN member = 'false' THEN 'Non-Member' ELSE 'Member' END AS member_status,
           COUNT(DISTINCT txn_id) AS total_transactions,
    	   ROUND(COUNT(DISTINCT txn_id)::NUMERIC * 100 /(SELECT COUNT(DISTINCT txn_id) FROM balanced_tree.sales), 2) AS perc_transactions
    FROM balanced_tree.sales
    GROUP BY member;

| member_status | total_transactions | perc_transactions |
| ------------- | ------------------ | ----------------- |
| Non-Member    | 995                | 39.80             |
| Member        | 1505               | 60.20             |

---

2.6 What is the average revenue for member transactions and non-member transactions?

---
**Query #9**

    SELECT CASE WHEN member = 'false' THEN 'Non-Member' ELSE 'Member' END AS member_status, 
           ROUND(AVG(qty * price), 2) AS avg_revenue
    FROM balanced_tree.sales
    GROUP BY member;

| member_status | avg_revenue |
| ------------- | ----------- |
| Non-Member    | 84.93       |
| Member        | 85.75       |

---

## 3. Product Analysis
----

3.1 What are the top 3 products by total revenue before discount?

---
**Query #10**

    SELECT p.product_name,
           SUM(qty * s.price) AS revenue
    FROM balanced_tree.sales s
    INNER JOIN balanced_tree.product_details p 
    ON p.product_id = s.prod_id
    GROUP BY p.product_name
    ORDER BY revenue DESC
    LIMIT 3;

| product_name                 | revenue |
| ---------------------------- | ------- |
| Blue Polo Shirt - Mens       | 217683  |
| Grey Fashion Jacket - Womens | 209304  |
| White Tee Shirt - Mens       | 152000  |

---

3.2 What is the total quantity, revenue and discount for each segment?

---
**Query #11**

    SELECT segment_id,
           segment_name,
           SUM(qty) AS total_quantity,
    	   SUM(qty * p.price) AS total_revenue,
    	   ROUND(SUM(qty * p.price * discount)/10E1, 2) AS discount
    FROM balanced_tree.sales s
    JOIN balanced_tree.product_details p 
    ON s.prod_id = p.product_id
    GROUP BY segment_id, segment_name;

| segment_id | segment_name | total_quantity | total_revenue | discount |
| ---------- | ------------ | -------------- | ------------- | -------- |
| 4          | Jacket       | 11385          | 366983        | 44277.46 |
| 6          | Socks        | 11217          | 307977        | 37013.44 |
| 5          | Shirt        | 11265          | 406143        | 49594.27 |
| 3          | Jeans        | 11349          | 208350        | 25343.97 |

---

3.3 What is the top selling product for each segment?

---
**Query #12**

    WITH best_selling_product AS (
    	SELECT segment_name, 
    		   style_name,
    		   SUM(qty) AS total_quantity,
    	       DENSE_RANK() OVER(PARTITION BY segment_name ORDER BY SUM(qty) DESC) AS d_rnk
    
    	FROM balanced_tree.sales s 
    	INNER JOIN balanced_tree.product_details p 
    	ON p.product_id = s.prod_id
    	GROUP BY segment_name, style_name)
    	
    SELECT segment_name, 
           style_name,
    	   total_quantity
    FROM best_selling_product
    WHERE d_rnk = 1;

| segment_name | style_name     | total_quantity |
| ------------ | -------------- | -------------- |
| Jacket       | Grey Fashion   | 3876           |
| Jeans        | Navy Oversized | 3856           |
| Shirt        | Blue Polo      | 3819           |
| Socks        | Navy Solid     | 3792           |

---
3.4 What is the total quantity, revenue and discount for each category?

---
**Query #13**

    SELECT category_id,
           category_name,
           SUM(qty) AS total_quantity,
    	   SUM(qty * p.price) AS total_revenue,
    	   ROUND(SUM(qty * p.price * discount)/10E1, 2) AS discount
    FROM balanced_tree.sales s
    JOIN balanced_tree.product_details p 
    ON s.prod_id = p.product_id
    GROUP BY category_id, category_name;

| category_id | category_name | total_quantity | total_revenue | discount |
| ----------- | ------------- | -------------- | ------------- | -------- |
| 2           | Mens          | 22482          | 714120        | 86607.71 |
| 1           | Womens        | 22734          | 575333        | 69621.43 |

---

3.5 What is the top selling product for each category?

---
**Query #14**

    WITH best_selling_product AS (
    	SELECT category_name, 
    		   style_name,
    		   SUM(qty) AS total_quantity,
    	       DENSE_RANK() OVER(PARTITION BY category_name ORDER BY SUM(qty) DESC) AS d_rnk
    
    	FROM balanced_tree.sales s 
    	INNER JOIN balanced_tree.product_details p 
    	ON p.product_id = s.prod_id
    	GROUP BY category_name, style_name)
    	
    SELECT category_name, 
           style_name,
    	   total_quantity
    FROM best_selling_product
    WHERE d_rnk = 1;

| category_name | style_name   | total_quantity |
| ------------- | ------------ | -------------- |
| Mens          | Blue Polo    | 3819           |
| Womens        | Grey Fashion | 3876           |

---

3.6 What is the percentage split of revenue by product for each segment?

---
**Query #15**

    SELECT segment_name,
           product_name, 
           SUM(qty * p.price) AS revenue,
    
    	   ROUND(SUM(qty * p.price) / SUM(SUM(qty * p.price)) OVER (PARTITION BY segment_name) * 100, 2) AS percentage_segment_revenue
    FROM balanced_tree.sales s 
    INNER JOIN balanced_tree.product_details p 
    ON s.prod_id = p.product_id 
    GROUP BY product_name, segment_name
    ORDER BY segment_name, percentage_segment_revenue DESC;

| segment_name | product_name                     | revenue | percentage_segment_revenue |
| ------------ | -------------------------------- | ------- | -------------------------- |
| Jacket       | Grey Fashion Jacket - Womens     | 209304  | 57.03                      |
| Jacket       | Khaki Suit Jacket - Womens       | 86296   | 23.51                      |
| Jacket       | Indigo Rain Jacket - Womens      | 71383   | 19.45                      |
| Jeans        | Black Straight Jeans - Womens    | 121152  | 58.15                      |
| Jeans        | Navy Oversized Jeans - Womens    | 50128   | 24.06                      |
| Jeans        | Cream Relaxed Jeans - Womens     | 37070   | 17.79                      |
| Shirt        | Blue Polo Shirt - Mens           | 217683  | 53.60                      |
| Shirt        | White Tee Shirt - Mens           | 152000  | 37.43                      |
| Shirt        | Teal Button Up Shirt - Mens      | 36460   | 8.98                       |
| Socks        | Navy Solid Socks - Mens          | 136512  | 44.33                      |
| Socks        | Pink Fluro Polkadot Socks - Mens | 109330  | 35.50                      |
| Socks        | White Striped Socks - Mens       | 62135   | 20.18                      |

---
3.7 What is the percentage split of revenue by segment for each category?

---
**Query #16**

    WITH pct_split AS (
    	SELECT segment_name,
    		   product_name, 
    		   SUM(qty * p.price) AS revenue,
    		   SUM(SUM(qty * p.price)) OVER(PARTITION BY segment_name) AS segment_revenue
    
    	FROM balanced_tree.sales s 
    	INNER JOIN balanced_tree.product_details p 
    	ON s.prod_id = p.product_id 
    	GROUP BY product_name, segment_name
    	)
    
    SELECT segment_name,
    	   product_name, 
    	   ROUND(revenue::NUMERIC * 100/segment_revenue, 2) AS pct_segment_revenue
    FROM pct_split
    ORDER BY segment_name, pct_segment_revenue DESC;

| segment_name | product_name                     | pct_segment_revenue |
| ------------ | -------------------------------- | ------------------- |
| Jacket       | Grey Fashion Jacket - Womens     | 57.03               |
| Jacket       | Khaki Suit Jacket - Womens       | 23.51               |
| Jacket       | Indigo Rain Jacket - Womens      | 19.45               |
| Jeans        | Black Straight Jeans - Womens    | 58.15               |
| Jeans        | Navy Oversized Jeans - Womens    | 24.06               |
| Jeans        | Cream Relaxed Jeans - Womens     | 17.79               |
| Shirt        | Blue Polo Shirt - Mens           | 53.60               |
| Shirt        | White Tee Shirt - Mens           | 37.43               |
| Shirt        | Teal Button Up Shirt - Mens      | 8.98                |
| Socks        | Navy Solid Socks - Mens          | 44.33               |
| Socks        | Pink Fluro Polkadot Socks - Mens | 35.50               |
| Socks        | White Striped Socks - Mens       | 20.18               |

---

3.8 What is the percentage split of total revenue by category?

---

**Query #17**

    SELECT category_name,
           segment_name, 
           SUM(qty * p.price) AS revenue,
    
    	   ROUND(SUM(qty * p.price) / SUM(SUM(qty * p.price)) OVER (PARTITION BY category_name) * 100, 2) AS percentage_category_revenue
    FROM balanced_tree.sales s 
    INNER JOIN balanced_tree.product_details p 
    ON s.prod_id = p.product_id 
    GROUP BY segment_name, category_name
    ORDER BY category_name, percentage_category_revenue DESC;

| category_name | segment_name | revenue | percentage_category_revenue |
| ------------- | ------------ | ------- | --------------------------- |
| Mens          | Shirt        | 406143  | 56.87                       |
| Mens          | Socks        | 307977  | 43.13                       |
| Womens        | Jacket       | 366983  | 63.79                       |
| Womens        | Jeans        | 208350  | 36.21                       |

---

**Alternative**

**Query #18**

    WITH pct_split AS (
    	SELECT category_name,
    		   segment_name,
    		   SUM(qty * p.price) AS revenue,
    		   SUM(SUM(qty * p.price)) OVER(PARTITION BY category_name) AS category_revenue
    
    	FROM balanced_tree.sales s 
    	INNER JOIN balanced_tree.product_details p 
    	ON s.prod_id = p.product_id 
    	GROUP BY segment_name, category_name
    	)
    
    SELECT category_name,
    	   segment_name, 
    	   revenue,
    	   ROUND(revenue::NUMERIC * 100/category_revenue, 2) AS pct_segment_revenue
    FROM pct_split
    ORDER BY category_name, pct_segment_revenue DESC;

| category_name | segment_name | revenue | pct_segment_revenue |
| ------------- | ------------ | ------- | ------------------- |
| Mens          | Shirt        | 406143  | 56.87               |
| Mens          | Socks        | 307977  | 43.13               |
| Womens        | Jacket       | 366983  | 63.79               |
| Womens        | Jeans        | 208350  | 36.21               |

---

3.9 What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)

---
**Query #20**

    WITH prod_purchased AS (
    	SELECT s.txn_id,
    	       p.product_id,
    		   p.product_name,
    	
    		   SUM(qty) AS quantity
    	FROM balanced_tree.sales s
    	RIGHT JOIN balanced_tree.product_details p 
    	ON p.product_id = s.prod_id
    	GROUP BY s.txn_id, p.product_name, p.product_id
    	ORDER BY txn_id),
    
    penetration_cal AS (
    	SELECT txn_id,
    		   product_name,
    		   CASE WHEN quantity >= 1 THEN 1 ELSE 0 END AS penetration_index
    	FROM prod_purchased)
    
    SELECT product_name,
           ROUND(100.0 * SUM(penetration_index)::NUMERIC/ (SELECT COUNT(DISTINCT txn_id) FROM balanced_tree.sales), 2) AS penetration
    FROM penetration_cal
    GROUP BY product_name;

| product_name                     | penetration |
| -------------------------------- | ----------- |
| White Tee Shirt - Mens           | 50.72       |
| Navy Solid Socks - Mens          | 51.24       |
| Grey Fashion Jacket - Womens     | 51.00       |
| Navy Oversized Jeans - Womens    | 50.96       |
| Pink Fluro Polkadot Socks - Mens | 50.32       |
| Khaki Suit Jacket - Womens       | 49.88       |
| Black Straight Jeans - Womens    | 49.84       |
| White Striped Socks - Mens       | 49.72       |
| Blue Polo Shirt - Mens           | 50.72       |
| Indigo Rain Jacket - Womens      | 50.00       |
| Cream Relaxed Jeans - Womens     | 49.72       |
| Teal Button Up Shirt - Mens      | 49.68       |

---

3.10 What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?

--- 
Hint - 1. Select transaction_id and product_name combination
       2. Create combination of products on the available list of products
       3. Count total combinations for each combination
       4. Filter only the top result
---
**Query #21**

    WITH product_purchased AS (
    	SELECT s.txn_id,
    		   p.product_name
    	FROM balanced_tree.sales s
    	JOIN balanced_tree.product_details p 
    	ON s.prod_id = p.product_id),
    
    product_combination AS (
    	SELECT DISTINCT txn_id,
    		   p1.product_name AS product1,
    		   p2.product_name AS product2,
    		   p3.product_name AS product3
    	FROM product_purchased p1
    	JOIN product_purchased p2
    	USING (txn_id)
    	JOIN product_purchased p3
    	USING (txn_id)
    	WHERE p1.product_name < p2.product_name
    	  AND p2.product_name  < p3.product_name),
    
    combination_counts AS (
    	SELECT product1,
    		   product2,
    		   product3,
    		   COUNT(*) AS combination
    	FROM product_combination
    	GROUP BY product1, product2, product3
    	ORDER BY combination DESC)
    
    SELECT product1, product2, product3, combination
    FROM combination_counts
    LIMIT 1;

| product1                     | product2                    | product3               | combination |
| ---------------------------- | --------------------------- | ---------------------- | ----------- |
| Grey Fashion Jacket - Womens | Teal Button Up Shirt - Mens | White Tee Shirt - Mens | 352         |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/dkhULDEjGib3K58MvDjYJr/61)
