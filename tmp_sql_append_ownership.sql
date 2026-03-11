USE DigitalLibraryDB;
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reader_Book_Ownership]') AND type in (N'U'))
BEGIN
CREATE TABLE Reader_Book_Ownership (
    ownership_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    acquired_via NVARCHAR(50) NULL,
    status NVARCHAR(30) DEFAULT 'active',
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Ownership_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Ownership_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO
