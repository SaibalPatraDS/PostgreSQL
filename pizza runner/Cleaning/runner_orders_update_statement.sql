-- Update `runner_orders` table
UPDATE pizza_runner.runner_orders
SET pickup_time = NULL
WHERE pickup_time LIKE 'null';

UPDATE pizza_runner.runner_orders 
SET distance = CAST(regexp_replace(distance, '[a-z]+', '') AS FLOAT)
WHERE distance NOT LIKE 'null';

UPDATE pizza_runner.runner_orders
SET duration = CAST(regexp_replace(duration, '[a-z]+', '') AS FLOAT)
WHERE duration NOT LIKE 'null';

UPDATE pizza_runner.runner_orders
SET cancellation = NULL
WHERE cancellation = '' OR cancellation = 'NaN' OR cancellation = 'null';

-- Display the updated contents of `runner_orders` table
SELECT * FROM pizza_runner.runner_orders;
























