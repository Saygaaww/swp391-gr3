-- Script để tạo dữ liệu mẫu cho hệ thống đăng nhập
-- Chạy script này sau khi đã tạo database và các bảng

USE DigitalLibraryDB;
GO

-- Insert default roles
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

-- Tạo tài khoản admin mẫu (password: admin123)
-- Password hash cho "admin123" (SHA-256): cần hash trong code
-- Hoặc có thể tạo trực tiếp từ ứng dụng

PRINT 'Dữ liệu mẫu đã được tạo thành công!';
PRINT 'Vui lòng tạo tài khoản admin từ ứng dụng hoặc script khác.';
GO
