CREATE DATABASE DigitalLibrary;
GO

USE DigitalLibrary;
GO

CREATE TABLE Role (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL
);
CREATE TABLE Admin (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Admin_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
CREATE TABLE [User] (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255),
    email NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    phone NVARCHAR(20),
    avatar NVARCHAR(255),
    status NVARCHAR(50),
    created_at DATETIME2 DEFAULT GETDATE(),
    role_id INT NOT NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (role_id) REFERENCES Role(role_id)
);
CREATE TABLE User_Account (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    provider NVARCHAR(50),
    provider_user_id NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_UserAccount_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
CREATE TABLE Author (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(255),
    bio NVARCHAR(MAX)
);
CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255),
    description NVARCHAR(MAX)
);
CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    summary NVARCHAR(MAX),
    content_path NVARCHAR(255),
    price DECIMAL(10,2),
    free_page_limit INT,
    author_id INT,
    category_id INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Book_Author FOREIGN KEY (author_id) REFERENCES Author(author_id),
    CONSTRAINT FK_Book_Category FOREIGN KEY (category_id) REFERENCES Category(category_id)
);
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    status NVARCHAR(50),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Cart_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
CREATE TABLE Cart_Item (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    quantity INT,
    CONSTRAINT FK_CartItem_Cart FOREIGN KEY (cart_id) REFERENCES Cart(cart_id),
    CONSTRAINT FK_CartItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE [Order] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2),
    status NVARCHAR(50),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Order_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
CREATE TABLE Order_Book (
    order_book_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price DECIMAL(10,2),
    CONSTRAINT FK_OrderBook_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    CONSTRAINT FK_OrderBook_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2),
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(50),
    paid_at DATETIME2,
    CONSTRAINT FK_Payment_Order FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);
CREATE TABLE User_Book_Ownership (
    ownership_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    acquired_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Ownership_User FOREIGN KEY (user_id) REFERENCES [User](user_id),
    CONSTRAINT FK_Ownership_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE Borrow (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    borrow_date DATETIME2,
    due_date DATETIME2,
    status NVARCHAR(50),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Borrow_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
CREATE TABLE Borrow_Item (
    borrow_item_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_id INT NOT NULL,
    book_id INT NOT NULL,
    returned_at DATETIME2,
    status NVARCHAR(50),
    CONSTRAINT FK_BorrowItem_Borrow FOREIGN KEY (borrow_id) REFERENCES Borrow(borrow_id),
    CONSTRAINT FK_BorrowItem_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE Fine_Type (
    fine_type_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    description NVARCHAR(MAX),
    default_amount DECIMAL(10,2)
);
CREATE TABLE Fine (
    fine_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_id INT NOT NULL,
    fine_type_id INT NOT NULL,
    amount DECIMAL(10,2),
    reason NVARCHAR(MAX),
    status NVARCHAR(50),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Fine_Borrow FOREIGN KEY (borrow_id) REFERENCES Borrow(borrow_id),
    CONSTRAINT FK_Fine_Type FOREIGN KEY (fine_type_id) REFERENCES Fine_Type(fine_type_id)
);
CREATE TABLE Reading_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    last_read_position INT,
    last_read_at DATETIME2,
    CONSTRAINT FK_Reading_User FOREIGN KEY (user_id) REFERENCES [User](user_id),
    CONSTRAINT FK_Reading_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE Bookmark (
    bookmark_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    page_number INT,
    note NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Bookmark_User FOREIGN KEY (user_id) REFERENCES [User](user_id),
    CONSTRAINT FK_Bookmark_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE Review (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT,
    comment NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Review_User FOREIGN KEY (user_id) REFERENCES [User](user_id),
    CONSTRAINT FK_Review_Book FOREIGN KEY (book_id) REFERENCES Book(book_id)
);
CREATE TABLE Notification (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    title NVARCHAR(255),
    message NVARCHAR(MAX),
    is_read BIT DEFAULT 0,
    created_at DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT FK_Notification_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
CREATE TABLE Borrow_Request (
    request_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    request_date DATETIME2 DEFAULT GETDATE(),
    status NVARCHAR(50), -- pending, approved, rejected
    note NVARCHAR(MAX),
    CONSTRAINT FK_BorrowRequest_User FOREIGN KEY (user_id) REFERENCES [User](user_id)
);
ALTER TABLE Borrow
ADD request_id INT UNIQUE;

ALTER TABLE Borrow
ADD CONSTRAINT FK_Borrow_Request FOREIGN KEY (request_id)
REFERENCES Borrow_Request(request_id);


INSERT INTO Role (role_name) VALUES
('Admin'),
('User');

INSERT INTO Admin (email, password_hash, role_id)
VALUES 
('admin@library.com', 'hashed_admin_pass', 1);

INSERT INTO [User] (full_name, email, password_hash, phone, status, role_id)
VALUES
('Nguyen Van A', 'user1@gmail.com', 'hashed_pass_1', '090000001', 'active', 2),
('Tran Thi B', 'user2@gmail.com', 'hashed_pass_2', '090000002', 'active', 2);

INSERT INTO User_Account (user_id, provider, provider_user_id)
VALUES
(1, 'google', 'google_123'),
(2, 'facebook', 'fb_456');
