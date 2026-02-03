-- Script để kiểm tra và xóa duplicate books trong database
-- Chạy script này để kiểm tra xem có duplicate records không

USE DigitalLibraryDB;
GO

-- Kiểm tra duplicate books dựa trên book_id
SELECT book_id, title, COUNT(*) as count
FROM Book
GROUP BY book_id, title
HAVING COUNT(*) > 1;
GO

-- Kiểm tra duplicate books dựa trên title (nếu có thể có cùng title)
SELECT title, COUNT(*) as count
FROM Book
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY count DESC;
GO

-- Kiểm tra tổng số books
SELECT COUNT(*) as total_books FROM Book;
GO

-- Kiểm tra books với status
SELECT status, COUNT(*) as count
FROM Book
GROUP BY status;
GO

-- Xem một vài records mẫu
SELECT TOP 10 book_id, title, author_id, category_id, status, created_at
FROM Book
ORDER BY created_at DESC;
GO

-- Nếu có duplicate, có thể chạy script sau để xóa (CẨN THẬN!)
-- Chỉ giữ lại record đầu tiên, xóa các record duplicate
/*
WITH CTE AS (
    SELECT book_id, title,
           ROW_NUMBER() OVER (PARTITION BY book_id ORDER BY created_at) as rn
    FROM Book
)
DELETE FROM Book
WHERE book_id IN (
    SELECT book_id FROM CTE WHERE rn > 1
);
*/
