SELECT e.employee_id,
       e.name,
       t.r1 - t.r3 AS improvement_score
FROM employees e
JOIN (
    SELECT x.employee_id,
           MAX(CASE WHEN x.rn = 1 THEN x.rating END) AS r1,
           MAX(CASE WHEN x.rn = 2 THEN x.rating END) AS r2,
           MAX(CASE WHEN x.rn = 3 THEN x.rating END) AS r3,
           COUNT(*) AS cnt
    FROM (
        SELECT p1.employee_id,
               p1.rating,
               (SELECT COUNT(*)
                FROM performance_reviews p2
                WHERE p2.employee_id = p1.employee_id
                  AND p2.review_date > p1.review_date) + 1 AS rn
        FROM performance_reviews p1
    ) x
    WHERE x.rn <= 3
    GROUP BY x.employee_id
) t ON t.employee_id = e.employee_id
WHERE t.cnt = 3
  AND t.r3 < t.r2
  AND t.r2 < t.r1
ORDER BY improvement_score DESC, e.name ASC;