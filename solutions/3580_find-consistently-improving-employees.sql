SELECT e.employee_id,
       e.name,
       t.r1 - t.r3 AS improvement_score
FROM employees e
JOIN (
    SELECT employee_id,
           MAX(CASE WHEN rn = 1 THEN rating END) AS r1,
           MAX(CASE WHEN rn = 2 THEN rating END) AS r2,
           MAX(CASE WHEN rn = 3 THEN rating END) AS r3,
           COUNT(*) AS cnt
    FROM (
        SELECT employee_id,
               rating,
               ROW_NUMBER() OVER (PARTITION BY employee_id ORDER BY review_date DESC) AS rn
        FROM performance_reviews
    ) x
    WHERE rn <= 3
    GROUP BY employee_id
) t ON t.employee_id = e.employee_id
WHERE t.cnt = 3
  AND t.r3 < t.r2
  AND t.r2 < t.r1
ORDER BY improvement_score DESC, e.name ASC
