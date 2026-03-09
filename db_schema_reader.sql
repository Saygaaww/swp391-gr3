-- ================================================
-- Digital Library - Reader Auth Schema (Fix for existing DB)
-- Chạy file này trong SQL Server Management Studio
-- Database: DigitalLibraryDB
-- ================================================

USE DigitalLibraryDB;
GO

-- ================================================
-- 1. Thêm cột còn thiếu vào bảng Reader hiện có
-- ================================================

-- Thêm cột avatar_url nếu chưa có
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Reader' AND COLUMN_NAME = 'avatar_url'
)
BEGIN
    ALTER TABLE Reader ADD avatar_url NVARCHAR(500) NULL;
    PRINT 'Đã thêm cột avatar_url vào Reader.';
END
ELSE
    PRINT 'Cột avatar_url đã tồn tại.';
GO

-- Thêm updated_at nếu chưa có
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Reader' AND COLUMN_NAME = 'updated_at'
)
BEGIN
    ALTER TABLE Reader ADD updated_at DATETIME2 NULL DEFAULT GETDATE();
    PRINT 'Đã thêm cột updated_at vào Reader.';
END
ELSE
    PRINT 'Cột updated_at đã tồn tại.';
GO

-- ================================================
-- 2. Thêm cột còn thiếu vào bảng Reader_Account
-- ================================================

-- Thêm provider_email nếu chưa có
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Reader_Account' AND COLUMN_NAME = 'provider_email'
)
BEGIN
    ALTER TABLE Reader_Account ADD provider_email NVARCHAR(255) NULL;
    PRINT 'Đã thêm cột provider_email vào Reader_Account.';
END
ELSE
    PRINT 'Cột provider_email đã tồn tại.';
GO

-- ================================================
-- 3. Thêm cột còn thiếu vào bảng Notification
-- ================================================

-- Kiểm tra tên cột type (có thể là 'type' hoặc 'notif_type')
-- Thêm cột nếu thiếu
IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Notification' AND COLUMN_NAME = 'type'
)
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'Notification' AND COLUMN_NAME = 'notif_type'
    )
    BEGIN
        ALTER TABLE Notification ADD type NVARCHAR(50) NOT NULL DEFAULT 'general';
        PRINT 'Đã thêm cột type vào Notification.';
    END
END
ELSE
    PRINT 'Cột type đã tồn tại trong Notification.';
GO

-- ================================================
-- 4. Tạo bảng PasswordResetToken (hoàn toàn mới)
-- ================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PasswordResetToken')
BEGIN
    CREATE TABLE PasswordResetToken (
        token_id        INT IDENTITY(1,1) PRIMARY KEY,
        reader_id       INT NOT NULL,
        token           VARCHAR(255) NOT NULL UNIQUE,
        expires_at      DATETIME2 NOT NULL,
        is_used         BIT NOT NULL DEFAULT 0,
        created_at      DATETIME2 NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_PasswordResetToken_Reader 
            FOREIGN KEY (reader_id) REFERENCES Reader(reader_id) ON DELETE CASCADE
    );
    PRINT 'Bảng PasswordResetToken đã được tạo.';
END
ELSE
    PRINT 'Bảng PasswordResetToken đã tồn tại.';
GO

-- ================================================
-- 5. Index tối ưu
-- ================================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_PasswordResetToken_Token')
    CREATE INDEX IX_PasswordResetToken_Token ON PasswordResetToken(token);
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Notification_Reader_Read')
    CREATE INDEX IX_Notification_Reader_Read ON Notification(reader_id, is_read, created_at);
GO

-- ================================================
-- 6. Dữ liệu thông báo mẫu (nếu có reader nào)
-- ================================================
INSERT INTO Notification (reader_id, title, message, type, is_read)
SELECT TOP 1 reader_id, 
    N'Chào mừng đến với Digital Library!',
    N'Hệ thống xác thực đã được nâng cấp. Hãy cập nhật thông tin hồ sơ của bạn.',
    'general', 0
FROM Reader
WHERE NOT EXISTS (
    SELECT 1 FROM Notification n2 
    WHERE n2.reader_id = Reader.reader_id 
    AND n2.title LIKE N'Chào mừng%'
);
GO

PRINT 'Schema fix hoàn tất!';
GO
