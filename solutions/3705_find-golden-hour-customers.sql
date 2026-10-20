SELECT customer_id,
       COUNT(*) AS total_orders,
       ROUND(100 * SUM(HOUR(order_timestamp) BETWEEN 11 AND 13 OR HOUR(order_timestamp) BETWEEN 18 AND 20) / COUNT(*)) AS peak_hour_percentage,
       ROUND(AVG(order_rating), 2) AS average_rating
FROM restaurant_orders
GROUP BY customer_id
HAVING COUNT(*) >= 3
   AND SUM(HOUR(order_timestamp) BETWEEN 11 AND 13 OR HOUR(order_timestamp) BETWEEN 18 AND 20) / COUNT(*) >= 0.6
   AND COUNT(order_rating) >= 0.5 * COUNT(*)
   AND AVG(order_rating) >= 4.0
ORDER BY average_rating DESC, customer_id DESC
