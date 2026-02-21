-- Mot reader chi duoc 1 review moi sach
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Review_Reader_Book' AND object_id = OBJECT_ID('Review'))
    CREATE UNIQUE INDEX IX_Review_Reader_Book ON Review(reader_id, book_id);
GO

-- Mot dong moi (reader, book) de luu tien do doc
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Reading_History_Reader_Book' AND object_id = OBJECT_ID('Reading_History'))
    CREATE UNIQUE INDEX IX_Reading_History_Reader_Book ON Reading_History(reader_id, book_id);
GO