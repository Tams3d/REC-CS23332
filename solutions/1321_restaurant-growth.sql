SELECT d1.visited_on,
       SUM(d2.amount) AS amount,
       ROUND(AVG(d2.amount), 2) AS average_amount
FROM (SELECT visited_on, SUM(amount) AS amount
      FROM Customer
      GROUP BY visited_on) d1
JOIN (SELECT visited_on, SUM(amount) AS amount
      FROM Customer
      GROUP BY visited_on) d2
  ON d2.visited_on BETWEEN DATE_SUB(d1.visited_on, INTERVAL 6 DAY) AND d1.visited_on
GROUP BY d1.visited_on
HAVING COUNT(*) = 7
ORDER BY d1.visited_on;