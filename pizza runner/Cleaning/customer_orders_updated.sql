-- Clean `customer_orders` data

DROP TABLE IF EXISTS customer_orders_updated;

CREATE TEMPORARY TABLE customer_orders_updated AS 
SELECT order_id,
       customer_id,
	   pizza_id,
	   CASE 
	       WHEN exclusions = '' THEN NULL
		   WHEN exclusions = 'null' THEN NULL
		   ELSE exclusions
	   END AS exclusions,
	   CASE 
	       WHEN extras = '' THEN NULL
		   WHEN extras = 'NaN' THEN NULL
		   WHEN extras = 'null' THEN NULL
		   ELSE extras
	   END AS extras,
	   order_time
FROM pizza_runner.customer_orders;


SELECT * FROM customer_orders_updated;