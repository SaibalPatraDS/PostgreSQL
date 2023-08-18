/* Data Mart Solution */

/*      1. Data Cleansing Steps    */

SELECT *
FROM data_mart.weekly_sales;


-- Checking Some Details

SELECT TO_CHAR(week_date::DATE, 'YYYY-MM-DD') AS date,
       week_date
FROM data_mart.weekly_sales;	   

SELECT segment,
       CASE WHEN segment = 'null' THEN ''
	   ELSE 
	       REGEXP_REPLACE(segment, '[^0-9]', '') END AS age_band
--        CASE WHEN segment ~ '^\d$' THEN 
-- 	        CASE 
-- 			    WHEN segment = '1' THEN 'Young Adults'
-- 				WHEN segment = '2' THEN 'Middle Aged'
-- 				WHEN segment IN ('3', '4') THEN 'Retires'
-- 				ELSE NULL
-- 			END 
-- 		END AS age_band
FROM data_mart.weekly_sales;

SELECT segment,
       CASE WHEN REGEXP_REPLACE(segment, '[^0-9]', '') = '1' THEN 'Young Adults'
	        WHEN REGEXP_REPLACE(segment, '[^0-9]', '') = '2' THEN 'Middle Aged'
			WHEN REGEXP_REPLACE(segment, '[^0-9]', '') IN ('3', '4') THEN 'Retirees'
	        WHEN segment = 'null' THEN ''
	   END AS age_band
FROM data_mart.weekly_sales;

SELECT segment, 
       CASE WHEN REGEXP_REPLACE(segment, '[^a-zA-Z]', '') = 'C' THEN 'Couples'
	        WHEN REGEXP_REPLACE(segment, '[^a-zA-Z]', '') = 'F' THEN 'Families'
            WHEN segment = 'null' THEN ''
	   END AS demographic
FROM data_mart.weekly_sales;

SELECT REPLACE(segment, 'null', 'unknown') AS segment
FROM data_mart.weekly_sales;

/** Data Cleaning **/

/*
1. Convert the week_date to a DATE format
*/

DROP TABLE IF EXISTS data_mart.clean_weekly_sales;
CREATE TABLE IF NOT EXISTS data_mart.clean_weekly_sales AS

SELECT /*
       Convert the week_date to a DATE format
       */
	   week_date::DATE AS week_date,
	   /*
	   Add a week_number as the second column for each week_date value, 
	   for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
       */
	   TO_CHAR(week_date::DATE, 'W') AS week_number,
	   /*
	   Add a month_number with the calendar month 
	   for each week_date value as the 3rd column
	   */
	   TO_CHAR(week_date::DATE, 'MM') AS month_number,
	   /*
	   Add a calendar_year column as the 4th column 
	   containing either 2018, 2019 or 2020 values
	   */
	   TO_CHAR(week_date::DATE, 'YYYY') AS calender_year,
	   /*
	   Add a new column called age_band after the original segment column using 
	   the following mapping on the number inside the segment value
	   segment	age_band
			1	    Young Adults
			2	    Middle Aged
			3 or 4	Retirees
	   */
	   CASE WHEN REGEXP_REPLACE(segment, '[^0-9]', '') = '1' THEN 'Young Adults'
	        WHEN REGEXP_REPLACE(segment, '[^0-9]', '') = '2' THEN 'Middle Aged'
			WHEN REGEXP_REPLACE(segment, '[^0-9]', '') IN ('3', '4') THEN 'Retirees'
	        WHEN segment = 'null' THEN 'unknown'
	   END AS age_band,
	   /*
	   Add a new demographic column using the following mapping for the first letter in the segment values
	   segment	demographic
			C	Couples
			F	Families
	   */
	   CASE WHEN REGEXP_REPLACE(segment, '[^a-zA-Z]', '') = 'C' THEN 'Couples'
	        WHEN REGEXP_REPLACE(segment, '[^a-zA-Z]', '') = 'F' THEN 'Families'
            WHEN segment = 'null' THEN 'unknown'
	   END AS demographic,
	   /*
	   Ensure all null string values with an "unknown" string value in the original segment column 
	   as well as the new age_band and demographic columns
	   */
	   REPLACE(segment, 'null', 'unknown') AS segment,
-- 	   COALESCE(age_band, 'unknown') AS age_band,
-- 	   COALESCE(demographic, 'unknown') AS demographic,
	   /*
	   Generate a new avg_transaction column 
	   as the sales value divided by transactions rounded to 2 decimal places for each record
	   */
	   ROUND(sales::NUMERIC/transactions::NUMERIC, 2) AS avg_transaction, 
	   transactions,
	   sales, 
	   region, 
	   platform
	  
FROM data_mart.weekly_sales;


