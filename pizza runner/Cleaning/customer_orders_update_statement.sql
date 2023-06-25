-- Update the `customer_orders` table
-- Clean 'customer_orders' data directly in the table
UPDATE pizza_runner.customer_orders
SET exclusions = NULL
WHERE exclusions = '' OR exclusions = 'null';

UPDATE pizza_runner.customer_orders
SET extras = NULL
WHERE extras = '' OR extras = 'NaN' OR extras = 'null';

-- Display the updated contents of 'customer_orders' table
SELECT * FROM pizza_runner.customer_orders;
