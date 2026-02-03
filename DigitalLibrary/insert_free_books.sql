-- Script để thêm sách miễn phí mẫu cho guest có thể xem
-- Chạy script này để thêm sách miễn phí vào database

USE DigitalLibraryDB;
GO

-- Kiểm tra và tạo Author nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Author WHERE author_name = N'Nguyễn Du')
BEGIN
    INSERT INTO Author (author_name, bio) VALUES 
    (N'Nguyễn Du', N'Đại thi hào dân tộc Việt Nam');
END
GO

IF NOT EXISTS (SELECT 1 FROM Author WHERE author_name = N'Nam Cao')
BEGIN
    INSERT INTO Author (author_name, bio) VALUES 
    (N'Nam Cao', N'Nhà văn hiện thực xuất sắc');
END
GO

IF NOT EXISTS (SELECT 1 FROM Author WHERE author_name = N'Nguyễn Nhật Ánh')
BEGIN
    INSERT INTO Author (author_name, bio) VALUES 
    (N'Nguyễn Nhật Ánh', N'Nhà văn viết cho thiếu nhi và thanh thiếu niên');
END
GO

-- Kiểm tra và tạo Category nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Category WHERE category_name = N'Văn Học')
BEGIN
    INSERT INTO Category (category_name, description) VALUES 
    (N'Văn Học', N'Sách văn học Việt Nam và thế giới');
END
GO

IF NOT EXISTS (SELECT 1 FROM Category WHERE category_name = N'Giáo Dục')
BEGIN
    INSERT INTO Category (category_name, description) VALUES 
    (N'Giáo Dục', N'Sách giáo dục và học tập');
END
GO

-- Lấy ID của Author và Category
DECLARE @AuthorId1 INT = (SELECT author_id FROM Author WHERE author_name = N'Nguyễn Du');
DECLARE @AuthorId2 INT = (SELECT author_id FROM Author WHERE author_name = N'Nam Cao');
DECLARE @AuthorId3 INT = (SELECT author_id FROM Author WHERE author_name = N'Nguyễn Nhật Ánh');
DECLARE @CategoryId1 INT = (SELECT category_id FROM Category WHERE category_name = N'Văn Học');
DECLARE @CategoryId2 INT = (SELECT category_id FROM Category WHERE category_name = N'Giáo Dục');

-- Lấy employee_id đầu tiên (nếu có) hoặc NULL
DECLARE @EmployeeId INT = NULL;
SELECT TOP 1 @EmployeeId = employee_id FROM Employee WHERE status = 'active';
IF @EmployeeId IS NULL
BEGIN
    SET @EmployeeId = NULL;
END

-- Chỉ thêm sách miễn phí nếu chưa có sách miễn phí nào
IF NOT EXISTS (SELECT 1 FROM Book WHERE (price IS NULL OR price <= 0) AND (status IS NULL OR status != 'deleted'))
BEGIN
    -- Thêm sách miễn phí mẫu
    INSERT INTO Book (title, summary, description, cover_url, price, currency, total_pages, status, author_id, category_id, created_by_employee_id, created_at) VALUES
    (N'Truyện Kiều', 
     N'Tác phẩm văn học kinh điển của đại thi hào Nguyễn Du', 
     N'Truyện Kiều là một trong những tác phẩm văn học nổi tiếng nhất của Việt Nam, kể về cuộc đời đầy thăng trầm của nàng Kiều.',
     NULL, 
     NULL, -- Sách miễn phí (price = NULL)
     'VND',
     3254,
     'active',
     @AuthorId1,
     @CategoryId1,
     @EmployeeId,
     SYSUTCDATETIME()),
    
    (N'Chí Phèo', 
     N'Truyện ngắn nổi tiếng của nhà văn Nam Cao', 
     N'Chí Phèo là một trong những tác phẩm xuất sắc nhất của Nam Cao, phản ánh hiện thực xã hội Việt Nam trước Cách mạng.',
     NULL, 
     0, -- Sách miễn phí (price = 0)
     'VND',
     120,
     'active',
     @AuthorId2,
     @CategoryId1,
     @EmployeeId,
     SYSUTCDATETIME()),
    
    (N'Tôi Thấy Hoa Vàng Trên Cỏ Xanh', 
     N'Tiểu thuyết dành cho thiếu nhi của Nguyễn Nhật Ánh', 
     N'Cuốn sách kể về tuổi thơ đầy kỷ niệm của những đứa trẻ ở một làng quê Việt Nam.',
     NULL, 
     NULL, -- Sách miễn phí
     'VND',
     280,
     'active',
     @AuthorId3,
     @CategoryId1,
     @EmployeeId,
     SYSUTCDATETIME()),
    
    (N'Kính Vạn Hoa', 
     N'Bộ truyện dài tập của Nguyễn Nhật Ánh', 
     N'Bộ truyện kể về những cuộc phiêu lưu của ba bạn nhỏ với chiếc kính vạn hoa thần kỳ.',
     NULL, 
     0, -- Sách miễn phí
     'VND',
     200,
     'active',
     @AuthorId3,
     @CategoryId1,
     @EmployeeId,
     SYSUTCDATETIME()),
    
    (N'Lão Hạc', 
     N'Truyện ngắn của Nam Cao', 
     N'Lão Hạc là một trong những truyện ngắn xuất sắc của Nam Cao, kể về cuộc đời của một lão nông nghèo khổ.',
     NULL, 
     NULL, -- Sách miễn phí
     'VND',
     80,
     'active',
     @AuthorId2,
     @CategoryId1,
     @EmployeeId,
     SYSUTCDATETIME());
    
    PRINT 'Đã thêm 5 cuốn sách miễn phí mẫu vào database.';
    PRINT 'Guest giờ có thể xem được sách miễn phí!';
END
ELSE
BEGIN
    PRINT 'Đã có sách miễn phí trong database.';
    PRINT 'Số lượng sách miễn phí: ' + CAST((SELECT COUNT(*) FROM Book WHERE (price IS NULL OR price <= 0) AND (status IS NULL OR status != 'deleted')) AS NVARCHAR(10));
END
GO

-- Kiểm tra lại số lượng sách miễn phí
SELECT 
    COUNT(*) AS 'Tổng số sách miễn phí',
    COUNT(CASE WHEN price IS NULL THEN 1 END) AS 'Sách có price = NULL',
    COUNT(CASE WHEN price = 0 THEN 1 END) AS 'Sách có price = 0'
FROM Book 
WHERE (status IS NULL OR status != 'deleted') 
AND (price IS NULL OR price <= 0);
GO

PRINT 'Hoàn tất!';
GO
