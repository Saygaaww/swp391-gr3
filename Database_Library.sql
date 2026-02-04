
CREATE TABLE Roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL
);
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100),
    display_name NVARCHAR(100),
    avatar_url NVARCHAR(255),
    email NVARCHAR(255),
    phone_number NVARCHAR(20),
    status NVARCHAR(20),
    role_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    last_login_at DATETIME,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);
CREATE TABLE User_Accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    provider NVARCHAR(50),
    provider_user_id NVARCHAR(255),
    email NVARCHAR(255),
    password_hash NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    last_login_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(255),
    biography NVARCHAR(MAX),
    avatar_url NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255),
    description NVARCHAR(MAX),
    parent_id INT NULL,
    FOREIGN KEY (parent_id) REFERENCES Categories(category_id)
);
CREATE TABLE Books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    subtitle NVARCHAR(255),
    summary NVARCHAR(MAX),
    description NVARCHAR(MAX),
    cover_image_url NVARCHAR(255),
    content_path NVARCHAR(255),
    language NVARCHAR(50),
    total_pages INT,
    preview_pages INT,
    price DECIMAL(10,2),
    currency NVARCHAR(10),
    isbn NVARCHAR(50),
    publisher NVARCHAR(255),
    publish_year INT,
    status NVARCHAR(50),
    author_id INT,
    category_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
CREATE TABLE Carts (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    status NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE Cart_Items (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    book_id INT NOT NULL,
    price_at_time DECIMAL(10,2),
    added_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (cart_id) REFERENCES Carts(cart_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    cart_id INT NULL,
    order_code NVARCHAR(100),
    total_amount DECIMAL(10,2),
    currency NVARCHAR(10),
    order_status NVARCHAR(50),
    created_at DATETIME DEFAULT GETDATE(),
    paid_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (cart_id) REFERENCES Carts(cart_id)
);
CREATE TABLE Order_Books (
    order_book_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    book_id INT NOT NULL,
    price_at_purchase DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(50),
    transaction_code NVARCHAR(255),
    amount DECIMAL(10,2),
    currency NVARCHAR(10),
    paid_at DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
CREATE TABLE User_Book_Ownerships (
    ownership_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    acquired_via NVARCHAR(50),
    acquired_at DATETIME DEFAULT GETDATE(),
    expire_at DATETIME NULL,
    status NVARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE Reading_History (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    last_read_page INT,
    progress_percentage FLOAT,
    last_read_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE Bookmarks (
    bookmark_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    page_number INT,
    note NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    book_id INT NOT NULL,
    rating INT,
    comment NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);
CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    is_read BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Bảng lưu mã OTP
CREATE TABLE OTP_Codes (
    otp_id INT IDENTITY(1,1) PRIMARY KEY,
    phone_number NVARCHAR(20) NOT NULL,
    otp_code NVARCHAR(6) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    expires_at DATETIME NOT NULL,
    is_used BIT DEFAULT 0
);

CREATE TABLE Email_Otp (
    otp_id INT IDENTITY PRIMARY KEY,
    email NVARCHAR(255) NOT NULL,
    otp_code NVARCHAR(10) NOT NULL,
    expired_at DATETIME NOT NULL,
    is_used BIT DEFAULT 0
);


ALTER TABLE Users
ADD CONSTRAINT CK_User_Status
CHECK (status IN ('ACTIVE','INACTIVE','BANNED'));

ALTER TABLE Users
ADD CONSTRAINT UQ_Users_Email UNIQUE (email);

ALTER TABLE User_Accounts
ADD CONSTRAINT UQ_Provider_User UNIQUE (provider, provider_user_id);


INSERT INTO [Roles] (role_name) VALUES
('SELLER'),
('ADMIN'),
('LIBRARIAN'),
('USER');




