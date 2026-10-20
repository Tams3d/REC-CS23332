SELECT f.student_id,
       f.subject,
       f.score AS first_score,
       l.score AS latest_score
FROM (
    SELECT s1.student_id, s1.subject, s1.score
    FROM Scores s1
    WHERE s1.exam_date = (SELECT MIN(s2.exam_date)
                          FROM Scores s2
                          WHERE s2.student_id = s1.student_id
                            AND s2.subject = s1.subject)
) f
JOIN (
    SELECT s1.student_id, s1.subject, s1.score
    FROM Scores s1
    WHERE s1.exam_date = (SELECT MAX(s2.exam_date)
                          FROM Scores s2
                          WHERE s2.student_id = s1.student_id
                            AND s2.subject = s1.subject)
) l
  ON l.student_id = f.student_id AND l.subject = f.subject
WHERE (SELECT COUNT(*)
       FROM Scores s3
       WHERE s3.student_id = f.student_id
         AND s3.subject = f.subject) >= 2
  AND l.score > f.score
ORDER BY f.student_id, f.subject;