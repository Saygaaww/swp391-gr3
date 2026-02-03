-- Script để thêm các field approval vào bảng Book
-- Chạy script này để hỗ trợ workflow phê duyệt sách từ seller

USE DigitalLibraryDB;
GO

-- Thêm field approval_status vào Book table
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Book]') AND name = 'approval_status')
BEGIN
    ALTER TABLE Book ADD approval_status NVARCHAR(20) DEFAULT 'pending_approval';
    PRINT 'Đã thêm field approval_status vào bảng Book';
END
ELSE
BEGIN
    PRINT 'Field approval_status đã tồn tại';
END
GO

-- Thêm field approved_by_employee_id
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Book]') AND name = 'approved_by_employee_id')
BEGIN
    ALTER TABLE Book ADD approved_by_employee_id INT NULL;
    ALTER TABLE Book ADD CONSTRAINT FK_Book_ApprovedByEmployee 
        FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id);
    PRINT 'Đã thêm field approved_by_employee_id vào bảng Book';
END
ELSE
BEGIN
    PRINT 'Field approved_by_employee_id đã tồn tại';
END
GO

-- Thêm field approval_notes
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Book]') AND name = 'approval_notes')
BEGIN
    ALTER TABLE Book ADD approval_notes NVARCHAR(MAX) NULL;
    PRINT 'Đã thêm field approval_notes vào bảng Book';
END
ELSE
BEGIN
    PRINT 'Field approval_notes đã tồn tại';
END
GO

-- Thêm field approved_at
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Book]') AND name = 'approved_at')
BEGIN
    ALTER TABLE Book ADD approved_at DATETIME2 NULL;
    PRINT 'Đã thêm field approved_at vào bảng Book';
END
ELSE
BEGIN
    PRINT 'Field approved_at đã tồn tại';
END
GO

-- Tạo index cho tìm kiếm nhanh
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_book_approval_status' AND object_id = OBJECT_ID(N'[dbo].[Book]'))
BEGIN
    CREATE INDEX idx_book_approval_status ON Book(approval_status);
    PRINT 'Đã tạo index idx_book_approval_status';
END
ELSE
BEGIN
    PRINT 'Index idx_book_approval_status đã tồn tại';
END
GO

-- Update các sách hiện tại (của Admin/Librarian) → approved
-- Các sách đã có sẽ được tự động approved
UPDATE Book 
SET approval_status = 'approved' 
WHERE approval_status IS NULL OR approval_status = '';
GO

PRINT 'Đã cập nhật các sách hiện tại thành approved';
GO

PRINT 'Hoàn thành! Các field approval đã được thêm vào bảng Book.';
GO
