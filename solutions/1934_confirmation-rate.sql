SELECT user_id, 0.00 AS confirmation_rate
FROM Signups
WHERE user_id NOT IN (SELECT user_id FROM Confirmations)
UNION
SELECT user_id, ROUND(SUM(action = 'confirmed') / COUNT(*), 2) AS confirmation_rate
FROM Confirmations
GROUP BY user_id
