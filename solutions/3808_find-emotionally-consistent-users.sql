WITH cnt AS (
    SELECT user_id, reaction, COUNT(*) AS c
    FROM reactions
    GROUP BY user_id, reaction
),
tot AS (
    SELECT user_id,
           COUNT(*) AS total,
           COUNT(DISTINCT content_id) AS contents
    FROM reactions
    GROUP BY user_id
),
ranked AS (
    SELECT cnt.user_id,
           cnt.reaction,
           cnt.c,
           tot.total,
           tot.contents,
           ROW_NUMBER() OVER (PARTITION BY cnt.user_id ORDER BY cnt.c DESC, cnt.reaction ASC) AS rn
    FROM cnt
    JOIN tot ON tot.user_id = cnt.user_id
)
SELECT user_id,
       reaction AS dominant_reaction,
       ROUND(c / total, 2) AS reaction_ratio
FROM ranked
WHERE rn = 1
  AND contents >= 5
  AND c / total >= 0.6
ORDER BY reaction_ratio DESC, user_id ASC;
