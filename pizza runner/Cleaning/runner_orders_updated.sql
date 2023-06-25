-- Update `runner_orders` table

DROP TABLE IF EXISTS pizza_runner.runner_orders_updated;

CREATE TEMPORARY TABLE runner_orders_updated AS
SELECT order_id,
       runner_id,
	   CASE 
		   WHEN pickup_time LIKE 'null' THEN NULL
		   ELSE pickup_time
	   END AS pickup_time,
	   CASE 
		   WHEN distance LIKE 'null' THEN NULL
		   ELSE CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
	   END AS distance,
	   CASE 
		   WHEN duration LIKE 'null' THEN NULL
		   ELSE CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
	   END AS duration,
	   CASE 
		   WHEN cancellation = '' THEN NULL
		   WHEN cancellation = 'NaN' THEN NULL
		   WHEN cancellation = 'null' THEN NULL
		   ELSE cancellation
	   END AS cancellation
FROM pizza_runner.runner_orders;

SELECT * FROM runner_orders_updated;