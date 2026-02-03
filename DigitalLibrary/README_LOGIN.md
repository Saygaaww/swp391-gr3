# Hướng Dẫn Cài Đặt Hệ Thống Đăng Nhập với Google OAuth

## Tổng Quan

Hệ thống đăng nhập đã được tạo với các tính năng:
- ✅ Giao diện đăng nhập đẹp, hiện đại và responsive
- ✅ Đăng nhập bằng email/password với validation
- ✅ Đăng nhập bằng Google OAuth
- ✅ Kết nối với SQL Server database
- ✅ Quản lý session và phân quyền

## Cấu Trúc Dự Án

```
DigitalLibrary/
├── src/java/
│   ├── controller/          # Servlets xử lý request
│   │   ├── LoginServlet.java
│   │   ├── GoogleAuthServlet.java
│   │   ├── GoogleCallbackServlet.java
│   │   └── LogoutServlet.java
│   ├── dao/                 # Data Access Objects
│   │   ├── ReaderDAO.java
│   │   ├── ReaderAccountDAO.java
│   │   └── RoleDAO.java
│   ├── model/               # Model classes
│   │   ├── Reader.java
│   │   ├── ReaderAccount.java
│   │   └── Role.java
│   └── utils/               # Utility classes
│       ├── DBConnection.java
│       ├── PasswordUtil.java
│       └── GoogleOAuthUtil.java
├── web/
│   ├── login.jsp            # Trang đăng nhập
│   ├── css/
│   │   └── login.css        # Stylesheet cho login
│   ├── js/
│   │   └── login.js         # JavaScript validation
│   └── WEB-INF/
│       └── web.xml          # Cấu hình servlet
```

## Cài Đặt

### 1. Cấu Hình Database

Mở file `src/java/utils/DBConnection.java` và cập nhật thông tin kết nối:

```java
private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
private static final String DB_USER = "sa";
private static final String DB_PASSWORD = "your_password"; // Thay đổi password của bạn
```

### 2. Tạo Dữ Liệu Mẫu

Chạy script SQL sau để tạo các role mặc định:

```sql
USE DigitalLibraryDB;
GO

-- Insert default roles
INSERT INTO Role (role_name, description) VALUES 
('ADMIN', 'Quản trị viên hệ thống'),
('LIBRARIAN', 'Thủ thư'),
('SELLER', 'Người bán'),
('USER', 'Người dùng thông thường');
GO
```

### 3. Cấu Hình Google OAuth

#### Bước 1: Tạo Google OAuth Credentials

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo một project mới hoặc chọn project có sẵn
3. Vào **APIs & Services** > **Credentials**
4. Click **Create Credentials** > **OAuth client ID**
5. Chọn **Web application**
6. Thêm **Authorized redirect URIs**:
   ```
   http://localhost:8080/DigitalLibrary/auth/google/callback
   ```
   (Thay đổi port nếu cần)
7. Lưu **Client ID** và **Client Secret**

#### Bước 2: Cập Nhật Thông Tin OAuth

Mở file `src/java/utils/GoogleOAuthUtil.java` và cập nhật:

```java
private static final String CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID";
private static final String CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET";
```

### 4. Thêm Thư Viện (Nếu Cần)

Dự án đã sử dụng các thư viện có sẵn:
- Jakarta Servlet API (có sẵn trong Tomcat)
- SQL Server JDBC Driver (đã có: sqljdbc42.jar)
- JSTL (đã có)

**Lưu ý:** Code đã được viết để không cần thư viện JSON bên ngoài, sử dụng regex parsing đơn giản.

## Sử Dụng

### Đăng Nhập Bằng Email/Password

1. Truy cập: `http://localhost:8080/DigitalLibrary/login`
2. Nhập email và password
3. Hệ thống sẽ validate và đăng nhập

### Đăng Nhập Bằng Google

1. Click nút "Đăng nhập bằng Google"
2. Chọn tài khoản Google
3. Hệ thống sẽ tự động tạo tài khoản nếu chưa có

### Validation

Form login có validation:
- Email phải đúng định dạng
- Password không được để trống (tối thiểu 6 ký tự)
- Hiển thị lỗi real-time
- Kiểm tra trạng thái tài khoản (active/inactive)

## Phân Quyền

Sau khi đăng nhập, user sẽ được redirect dựa trên role:
- **ADMIN** → `/admin/dashboard`
- **LIBRARIAN** → `/librarian/dashboard`
- **SELLER** → `/seller/dashboard`
- **USER** → `/home`

## Session Management

Thông tin user được lưu trong session:
- `reader`: Object Reader
- `readerId`: ID của reader
- `readerName`: Tên đầy đủ
- `readerEmail`: Email
- `readerRole`: Tên role

## Logout

Truy cập: `http://localhost:8080/DigitalLibrary/logout`

## Troubleshooting

### Lỗi kết nối database
- Kiểm tra SQL Server đã chạy chưa
- Kiểm tra thông tin kết nối trong `DBConnection.java`
- Đảm bảo database `DigitalLibraryDB` đã được tạo

### Lỗi Google OAuth
- Kiểm tra Client ID và Client Secret đã đúng chưa
- Kiểm tra Redirect URI đã được thêm vào Google Cloud Console
- Đảm bảo OAuth consent screen đã được cấu hình

### Lỗi compile
- Đảm bảo Java version >= 17 (cho Jakarta EE)
- Kiểm tra các thư viện trong `WEB-INF/lib`
- Clean và rebuild project

## Tính Năng Nâng Cao (Có Thể Thêm)

- [ ] Remember me với cookie
- [ ] Forgot password
- [ ] Email verification
- [ ] Two-factor authentication
- [ ] Rate limiting cho login attempts
- [ ] CAPTCHA

## Ghi Chú

- Password được hash bằng SHA-256 (có thể nâng cấp lên BCrypt)
- Google OAuth sử dụng OAuth 2.0 flow
- Session timeout: 30 phút (có thể cấu hình trong web.xml)
