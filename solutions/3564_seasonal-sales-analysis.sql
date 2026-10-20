SELECT a.season,
       a.category,
       a.total_quantity,
       ROUND(a.total_revenue, 2) AS total_revenue
FROM (
    SELECT season,
           category,
           SUM(quantity) AS total_quantity,
           SUM(quantity * price) AS total_revenue
    FROM (
        SELECT CASE
                   WHEN MONTH(s.sale_date) IN (12, 1, 2) THEN 'Winter'
                   WHEN MONTH(s.sale_date) IN (3, 4, 5) THEN 'Spring'
                   WHEN MONTH(s.sale_date) IN (6, 7, 8) THEN 'Summer'
                   ELSE 'Fall'
               END AS season,
               p.category,
               s.quantity,
               s.price
        FROM sales s
        JOIN products p ON p.product_id = s.product_id
    ) x
    GROUP BY season, category
) a
LEFT JOIN (
    SELECT season,
           category,
           SUM(quantity) AS total_quantity,
           SUM(quantity * price) AS total_revenue
    FROM (
        SELECT CASE
                   WHEN MONTH(s.sale_date) IN (12, 1, 2) THEN 'Winter'
                   WHEN MONTH(s.sale_date) IN (3, 4, 5) THEN 'Spring'
                   WHEN MONTH(s.sale_date) IN (6, 7, 8) THEN 'Summer'
                   ELSE 'Fall'
               END AS season,
               p.category,
               s.quantity,
               s.price
        FROM sales s
        JOIN products p ON p.product_id = s.product_id
    ) y
    GROUP BY season, category
) b
  ON b.season = a.season
 AND (b.total_quantity > a.total_quantity
      OR (b.total_quantity = a.total_quantity AND b.total_revenue > a.total_revenue)
      OR (b.total_quantity = a.total_quantity AND b.total_revenue = a.total_revenue AND b.category < a.category))
WHERE b.season IS NULL
ORDER BY a.season ASC;