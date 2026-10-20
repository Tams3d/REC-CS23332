SELECT c.user_id,
       c.reaction AS dominant_reaction,
       ROUND(c.c / t.total, 2) AS reaction_ratio
FROM (
    SELECT user_id, reaction, COUNT(*) AS c
    FROM reactions
    GROUP BY user_id, reaction
) c
JOIN (
    SELECT user_id,
           COUNT(*) AS total,
           COUNT(DISTINCT content_id) AS contents
    FROM reactions
    GROUP BY user_id
) t ON t.user_id = c.user_id
WHERE t.contents >= 5
  AND c.c / t.total >= 0.6
  AND NOT EXISTS (
      SELECT 1
      FROM (
          SELECT user_id, reaction, COUNT(*) AS c
          FROM reactions
          GROUP BY user_id, reaction
      ) c2
      WHERE c2.user_id = c.user_id
        AND (c2.c > c.c
             OR (c2.c = c.c AND c2.reaction < c.reaction))
  )
ORDER BY reaction_ratio DESC, c.user_id ASC;