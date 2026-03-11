USE DigitalLibraryDB;
GO

-- 1. Cart & Cart_Item
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    status NVARCHAR(30) NOT NULL, -- active, checked_out, abandoned
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Cart_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart_Item]') AND type in (N'U'))
BEGIN
CREATE TABLE Cart_Item (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL DEFAULT 0,
    added_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CartItem_Cart FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    CONSTRAINT FK_CartItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

-- 2. Order, Order_Book, Payment
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
BEGIN
CREATE TABLE [Order] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    currency NVARCHAR(10) NULL,
    status NVARCHAR(30) NOT NULL, -- pending, paid, cancelled, refunded
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Order_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_Book]') AND type in (N'U'))
BEGIN
CREATE TABLE Order_Book (
    order_book_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_OrderBook_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    CONSTRAINT FK_OrderBook_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
BEGIN
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(50) NULL,
    payment_status NVARCHAR(30) NOT NULL, -- pending, success, failed
    transaction_code NVARCHAR(100) NULL,
    paid_at DATETIME2 NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);
END
GO

-- 3. Reading History
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reading_History]') AND type in (N'U'))
BEGIN
CREATE TABLE Reading_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    last_read_position INT NULL,
    last_read_at DATETIME2 NULL,
    CONSTRAINT FK_ReadHistory_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_ReadHistory_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Reading_History_Reader_Book' AND object_id = OBJECT_ID('Reading_History'))
    CREATE UNIQUE INDEX IX_Reading_History_Reader_Book ON Reading_History(reader_id, book_id);
GO

-- 4. Bookmark
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bookmark]') AND type in (N'U'))
BEGIN
CREATE TABLE Bookmark (
    bookmark_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    page_number INT NOT NULL,
    note NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Bookmark_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Bookmark_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

-- 5. Review
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Review]') AND type in (N'U'))
BEGIN
CREATE TABLE Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT NULL,
    comment NVARCHAR(MAX) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Review_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Review_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Review_Reader_Book' AND object_id = OBJECT_ID('Review'))
    CREATE UNIQUE INDEX IX_Review_Reader_Book ON Review(reader_id, book_id);
GO

-- Ensure new column stock_quantity on Book table for Buy Book features
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Book') AND name = 'stock_quantity')
BEGIN
    ALTER TABLE Book ADD stock_quantity INT NOT NULL DEFAULT 0;
    UPDATE Book SET stock_quantity = 10 WHERE stock_quantity = 0;
END
GO
