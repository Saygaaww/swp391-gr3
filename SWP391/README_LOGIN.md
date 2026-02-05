# Hướng dẫn đăng nhập hệ thống

## Cài đặt Database

1. Chạy file `SWPDB.sql` để tạo database và các bảng
2. Chạy file `InsertSampleData.sql` để thêm dữ liệu mẫu

## Tài khoản mẫu

### Người đọc (Reader)
- **Email:** `reader1@example.com`  
  **Password:** `123456`

- **Email:** `reader2@example.com`  
  **Password:** `123456`

- **Email:** `reader3@example.com`  
  **Password:** `reader123`

### Thủ thư (Librarian)
- **Email:** `librarian1@example.com`  
  **Password:** `librarian123`

- **Email:** `librarian2@example.com`  
  **Password:** `123456`

## Cách sử dụng

1. **Đăng nhập người đọc:**
   - Truy cập: `http://localhost:8080/SWP391/login`
   - Nhập email và password của Reader
   - Sau khi đăng nhập, có thể:
     - Xem danh sách sách
     - Tạo yêu cầu mượn sách
     - Xem sách đang mượn
     - Trả sách

2. **Đăng nhập thủ thư:**
   - Truy cập: `http://localhost:8080/SWP391/login?type=librarian`
   - Nhập email và password của Librarian
   - Sau khi đăng nhập, có thể:
     - Xem danh sách yêu cầu mượn sách đang chờ duyệt
     - Duyệt yêu cầu mượn sách
     - Từ chối yêu cầu mượn sách

## Lưu ý về Password Hash

Hệ thống sử dụng SHA-256 để hash password. Nếu bạn muốn tạo tài khoản mới, bạn cần:

1. Hash password bằng SHA-256
2. Insert vào database với password_hash đã được hash

### Công cụ hash password online:
- https://emn178.github.io/online-tools/sha256.html
- Hoặc sử dụng Java code trong `ReaderDAO.java` hoặc `EmployeeDAO.java`

### Ví dụ:
- Password: `123456` → Hash: `8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92`
- Password: `librarian123` → Hash: `240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9`

## Tạo tài khoản mới

### Tạo Reader mới:
```sql
INSERT INTO Reader (full_name, email, password_hash, phone, avatar, status, role_id) 
VALUES ('Tên người dùng', 'email@example.com', 'SHA256_HASH_CỦA_PASSWORD', '0123456789', NULL, 'active', 3);
```

### Tạo Librarian mới:
```sql
INSERT INTO Employee (full_name, email, password_hash, status, role_id) 
VALUES ('Tên thủ thư', 'email@example.com', 'SHA256_HASH_CỦA_PASSWORD', 'active', 2);
```

**Lưu ý:** 
- `role_id = 3` là USER (Reader)
- `role_id = 2` là LIBRARIAN
- Password phải được hash bằng SHA-256 trước khi insert vào database
