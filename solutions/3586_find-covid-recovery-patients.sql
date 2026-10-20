SELECT p.patient_id,
       p.patient_name,
       p.age,
       DATEDIFF(t.neg_date, t.pos_date) AS recovery_time
FROM patients p
JOIN (
    SELECT c.patient_id,
           c.pos_date,
           (SELECT MIN(c2.test_date)
            FROM covid_tests c2
            WHERE c2.patient_id = c.patient_id
              AND c2.result = 'Negative'
              AND c2.test_date > c.pos_date) AS neg_date
    FROM (
        SELECT patient_id, MIN(test_date) AS pos_date
        FROM covid_tests
        WHERE result = 'Positive'
        GROUP BY patient_id
    ) c
) t ON t.patient_id = p.patient_id
WHERE t.neg_date IS NOT NULL
ORDER BY recovery_time ASC, p.patient_name ASC;
