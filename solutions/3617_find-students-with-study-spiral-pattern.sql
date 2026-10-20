SELECT st.student_id,
       st.student_name,
       st.major,
       CAST(SUBSTRING_INDEX(GROUP_CONCAT(v.L ORDER BY v.L ASC, v.total_hours DESC), ',', 1) AS UNSIGNED) AS cycle_length,
       CAST(SUBSTRING_INDEX(GROUP_CONCAT(v.total_hours ORDER BY v.L ASC, v.total_hours DESC), ',', 1) AS DECIMAL(10, 2)) AS total_study_hours
FROM (SELECT a.student_id,
       a.rn AS start_rn,
       b.rn AS end_rn,
       N.n AS L,
       (SELECT SUM(x.hours_studied)
        FROM (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) x
        WHERE x.student_id = a.student_id
          AND x.rn BETWEEN a.rn AND b.rn) AS total_hours
FROM (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) a
JOIN (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) b
  ON b.student_id = a.student_id
 AND b.rn >= a.rn
JOIN (SELECT ones.n + tens.n * 10 + hundreds.n * 100 + 1 AS n
 FROM (SELECT 0 AS n UNION ALL SELECT 1 AS n UNION ALL SELECT 2 AS n UNION ALL SELECT 3 AS n UNION ALL SELECT 4 AS n UNION ALL SELECT 5 AS n UNION ALL SELECT 6 AS n UNION ALL SELECT 7 AS n UNION ALL SELECT 8 AS n UNION ALL SELECT 9 AS n) ones
 CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 AS n UNION ALL SELECT 2 AS n UNION ALL SELECT 3 AS n UNION ALL SELECT 4 AS n UNION ALL SELECT 5 AS n UNION ALL SELECT 6 AS n UNION ALL SELECT 7 AS n UNION ALL SELECT 8 AS n UNION ALL SELECT 9 AS n) tens
 CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 AS n UNION ALL SELECT 2 AS n UNION ALL SELECT 3 AS n UNION ALL SELECT 4 AS n UNION ALL SELECT 5 AS n UNION ALL SELECT 6 AS n UNION ALL SELECT 7 AS n UNION ALL SELECT 8 AS n UNION ALL SELECT 9 AS n) hundreds) N
  ON N.n >= 3
 AND N.n * 2 <= b.rn - a.rn + 1
 AND (b.rn - a.rn + 1) % N.n = 0
WHERE NOT EXISTS (
          SELECT 1
          FROM (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) x
          JOIN (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) y
            ON y.student_id = x.student_id
           AND y.rn = x.rn + 1
          WHERE x.student_id = a.student_id
            AND x.rn >= a.rn
            AND x.rn < b.rn
            AND DATEDIFF(y.session_date, x.session_date) > 2
      )
  AND NOT EXISTS (
          SELECT 1
          FROM (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) x
          JOIN (SELECT s1.student_id,
       s1.session_id,
       s1.subject,
       s1.session_date,
       s1.hours_studied,
       (SELECT COUNT(*)
        FROM study_sessions s2
        WHERE s2.student_id = s1.student_id
          AND (s2.session_date < s1.session_date
               OR (s2.session_date = s1.session_date
                   AND s2.session_id < s1.session_id))) + 1 AS rn
FROM study_sessions s1) y
            ON y.student_id = x.student_id
           AND y.rn = x.rn + N.n
          WHERE x.student_id = a.student_id
            AND x.rn >= a.rn
            AND x.rn + N.n <= b.rn
            AND x.subject <> y.subject
      )) v
JOIN students st ON st.student_id = v.student_id
GROUP BY st.student_id, st.student_name, st.major
ORDER BY cycle_length DESC, total_study_hours DESC;
