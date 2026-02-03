-- Script để tạo các bảng cho Buy Flow (Cart, Order, Payment)
-- Lưu ý: Các bảng này đã được định nghĩa trong schema chính
-- Script này chỉ để tham khảo và kiểm tra

USE DigitalLibraryDB;
GO

-- ============================================
-- KIỂM TRA VÀ TẠO BẢNG CART (Nếu chưa có)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
    CREATE TABLE Cart (
        cart_id INT IDENTITY(1,1) PRIMARY KEY,
        reader_id INT NOT NULL,
        status NVARCHAR(30) NOT NULL DEFAULT 'active', -- active, checked_out, abandoned
        created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at DATETIME2 NULL,
        
        CONSTRAINT FK_Cart_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
    );
    
    CREATE INDEX IX_Cart_ReaderId ON Cart(reader_id);
    CREATE INDEX IX_Cart_Status ON Cart(status);
    CREATE INDEX IX_Cart_UpdatedAt ON Cart(updated_at);
    
    PRINT 'Bảng Cart đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Cart đã tồn tại.';
END
GO

-- ============================================
-- KIỂM TRA VÀ TẠO BẢNG CART_ITEM (Nếu chưa có)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart_Item]') AND type in (N'U'))
BEGIN
    CREATE TABLE Cart_Item (
        cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
        cart_id INT NOT NULL,
        book_id INT NOT NULL,
        quantity INT NOT NULL DEFAULT 1,
        added_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        
        CONSTRAINT FK_CartItem_Cart FOREIGN KEY (cart_id) REFERENCES Cart(cart_id) ON DELETE CASCADE,
        CONSTRAINT FK_CartItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id) ON DELETE CASCADE,
        
        CONSTRAINT CK_CartItems_Quantity CHECK (quantity > 0)
    );
    
    CREATE INDEX IX_CartItems_CartId ON Cart_Item(cart_id);
    CREATE INDEX IX_CartItems_BookId ON Cart_Item(book_id);
    CREATE UNIQUE INDEX IX_CartItems_CartBook ON Cart_Item(cart_id, book_id);
    
    PRINT 'Bảng Cart_Item đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Cart_Item đã tồn tại.';
END
GO

-- ============================================
-- KIỂM TRA VÀ TẠO BẢNG ORDER (Nếu chưa có)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Order] (
        order_id INT IDENTITY(1,1) PRIMARY KEY,
        reader_id INT NOT NULL,
        total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
        currency NVARCHAR(10) NULL DEFAULT 'VND',
        status NVARCHAR(30) NOT NULL DEFAULT 'pending', -- pending, paid, cancelled, refunded
        created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        
        CONSTRAINT FK_Order_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
        CONSTRAINT CK_Orders_TotalAmount CHECK (total_amount >= 0),
        CONSTRAINT CK_Orders_Status CHECK (status IN ('pending', 'paid', 'cancelled', 'refunded'))
    );
    
    CREATE INDEX IX_Orders_ReaderId ON [Order](reader_id);
    CREATE INDEX IX_Orders_Status ON [Order](status);
    CREATE INDEX IX_Orders_CreatedAt ON [Order](created_at);
    
    PRINT 'Bảng Order đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Order đã tồn tại.';
END
GO

-- ============================================
-- KIỂM TRA VÀ TẠO BẢNG ORDER_BOOK (Nếu chưa có)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_Book]') AND type in (N'U'))
BEGIN
    CREATE TABLE Order_Book (
        order_book_id INT IDENTITY(1,1) PRIMARY KEY,
        order_id INT NOT NULL,
        book_id INT NOT NULL,
        quantity INT NOT NULL DEFAULT 1,
        price DECIMAL(10,2) NOT NULL DEFAULT 0,
        
        CONSTRAINT FK_OrderBook_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id) ON DELETE CASCADE,
        CONSTRAINT FK_OrderBook_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
        
        CONSTRAINT CK_OrderBooks_Quantity CHECK (quantity > 0),
        CONSTRAINT CK_OrderBooks_Price CHECK (price >= 0)
    );
    
    CREATE INDEX IX_OrderBooks_OrderId ON Order_Book(order_id);
    CREATE INDEX IX_OrderBooks_BookId ON Order_Book(book_id);
    
    PRINT 'Bảng Order_Book đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Order_Book đã tồn tại.';
END
GO

-- ============================================
-- KIỂM TRA VÀ TẠO BẢNG PAYMENT (Nếu chưa có)
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
BEGIN
    CREATE TABLE Payment (
        payment_id INT IDENTITY(1,1) PRIMARY KEY,
        order_id INT NOT NULL,
        amount DECIMAL(10,2) NOT NULL DEFAULT 0,
        payment_method NVARCHAR(50) NULL,
        payment_status NVARCHAR(30) NOT NULL DEFAULT 'pending', -- pending, success, failed
        transaction_code NVARCHAR(100) NULL,
        paid_at DATETIME2 NULL,
        created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        
        CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id),
        CONSTRAINT CK_Payments_Amount CHECK (amount >= 0),
        CONSTRAINT CK_Payments_PaymentStatus CHECK (payment_status IN ('pending', 'success', 'failed'))
    );
    
    CREATE INDEX IX_Payments_OrderId ON Payment(order_id);
    CREATE INDEX IX_Payments_TransactionCode ON Payment(transaction_code);
    CREATE INDEX IX_Payments_PaymentStatus ON Payment(payment_status);
    CREATE INDEX IX_Payments_CreatedAt ON Payment(created_at);
    
    PRINT 'Bảng Payment đã được tạo thành công!';
END
ELSE
BEGIN
    PRINT 'Bảng Payment đã tồn tại.';
END
GO

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger để tự động cập nhật updated_at cho Cart
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_Cart_UpdateTime]') AND type = 'TR')
BEGIN
    DROP TRIGGER TR_Cart_UpdateTime;
END
GO

CREATE TRIGGER TR_Cart_UpdateTime
ON Cart
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE Cart
    SET updated_at = SYSUTCDATETIME()
    WHERE cart_id IN (SELECT cart_id FROM inserted);
END
GO

PRINT 'Trigger TR_Cart_UpdateTime đã được tạo thành công!';
GO

-- ============================================
-- GHI CHÚ QUAN TRỌNG
-- ============================================
PRINT '';
PRINT '========================================';
PRINT 'LƯU Ý QUAN TRỌNG:';
PRINT '========================================';
PRINT '1. Các bảng Cart, Cart_Item, Order, Order_Book, Payment đã được định nghĩa trong schema chính.';
PRINT '2. Script này chỉ để kiểm tra và tạo nếu chưa tồn tại.';
PRINT '3. Đảm bảo các bảng Reader và Book đã được tạo trước khi chạy script này.';
PRINT '========================================';
GO
