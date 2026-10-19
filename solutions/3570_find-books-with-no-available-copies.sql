SELECT b.book_id, b.title, b.author, b.genre, b.publication_year, COUNT(b2.record_id) AS current_borrowers
FROM library_books b
JOIN borrowing_records b2 ON b2.book_id = b.book_id AND b2.return_date IS NULL
GROUP BY b.book_id, b.title, b.author, b.genre, b.publication_year, b.total_copies
HAVING COUNT(b2.record_id) = b.total_copies
ORDER BY current_borrowers DESC, b.title ASC