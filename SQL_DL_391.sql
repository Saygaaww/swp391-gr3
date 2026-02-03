

CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(255),
    avatar_url NVARCHAR(MAX),
    status NVARCHAR(50),
    created_at DATETIME2 DEFAULT SYSDATETIME()
);
CREATE TABLE user_auth_providers (
    auth_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    provider_name NVARCHAR(50),
    provider_user_id NVARCHAR(255),
    email_from_provider NVARCHAR(255),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_auth_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE local_accounts (
    user_id INT PRIMARY KEY,
    username NVARCHAR(100) UNIQUE,
    password_hash NVARCHAR(MAX),
    CONSTRAINT FK_local_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE roles (
    role_id INT IDENTITY(1,1) PRIMARY KEY,
    role_name NVARCHAR(100),
    description NVARCHAR(MAX)
);
CREATE TABLE user_roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT FK_user_roles_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT FK_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(role_id)
);
CREATE TABLE authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name NVARCHAR(255),
    biography NVARCHAR(MAX)
);
CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(255),
    description NVARCHAR(MAX)
);
CREATE TABLE documents (
    document_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    description NVARCHAR(MAX),
    file_path NVARCHAR(MAX),
    category_id INT,
    author_id INT,
    uploaded_by INT,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    is_available BIT DEFAULT 1,
    CONSTRAINT FK_documents_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT FK_documents_author FOREIGN KEY (author_id) REFERENCES authors(author_id),
    CONSTRAINT FK_documents_user FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);
CREATE TABLE books (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    price DECIMAL(10,2),
    stock_quantity INT,
    cover_image NVARCHAR(MAX),
    category_id INT,
    author_id INT,
    CONSTRAINT FK_books_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT FK_books_author FOREIGN KEY (author_id) REFERENCES authors(author_id)
);
CREATE TABLE borrow_records (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    borrow_date DATE,
    due_date DATE,
    return_date DATE,
    status NVARCHAR(50),
    CONSTRAINT FK_borrow_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE borrow_items (
    borrow_item_id INT IDENTITY(1,1) PRIMARY KEY,
    borrow_id INT,
    document_id INT,
    CONSTRAINT FK_borrow_items_borrow FOREIGN KEY (borrow_id) REFERENCES borrow_records(borrow_id),
    CONSTRAINT FK_borrow_items_document FOREIGN KEY (document_id) REFERENCES documents(document_id)
);
CREATE TABLE download_history (
    download_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    document_id INT,
    downloaded_at DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_download_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT FK_download_document FOREIGN KEY (document_id) REFERENCES documents(document_id)
);
CREATE TABLE carts (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_cart_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE cart_items (
    cart_item_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT,
    book_id INT,
    quantity INT,
    CONSTRAINT FK_cart_items_cart FOREIGN KEY (cart_id) REFERENCES carts(cart_id),
    CONSTRAINT FK_cart_items_book FOREIGN KEY (book_id) REFERENCES books(book_id)
);
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    total_amount DECIMAL(10,2),
    order_status NVARCHAR(50),
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_orders_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE order_items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    price DECIMAL(10,2),
    CONSTRAINT FK_order_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT FK_order_items_book FOREIGN KEY (book_id) REFERENCES books(book_id)
);
CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    payment_method NVARCHAR(100),
    payment_status NVARCHAR(50),
    paid_at DATETIME2,
    CONSTRAINT FK_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
CREATE TABLE activity_logs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    action NVARCHAR(255),
    entity_type NVARCHAR(100),
    entity_id INT,
    created_at DATETIME2 DEFAULT SYSDATETIME(),
    CONSTRAINT FK_logs_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);
