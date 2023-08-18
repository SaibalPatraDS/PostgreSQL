/* Data Mart Solution */

/*   -- 2. Data Exploration --   */

/*
1. What day of the week is used for each week_date value?
2. What range of week numbers are missing from the dataset?
3. How many total transactions were there for each year in the dataset?
4. What is the total sales for each region for each month?
5. What is the total count of transactions for each platform
6. What is the percentage of sales for Retail vs Shopify for each month?
7. What is the percentage of sales by demographic for each year in the dataset?
8. Which age_band and demographic values contribute the most to Retail sales?
9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
*/


SELECT * 
FROM data_mart.clean_weekly_sales;


/*
1. What day of the week is used for each week_date value?
*/

SELECT DiSTINCT TO_CHAR(week_date, 'Day') AS day_of_week
FROM data_mart.clean_weekly_sales;



/*
2. What range of week numbers are missing from the dataset?
*/

SELECT DISTINCT TO_CHAR(week_date::DATE, 'WW') AS range_of_weeks
FROM data_mart.clean_weekly_sales
ORDER BY range_of_weeks;


/*
3. How many total transactions were there for each year in the dataset?
*/

SELECT calender_year, 
       COUNT(*) AS total_transaction
FROM data_mart.clean_weekly_sales
GROUP BY calender_year;



/*
4. What is the total sales for each region for each month?
*/


SELECT region,
       TO_CHAR(week_date::DATE, 'MM') AS month,
	   SUM(transactions) AS total_sales
FROM data_mart.weekly_sales
GROUP BY region, TO_CHAR(week_date::DATE, 'MM')
ORDER BY region, month;



/*
5. What is the total count of transactions for each platform
*/

SELECT platform,
       SUM(transactions) AS total_transactions
FROM data_mart.weekly_sales
GROUP BY platform
ORDER BY platform;



/*
6. What is the percentage of sales for Retail vs Shopify for each month?
*/


-- SELECT DISTINCT platform,
--        TO_CHAR(week_date::DATE, 'MM') AS month,
--        SUM(transactions)::NUMERIC / SUM(transactions) OVER(PARTITION BY TO_CHAR(week_date::DATE, 'MM'))::NUMERIC AS total_transactions
-- FROM data_mart.weekly_sales
-- GROUP BY platform, TO_CHAR(week_date::DATE, 'MM'), transactions
-- ORDER BY platform, month;

-- SELECT DISTINCT platform,
--        TO_CHAR(week_date::DATE, 'MM') AS month,
-- 	   SUM(transactions)::NUMERIC OVER(ORDER BY TO_CHAR(week_date::DATE, 'MM'))/(SELECT SUM(transactions) FROM data_mart.weekly_sales
-- 						                                                             GROUP BY TO_CHAR(week_date::DATE, 'MM')
-- 																					 ORDER BY TO_CHAR(week_date::DATE, 'MM'))::NUMERIC * 100.00 as perct_contri
-- FROM data_mart.weekly_sales
-- WHERE platform IN ('Shopify', 'Retail')
-- GROUP BY platform, week_date
-- ORDER BY month;


-- SELECT DISTINCT 
--        platform,
--        TO_CHAR(week_date::DATE, 'MM') AS month,
--        (SUM(transactions) * 100.0) / 
--            SUM(SUM(transactions)) OVER(PARTITION BY TO_CHAR(week_date::DATE, 'MM')) AS perct_contri
-- FROM data_mart.weekly_sales
-- WHERE platform IN ('Shopify', 'Retail')
-- GROUP BY platform, week_date
-- ORDER BY month, platform;


WITH total_platform_transactions AS (
	SELECT DISTINCT platform, 
		   TO_CHAR(week_date::DATE, 'MM') AS month,
		   SUM(transactions) OVER(PARTITION BY platform ORDER BY TO_CHAR(week_date::DATE, 'MM')) AS total_transaction
	FROM data_mart.weekly_sales
	WHERE platform IN ('Shopify', 'Retail')
	-- GROUP BY platform, week_date, transactions
	ORDER BY month),
net_transactions AS(
	SELECT DISTINCT TO_CHAR(week_date::DATE, 'MM') AS month,
		   SUM(transactions) OVER(ORDER BY TO_CHAR(week_date::DATE, 'MM')) AS net_transactions
	FROM data_mart.weekly_sales
	GROUP BY month, transactions
	ORDER BY month)

SELECT tpt.month, 
       tpt.platform, 
       ROUND(tpt.total_transaction::NUMERIC/nt.net_transactions::NUMERIC * 100, 3) AS net_contribution
FROM total_platform_transactions tpt
JOIN net_transactions nt
ON tpt.month = nt.month;


WITH sales_cte AS
  (SELECT TO_CHAR(week_date::DATE, 'YYYY') AS calender_year,
          TO_CHAR(week_date::DATE, 'MM') AS month_number,
          SUM(CASE
                  WHEN platform='Retail' THEN sales
              END) AS retail_sales,
          SUM(CASE
                  WHEN platform='Shopify' THEN sales
              END) AS shopify_sales,
          sum(sales) AS total_sales
   FROM data_mart.weekly_sales
   GROUP BY 1,
            2
   ORDER BY 1,
            2)
SELECT calender_year,
       month_number,
       ROUND(retail_sales::NUMERIC/total_sales::NUMERIC*100, 2) AS retail_percent,
       ROUND(shopify_sales::NUMERIC/total_sales::NUMERIC*100, 2) AS shopify_percent
FROM sales_cte;




/*
7. What is the percentage of sales by demographic for each year in the dataset?
*/

SELECT DISTINCT calender_year,
       demographic, 
       SUM(sales) as total_sales
-- 	   SUM(sales) OVER(PARTITION BY calender_year) as net_sales
FROM data_mart.clean_weekly_sales
GROUP BY demographic, calender_year
ORDER BY calender_year;

SELECT calender_year,
       SUM(sales) AS net_sales
FROM data_mart.clean_weekly_sales
GROUP BY calender_year;


SELECT calender_year,
       demographic,
	   percentage_sales
FROM (
SELECT cws1.calender_year,
       cws1.demographic,
	   SUM(cws1.sales) AS total_sales,
	   cws2.net_sales,
	   ROUND(SUM(cws1.sales)::NUMERIC / cws2.net_sales::NUMERIC * 100, 2) ||' %' AS percentage_sales
FROM data_mart.clean_weekly_sales cws1
JOIN (
	SELECT calender_year, 
	       SUM(sales) AS net_sales
    FROM data_mart.clean_weekly_sales
	GROUP BY calender_year
) cws2
ON cws1.calender_year = cws2.calender_year
GROUP BY cws1.calender_year, cws1.demographic, cws2.net_sales
ORDER BY cws1.calender_year) x
ORDER BY x.calender_year;




/*
8. Which age_band and demographic values contribute the most to Retail sales?
*/

SELECT age_band,
       demographic,
	   SUM(sales) AS net_sales
FROM data_mart.clean_weekly_sales
WHERE platform = 'Retail' AND age_band <> 'unknown' OR demographic <> 'unknown'
GROUP BY age_band, demographic
ORDER BY net_sales DESC
LIMIT 1;




/*
9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
If not - how would you calculate it instead?
*/

--- We can't use avg_tranasction to find the average transaction size for each year, for Retail and Shopify. 
--- For example, avg of 5, 5 s is 5, and average of 2, 6 is 6, now the average of results will be (5+6)/2 = 5.5
--- And net average will be (5*5 + 6*2)/7 = 37/7 = 5.28, not equal to 5.5
--- So using svg_transaction will give wrong results.


SELECT calender_year, 
       cws.platform,
	   ROUND(SUM(cws.sales)::NUMERIC/SUM(cws.transactions)::NUMERIC, 2) AS correct_avg_transaction,
	   ROUND(AVG(cws.avg_transaction), 2) AS incorrect_avg_transactions
FROM data_mart.clean_weekly_sales cws
GROUP BY calender_year, cws.platform;





























































































