USE [DigitalLibraryDB]
GO

-- Insert 10 copies for each active book
DECLARE @BookID INT, @Stock INT;
DECLARE book_cursor CURSOR FOR
SELECT BookID, stock_quantity FROM Book WHERE Status = 'active' AND stock_quantity > 0;

OPEN book_cursor;
FETCH NEXT FROM book_cursor INTO @BookID, @Stock;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @i INT = 1;
    WHILE @i <= @Stock
    BEGIN
        INSERT INTO BookCopy (book_id, copy_code, status, created_at)
        VALUES (@BookID, CONCAT('B', @BookID, '-CP', @i), 'available', GETDATE());
        SET @i = @i + 1;
    END

    FETCH NEXT FROM book_cursor INTO @BookID, @Stock;
END

CLOSE book_cursor;
DEALLOCATE book_cursor;
GO
