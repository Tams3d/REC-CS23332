WITH daily AS (
    SELECT user_id, action_date, MIN(action) AS action, COUNT(*) AS cnt
    FROM activity
    GROUP BY user_id, action_date
),
valid AS (
    SELECT user_id, action_date, action
    FROM daily
    WHERE cnt = 1
),
grp AS (
    SELECT user_id, action, action_date,
           DATE_SUB(action_date,
                    INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id, action ORDER BY action_date) DAY) AS grpkey
    FROM valid
),
streaks AS (
    SELECT user_id, action,
           MIN(action_date) AS start_date,
           MAX(action_date) AS end_date,
           COUNT(*) AS streak_length
    FROM grp
    GROUP BY user_id, action, grpkey
),
best AS (
    SELECT user_id, action, streak_length, start_date, end_date,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY streak_length DESC, start_date ASC) AS rn
    FROM streaks
    WHERE streak_length >= 5
)
SELECT user_id, action, streak_length, start_date, end_date
FROM best
WHERE rn = 1
ORDER BY streak_length DESC, user_id ASC;
