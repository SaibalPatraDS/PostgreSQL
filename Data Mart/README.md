# `Data Mart` README file
------------------------------------------------------------

This README provides an overview of the data mart solution for managing and cleaning weekly sales data. The solution involves creating a schema, defining tables, and performing data cleansing steps to enhance the quality and usability of the provided data.

## Table of Contents

- [Schema Creation](#schema-creation)
- [Table Creation](#table-creation)
- [Data Cleansing Steps](#data-cleansing-steps)
  - [Week Date Formatting](#week-date-formatting)
  - [Week Number Calculation](#week-number-calculation)
  - [Month Number Calculation](#month-number-calculation)
  - [Calendar Year Calculation](#calendar-year-calculation)
  - [Age Band and Demographic Mapping](#age-band-and-demographic-mapping)
  - [Null Value Handling](#null-value-handling)
  - [Average Transaction Calculation](#average-transaction-calculation)

## Schema Creation

To create the schema and set the search path, execute the following SQL commands:

```sql
CREATE SCHEMA data_mart;
SET search_path = data_mart;
```

## Table Creation

To create the `weekly_sales` table, execute the following SQL command:

```sql
DROP TABLE IF EXISTS data_mart.weekly_sales;
CREATE TABLE data_mart.weekly_sales (
  "week_date" VARCHAR(7),
  "region" VARCHAR(13),
  "platform" VARCHAR(7),
  "segment" VARCHAR(4),
  "customer_type" VARCHAR(8),
  "transactions" INTEGER,
  "sales" INTEGER
);
```

## Data Cleansing Steps

The data cleansing steps aim to enhance the quality and usefulness of the data stored in the `weekly_sales` table.

### Week Date Formatting

Convert the week dates to the DATE format for consistency and better usability:

```sql
SELECT week_date::DATE AS week_date
FROM data_mart.weekly_sales;
```

### Week Number Calculation

Calculate a week number for each week date:

```sql
SELECT TO_CHAR(week_date::DATE, 'W') AS week_number
FROM data_mart.weekly_sales;
```

### Month Number Calculation

Calculate a month number for each week date to represent the calendar month:

```sql
SELECT TO_CHAR(week_date::DATE, 'MM') AS month_number
FROM data_mart.weekly_sales;
```

### Calendar Year Calculation

Extract a calendar year from the week dates:

```sql
SELECT TO_CHAR(week_date::DATE, 'YYYY') AS calendar_year
FROM data_mart.weekly_sales;
```

### Age Band and Demographic Mapping

Categorize segments into age groups and demographics:

```sql
SELECT
  CASE WHEN REGEXP_REPLACE(segment, '[^0-9]', '') = '1' THEN 'Young Adults'
       WHEN REGEXP_REPLACE(segment, '[^0-9]', '') = '2' THEN 'Middle Aged'
       WHEN REGEXP_REPLACE(segment, '[^0-9]', '') IN ('3', '4') THEN 'Retirees'
       WHEN segment = 'null' THEN 'unknown'
  END AS age_band,
  CASE WHEN REGEXP_REPLACE(segment, '[^a-zA-Z]', '') = 'C' THEN 'Couples'
       WHEN REGEXP_REPLACE(segment, '[^a-zA-Z]', '') = 'F' THEN 'Families'
       WHEN segment = 'null' THEN 'unknown'
  END AS demographic
FROM data_mart.weekly_sales;
```

### Null Value Handling

Replace null values in the `segment` column with "unknown":

```sql
SELECT REPLACE(segment, 'null', 'unknown') AS segment
FROM data_mart.weekly_sales;
```

### Average Transaction Calculation

Calculate average transaction values:

```sql
SELECT
  ROUND(sales::NUMERIC / transactions::NUMERIC, 2) AS avg_transaction
FROM data_mart.weekly_sales;
```

## Generating Clean Data

The cleaned data is stored in a new table named `clean_weekly_sales`, which incorporates all the transformations and enhancements described above:

```sql
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
```

## Usage

To utilize the data mart solution, follow the steps provided in the SQL script. Adjust column names and calculations as needed to suit your specific requirements.

Remember that this README provides an overview, and the SQL script itself contains the detailed implementation of the data cleansing process. Feel free to modify and extend the script according to your data and business needs.

For questions or assistance, please contact [Saibal Patra](https://www.linkedin.com/in/saibal-patra/).

## License

This data mart solution is provided under (GNU General Public License v3.0)[]. See (LICENSE)[https://github.com/SaibalPatraDS/PostgreSQL/blob/main/LICENSE] for more details.
