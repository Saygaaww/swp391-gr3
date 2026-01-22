CREATE DATABASE DigitalLibraryDB;
GO
USE DigitalLibraryDB;
GO
CREATE TABLE Role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(30) NOT NULL UNIQUE, -- ADMIN, LIBRARIAN, SELLER, USER
    description NVARCHAR(255) NULL
);
GO

CREATE TABLE Reader (
    reader_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255) NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    phone NVARCHAR(30) NULL,
    avatar NVARCHAR(255) NULL,
    status NVARCHAR(50) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    role_id INT NOT NULL,
    CONSTRAINT FK_Reader_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO

CREATE TABLE Reader_Account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    provider NVARCHAR(50) NOT NULL,          -- local, google, facebook, github...
    provider_user_id NVARCHAR(255) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_ReaderAccount_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

CREATE TABLE Employee (
    employee_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255) NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    status NVARCHAR(50) NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    role_id INT NOT NULL,
    CONSTRAINT FK_Employee_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
GO
CREATE TABLE Author (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(255) NOT NULL,
    bio NVARCHAR(MAX) NULL
);
GO

CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL
);
GO

CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    summary NVARCHAR(MAX) NULL,
    description NVARCHAR(MAX) NULL,
    cover_url NVARCHAR(255) NULL,
    content_path NVARCHAR(500) NULL,
    price DECIMAL(10,2) NULL,
    currency NVARCHAR(10) NULL,
    total_pages INT NULL,
    preview_pages INT NULL,
    status NVARCHAR(50) NULL, -- active, inactive
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,

    author_id INT NULL,
    category_id INT NULL,

    created_by_employee_id INT NULL,
    updated_by_employee_id INT NULL,

    CONSTRAINT FK_Book_Author FOREIGN KEY (author_id) REFERENCES Author(author_id),
    CONSTRAINT FK_Book_Category FOREIGN KEY (category_id) REFERENCES Category(category_id),
    CONSTRAINT FK_Book_CreatedBy FOREIGN KEY (created_by_employee_id) REFERENCES Employee(employee_id),
    CONSTRAINT FK_Book_UpdatedBy FOREIGN KEY (updated_by_employee_id) REFERENCES Employee(employee_id)
);
GO
CREATE TABLE BookCopy (
    copy_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT NOT NULL,
    copy_code NVARCHAR(100) NOT NULL UNIQUE,
    status NVARCHAR(30) NOT NULL, -- available, borrowed, reserved, lost, damaged
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_BookCopy_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    status NVARCHAR(30) NOT NULL, -- active, checked_out, abandoned
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NULL,
    CONSTRAINT FK_Cart_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

CREATE TABLE Cart_Item (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    added_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_CartItem_Cart FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    CONSTRAINT FK_CartItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE [Order] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    currency NVARCHAR(10) NULL,
    status NVARCHAR(30) NOT NULL, -- pending, paid, cancelled, refunded
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Order_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO

CREATE TABLE Order_Book (
    order_book_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_OrderBook_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    CONSTRAINT FK_OrderBook_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

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
GO

CREATE TABLE Reader_Book_Ownership (
    ownership_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    acquired_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    acquired_via NVARCHAR(30) NULL, -- order, promo, admin_grant
    status NVARCHAR(30) NULL,       -- active, revoked
    CONSTRAINT FK_Ownership_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Ownership_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO
CREATE TABLE Borrow_Request (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    status NVARCHAR(30) NOT NULL, -- pending, approved, rejected, cancelled, expired
    requested_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    note NVARCHAR(MAX) NULL,

    processed_by_employee_id INT NULL,
    processed_at DATETIME2 NULL,
    decision_note NVARCHAR(MAX) NULL,

    CONSTRAINT FK_BorrowRequest_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_BorrowRequest_ProcessedBy FOREIGN KEY (processed_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Borrow_Request_Item (
    request_item_id INT IDENTITY(1,1) PRIMARY KEY,
    request_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    CONSTRAINT FK_BRItem_Request FOREIGN KEY (request_id) REFERENCES Borrow_Request(request_id),
    CONSTRAINT FK_BRItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

CREATE TABLE Borrow (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    request_id INT NULL UNIQUE, -- 1 request -> 0..1 borrow
    borrow_date DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    status NVARCHAR(30) NOT NULL, -- active, overdue, completed, cancelled
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    approved_by_employee_id INT NULL,

    CONSTRAINT FK_Borrow_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Borrow_Request FOREIGN KEY (request_id) REFERENCES Borrow_Request(request_id),
    CONSTRAINT FK_Borrow_ApprovedBy FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id)
);
GO

CREATE TABLE Borrow_Item (
    borrow_item_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_id INT NOT NULL,
    copy_id INT NOT NULL,
    due_date DATETIME2 NOT NULL,
    returned_at DATETIME2 NULL,
    status NVARCHAR(30) NOT NULL, -- borrowed, returned, overdue, lost, damaged

    CONSTRAINT FK_BorrowItem_Borrow FOREIGN KEY (borrow_id) REFERENCES Borrow(borrow_id),
    CONSTRAINT FK_BorrowItem_Copy FOREIGN KEY (copy_id) REFERENCES BookCopy(copy_id)
);
GO
CREATE TABLE Borrow_Extend (
    extend_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_item_id INT NOT NULL,

    old_due_date DATETIME2 NOT NULL,
    requested_due_date DATETIME2 NOT NULL,
    approved_due_date DATETIME2 NULL,

    status NVARCHAR(30) NOT NULL, -- pending, approved, rejected, cancelled
    requested_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    processed_at DATETIME2 NULL,
    decision_note NVARCHAR(MAX) NULL,

    approved_by_employee_id INT NULL,

    CONSTRAINT FK_Extend_BorrowItem FOREIGN KEY (borrow_item_id) REFERENCES Borrow_Item(borrow_item_id),
    CONSTRAINT FK_Extend_ApprovedBy FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id)
);
GO
CREATE TABLE Fine_Type (
    fine_type_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL, -- late_return, lost, damaged
    description NVARCHAR(MAX) NULL,
    default_amount DECIMAL(10,2) NULL,
    per_day_rate DECIMAL(10,2) NULL
);
GO

CREATE TABLE Fine (
    fine_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    borrow_item_id INT NOT NULL,
    fine_type_id INT NOT NULL,

    amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    reason NVARCHAR(MAX) NULL,
    status NVARCHAR(30) NOT NULL, -- unpaid, paid, waived
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    paid_at DATETIME2 NULL,

    handled_by_employee_id INT NULL,

    CONSTRAINT FK_Fine_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_Fine_BorrowItem FOREIGN KEY (borrow_item_id) REFERENCES Borrow_Item(borrow_item_id),
    CONSTRAINT FK_Fine_Type FOREIGN KEY (fine_type_id) REFERENCES Fine_Type(fine_type_id),
    CONSTRAINT FK_Fine_HandledBy FOREIGN KEY (handled_by_employee_id) REFERENCES Employee(employee_id)
);
GO
CREATE TABLE Reading_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    book_id INT NOT NULL,
    last_read_position INT NULL,
    last_read_at DATETIME2 NULL,
    CONSTRAINT FK_ReadHistory_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id),
    CONSTRAINT FK_ReadHistory_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
GO

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
GO

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
GO

CREATE TABLE Notification (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    reader_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    message NVARCHAR(MAX) NULL,
    type NVARCHAR(30) NULL, -- borrow, overdue, reservation, order, system
    is_read BIT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Notification_Reader FOREIGN KEY (reader_id) REFERENCES Reader(reader_id)
);
GO
