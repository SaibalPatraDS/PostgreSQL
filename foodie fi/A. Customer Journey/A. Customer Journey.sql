-- A. Customer Journey

SELECT * FROM foodie_fi.plans;
SELECT * FROM foodie_fi.subscriptions LIMIT 10;

-- total unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customer
FROM foodie_fi.subscriptions;


-- basic idea how many annual subscriptions

SELECT COUNT(plan_id) 
FROM foodie_fi.subscriptions
GROUP BY plan_id;
/*more than 50% times people has converted to annual membership */

