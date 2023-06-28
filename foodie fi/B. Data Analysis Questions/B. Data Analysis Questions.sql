-- B. Data Analysis Questions

-- 1. How many customers has Foodie-Fi ever had?

-- unique customers

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM foodie_fi.subscriptions;


-- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value.

-- extracting months
-- use `case when` statement to cast every month id to its name

SELECT CASE WHEN month = 1 THEN 'January'
            WHEN month = 2 THEN 'February'
			WHEN month = 3 THEN 'March'
            WHEN month = 4 THEN 'April'
			WHEN month = 5 THEN 'May'
			WHEN month = 6 THEN 'June'
			WHEN month = 7 THEN 'July'
			WHEN month = 8 THEN 'August'
			WHEN month = 9 THEN 'September'
			WHEN month = 10 THEN 'October'
			WHEN month = 11 THEN 'November'
			WHEN month = 12 THEN 'December'
		END AS months,
			monthly_distributions
FROM (			
	SELECT EXTRACT(MONTH FROM start_date) AS month, 
		   COUNT(DISTINCT customer_id) AS monthly_distributions
	FROM foodie_fi.subscriptions
	WHERE plan_id = 0
	GROUP BY month) p;


/* 
-- 3. What plan start_date values occur after the year 2020 for our dataset? 
Show the breakdown by count of events for each plan_name */

-- User must be of 2021 or more
-- count total no of customers in each category after counting  

SELECT p.plan_id,
       p.plan_name AS Name_of_Plan,
       COUNT(customer_id)
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p
USING (plan_id)
WHERE start_date > '2020-12-31'
GROUP BY p.plan_id, Name_of_Plan
ORDER BY p.plan_id;


-- 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

-- count total no customer and total churned customer and calculate final ratio/percentage

SELECT p.plan_name, 
       COUNT(DISTINCT customer_id) AS churn_customers,
       ROUND(100 * COUNT(DISTINCT customer_id)::NUMERIC / 
			 (SELECT COUNT(DISTINCT customer_id) AS total_customer
			FROM foodie_fi.subscriptions)::NUMERIC, 1) AS ratio_of_churn
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p
ON p.plan_id = s.plan_id
WHERE p.plan_id = 4
GROUP BY p.plan_name;


/*
-- 5. How many customers have churned straight after their initial free trial - 
what percentage is this rounded to the nearest whole number?
*/

-- using `ROW_NUMBER()`, numbering all the customers based on their plans
-- filtering those customers whose plan_id = 4 as well as it's there second plan
-- using two CTEs we can acheive the results

WITH temp AS (
	SELECT *,
		  ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY plan_id) AS result
	FROM foodie_fi.subscriptions),

total AS (
	SELECT COUNT(DISTINCT customer_id) AS total_customer
	FROM foodie_fi.subscriptions)

SELECT COUNT(DISTINCT customer_id) AS total_churn_customer,
       ROUND(100 * COUNT(DISTINCT customer_id)::NUMERIC/total_customer::NUMERIC, 2) AS percentage_churn_customer
FROM temp AS p, total
WHERE p.result = 2 and p.plan_id = 4  
GROUP BY total.total_customer;


-- 6. What is the number and percentage of customer plans after their initial free trial?

with temp AS (
	SELECT *,
		  ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY plan_id) AS plan
	FROM foodie_fi.subscriptions
),
customer AS (
	SELECT COUNT(DISTINCT customer_id) AS total_customer
	FROM foodie_fi.subscriptions
)

SELECT temp.plan_id,
       COUNT(DISTINCT customer_id) AS monthly_customers,
       ROUND(100 * COUNT(DISTINCT customer_id)::NUMERIC/total_customer::NUMERIC , 2) AS customer_percent
FROM temp, customer
WHERE temp.plan > 1
GROUP BY temp.plan_id,total_customer;

-- SELECT plan_id, COUNT(customer_id)
-- FROM(
-- SELECT *,
--       ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY plan_id) AS plan
-- FROM foodie_fi.subscriptions) p
-- WHERE plan > 1
-- GROUP BY plan_id;


-- 7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

-- step 1 : filter data, start_date < 2020-12-31
-- step 2 : count unique customers
-- step 3 : count percentage for each 
/*
-- step 4 : use ROW_NUMBER() function and ORDER the data by start_date 
in DESC order, so that the recent will be ranked 1st
*/

SELECT plan_id,
       plan_name,
	   COUNT(customer_id) AS total_customers,
	   ROUND(100 * COUNT(customer_id)::NUMERIC/(
		   SELECT COUNT(DISTINCT customer_id)
		   FROM foodie_fi.subscriptions
	   )::NUMERIC, 2) AS percent_breakdown
FROM(	   
SELECT *,
      ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY start_date DESC) AS latest_plan
FROM foodie_fi.subscriptions 
JOIN foodie_fi.plans p
USING (plan_id)
WHERE start_date <= '2020-12-31') x
WHERE x.latest_plan = 1
GROUP BY x.plan_id, x.plan_name;



--- 8. How many customers have upgraded to an annual plan in 2020?

SELECT COUNT(DISTINCT customer_id) AS annual_subscription 
FROM foodie_fi.subscriptions 
WHERE start_date <= '2020-12-31'
and plan_id = 3;


-- 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

--- filter those customer whose plan_id = 3
--- filter those customer whose plan_id = 0
--- calculate the average of time(date) to find out the average conversion rate


with annual_plans_customer_cte AS(
	SELECT *
	FROM foodie_fi.subscriptions
	JOIN foodie_fi.plans
	USING (plan_id)
	WHERE plan_id = 3
),

trial_plans_customer_cte AS(
	SELECT * 
	FROM foodie_fi.subscriptions
	JOIN foodie_fi.plans 
	USING (plan_id)
	WHERE plan_id = 0
)

SELECT ROUND(AVG(annual_plans_customer_cte.start_date - trial_plans_customer_cte.start_date), 2) AS avg_customer_time_taken
FROM annual_plans_customer_cte 
JOIN trial_plans_customer_cte 
USING (customer_id);



-- 10. Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)

-- filter those customer whose plan_id = 3 and plan_id = 0
-- select customer_id and avg_customer_convo_days, avg_customer_convo_days = (start_date, plan_id = 3) - (start_date, plan_id= 0)
-- use case when statement to find out the result

WITH annual_customer_cte AS (
	SELECT * 
    FROM foodie_fi.subscriptions
	JOIN foodie_fi.plans
	USING (plan_id)
	WHERE plan_id = 3
),
trial_customer_cte AS (
	SELECT * 
    FROM foodie_fi.subscriptions
	JOIN foodie_fi.plans
	USING (plan_id)
	WHERE plan_id = 1
)

SELECT category,
       COUNT(category) AS customer_count
FROM (
	SELECT customer_id,
		  CASE 
				WHEN avg_convo_date > '330' THEN '330-360 days'
				WHEN avg_convo_date > '300' THEN '300-360 days'
				WHEN avg_convo_date > '270' THEN '270-300 days'
				WHEN avg_convo_date > '240' THEN '240-270 days'
				WHEN avg_convo_date > '210' THEN '210-240 days'
				WHEN avg_convo_date > '180' THEN '180-210 days'
				WHEN avg_convo_date > '150' THEN '150-180 days'
				WHEN avg_convo_date > '120' THEN '120-150 days'
				WHEN avg_convo_date > '90' THEN '90-120 days'
				WHEN avg_convo_date > '60' THEN '60-90 days'
				WHEN avg_convo_date > '30' THEN '30-60 days'
				ELSE '0-30 days'
		  END AS category
	FROM(
		SELECT customer_id,
			  ROUND(AVG(annual_customer_cte.start_date - trial_customer_cte.start_date)::NUMERIC, 2) AS avg_convo_date
		FROM annual_customer_cte
		JOIN trial_customer_cte
		USING (customer_id)
		GROUP BY customer_id) x
	GROUP BY x.customer_id, x.avg_convo_date
	ORDER BY x.customer_id) p
GROUP BY p.category
ORDER BY p.category;


--- 11. How many customers downgraded from a pro monthly to a basic monthly plan in 2020?

/*
-- 1. using LEAD() function make sure that for each customer current/prev to current and previous/initial plan_id are shown
-- 2. current plan_id = 1 and previous_plan_id = 2, means churning
*/

SELECT COUNT(customer_id) AS total_downgraded_customer
FROM(      
	SELECT *, 
		  LEAD(plan_id, 1) OVER(PARTITION BY customer_id 
								 ORDER BY start_date) AS downgraded_customers
	FROM foodie_fi.subscriptions) x
WHERE plan_id = 2 AND downgraded_customers = 1;


-- with pro_monthly_cte AS(
-- 	SELECT 
-- 	      COUNT(DISTINCT customer_id) AS pro_customer_count
-- 	FROM foodie_fi.subscriptions
-- 	JOIN foodie_fi.plans
-- 	USING (plan_id)
-- 	WHERE plan_id = 2 AND EXTRACT(YEAR FROM start_date) <= '2020'
-- ),

-- basic_monthly_cte AS(
-- 	SELECT 
-- 	      COUNT(DISTINCT customer_id) AS basic_customer_count
-- 	FROM foodie_fi.subscriptions
-- 	JOIN foodie_fi.plans
-- 	USING (plan_id)
-- 	WHERE plan_id = 1 AND EXTRACT(YEAR FROM start_date) <= '2020'
-- )

-- SELECT (pro_customer_count - basic_customer_count) AS downgraded_customer
-- FROM basic_monthly_cte
-- CROSS JOIN pro_monthly_cte;
-- -- USING (customer_id);












































































































































































































































































































































































































































