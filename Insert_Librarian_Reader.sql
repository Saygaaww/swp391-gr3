-- Script để thêm tài khoản Reader với role LIBRARIAN (thủ thư)
-- Dựa trên Insert.sql từ Repository
-- Chạy script này sau khi đã chạy Insert.sql hoặc Database_DigitalLibrary.sql

USE DigitalLibraryDB;
GO

-- Kiểm tra và thêm Role nếu chưa có
IF NOT EXISTS (SELECT 1 FROM Role WHERE role_name = 'LIBRARIAN')
BEGIN
    INSERT INTO Role (role_name, description) VALUES
    ('LIBRARIAN', 'Thủ thư - quản lý mượn trả sách');
END
GO

-- Thêm tài khoản Reader với role LIBRARIAN
-- Password: librarian123 (SHA-256 hash: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9)
-- Password: 123456 (SHA-256 hash: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92)

-- Thêm Reader với role LIBRARIAN (chỉ thêm nếu chưa tồn tại)
IF NOT EXISTS (SELECT 1 FROM Reader WHERE email = 'librarian1@example.com')
BEGIN
    DECLARE @LibrarianRoleId1 INT;
    SELECT @LibrarianRoleId1 = role_id FROM Role WHERE role_name = 'LIBRARIAN';
    
    INSERT INTO Reader (full_name, email, password_hash, phone, avatar, status, role_id) VALUES
    ('Phạm Thị D', 'librarian1@example.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '0123456789', NULL, 'active', @LibrarianRoleId1);
    
    -- Thêm Reader_Account
    DECLARE @ReaderId1 INT = SCOPE_IDENTITY();
    INSERT INTO Reader_Account (reader_id, provider) VALUES (@ReaderId1, 'LOCAL');
END
GO

IF NOT EXISTS (SELECT 1 FROM Reader WHERE email = 'librarian2@example.com')
BEGIN
    DECLARE @LibrarianRoleId2 INT;
    SELECT @LibrarianRoleId2 = role_id FROM Role WHERE role_name = 'LIBRARIAN';
    
    INSERT INTO Reader (full_name, email, password_hash, phone, avatar, status, role_id) VALUES
    ('Hoàng Văn E', 'librarian2@example.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0987654321', NULL, 'active', @LibrarianRoleId2);
    
    -- Thêm Reader_Account
    DECLARE @ReaderId2 INT = SCOPE_IDENTITY();
    INSERT INTO Reader_Account (reader_id, provider) VALUES (@ReaderId2, 'LOCAL');
END
GO

PRINT 'Đã thêm tài khoản thủ thư thành công!';
PRINT '';
PRINT 'Tài khoản Librarian (Thủ thư) - Đăng nhập bằng Reader:';
PRINT '  Email: librarian1@example.com | Password: librarian123';
PRINT '  Email: librarian2@example.com | Password: 123456';
PRINT '';
PRINT 'Sau khi đăng nhập, bạn sẽ được chuyển đến trang /librarian/home';
PRINT 'Từ đó có thể vào "Xem yêu cầu" để duyệt/từ chối yêu cầu mượn sách.';
GO
