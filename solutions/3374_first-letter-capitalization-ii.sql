WITH RECURSIVE nums AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM nums WHERE n < 1000
),
tokens AS (
    SELECT c.content_id,
           c.content_text,
           nm.n AS widx,
           SUBSTRING_INDEX(SUBSTRING_INDEX(c.content_text, ' ', nm.n), ' ', -1) AS word
    FROM user_content c
    JOIN nums nm
      ON nm.n <= CHAR_LENGTH(c.content_text) - CHAR_LENGTH(REPLACE(c.content_text, ' ', '')) + 1
),
parts AS (
    SELECT t.content_id,
           t.widx,
           nm.n AS pidx,
           SUBSTRING_INDEX(SUBSTRING_INDEX(t.word, '-', nm.n), '-', -1) AS part
    FROM tokens t
    JOIN nums nm
      ON nm.n <= CHAR_LENGTH(t.word) - CHAR_LENGTH(REPLACE(t.word, '-', '')) + 1
),
compound AS (
    SELECT content_id,
           widx,
           GROUP_CONCAT(CONCAT(UPPER(LEFT(part, 1)), LOWER(SUBSTRING(part, 2)))
                        ORDER BY pidx SEPARATOR '-') AS cword
    FROM parts
    GROUP BY content_id, widx
),
transformed AS (
    SELECT t.content_id,
           t.content_text,
           t.widx,
           CASE
               WHEN t.word = '' THEN ''
               WHEN t.word NOT REGEXP '^[A-Za-z]' THEN t.word
               WHEN t.word REGEXP '^[A-Za-z]+(-[A-Za-z]+)+$' THEN cp.cword
               ELSE CONCAT(UPPER(LEFT(t.word, 1)), LOWER(SUBSTRING(t.word, 2)))
           END AS nword
    FROM tokens t
    LEFT JOIN compound cp
      ON cp.content_id = t.content_id AND cp.widx = t.widx
)
SELECT content_id,
       MAX(content_text) AS original_text,
       GROUP_CONCAT(nword ORDER BY widx SEPARATOR ' ') AS converted_text
FROM transformed
GROUP BY content_id
ORDER BY content_id
