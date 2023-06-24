-- step - 1 : for evert session_id calculate total session time
-- step - 2 : Now calculate total time spends by user on that post
-- step - 2.1 - total_viewing_time = (session_endtime - session_starttime) * perc_viewd/100 (decimal point)
-- step - 3 : output post id and total time spends 
-- step - 4 : inner join both columns using session_id

SELECT pv.post_id, SUM((us.session_endtime - us.session_starttime) * (pv.perc_viewed/100)) AS total_viewing_time
FROM post_views pv 
JOIN user_sessions us 
ON us.session_id = pv.session_id
GROUP BY pv.post_id
HAVING SUM((us.session_endtime - us.session_starttime) * (pv.perc_viewed/100)) > 5 * '1 sec' :: interval;

## Explanation - 
`(us.session_endtime - us.session_starttime)` this will return a interval instead of float ot int datatype. So while using HAVING we have to explicitly convert the comparison to interval datatypes.

