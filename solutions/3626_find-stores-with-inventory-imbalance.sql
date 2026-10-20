WITH store_counts AS (
    SELECT store_id, COUNT(DISTINCT product_name) AS product_count
    FROM inventory
    GROUP BY store_id
),
ranked AS (
    SELECT i.store_id,
           s.store_name,
           s.location,
           i.product_name,
           i.quantity,
           ROW_NUMBER() OVER (PARTITION BY i.store_id ORDER BY i.price DESC, i.product_name ASC) AS rn_expensive,
           ROW_NUMBER() OVER (PARTITION BY i.store_id ORDER BY i.price ASC, i.product_name ASC) AS rn_cheapest
    FROM inventory i
    JOIN stores s ON s.store_id = i.store_id
)
SELECT r.store_id,
       r.store_name,
       r.location,
       MAX(CASE WHEN r.rn_expensive = 1 THEN r.product_name END) AS most_exp_product,
       MAX(CASE WHEN r.rn_cheapest = 1 THEN r.product_name END) AS cheapest_product,
       ROUND(MAX(CASE WHEN r.rn_cheapest = 1 THEN r.quantity END) /
             MAX(CASE WHEN r.rn_expensive = 1 THEN r.quantity END), 2) AS imbalance_ratio
FROM ranked r
JOIN store_counts c ON c.store_id = r.store_id
WHERE c.product_count >= 3
GROUP BY r.store_id, r.store_name, r.location
HAVING MAX(CASE WHEN r.rn_expensive = 1 THEN r.quantity END) <
       MAX(CASE WHEN r.rn_cheapest = 1 THEN r.quantity END)
ORDER BY imbalance_ratio DESC, r.store_name ASC
