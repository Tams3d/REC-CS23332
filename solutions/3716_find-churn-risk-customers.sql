WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_date DESC, event_id DESC) AS rn
    FROM subscription_events
),
agg AS (
    SELECT user_id,
           MAX(monthly_amount) AS max_amt,
           MIN(event_date) AS first_date,
           MAX(CASE WHEN event_type = 'downgrade' THEN 1 ELSE 0 END) AS has_downgrade
    FROM subscription_events
    GROUP BY user_id
)
SELECT r.user_id,
       r.plan_name AS current_plan,
       r.monthly_amount AS current_monthly_amount,
       a.max_amt AS max_historical_amount,
       DATEDIFF(r.event_date, a.first_date) AS days_as_subscriber
FROM ranked r
JOIN agg a ON a.user_id = r.user_id
WHERE r.rn = 1
  AND r.event_type <> 'cancel'
  AND a.has_downgrade = 1
  AND r.monthly_amount < 0.5 * a.max_amt
  AND DATEDIFF(r.event_date, a.first_date) >= 60
ORDER BY days_as_subscriber DESC, r.user_id ASC
