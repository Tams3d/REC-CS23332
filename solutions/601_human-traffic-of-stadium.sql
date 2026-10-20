WITH valid AS (
    SELECT id,
           visit_date,
           people,
           id - ROW_NUMBER() OVER (ORDER BY id) AS grp
    FROM Stadium
    WHERE people >= 100
)
SELECT id, visit_date, people
FROM valid
WHERE grp IN (
    SELECT grp
    FROM valid
    GROUP BY grp
    HAVING COUNT(*) >= 3
)
ORDER BY visit_date;
