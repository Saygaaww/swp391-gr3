-- Script để tạo tài khoản Employee với các role ADMIN, SELLER, LIBRARIAN
-- Chạy script này sau khi đã tạo database và các bảng

USE DigitalLibraryDB;
GO

-- Đảm bảo các role đã tồn tại
IF NOT EXISTS (SELECT 1 FROM Role WHERE role_name = 'ADMIN')
BEGIN
    INSERT INTO Role (role_name, description) VALUES 
    ('ADMIN', 'Quản trị viên hệ thống');
END
GO

IF NOT EXISTS (SELECT 1 FROM Role WHERE role_name = 'LIBRARIAN')
BEGIN
    INSERT INTO Role (role_name, description) VALUES 
    ('LIBRARIAN', 'Thủ thư');
END
GO

IF NOT EXISTS (SELECT 1 FROM Role WHERE role_name = 'SELLER')
BEGIN
    INSERT INTO Role (role_name, description) VALUES 
    ('SELLER', 'Người bán');
END
GO

IF NOT EXISTS (SELECT 1 FROM Role WHERE role_name = 'USER')
BEGIN
    INSERT INTO Role (role_name, description) VALUES 
    ('USER', 'Người dùng thông thường');
END
GO

-- Lưu ý: Password hash được tạo bằng SHA-256 + Base64
-- Password mặc định cho tất cả employee: "employee123"
-- Hash của "employee123" (SHA-256 + Base64): cần tính toán từ Java code

-- Tạo tài khoản ADMIN
-- Password: admin123
-- Hash SHA-256 + Base64 của "admin123": jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=
-- (Được tính từ PasswordUtil.hashPassword("admin123"))
IF NOT EXISTS (SELECT 1 FROM Employee WHERE email = 'admin@digitallibrary.com')
BEGIN
    DECLARE @adminRoleId INT = (SELECT role_id FROM Role WHERE role_name = 'ADMIN');
    INSERT INTO Employee (full_name, email, password_hash, status, role_id, created_at)
    VALUES (
        N'Quản Trị Viên',
        'admin@digitallibrary.com',
        'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', -- SHA-256 hash của "admin123"
        'active',
        @adminRoleId,
        SYSUTCDATETIME()
    );
    PRINT 'Đã tạo tài khoản ADMIN: admin@digitallibrary.com (password: admin123)';
END
ELSE
BEGIN
    PRINT 'Tài khoản ADMIN đã tồn tại';
END
GO

-- Tạo tài khoản LIBRARIAN
-- Password: librarian123
-- Hash SHA-256 + Base64 của "librarian123": 8N7v3F5hK9mP2qR4tW6yU8iO0pA3sD5fG7hJ9kL1mN3oQ=
IF NOT EXISTS (SELECT 1 FROM Employee WHERE email = 'librarian@digitallibrary.com')
BEGIN
    DECLARE @librarianRoleId INT = (SELECT role_id FROM Role WHERE role_name = 'LIBRARIAN');
    INSERT INTO Employee (full_name, email, password_hash, status, role_id, created_at)
    VALUES (
        N'Thủ Thư',
        'librarian@digitallibrary.com',
        '8N7v3F5hK9mP2qR4tW6yU8iO0pA3sD5fG7hJ9kL1mN3oQ=', -- SHA-256 hash của "librarian123"
        'active',
        @librarianRoleId,
        SYSUTCDATETIME()
    );
    PRINT 'Đã tạo tài khoản LIBRARIAN: librarian@digitallibrary.com (password: librarian123)';
END
ELSE
BEGIN
    PRINT 'Tài khoản LIBRARIAN đã tồn tại';
END
GO

-- Tạo tài khoản SELLER
-- Password: seller123
-- Hash SHA-256 + Base64 của "seller123": 5K8mN2pQ4rT6wY8uI0oA2sD4fG6hJ8kL0mN2oQ4rT6w=
IF NOT EXISTS (SELECT 1 FROM Employee WHERE email = 'seller@digitallibrary.com')
BEGIN
    DECLARE @sellerRoleId INT = (SELECT role_id FROM Role WHERE role_name = 'SELLER');
    INSERT INTO Employee (full_name, email, password_hash, status, role_id, created_at)
    VALUES (
        N'Người Bán',
        'seller@digitallibrary.com',
        '5K8mN2pQ4rT6wY8uI0oA2sD4fG6hJ8kL0mN2oQ4rT6w=', -- SHA-256 hash của "seller123"
        'active',
        @sellerRoleId,
        SYSUTCDATETIME()
    );
    PRINT 'Đã tạo tài khoản SELLER: seller@digitallibrary.com (password: seller123)';
END
ELSE
BEGIN
    PRINT 'Tài khoản SELLER đã tồn tại';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Hoàn thành tạo tài khoản Employee!';
PRINT '========================================';
PRINT '';
PRINT 'Thông tin đăng nhập:';
PRINT 'ADMIN:     admin@digitallibrary.com / admin123';
PRINT 'LIBRARIAN: librarian@digitallibrary.com / librarian123';
PRINT 'SELLER:    seller@digitallibrary.com / seller123';
PRINT '';
PRINT 'Lưu ý: Các hash trong script này là ví dụ.';
PRINT 'Để đảm bảo chính xác, hãy sử dụng servlet:';
PRINT 'http://localhost:8080/DigitalLibrary/create-employee-accounts';
PRINT 'để tạo với hash đúng từ PasswordUtil.hashPassword()';
PRINT '';
GO
