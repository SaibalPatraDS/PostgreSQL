# Table Descriptions

## chicago_areas Table
This table represents various community areas in Chicago.

| Column Name | Data Type | Description |
| -------------- | -------------- | -------------- |
| community_area_id	| INTEGER	| Unique identifier for the community area|
| name |	VARCHAR(22) |	Name of the community area|
| population | INTEGER | Population count of the community area|
| area_sq_mi| NUMERIC(5,2) |	Area of the community area in square miles|
| density	| NUMERIC(8,2) | Population density of the community area|

## chicago_crimes_2021 Table
This table contains information about crimes reported in Chicago in 2021.

| Column Name | Data Type | Description |
| -------------- | -------------- | -------------- |
| crime_date |	VARCHAR(16) |	Date of the crime incident |
| city_block |	VARCHAR(28)	| Name of the city block where the crime occurred |
| crime_type |	VARCHAR(33)	| Type of the crime |
| crime_description |	VARCHAR(60) |	Description of the crime |
| crime_location |	VARCHAR(53)	| Location of the crime incident |
| arrest |	VARCHAR(5) |	Indicates whether an arrest was made for the crime (Yes/No) |
| domestic |	VARCHAR(5)	| Indicates whether the crime was domestic in nature (Yes/No) |
| community_id | INTEGER | Unique identifier for the community area where the crime occurred |
| latitude |	NUMERIC(11,8) |	Latitude coordinate of the crime location |
| longitude	| NUMERIC(12,8)	| Longitude coordinate of the crime location |

## chicago_temps_2021 Table
This table contains weather information for Chicago in 2021.

| Column Name | Data Type | Description |
| -------------- | -------------- | -------------- |
| date |	DATE	| Date of the weather record |
| temp_high	| INTEGER	| Highest temperature recorded for the day |
| temp_low |	INTEGER	| Lowest temperature recorded for the day |
| precipitation |	NUMERIC(4,2) |	Amount of precipitation (rainfall) for the day |

