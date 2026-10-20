SELECT first_course,
       second_course,
       COUNT(*) AS transition_count
FROM (
    SELECT c1.course_name AS first_course,
           (SELECT c2.course_name
            FROM course_completions c2
            WHERE c2.user_id = c1.user_id
              AND (c2.completion_date > c1.completion_date
                   OR (c2.completion_date = c1.completion_date
                       AND c2.course_id > c1.course_id))
            ORDER BY c2.completion_date, c2.course_id
            LIMIT 1) AS second_course
    FROM course_completions c1
    WHERE c1.user_id IN (
        SELECT user_id
        FROM course_completions
        GROUP BY user_id
        HAVING COUNT(*) >= 5
           AND AVG(course_rating) >= 4
    )
) p
WHERE second_course IS NOT NULL
GROUP BY first_course, second_course
ORDER BY transition_count DESC, first_course ASC, second_course ASC;