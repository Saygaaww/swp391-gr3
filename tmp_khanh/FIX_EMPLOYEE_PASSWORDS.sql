-- =====================================================
-- FIX EMPLOYEE LOGIN - Cập nhật mật khẩu đã hash
-- =====================================================

USE DigitalLibraryDB;
GO

-- Xóa dữ liệu cũ nếu có
DELETE FROM Employee;
GO

-- Thêm lại employee với password đã hash đúng
-- Hash được tính từ PasswordUtil.hash()

-- 1. ADMIN: email=admin@library.com, password=admin123
INSERT INTO Employee (full_name, email, password_hash, status, role_id)
VALUES ('Admin User', 'admin@library.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'active', 1);

-- 2. LIBRARIAN: email=librarian@library.com, password=librarian123
INSERT INTO Employee (full_name, email, password_hash, status, role_id)
VALUES ('Library Staff', 'librarian@library.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'active', 2);

-- 3. SELLER: email=seller@library.com, password=seller123
INSERT INTO Employee (full_name, email, password_hash, status, role_id)
VALUES ('Sales Manager', 'seller@library.com', 'e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446', 'active', 3);

GO

-- Kiểm tra kết quả
SELECT 
    e.employee_id,
    e.full_name,
    e.email,
    r.role_name,
    e.status,
    e.created_at
FROM Employee e
JOIN Role r ON e.role_id = r.role_id
ORDER BY e.role_id;

GO

PRINT '✅ Đã cập nhật employee passwords!';
PRINT '';
PRINT 'THÔNG TIN ĐĂNG NHẬP:';
PRINT '=====================';
PRINT '';
PRINT '1. ADMIN:';
PRINT '   URL: http://localhost:8080/DigitalLibrary/employee/login';
PRINT '   Email: admin@library.com';
PRINT '   Password: admin123';
PRINT '';
PRINT '2. LIBRARIAN:';
PRINT '   URL: http://localhost:8080/DigitalLibrary/employee/login';
PRINT '   Email: librarian@library.com';
PRINT '   Password: librarian123';
PRINT '';
PRINT '3. SELLER:';
PRINT '   URL: http://localhost:8080/DigitalLibrary/employee/login';
PRINT '   Email: seller@library.com';
PRINT '   Password: seller123';
PRINT '';
