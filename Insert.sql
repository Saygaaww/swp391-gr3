-- Script để thêm dữ liệu mẫu cho hệ thống đăng nhập
-- Chạy script này sau khi đã tạo database và các bảng

USE DigitalLibraryDB;
GO

-- 1. Thêm các Role
INSERT INTO Role (role_name, description) VALUES
('ADMIN', 'Quản trị viên hệ thống'),
('LIBRARIAN', 'Thủ thư - quản lý mượn trả sách'),
('USER', 'Người đọc'),
('SELLER', 'Nhân viên bán hàng');
GO

-- 2. Thêm dữ liệu Reader (Người đọc)
-- Password: 123456 (SHA-256 hash: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92)
-- Password: reader123 (SHA-256 hash: 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d)
INSERT INTO Reader (full_name, email, password_hash, phone, avatar, status, role_id) VALUES
('Nguyễn Văn A', 'reader1@example.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0123456789', NULL, 'active', 3),
('Trần Thị B', 'reader2@example.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '0987654321', NULL, 'active', 3),
('Lê Văn C', 'reader3@example.com', '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d', '0912345678', NULL, 'active', 3);
GO

-- 3. Thêm dữ liệu Employee (Thủ thư)
-- Password: librarian123 (SHA-256 hash: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9)
-- Password: 123456 (SHA-256 hash: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92)
INSERT INTO Employee (full_name, email, password_hash, status, role_id) VALUES
('Phạm Thị D', 'librarian1@example.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'active', 2),
('Hoàng Văn E', 'librarian2@example.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'active', 2);
GO

-- 4. Thêm dữ liệu Category (Thể loại sách)
INSERT INTO Category (category_name, description) VALUES
('Tiểu thuyết', 'Các tác phẩm tiểu thuyết văn học'),
('Khoa học', 'Sách về khoa học và công nghệ'),
('Lịch sử', 'Sách về lịch sử'),
('Kinh tế', 'Sách về kinh tế và tài chính'),
('Văn học', 'Các tác phẩm văn học'),
('Tự nhiên', 'Sách về tự nhiên và môi trường');
GO

-- 5. Thêm dữ liệu Author (Tác giả)
INSERT INTO Author (author_name, bio) VALUES
('Nguyễn Nhật Ánh', 'Nhà văn Việt Nam chuyên viết cho thanh thiếu niên'),
('Nguyễn Du', 'Đại thi hào dân tộc Việt Nam'),
('Nam Cao', 'Nhà văn hiện thực phê phán'),
('Stephen Hawking', 'Nhà vật lý lý thuyết, vũ trụ học'),
('Bill Gates', 'Doanh nhân, nhà từ thiện'),
('Nguyễn Ngọc Tư', 'Nhà văn đương đại Việt Nam');
GO

-- 6. Thêm dữ liệu Book (Sách)
-- Lưu ý: Bạn cần điều chỉnh author_id và category_id dựa trên dữ liệu đã insert ở trên
INSERT INTO Book (title, summary, description, cover_url, content_path, price, currency, total_pages, preview_pages, status, author_id, category_id) VALUES
('Tôi thấy hoa vàng trên cỏ xanh', 
 'Câu chuyện về tuổi thơ ở một làng quê Việt Nam', 
 'Cuốn tiểu thuyết kể về những kỷ niệm tuổi thơ của nhân vật chính...', 
 NULL, NULL, 80000, 'VND', 300, 20, 'active', 1, 1),
('Truyện Kiều', 
 'Tác phẩm kinh điển của văn học Việt Nam', 
 'Truyện Kiều là một trong những tác phẩm văn học lớn nhất của Việt Nam...', 
 NULL, NULL, 120000, 'VND', 500, 30, 'active', 2, 5),
('Chí Phèo', 
 'Tác phẩm nổi tiếng của Nam Cao', 
 'Câu chuyện về số phận của người nông dân trong xã hội cũ...', 
 NULL, NULL, 60000, 'VND', 150, 15, 'active', 3, 5),
('A Brief History of Time', 
 'Lịch sử vũ trụ từ Big Bang đến lỗ đen', 
 'Cuốn sách giải thích các khái niệm vật lý phức tạp một cách dễ hiểu...', 
 NULL, NULL, 200000, 'VND', 400, 25, 'active', 4, 2),
('Business @ the Speed of Thought', 
 'Tư duy kinh doanh trong thời đại số', 
 'Bill Gates chia sẻ về cách công nghệ thay đổi cách làm kinh doanh...', 
 NULL, NULL, 180000, 'VND', 350, 20, 'active', 5, 4);
GO

-- 7. Thêm BookCopy (Bản sao sách) cho một số sách
-- Giả sử book_id từ 1 đến 5 tương ứng với các sách vừa insert
INSERT INTO BookCopy (book_id, copy_code, status) VALUES
-- Sách ID 1 (Tôi thấy hoa vàng trên cỏ xanh) - 3 bản
(1, 'BC001', 'available'),
(1, 'BC002', 'available'),
(1, 'BC003', 'available'),
-- Sách ID 2 (Truyện Kiều) - 2 bản
(2, 'BC004', 'available'),
(2, 'BC005', 'available'),
-- Sách ID 3 (Chí Phèo) - 2 bản
(3, 'BC006', 'available'),
(3, 'BC007', 'available'),
-- Sách ID 4 (A Brief History of Time) - 1 bản
(4, 'BC008', 'available'),
-- Sách ID 5 (Business @ the Speed of Thought) - 2 bản
(5, 'BC009', 'available'),
(5, 'BC010', 'available');
GO

PRINT 'Đã thêm dữ liệu mẫu thành công!';
PRINT '';
PRINT 'Tài khoản Reader (Người đọc):';
PRINT '  Email: c | Password: 123456';
PRINT '  Email: reader2@example.com | Password: 123456';
PRINT '  Email: reader3@example.com | Password: reader123';
PRINT '';
PRINT 'Tài khoản Librarian (Thủ thư):';
PRINT '  Email: librarian1@example.com | Password: librarian123';
PRINT '  Email: librarian2@example.com | Password: 123456';
GO
