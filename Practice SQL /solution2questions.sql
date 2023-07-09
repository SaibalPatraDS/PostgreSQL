## Questions ##

  /*
-- 1. Show all of the patients grouped into weight groups.
     Show the total amount of patients in each weight group.
     Order the list by the weight group decending.

For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
*/

-- Solution : 
SELECT COUNT(patient_id) AS patients_in_grp,
       CASE WHEN weight < 10 THEN 0
            WHEN weight < 20 THEN 10
            WHEN weight < 30 THEN 20
            WHEN weight < 40 THEN 30
            WHEN weight < 50 THEN 40
            WHEN weight < 60 THEN 50
            WHEN weight < 70 THEN 60
            WHEN weight < 80 THEN 70
            WHEN weight < 90 THEN 80
            WHEN weight < 100 THEN 90
            WHEN weight < 110 THEN 100
            WHEN weight < 120 THEN 110
            WHEN weight < 130 THEN 120
            WHEN weight < 140 THEN 130
            WHEN weight < 150 THEN 140
         END AS patient_grp
FROM patients
GROUP BY patient_grp
ORDER BY patient_grp DESC;


SELECT COUNT(*) AS patients_in_grp,
       FLOOR(weight/10) * 10 AS weight_grp
FROM patients
GROUP BY weight_grp
ORDER BY weight_grp DESC;


/* Alternative */

SELECT
  COUNT(*) AS patients_in_group,
  FLOOR(weight / 10) * 10 AS weight_group
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;





