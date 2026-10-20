WITH daily AS (
    SELECT visited_on, SUM(amount) AS amount
    FROM Customer
    GROUP BY visited_on
),
windowed AS (
    SELECT visited_on,
           SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
           ROUND(AVG(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount,
           ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM daily
)
SELECT visited_on, amount, average_amount
FROM windowed
WHERE rn >= 7
ORDER BY visited_on;
