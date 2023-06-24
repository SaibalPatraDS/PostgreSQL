-- step - 1 : for evert session_id calculate total session time
-- step - 2 : Now calculate total time spends by user on that post
-- step - 2.1 - total_viewing_time = (session_endtime - session_starttime) * perc_viewd/100 (decimal point)
-- step - 3 : output post id and total time spends 
-- step - 4 : inner join both columns using session_id

WITH viewing_time AS (
SELECT session_id, 
       EXTRACT(EPOCH FROM session_endtime) - EXTRACT(EPOCH FROM session_starttime) AS duration
FROM user_sessions)

SELECT post_id,
       SUM(duration * (perc_viewed/100)::float) AS total_viewing_time
FROM post_views pv
JOIN viewing_time vt
ON pv.session_id = vt.session_id
GROUP BY post_id
HAVING SUM(duration * (perc_viewed/100)::float) > 5;


-- ## Explanation - 
-- Using CTE we can create a temporary schema and then using JOIN we will perform the rest of the things. 
