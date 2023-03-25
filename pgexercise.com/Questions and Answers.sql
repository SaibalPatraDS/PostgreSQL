-- Produce a list of all members who have recommended another member

--Question - 
--How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

--Solution - 
SELECT DISTINCT m2.firstname AS firstname, m2.surname AS surname
FROM cd.members AS m1
INNER JOIN cd.members AS m2
ON m2.memid = m1.recommendedby
ORDER BY surname, firstname;

--Answers and Discussion : [Solution Given in Website]
select distinct recs.firstname as firstname, recs.surname as surname
	from 
		cd.members mems
		inner join cd.members recs
			on recs.memid = mems.recommendedby
order by surname, firstname;   
