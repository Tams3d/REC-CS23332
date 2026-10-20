SELECT b.user_id,
       b.action,
       b.streak_length,
       b.start_date,
       b.end_date
FROM (
    SELECT user_id,
           action,
           MIN(action_date) AS start_date,
           MAX(action_date) AS end_date,
           COUNT(*) AS streak_length
    FROM (
        SELECT v1.user_id,
               v1.action,
               v1.action_date,
               DATE_SUB(v1.action_date, INTERVAL (
                   SELECT COUNT(*)
                   FROM (
                       SELECT user_id, action_date, MIN(action) AS action
                       FROM activity
                       GROUP BY user_id, action_date
                       HAVING COUNT(*) = 1
                   ) v2
                   WHERE v2.user_id = v1.user_id
                     AND v2.action = v1.action
                     AND v2.action_date < v1.action_date
               ) DAY) AS grpkey
        FROM (
            SELECT user_id, action_date, MIN(action) AS action
            FROM activity
            GROUP BY user_id, action_date
            HAVING COUNT(*) = 1
        ) v1
    ) g
    GROUP BY user_id, action, grpkey
) b
WHERE b.streak_length >= 5
  AND NOT EXISTS (
      SELECT 1
      FROM (
          SELECT user_id,
                 action,
                 MIN(action_date) AS start_date,
                 MAX(action_date) AS end_date,
                 COUNT(*) AS streak_length
          FROM (
              SELECT v1.user_id,
                     v1.action,
                     v1.action_date,
                     DATE_SUB(v1.action_date, INTERVAL (
                         SELECT COUNT(*)
                         FROM (
                             SELECT user_id, action_date, MIN(action) AS action
                             FROM activity
                             GROUP BY user_id, action_date
                             HAVING COUNT(*) = 1
                         ) v2
                         WHERE v2.user_id = v1.user_id
                           AND v2.action = v1.action
                           AND v2.action_date < v1.action_date
                     ) DAY) AS grpkey
              FROM (
                  SELECT user_id, action_date, MIN(action) AS action
                  FROM activity
                  GROUP BY user_id, action_date
                  HAVING COUNT(*) = 1
              ) v1
          ) g
          GROUP BY user_id, action, grpkey
      ) b2
      WHERE b2.user_id = b.user_id
        AND b2.streak_length >= 5
        AND (b2.streak_length > b.streak_length
             OR (b2.streak_length = b.streak_length AND b2.start_date < b.start_date))
  )
ORDER BY b.streak_length DESC, b.user_id ASC;