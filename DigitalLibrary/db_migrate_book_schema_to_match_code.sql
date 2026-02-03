-- Migration script: cập nhật schema Book để khớp với code hiện tại
-- Mục tiêu: thêm các cột mà code đang query (cover_url, currency, total_pages, preview_pages, ...)
-- và bổ sung workflow duyệt sách (approval_status, ...), đồng thời tạo Author/Category nếu cần.
--
-- LƯU Ý:
-- - Script này cố gắng "an toàn": chỉ ADD nếu cột/tables chưa tồn tại.
-- - Nếu bạn đang dùng schema Book cũ (author/category/cover_image/quantity), script sẽ map dữ liệu sang cột mới.
--
USE DigitalLibraryDB;
GO

IF OBJECT_ID(N'dbo.Book', N'U') IS NULL
BEGIN
    PRINT 'ERROR: Bảng Book chưa tồn tại. Hãy tạo Book trước rồi chạy script này.';
    RETURN;
END
GO

-- 1) Thêm các cột mới mà code đang dùng
IF COL_LENGTH('dbo.Book', 'summary') IS NULL
    ALTER TABLE dbo.Book ADD summary NVARCHAR(MAX) NULL;
GO

IF COL_LENGTH('dbo.Book', 'cover_url') IS NULL
    ALTER TABLE dbo.Book ADD cover_url NVARCHAR(500) NULL;
GO

IF COL_LENGTH('dbo.Book', 'content_path') IS NULL
    ALTER TABLE dbo.Book ADD content_path NVARCHAR(500) NULL;
GO

IF COL_LENGTH('dbo.Book', 'currency') IS NULL
    ALTER TABLE dbo.Book ADD currency NVARCHAR(10) NULL CONSTRAINT DF_Book_Currency DEFAULT 'VND';
GO

IF COL_LENGTH('dbo.Book', 'total_pages') IS NULL
    ALTER TABLE dbo.Book ADD total_pages INT NULL;
GO

IF COL_LENGTH('dbo.Book', 'preview_pages') IS NULL
    ALTER TABLE dbo.Book ADD preview_pages INT NULL;
GO

IF COL_LENGTH('dbo.Book', 'created_by_employee_id') IS NULL
    ALTER TABLE dbo.Book ADD created_by_employee_id INT NULL;
GO

IF COL_LENGTH('dbo.Book', 'updated_by_employee_id') IS NULL
    ALTER TABLE dbo.Book ADD updated_by_employee_id INT NULL;
GO

-- 2) Workflow duyệt sách
IF COL_LENGTH('dbo.Book', 'approval_status') IS NULL
    ALTER TABLE dbo.Book ADD approval_status NVARCHAR(20) NULL CONSTRAINT DF_Book_ApprovalStatus DEFAULT 'approved';
GO

IF COL_LENGTH('dbo.Book', 'approved_by_employee_id') IS NULL
    ALTER TABLE dbo.Book ADD approved_by_employee_id INT NULL;
GO

IF COL_LENGTH('dbo.Book', 'approval_notes') IS NULL
    ALTER TABLE dbo.Book ADD approval_notes NVARCHAR(MAX) NULL;
GO

IF COL_LENGTH('dbo.Book', 'approved_at') IS NULL
    ALTER TABLE dbo.Book ADD approved_at DATETIME2 NULL;
GO

-- 3) Author/Category tables (nếu code đang dùng)
IF OBJECT_ID(N'dbo.Author', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Author (
        author_id INT IDENTITY(1,1) PRIMARY KEY,
        author_name NVARCHAR(255) NOT NULL,
        bio NVARCHAR(MAX) NULL
    );
    CREATE UNIQUE INDEX UX_Author_Name ON dbo.Author(author_name);
END
GO

IF OBJECT_ID(N'dbo.Category', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Category (
        category_id INT IDENTITY(1,1) PRIMARY KEY,
        category_name NVARCHAR(100) NOT NULL,
        description NVARCHAR(MAX) NULL
    );
    CREATE UNIQUE INDEX UX_Category_Name ON dbo.Category(category_name);
END
GO

IF COL_LENGTH('dbo.Book', 'author_id') IS NULL
    ALTER TABLE dbo.Book ADD author_id INT NULL;
GO

IF COL_LENGTH('dbo.Book', 'category_id') IS NULL
    ALTER TABLE dbo.Book ADD category_id INT NULL;
GO

-- 4) Map dữ liệu từ schema cũ (nếu có cột author/category/cover_image)
IF COL_LENGTH('dbo.Book', 'cover_image') IS NOT NULL AND COL_LENGTH('dbo.Book', 'cover_url') IS NOT NULL
BEGIN
    UPDATE dbo.Book
    SET cover_url = COALESCE(cover_url, cover_image)
    WHERE cover_url IS NULL OR LTRIM(RTRIM(cover_url)) = '';
END
GO

-- Map Author
IF COL_LENGTH('dbo.Book', 'author') IS NOT NULL AND COL_LENGTH('dbo.Book', 'author_id') IS NOT NULL
BEGIN
    INSERT INTO dbo.Author(author_name)
    SELECT DISTINCT LTRIM(RTRIM(b.author))
    FROM dbo.Book b
    WHERE b.author IS NOT NULL AND LTRIM(RTRIM(b.author)) <> ''
      AND NOT EXISTS (SELECT 1 FROM dbo.Author a WHERE a.author_name = LTRIM(RTRIM(b.author)));

    UPDATE b
    SET author_id = a.author_id
    FROM dbo.Book b
    INNER JOIN dbo.Author a ON a.author_name = LTRIM(RTRIM(b.author))
    WHERE b.author_id IS NULL;
END
GO

-- Map Category
IF COL_LENGTH('dbo.Book', 'category') IS NOT NULL AND COL_LENGTH('dbo.Book', 'category_id') IS NOT NULL
BEGIN
    INSERT INTO dbo.Category(category_name)
    SELECT DISTINCT LTRIM(RTRIM(b.category))
    FROM dbo.Book b
    WHERE b.category IS NOT NULL AND LTRIM(RTRIM(b.category)) <> ''
      AND NOT EXISTS (SELECT 1 FROM dbo.Category c WHERE c.category_name = LTRIM(RTRIM(b.category)));

    UPDATE b
    SET category_id = c.category_id
    FROM dbo.Book b
    INNER JOIN dbo.Category c ON c.category_name = LTRIM(RTRIM(b.category))
    WHERE b.category_id IS NULL;
END
GO

-- 5) FK constraints (add nếu chưa có)
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Book_Author')
BEGIN
    ALTER TABLE dbo.Book WITH NOCHECK
    ADD CONSTRAINT FK_Book_Author FOREIGN KEY (author_id) REFERENCES dbo.Author(author_id);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Book_Category')
BEGIN
    ALTER TABLE dbo.Book WITH NOCHECK
    ADD CONSTRAINT FK_Book_Category FOREIGN KEY (category_id) REFERENCES dbo.Category(category_id);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Book_CreatedByEmployee')
BEGIN
    IF OBJECT_ID(N'dbo.Employee', N'U') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.Book WITH NOCHECK
        ADD CONSTRAINT FK_Book_CreatedByEmployee FOREIGN KEY (created_by_employee_id) REFERENCES dbo.Employee(employee_id);
    END
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Book_UpdatedByEmployee')
BEGIN
    IF OBJECT_ID(N'dbo.Employee', N'U') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.Book WITH NOCHECK
        ADD CONSTRAINT FK_Book_UpdatedByEmployee FOREIGN KEY (updated_by_employee_id) REFERENCES dbo.Employee(employee_id);
    END
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Book_ApprovedByEmployee')
BEGIN
    IF OBJECT_ID(N'dbo.Employee', N'U') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.Book WITH NOCHECK
        ADD CONSTRAINT FK_Book_ApprovedByEmployee FOREIGN KEY (approved_by_employee_id) REFERENCES dbo.Employee(employee_id);
    END
END
GO

-- 6) Indexes
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Book_ApprovalStatus' AND object_id = OBJECT_ID(N'dbo.Book'))
    CREATE INDEX IX_Book_ApprovalStatus ON dbo.Book(approval_status);
GO

PRINT 'DONE: Book schema đã được migrate để khớp code.';
GO

