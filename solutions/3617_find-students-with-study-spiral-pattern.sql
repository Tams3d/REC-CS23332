WITH RECURSIVE nums AS (
    SELECT 1 AS k
    UNION ALL
    SELECT k + 1 FROM nums WHERE k < 1000
),
s AS (
    SELECT student_id,
           subject,
           session_date,
           hours_studied,
           session_id,
           ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY session_date, session_id) AS rn
    FROM study_sessions
),
d AS (
    SELECT *,
           DATEDIFF(session_date, LAG(session_date) OVER (PARTITION BY student_id ORDER BY session_date, session_id)) AS diff
    FROM s
),
seg AS (
    SELECT *,
           SUM(CASE WHEN diff > 2 OR diff IS NULL THEN 1 ELSE 0 END)
               OVER (PARTITION BY student_id ORDER BY session_date, session_id) AS seg_id
    FROM d
),
seg_info AS (
    SELECT student_id,
           seg_id,
           COUNT(*) AS n,
           SUM(hours_studied) AS total_hours
    FROM seg
    GROUP BY student_id, seg_id
    HAVING COUNT(*) >= 6
),
valid AS (
    SELECT si.student_id,
           si.seg_id,
           si.total_hours,
           num.k AS L
    FROM seg_info si
    JOIN nums num
      ON num.k >= 3
     AND num.k * 2 <= si.n
     AND si.n % num.k = 0
    WHERE NOT EXISTS (
        SELECT 1
        FROM seg a
        JOIN seg b
          ON b.student_id = a.student_id
         AND b.seg_id = a.seg_id
         AND b.rn = a.rn + num.k
        WHERE a.student_id = si.student_id
          AND a.seg_id = si.seg_id
          AND a.subject <> b.subject
    )
),
best AS (
    SELECT student_id,
           seg_id,
           L,
           total_hours,
           ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY L ASC, total_hours DESC) AS rn
    FROM valid
)
SELECT st.student_id,
       st.student_name,
       st.major,
       b.L AS cycle_length,
       b.total_hours AS total_study_hours
FROM best b
JOIN students st ON st.student_id = b.student_id
WHERE b.rn = 1
ORDER BY b.L DESC, b.total_hours DESC
