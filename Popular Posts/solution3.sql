-- step - 1 : for evert session_id calculate total session time
-- step - 2 : Now calculate total time spends by user on that post
-- step - 2.1 - total_viewing_time = (session_endtime - session_starttime) * perc_viewd/100 (decimal point)
-- step - 3 : output post id and total time spends 
-- step - 4 : inner join both columns using session_id

SELECT post_id,
      SUM((perc_viewed * session_time/100)::float) AS total_session_time
FROM post_views pv
JOIN 
(SELECT session_id, 
        EXTRACT(EPOCH FROM session_endtime) - EXTRACT(EPOCH FROM session_starttime) AS session_time
FROM user_sessions) AS s ON pv.session_id = s.session_id
GROUP BY post_id
HAVING SUM((perc_viewed * session_time/100)::float) > 5;


## Explanation - Joining two schemas but in a different manner. 
