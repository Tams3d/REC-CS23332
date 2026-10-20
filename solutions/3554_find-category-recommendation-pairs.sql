SELECT a.category AS category1,
       b.category AS category2,
       COUNT(DISTINCT a.user_id) AS customer_count
FROM (SELECT DISTINCT p.user_id, i.category
      FROM ProductPurchases p
      JOIN ProductInfo i ON p.product_id = i.product_id) a
JOIN (SELECT DISTINCT p.user_id, i.category
      FROM ProductPurchases p
      JOIN ProductInfo i ON p.product_id = i.product_id) b
  ON a.user_id = b.user_id
 AND a.category < b.category
GROUP BY a.category, b.category
HAVING COUNT(DISTINCT a.user_id) >= 3
ORDER BY customer_count DESC, category1 ASC, category2 ASC;