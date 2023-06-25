-- Runner and Customer Experience


-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- step 1 : filter the weeks from registration date
-- step 2 : GROUP BY each week to find out total no of sign ups

SELECT date_trunc('week', registration_date) AS Start_of_Week, 
       COUNT(runner_id) AS Total_Runner
FROM pizza_runner.runners
GROUP BY start_of_week;

-- SELECT
--   date_trunc('week', registration_date) AS start_of_week,
--   COUNT(DISTINCT runner_id) AS total_runners
-- FROM pizza_runner.runners
-- GROUP BY start_of_week
-- ORDER BY start_of_week;


-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- step 1 : order_time given in customer_orders and pickup_time given in runner_orders, 
-- step 2 : time_taken = pickup_time - order_time
-- step 3 : select all order_id and perform INNER JOIN
-- step 4 : using subquery, calculate the average time taken

SELECT runner_id,
       ROUND(AVG(total_reaching_time)/60 , 2) AS avg_time
FROM(
SELECT ro.runner_id, 
       (EXTRACT(EPOCH FROM ro.pickup_time::timestamp) - EXTRACT(EPOCH FROM co.order_time::timestamp)) AS total_reaching_time
FROM pizza_runner.customer_orders co
INNER JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id) p
GROUP BY runner_id
ORDER BY runner_id;


-- another approach [using CTE]
WITH temp AS (
SELECT runner_id,
       EXTRACT(EPOCH FROM AGE(ro.pickup_time::timestamp, co.order_time::timestamp)) AS total_time
FROM pizza_runner.customer_orders co
INNER JOIN pizza_runner.runner_orders ro
ON ro.order_id = co.order_id) 


SELECT runner_id,
       ROUND(AVG(total_time)/60, 2) AS avg_reaching_time 
FROM temp
GROUP BY runner_id
ORDER BY runner_id;


-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- step 1 : filter count of order_id 
-- step 2 : based on order_id calculate individual preparation time

SELECT order_id,
       COUNT(order_id) total_items_ordered,
	   ROUND(AVG(order_preparation_time),2) order_time
FROM(
SELECT ro.order_id,
       ROUND(EXTRACT(EPOCH FROM AGE(ro.pickup_time::timestamp, co.order_time::timestamp))/60, 2) AS order_preparation_time
FROM pizza_runner.customer_orders co
INNER JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id
ORDER BY order_id) p
JOIN pizza_runner.runner_orders ro
USING (order_id)
WHERE ro.cancellation IS NULL
GROUP BY order_id;


-- step 1 : for each order id count total no of orders
-- step 2 : calculate time_taken, time_taken = AVG(pickup_time - order_time)
-- step 3 : make sure cancellation IS NOT NULL

SELECT ro.order_id,
       COUNT(ro.order_id) AS total_items_ordered,
	   ROUND(AVG(EXTRACT(EPOCH FROM AGE(ro.pickup_time::timestamp, co.order_time::timestamp))/60), 2) AS order_receiving_time
FROM pizza_runner.runner_orders ro
JOIN pizza_runner.customer_orders co USING (order_id)
WHERE ro.cancellation IS NULL
GROUP BY ro.order_id;
 

-- 4. What was the average distance travelled for each customer?

-- step 1 : filter distance for each order_id, and customer_id
-- step 2 : make sure cancellation IS NULL
-- step 3 : calculate distance using runner_orders and customer_orders table

SELECT ro.order_id,
       co.customer_id,
       AVG(ro.distance::FLOAT)::NUMERIC AS avg_distance_travelled
FROM pizza_runner.runner_orders ro 
INNER JOIN pizza_runner.customer_orders co
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
GROUP BY ro.order_id, co.customer_id;




-- 5.What was the difference between the longest and shortest delivery times for all orders?

-- step 1 : calculate difference between shortest and longest delivery_time

SELECT MAX(duration) max_delivery_time,
       MIN(duration) min_delivery_time,
	   MAX(duration::NUMERIC) - MIN(duration::NUMERIC) max_delivery_time_difference
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL;

SELECT * FROM pizza_runner.runner_orders;

-- NOTE : `CAST(ro.duration AS numeric)` to convert `ro.duration` from double precision to numeric 
-- before calculating the average and rounding it to 2 decimal places using the `ROUND()` function.

-- SELECT ro.order_id,
--        COUNT(ro.order_id),
--        ROUND(SUM(ro.duration::FLOAT)::NUMERIC, 2) AS avg_delivery_time
-- FROM pizza_runner.runner_orders ro
-- INNER JOIN pizza_runner.customer_orders co
-- USING (order_id)
-- WHERE ro.cancellation IS NULL
-- GROUP BY ro.order_id;


-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

-- step 1 : avg_speed = total_distance/duration

SELECT runner_id, 
       order_id,
	   ROUND(AVG((distance::NUMERIC/duration::NUMERIC)) * 60, 2) AS avg_speed_km_per_hour
FROM pizza_runner.runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id, order_id;


-- 7. What is the successful delivery percentage for each runner?

-- step 1 : sucessful_delivery = total_delivery_without_cancel/total_delivery
-- step 2 : once an order is picked up, it will be delivered
SELECT runner_id,
       COUNT(pickup_time) AS sucessfully_delivered,
	   COUNT(order_id) AS total_orders,
	   ROUND(100 * COUNT(pickup_time)/COUNT(order_id), 2) AS total_delivery
FROM pizza_runner.runner_orders
GROUP BY runner_id
ORDER BY runner_id;

























