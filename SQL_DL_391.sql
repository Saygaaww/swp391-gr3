

CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(50) NOT NULL UNIQUE
);

SET IDENTITY_INSERT roles ON;
INSERT INTO roles (role_id, role_name) VALUES
(1, 'Guest'),
(2, 'User'),
(3, 'UserVip'),
(4, 'Admin');
SET IDENTITY_INSERT roles OFF;

CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    email NVARCHAR(100),
    status NVARCHAR(20),
    role_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX)
);

CREATE TABLE authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(100) NOT NULL,
    biography NVARCHAR(MAX)
);

CREATE TABLE documents (
    document_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    file_path NVARCHAR(255),
    category_id INT,
    author_id INT,
    uploaded_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

CREATE TABLE download_history (
    download_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    document_id INT,
    downloaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (document_id) REFERENCES documents(document_id)
);

CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    summary NVARCHAR(500),
    description NVARCHAR(MAX),
    price DECIMAL(10,2),
    file_path NVARCHAR(255),
    cover_image NVARCHAR(255),
    stock_quantity INT,
    status NVARCHAR(20),
    category_id INT,
    author_id INT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE carts (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT UNIQUE,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE cart_items (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2),
    order_status NVARCHAR(20),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT UNIQUE,
    payment_method NVARCHAR(50),
    payment_status NVARCHAR(20),
    paid_at DATETIME,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


