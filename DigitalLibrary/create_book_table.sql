-- Script để tạo bảng Book cho hệ thống Digital Library
-- Chạy script này để tạo bảng Book trong database

USE DigitalLibraryDB;
GO

-- Tạo bảng Book
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Book]') AND type in (N'U'))
BEGIN
    CREATE TABLE Book (
        book_id INT IDENTITY(1,1) PRIMARY KEY,
        title NVARCHAR(255) NOT NULL,
        author NVARCHAR(255) NOT NULL,
        isbn NVARCHAR(50) UNIQUE,
        description NVARCHAR(MAX),
        category NVARCHAR(100),
        price DECIMAL(10,2) DEFAULT 0.00,
        quantity INT DEFAULT 0,
        cover_image NVARCHAR(500),
        status NVARCHAR(20) DEFAULT 'available', -- available, unavailable, deleted
        created_at DATETIME DEFAULT GETDATE(),
        updated_at DATETIME DEFAULT GETDATE()
    );
    
    -- Tạo index cho các trường thường xuyên được tìm kiếm
    CREATE INDEX IX_Book_Title ON Book(title);
    CREATE INDEX IX_Book_Author ON Book(author);
    CREATE INDEX IX_Book_Category ON Book(category);
    CREATE INDEX IX_Book_Status ON Book(status);
    CREATE INDEX IX_Book_ISBN ON Book(isbn);
    
    PRINT 'Bảng Book đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Book đã tồn tại.';
END
GO

-- Tạo trigger để tự động cập nhật updated_at
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Book_UpdateTime]') AND type = 'TR')
BEGIN
    DROP TRIGGER TR_Book_UpdateTime;
END
GO

CREATE TRIGGER TR_Book_UpdateTime
ON Book
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Book
    SET updated_at = GETDATE()
    WHERE book_id IN (SELECT book_id FROM inserted);
END
GO

PRINT 'Trigger TR_Book_UpdateTime đã được tạo thành công!';
GO

-- Insert dữ liệu mẫu (tùy chọn)
-- Bạn có thể comment hoặc xóa phần này nếu không muốn dữ liệu mẫu

-- Lấy role_id của USER role để sử dụng trong dữ liệu mẫu
DECLARE @UserRoleId INT;
SELECT @UserRoleId = role_id FROM Role WHERE role_name = 'USER';

-- Chỉ insert dữ liệu mẫu nếu chưa có sách nào
IF NOT EXISTS (SELECT 1 FROM Book)
BEGIN
    INSERT INTO Book (title, author, isbn, description, category, price, quantity, status) VALUES
    (N'Đắc Nhân Tâm', N'Dale Carnegie', '978-604-1-00001-1', N'Cuốn sách kinh điển về nghệ thuật ứng xử và giao tiếp', N'Self-help', 89000, 50, 'available'),
    (N'Nhà Giả Kim', N'Paulo Coelho', '978-604-1-00002-2', N'Cuốn tiểu thuyết về hành trình tìm kiếm ý nghĩa cuộc sống', N'Fiction', 120000, 30, 'available'),
    (N'Tôi Tài Giỏi, Bạn Cũng Thế', N'Adam Khoo', '978-604-1-00003-3', N'Phương pháp học tập hiệu quả', N'Education', 150000, 25, 'available'),
    (N'Tuổi Trẻ Đáng Giá Bao Nhiêu', N'Rosie Nguyễn', '978-604-1-00004-4', N'Cuốn sách truyền cảm hứng cho giới trẻ', N'Inspiration', 95000, 40, 'available'),
    (N'Sapiens: Lược Sử Loài Người', N'Yuval Noah Harari', '978-604-1-00005-5', N'Lịch sử tiến hóa của loài người', N'History', 200000, 20, 'available');
    
    PRINT 'Đã thêm 5 cuốn sách mẫu vào database.';
END
ELSE
BEGIN
    PRINT 'Bảng Book đã có dữ liệu, bỏ qua việc thêm dữ liệu mẫu.';
END
GO

PRINT 'Hoàn tất! Bảng Book đã sẵn sàng sử dụng.';
GO
