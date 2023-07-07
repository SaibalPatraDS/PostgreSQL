-- Analysis Solutions --

SELECT *
FROM meta
LIMIT 10;


-- 1. Find the total volume traded on each date.

SELECT COUNT(DISTINCT(date)) AS total_days 
FROM meta;

SELECT date, 
       SUM(volume) AS total_volume
FROM meta
GROUP BY date
ORDER BY date;

-- 2. Calculate the average closing price for each month.

/* 
hint - extract month from date column and 
          then group by date to find the avg closing price for each month 
*/


SELECT EXTRACT(MONTH FROM date) AS stock_month,
	   TO_CHAR(date, 'MON') AS months,
       '$' || ROUND(AVG(close)::NUMERIC,2) AS closing_price
FROM meta
GROUP BY stock_month, months;


-- 3. Retrieve the date with the highest opening price.

SELECT date AS highest_opening_day,
       open AS highest_opening_price
FROM meta
WHERE open = (SELECT max(open)
			 FROM meta);
		  
/* another try */

SELECT date AS highest_opening_day,
       open AS highest_opening_price
FROM(
	SELECT *,
		   ROW_NUMBER() OVER(ORDER BY open DESC) AS ranking
	FROM meta) x
WHERE x.ranking = 1;
		  


-- 4. Determine the number of days where the closing price was higher than the opening price.

/*
hint - calculate the difference between closing_price and opening_price 
       and then filter those where the result is > 0
*/

SELECT COUNT(stock_date) AS total_days
FROM(
	SELECT date AS stock_date,
		   ROUND((close::NUMERIC - open::NUMERIC),2) AS diff_close_open
	FROM meta) x
WHERE x.diff_close_open > 0;
		  
		  
-- 5. Find the date with the largest difference between the highest and lowest price.
	  
/*
hint - 
 1. Calculate the difference between highest and lowest price and 
 2. rank then using row number and ORDER them on difference_value
 3. select only rank = 1
*/

SELECT stock_date,
       diff_high_low
--        ROW_NUMBER() OVER(ORDER BY diff_high_low DESC)
FROM(	   
	SELECT date AS stock_date,
		   (high::NUMERIC - low::NUMERIC) AS diff_high_low,
	       ROW_NUMBER() OVER(ORDER BY high-low DESC) AS ranking
	FROM meta) x
WHERE ranking = 1;


--6. Calculate the average volume traded on days where the closing price was above the opening price.

/*
hint - 1. Calculate diff btw close and open, filter where result > 0
       2. Calculate AVG(volume) of the results after filtering
*/

SELECT AVG(volume) AS avg_volume
FROM(
	SELECT  date AS stock_date,
			volume,
		   (close - open) AS diff_close_open
	FROM meta) x
WHERE diff_close_open > 0;
		  
		  
/* alternative */
SELECT AVG(volume) AS avg_volume
FROM meta
WHERE close > open;


/*
--7. Retrieve the dates where the opening price was greater 
     than the closing price for at least five consecutive days.
*/

/*
hint - 1. filter for open > close, 
       2. SUM(all those days where prev 4 days and current days, open > close)
	   3. Select those when sum of consecutive days >= 5
*/

WITH consecutive_days AS(
	SELECT date,
	       open > close AS is_higher,
	       ROW_NUMBER() OVER(ORDER BY date) AS ranking
	FROM meta
)

SELECT date
FROM(
	SELECT date, 
		   SUM(CASE WHEN is_higher THEN 1 ELSE 0 END) 
			   OVER(ORDER BY date 
					ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS consecutive_days
	FROM consecutive_days) x
WHERE x.consecutive_days >= 4;
		  
		  
		  
-- 8. Determine the top 5 dates with the highest trading volume.

SELECT date,
       volume AS highest_trading_volume
FROM meta
ORDER BY volume DESC
LIMIT 5;
		  
		  
-- 9. Calculate the percentage change in the closing price from the previous day for each date.		  
		  
SELECT date,
       (CASE WHEN ROUND((current_closing_price - prev_closing_price)/prev_closing_price * 100,2)||'%' IS NULL THEN 'first_record'
                  ELSE ROUND((current_closing_price - prev_closing_price)/prev_closing_price * 100,2)||'%' END) AS percent_change
FROM(	  
	SELECT date,
		   close AS current_closing_price,
		  LAG(close, 1) OVER(ORDER BY date) AS prev_closing_price
	FROM meta) x;

/* optimized query */

SELECT date, 
       CASE WHEN LAG(close,1) OVER(ORDER BY date) IS NULL THEN 'first_record'
	        ELSE ROUND((close - LAG(close, 1) OVER(ORDER BY date))/LAG(close) OVER(ORDER BY date) * 100, 2) || '%'
		END AS percent_change
FROM meta;
		  
		  
-- 10. Retrieve the dates where the closing price had a positive percentage change for three consecutive days.
		  
/*
hint - 
1. using CTE, calculate percentange change,
2. within sub-query, we will rank the rows as per date
3. Sum total no of days when percentage_change > 0 and rows will be in between 2 preceding and current_row
*/

WITH percent_change AS(
	SELECT date,
	       ROUND((close - LAG(close,1) OVER(ORDER BY date))/LAG(close,1) OVER(ORDER BY date) * 100, 2) AS change
	FROM meta
)

SELECT date
--     closing_category,
-- 	   consecutive_days
FROM(								 
	SELECT *,
		   ROW_NUMBER() OVER(ORDER BY date) AS row_number,
		   CASE WHEN change > 0 THEN 1 ELSE 0 END AS closing_category,
	       SUM(CASE WHEN change > 0 THEN 1 ELSE 0 END) OVER(ORDER BY date
								 ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS consecutive_days
	FROM percent_change) x
WHERE x.consecutive_days >= 3;
		  
		  
		  
-- Advanced Concepts:


		  
-- 11. Calculate the 7-day moving average of the closing price for each date.
/*
Hint - 
Moving_average - use LAG(close,1) OVER(ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) and Apply AVG() to top of it so calculate the avg
*/

SELECT date,
       lag_closing,
       AVG(lag_closing) OVER(ORDER BY date 
							 ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Moving_Average
FROM (
	SELECT date,
		   close,
		   LAG(close,1) OVER(ORDER BY date) AS lag_closing
	FROM meta) x;
		  

-- 12. Determine the date with the highest trading volume in the month of January.
/*
hint - 1. Filter all those data, where month = 'JAN'
       2. query to find the date when volume of trading is max using subquery
*/

WITH trading AS(
	SELECT date,
	       EXTRACT(MONTH FROM date) AS month,
	       volume
	FROM meta
)

SELECT date, 
       volume AS max_volume
FROM trading
WHERE volume = (SELECT max(volume)
			   FROM trading
			   WHERE month = 1);
		  

-- 13. Retrieve the dates where the closing price is within 5% of the highest price.
/*
hint - 1. calculate (high-close)/high * 100 and filter those where the value <= 5
       2. find out the dates when the above condition is satisfied
*/

SELECT date,
       percent_diff_high_close
FROM (
	SELECT date,
		   ROUND((high-close)/high * 100,2) AS percent_diff_high_close
	FROM meta) x
WHERE x.percent_diff_high_close >= 5;



-- 14. Calculate the exponential moving average (EMA) of the closing price using a period of 14 days.
		  
