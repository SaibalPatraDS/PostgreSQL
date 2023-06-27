-- WINDOW FUNCTION 

-- FIRST_VALUE, LAST_VALUE, NTH_VALUE, NTILE, CUME_DIST and PERCENT_RANK

-- FIRST_VALUE

-- 1. Find out the most expensive product under each category.
SELECT product_category,
       brand,
	   product_name,
	   price,
      product_rank 
FROM(	  
	SELECT *,
		  RANK() OVER(PARTITION BY product_category ORDER BY price DESC) AS product_rank
	FROM product) p
WHERE p.product_rank = 1 ;



-- 2. Find out the most expensive product under each category corresponding to each category.

SELECT *,
    FIRST_VALUE(product_name) OVER(PARTITION BY product_category ORDER BY price DESC) AS most_exp_product, 
	FIRST_VALUE(price) OVER(PARTITION BY product_category ORDER BY price DESC) AS highest_price
FROM product;

-- FIRST_VALUE() function will take one input and will give the particular output corresponds to every column

-- LAST_VALUE()

-- 3. Find out the least expensive product under each category corresponding each product.

SELECT *,
     LAST_VALUE(product_name) 
	 OVER(PARTITION BY product_category ORDER BY price DESC
		  RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
     AS least_exp_product			  
FROM product;

-- Frame Statement used if not is mentioned

SELECT *,
     LAST_VALUE(product_name) 
	 OVER(PARTITION BY product_category ORDER BY price DESC
		  RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
     AS least_exp_product			  
FROM product;

-- Range between unbounded preceding and current row means the during searching, 
-- the search will be done between prior rows and current rows


SELECT *,
     LAST_VALUE(product_name) 
	 OVER(PARTITION BY product_category ORDER BY price DESC
		  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
     AS least_exp_product			  
FROM product;

-- Difference between ROWS and RANGE frame clause, 
-- if there is duplicate values, ROWS will consider them seperately while RANGE will consider all the duplicate at once. 


-- 4. Alternate ways of writing WINDOW functions

-- Instead of defining OVER() clause for every window_function(), we can define it once and can use it for multiplr times.

SELECT *,
     FIRST_VALUE(product_name) OVER w AS most_exp_product,
	 LAST_VALUE(product_name) OVER w AS least_exp_product
FROM product
WINDOW w AS (PARTITION BY product_category ORDER BY price DESC
			 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);


-- increases readability and less number of functions

-- `NTH_VALUE`

-- 5. Find out the second most expensive product under each category.  

-- nth_value() window function can be used to find out any number/order from result

SELECT *,
     FIRST_VALUE(product_name) OVER w AS most_exp_product,
	 LAST_VALUE(product_name) OVER w AS least_exp_product,
	 NTH_VALUE(product_name, 2) OVER w AS second_most_exp_product
FROM product
WINDOW w AS (PARTITION BY product_category ORDER BY price DESC 
			 RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);

-- LAST_VALUE() and NTH_VALUE() window function need proper FRAMEs to give correct results.


-- `NTILE()` function

-- 6. Write a query to segregate all the expensive phones, mid-range phones and cheaper phones.  

SELECT product_name, 
      CASE 
		  WHEN p.price_cat = 1 THEN 'Expensive Phone'
		  WHEN p.price_cat = 2 THEN 'Mid Range Phone'
		  ELSE 'Cheaper Phone'
	  END AS phone_category
FROM (
	SELECT *,
		  NTILE(3) OVER(ORDER BY price DESC) AS price_cat
	FROM product
	WHERE product_category = 'Phone') p;
	
	
-- 7. Classify the Laptops as per their price range. 

SELECT product_name,
       CASE WHEN brand_cat = 1 THEN 'Expensive Laptop'
	        WHEN brand_cat = 2 THEN 'Mid-Range Laptop'
			ELSE 'Under Budget Laptop'
		END AS product_category
FROM(
	SELECT * ,
		  NTILE(3) OVER(ORDER BY price DESC) AS brand_cat
	FROM product
	WHERE product_category = 'Laptop') p;

-- `NTILE()` function will take one `#num` integer argument, that's the number of classes the rows value should be classifier in.


-- CUME_DIST() // Cumulative Distribution
-- Value of CUME_DIST() can range from (0,1] , 0 ->excluded and 1 -> included
-- calculation of CUME_DIST = current row_number(if duplicate values are there then will consider last row number) / total no of rows

-- 8. Find which product prices are top 30% priced in the whole product list. 

WITH p AS (
	SELECT *,
		 CUME_DIST() OVER(ORDER BY price DESC) AS cume_distribution,
		 ROUND(100 * CUME_DIST() OVER(ORDER BY price DESC)::NUMERIC, 2) AS cume_dist_percentage
	FROM product) 
	
SELECT product_name,
       cume_dist_percentage||'%' AS percentage_Cumulative
FROM p
WHERE cume_dist_percentage <= 30;


-- One of application can be finding the best selling product section and top 20% products(SKUs)


-- PERCENT_RANK()
/*- relative rank of the current row / percentage ranking */
-- PERCENT_RANK() value can range from (0,1] => percent_rank() > 0 and percent_rank() <= 1
/* Formula -> Current Row No - 1 / Total Row No - 1 */

-- 9. How much percentage "Surface Laptop 4" is expensive than other products. 

SELECT product_name, 
       percentage||'%' AS more_expensive_other
FROM (	   
SELECT *,
     PERCENT_RANK() OVER(ORDER BY price) AS percentage_rank,
	 ROUND(100 * PERCENT_RANK() OVER(ORDER BY price)::NUMERIC, 2) AS percentage
FROM product) p
WHERE p.product_name = 'Surface Laptop 4';


/* Not necessarily, every time the PERCENT_RANK() value will be 1 
if there are duplicates in the final rows, 
then first occurance of duplicate values row number will be taken into consideratio n */

SELECT *,
     PERCENT_RANK() OVER(ORDER BY price) AS percentage_rank
FROM product
WHERE price <= 1000;





























































