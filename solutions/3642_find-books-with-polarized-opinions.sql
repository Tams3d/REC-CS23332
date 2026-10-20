SELECT b.book_id,
       b.title,
       b.author,
       b.genre,
       b.pages,
       MAX(rs.session_rating) - MIN(rs.session_rating) AS rating_spread,
       ROUND(SUM(rs.session_rating <= 2 OR rs.session_rating >= 4) / COUNT(*), 2) AS polarization_score
FROM books b
JOIN reading_sessions rs ON rs.book_id = b.book_id
GROUP BY b.book_id, b.title, b.author, b.genre, b.pages
HAVING COUNT(*) >= 5
   AND MAX(rs.session_rating) >= 4
   AND MIN(rs.session_rating) <= 2
   AND SUM(rs.session_rating <= 2 OR rs.session_rating >= 4) / COUNT(*) >= 0.6
ORDER BY polarization_score DESC, b.title DESC;
