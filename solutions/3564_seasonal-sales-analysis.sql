WITH sales_season AS (
    SELECT CASE
               WHEN MONTH(s.sale_date) IN (12, 1, 2) THEN 'Winter'
               WHEN MONTH(s.sale_date) IN (3, 4, 5) THEN 'Spring'
               WHEN MONTH(s.sale_date) IN (6, 7, 8) THEN 'Summer'
               ELSE 'Fall'
           END AS season,
           p.category,
           s.quantity,
           s.quantity * s.price AS revenue
    FROM sales s
    JOIN products p ON p.product_id = s.product_id
),
category_totals AS (
    SELECT season,
           category,
           SUM(quantity) AS total_quantity,
           SUM(revenue) AS total_revenue
    FROM sales_season
    GROUP BY season, category
),
ranked AS (
    SELECT season,
           category,
           total_quantity,
           total_revenue,
           ROW_NUMBER() OVER (
               PARTITION BY season
               ORDER BY total_quantity DESC, total_revenue DESC, category ASC
           ) AS rn
    FROM category_totals
)
SELECT season,
       category,
       total_quantity,
       ROUND(total_revenue, 2) AS total_revenue
FROM ranked
WHERE rn = 1
ORDER BY season ASC
