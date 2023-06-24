-- step - 1 : for evert session_id calculate total session time
-- step - 2 : Now calculate total time spends by user on that post
-- step - 2.1 - total_viewing_time = (session_endtime - session_starttime) * perc_viewd/100 (decimal point)
-- step - 3 : output post id and total time spends 
-- step - 4 : inner join both columns using session_id

SELECT pv.post_id, SUM(EXTRACT(EPOCH FROM(us.session_endtime::timestamp - us.session_starttime::timestamp)) * (pv.perc_viewed/100)) AS total_viewing_time
FROM post_views pv 
JOIN user_sessions us 
ON us.session_id = pv.session_id
GROUP BY pv.post_id
HAVING SUM(EXTRACT(EPOCH FROM(us.session_endtime::timestamp - us.session_starttime::timestamp)) * (pv.perc_viewed/100)) > 5;
