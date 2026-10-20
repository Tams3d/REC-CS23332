SELECT s.id, s.visit_date, s.people
FROM Stadium s
WHERE s.people >= 100
  AND EXISTS (
      SELECT 1
      FROM Stadium s1
      JOIN Stadium s2 ON s2.id = s1.id + 1 AND s2.people >= 100
      JOIN Stadium s3 ON s3.id = s1.id + 2 AND s3.people >= 100
      WHERE s1.people >= 100
        AND s.id BETWEEN s1.id AND s1.id + 2
  )
ORDER BY s.visit_date;