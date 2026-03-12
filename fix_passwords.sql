USE DigitalLibraryDB;
GO

-- =====================================================
-- FIX PASSWORD: Cập nhật mật khẩu đúng format salt:hash
-- Code dùng: SHA-256 + salt + pepper("DL@SWP391#2024")
-- Format trong DB phải là: "salt:hash" (có dấu hai chấm)
-- =====================================================

-- 1. Tạo bảng Email_Otp nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Email_Otp')
CREATE TABLE Email_Otp (
    otp_id INT IDENTITY PRIMARY KEY,
    email NVARCHAR(255) NOT NULL,
    otp_code NVARCHAR(10) NOT NULL,
    expired_at DATETIME NOT NULL,
    is_used BIT DEFAULT 0
);
GO

-- 2. Tạo bảng OTP_Codes nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'OTP_Codes')
CREATE TABLE OTP_Codes (
    otp_id INT IDENTITY(1,1) PRIMARY KEY,
    phone_number NVARCHAR(20) NOT NULL,
    otp_code NVARCHAR(6) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    expires_at DATETIME NOT NULL,
    is_used BIT DEFAULT 0
);
GO

-- 3. Thêm cột avatar_url và updated_at vào Reader nếu chưa có
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Reader') AND name = 'avatar_url')
BEGIN
    ALTER TABLE Reader ADD avatar_url NVARCHAR(500) NULL;
    -- Copy dữ liệu từ cột avatar sang avatar_url nếu cột avatar tồn tại
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Reader') AND name = 'avatar')
        EXEC('UPDATE Reader SET avatar_url = avatar');
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Reader') AND name = 'updated_at')
    ALTER TABLE Reader ADD updated_at DATETIME2 NULL;
GO

-- 4. Update password Employee - format salt:hash (SHA-256 + salt + pepper "DL@SWP391#2024")
-- ADMIN: admin123
UPDATE Employee 
SET password_hash = '2d2341916ac9b4de853898e6d55c1477:e651d2b1d2c89b6a54dce9f3a40bf02ee600c4a54e02155be058ebc70404b6a3'
WHERE email = 'admin@digitallibrary.vn';

-- LIBRARIAN: librarian123
UPDATE Employee 
SET password_hash = '350137e93c3bb8d8192de8f853e1a820:9f00c079a8f38c5d01a1e538bac5b65a3fbddb03b9c1ba838d9e3ebb02405c8d'
WHERE email = 'librarian@digitallibrary.vn';

-- SELLER: seller123
UPDATE Employee 
SET password_hash = 'be271504e21c500b8446a78f954b9610:9415a5ccfecc26c2799e037e3c3233c8a8bba46e1966cd4697a9a25d824944e6'
WHERE email = 'seller@digitallibrary.vn';

-- 5. Update password Reader - format salt:hash
-- password123
UPDATE Reader 
SET password_hash = 'a77dc65f1a82f215b63ba61d461e626a:b50258d411242a7e5d2ba98d1fe9f2aaec71cedac254644ab7e3e7f7b29418fe'
WHERE password_hash NOT LIKE '%:%' OR LEN(password_hash) <> 97;
GO

PRINT 'Done! Passwords updated successfully.';
PRINT 'ADMIN: admin@digitallibrary.vn / admin123';
PRINT 'LIBRARIAN: librarian@digitallibrary.vn / librarian123';
PRINT 'SELLER: seller@digitallibrary.vn / seller123';
PRINT 'READER: nguyenvana@example.com / password123';
GO
