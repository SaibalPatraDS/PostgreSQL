/* ANALYSIS ON CRIME DATA */

-- 1. How many community areas are there in Chicago?

SELECT COUNT(DISTINCT community_area_id) AS total_community_area
FROM crime_data.chicago_areas;


-- 2. What is the name of the community area with the highest population?

SELECT community_area_id,
       name
FROM crime_data.chicago_areas
WHERE population = (
	SELECT MAX(population)
	FROM crime_data.chicago_areas
);


--3. What is the average population density of all community areas in Chicago?

SELECT community_area_id,
       ROUND(AVG(density),2) AS avg_population_density
FROM crime_data.chicago_areas
GROUP BY community_area_id
ORDER BY avg_population_density DESC;


-- 4. Which community area has the highest population density?

SELECT community_area_id
FROM crime_data.chicago_areas
WHERE density = (
	SELECT MAX(density)
	FROM crime_data.chicago_areas
);

/* alternative 
hint - using `subquery` we will find the max_density and use that to find the matching result.*/

SELECT community_area_id
FROM crime_data.chicago_areas c1
JOIN (
	SELECT MAX(density) AS max_density
	FROM crime_data.chicago_areas
) max_density_subquery
ON c1.density = max_density_subquery.max_density;


-- 5. How many crimes were reported in Chicago in 2021?

-- SELECT TO_CHAR(crime_date::TIMESTAMP, 'YYYY') AS crime_year,
--        COUNT(*) total_crimes_reported
-- FROM crime_data.chicago_crimes_2021
-- GROUP BY crime_year;

SELECT COUNT(*) AS total_crimes_reported
FROM crime_data.chicago_crimes_2021
WHERE crime_date LIKE '%2021%';

-- SELECT DISTINCT crime_location
-- FROM crime_data.chicago_crimes_2021;


-- 6. What is the most common type of crime reported in Chicago in 2021?

SELECT crime_type AS most_common_crime_type
FROM (
	SELECT crime_type,
		   COUNT(*) AS total_crime_count
	FROM crime_data.chicago_crimes_2021
	GROUP BY crime_type
	ORDER BY total_crime_count DESC
	LIMIT 1) x;


-- 7. How many crimes resulted in an arrest in Chicago in 2021?

SELECT COUNT(arrest) AS n_arrests
FROM crime_data.chicago_crimes_2021
WHERE arrest = 'TRUE'
      AND crime_date LIKE '%2021%';


-- 8. How many crimes were classified as domestic incidents in Chicago in 2021?

SELECT COUNT(*) AS n_crimes
FROM crime_data.chicago_crimes_2021
WHERE domestic = 'TRUE' AND crime_date LIKE '%2021%';


-- SELECT domestic
-- FROM crime_data.chicago_crimes_2021;


-- 9. What is the total population of all community areas where crimes were reported in Chicago in 2021?

SELECT ROUND(SUM(ca.population)/1000000 ::NUMERIC, 3) || 'Milion' AS total_population
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON ca.community_area_id = cc.community_id;
-- WHERE cc.crime_type <> NULL;


-- SELECT DISTINCT crime_type
-- FROM crime_data.chicago_crimes_2021;


/*
-- 10.What is the average population density of community areas 
   where crimes were reported in Chicago in 2021?
*/

SELECT cc.community_id,
       ca.name,
       ROUND(AVG(density)::NUMERIC, 2) AS avg_population_density
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON cc.community_id = ca.community_area_id
WHERE cc.crime_date LIKE '%2021%'
GROUP BY cc.community_id, ca.name
ORDER BY avg_population_density DESC;



--11. How many crimes were reported in each community area in Chicago in 2021?

SELECT cc.community_id,
       ca.name,
	   COUNT(*) AS total_crimes
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON cc.community_id = ca.community_area_id
GROUP BY cc.community_id, ca.name
ORDER BY total_crimes DESC;



--12. Which community area had the highest number of crimes reported in Chicago in 2021?
SELECT cc.community_id,
       ca.name,
	   COUNT(*) AS total_crimes
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON cc.community_id = ca.community_area_id
GROUP BY cc.community_id, ca.name
ORDER BY total_crimes DESC
LIMIT 1;



--13. What is the average temperature high in Chicago in 2021?

SELECT ROUND(AVG(temp_high),2) AS avg_temp_high
FROM crime_data.chicago_temps_2021
WHERE EXTRACT(YEAR FROM date) = '2021';


--14. What is the average temperature low in Chicago in 2021?

SELECT ROUND(AVG(temp_low),2) AS avg_temp_low
FROM crime_data.chicago_temps_2021
WHERE EXTRACT(YEAR FROM date) = '2021';


--15. What is the highest temperature high recorded in Chicago in 2021?

SELECT MAX(temp_high) AS max_temp_high
FROM crime_data.chicago_temps_2021
WHERE EXTRACT(YEAR FROM date) = '2021';


--16. How many days in 2021 had precipitation recorded in Chicago?

SELECT COUNT(*) AS has_precipited
FROM crime_data.chicago_temps_2021
WHERE EXTRACT(YEAR FROM date) = 2021
      AND precipitation IS NOT NULL;

-- SELECT date, precipitation 
-- FROM crime_data.chicago_temps_2021;

/* alternative */

SELECT SUM(CASE WHEN precipitation > 0 THEN 1 ELSE 0 END) AS has_precipitated
FROM crime_data.chicago_temps_2021
WHERE EXTRACT(YEAR FROM date) = 2021;



--17. What is the total precipitation in Chicago in 2021?

SELECT SUM(precipitation)||' ml' AS total_precipitation
FROM crime_data.chicago_temps_2021
WHERE EXTRACT(YEAR FROM date) = 2021;




--18. How many crimes were reported in community areas with a population density above the average?

WITH density_more_avg AS(
	SELECT AVG(density) AS avg_density
	FROM crime_data.chicago_areas
)
SELECT COUNT(cc.*) AS total_crimes_reported
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON cc.community_id = ca.community_area_id
WHERE ca.density > (SELECT avg_density
					FROM density_more_avg);



--19. How many crimes were reported in each month of 2021 in Chicago?

SELECT x.crime_month, 
       COUNT(*) AS total_crimes_per_month
FROM(
	SELECT *,
		   EXTRACT(MONTH FROM (TO_DATE(crime_date, 'MM/DD/YYYY HH24-MI'))) AS crime_month
	FROM crime_data.chicago_crimes_2021 cc
	JOIN crime_data.chicago_areas ca
	ON cc.community_id = ca.community_area_id) x
GROUP BY x.crime_month
ORDER BY x.crime_month;


-- SELECT DISTINCT EXTRACT(MONTH FROM (TO_DATE(crime_date, 'MM/DD/YYYY HH24-MI'))) AS crime_month
-- FROM crime_data.chicago_crimes_2021;



--20. How many crimes were reported in each season (spring, summer, fall, winter) in Chicago in 2021?

SELECT CASE WHEN quarters = 1 THEN 'Winter'
	        WHEN quarters = 2 THEN 'Spring'
			WHEN quarters = 3 THEN 'Summer'
			WHEN quarters = 4 THEN 'Fall'
		END AS Quarters,
		COUNT(*) AS total_crimes
FROM (
	SELECT EXTRACT(QUARTER FROM(TO_DATE(crime_date, 'MM/DD/YYYY HR24:MI'))) AS quarters
	FROM crime_data.chicago_crimes_2021) x
GROUP BY x.quarters;



--21. What is the crime rate (crimes per capita) in each community area in Chicago in 2021?

SELECT cc.community_id,
       ca.name,
       ROUND(100 * COUNT(cc.*)/ca.population::NUMERIC, 2) AS crime_rate
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON cc.community_id = ca.community_area_id
GROUP BY cc.community_id, ca.population, ca.name
ORDER BY crime_rate DESC;



--22. How many crimes were reported in each community area per square mile in Chicago in 2021?

SELECT cc.community_id,
       ca.name,
	   ROUND(COUNT(*)/ca.area_sq_mi,0) AS crimes_per_sq_area
FROM crime_data.chicago_crimes_2021 cc
JOIN crime_data.chicago_areas ca
ON cc.community_id = ca.community_area_id
GROUP BY cc.community_id, ca.area_sq_mi, ca.name
ORDER BY crimes_per_sq_area DESC;




--







































































































