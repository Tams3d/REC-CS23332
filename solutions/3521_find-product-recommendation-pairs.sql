WITH user_product AS (
    SELECT DISTINCT user_id, product_id
    FROM ProductPurchases
)
SELECT a.product_id AS product1_id,
       b.product_id AS product2_id,
       ia.category AS product1_category,
       ib.category AS product2_category,
       COUNT(*) AS customer_count
FROM user_product a
JOIN user_product b
  ON a.user_id = b.user_id
 AND a.product_id < b.product_id
JOIN ProductInfo ia ON a.product_id = ia.product_id
JOIN ProductInfo ib ON b.product_id = ib.product_id
GROUP BY a.product_id, b.product_id, ia.category, ib.category
HAVING COUNT(*) >= 3
ORDER BY customer_count DESC, product1_id ASC, product2_id ASC;
