SELECT st.store_id,
       st.store_name,
       st.location,
       exp.product_name AS most_exp_product,
       chp.product_name AS cheapest_product,
       ROUND(chp.quantity / exp.quantity, 2) AS imbalance_ratio
FROM stores st
JOIN (
    SELECT i.store_id, i.product_name, i.quantity
    FROM inventory i
    WHERE NOT EXISTS (
        SELECT 1
        FROM inventory i2
        WHERE i2.store_id = i.store_id
          AND (i2.price > i.price
               OR (i2.price = i.price AND i2.product_name < i.product_name))
    )
) exp ON exp.store_id = st.store_id
JOIN (
    SELECT i.store_id, i.product_name, i.quantity
    FROM inventory i
    WHERE NOT EXISTS (
        SELECT 1
        FROM inventory i2
        WHERE i2.store_id = i.store_id
          AND (i2.price < i.price
               OR (i2.price = i.price AND i2.product_name < i.product_name))
    )
) chp ON chp.store_id = st.store_id
WHERE (SELECT COUNT(DISTINCT i3.product_name)
       FROM inventory i3
       WHERE i3.store_id = st.store_id) >= 3
  AND exp.quantity < chp.quantity
ORDER BY imbalance_ratio DESC, st.store_name ASC;