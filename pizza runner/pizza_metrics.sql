-- A. Pizza Metrics

-- 1. How many pizzas were ordered?

SELECT COUNT(pizza_id) AS total_pizza_ordered 
FROM customer_orders;

-- 2. How many unique customer orders were made?

SELECT COUNT(DISTINCT order_id) AS unique_customer
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, 
       COUNT(order_id) AS total_order_delivered 
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. How many of each type of pizza was delivered?

SELECT co.pizza_id, pn.pizza_name, COUNT(co.pizza_id) AS no_of_pizzas
FROM pizza_runner.customer_orders AS co
JOIN (
SELECT pizza_id, pizza_name
FROM pizza_runner.pizza_names) AS pn 
ON pn.pizza_id = co.pizza_id
GROUP BY co.pizza_id, pn.pizza_name
ORDER BY no_of_pizzas DESC;


-- 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT co.customer_id, pn.pizza_name, COUNT(co.pizza_id) AS total_pizza_ordered
FROM pizza_runner.customer_orders co
LEFT JOIN pizza_runner.pizza_names pn 
ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id, pn.pizza_name
ORDER BY co.customer_id;


-- 6. What was the maximum number of pizzas delivered in a single order?

SELECT customer_id, 
       order_id, 
	   COUNT(order_id) AS pizza_count
FROM pizza_runner.customer_orders
GROUP BY order_id, customer_id
ORDER BY pizza_count DESC 
LIMIT 1;


-- 7. For each customer, how many delivered pizzas had at least 1 change and 
--    how many had no changes?

-- step 1 : exclusion is not null or extras are not null 
-- step 2 : exclusion is null and eztras are null 
-- step 3 : order is not cancelled.

SELECT customer_id, 
       SUM(CASE 
			   WHEN (exclusions IS NOT NULL 
			   OR   extras IS NOT NULL) THEN 1
		   ELSE 0
		  END) AS change_done,
	   SUM(CASE 
				WHEN (exclusions IS NULL 
				AND extras IS NULL) THEN 1
		  ELSE 0
		  END) AS no_change_done
FROM pizza_runner.customer_orders co
JOIN pizza_runner.runner_orders ro 
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY customer_id;


-- 8. How many pizzas were delivered that had both exclusions and extras?

-- step 1: exclusion is not null and extras is not null
-- step 2: not cancelled
-- step 3: group by order id
-- step 4: using subquery to get the customer_id and exact column 

SELECT customer_id, 
       both_exclusion_extra
FROM(	   
SELECT co.customer_id AS customer_id, co.order_id,
       SUM(CASE 
		  WHEN (co.exclusions IS NOT NULL 
             AND co.extras IS NOT NULL) THEN 1
		  ELSE 0
		  END) AS both_exclusion_extra
FROM pizza_runner.customer_orders co
JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY co.order_id,co.customer_id) AS p
WHERE both_exclusion_extra >= 1;


-- 9.What was the total volume of pizzas ordered for each hour of the day?

-- step 1:convert the timestamp into hour only
-- step 2:filter corresponding COUNT(order_id) AS total_pizza
-- step 3:group by hour only to count total_pizza per hour
SELECT hour_only, total_pizza,
       Volume_of_pizza
FROM(
SELECT COUNT(order_id) AS total_pizza, 
       EXTRACT(HOUR FROM order_time) AS hour_only,
	   ROUND(100 * COUNT(order_id)/SUM(COUNT(order_id)) OVER(), 2) AS Volume_of_Pizza
FROM pizza_runner.customer_orders
GROUP BY hour_only) AS p
ORDER BY hour_only;

-- 10. What was the volume of orders for each day of the week?

-- step 1: convert the datetime column to date_only
-- step 2: count total order per day, COUNT(order_id) 
-- step 3: groupby date_only

-- [MySQL]The DAYOFWEEK() function returns the weekday index for a given date ( 1=Sunday, 2=Monday, 3=Tuesday, 4=Wednesday, 5=Thursday, 6=Friday, 7=Saturday )
-- [MySQL]DAYNAME() returns the name of the week day

-- [PostgreSQL] `TO_CHAR(datetime_col, 'Dy')` returns the dayname

SELECT TO_CHAR(order_time, 'Dy') AS day_only,
       COUNT(order_id) AS total_order,
	   ROUND(100 * COUNT(order_id)/SUM(COUNT(order_id)) OVER(), 2) AS VOLUME_of_pizza
FROM pizza_runner.customer_orders
GROUP BY day_only
ORDER BY day_only;

-- SELECT EXTRACT(HOUR FROM order_time), order_time FROM pizza_runner.customer_orders;



















