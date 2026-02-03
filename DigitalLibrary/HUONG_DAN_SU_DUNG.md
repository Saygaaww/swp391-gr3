# Hướng Dẫn Sử Dụng Hệ Thống Đăng Nhập Digital Library

## 📋 Tổng Quan

Đã tạo xong hệ thống đăng nhập với các tính năng:
- ✅ Giao diện đăng nhập đẹp, hiện đại, responsive
- ✅ Đăng nhập bằng email/password với validation đầy đủ
- ✅ Đăng nhập bằng Google OAuth
- ✅ Kết nối với SQL Server database
- ✅ Quản lý session và phân quyền theo role

## 🚀 Các Bước Cài Đặt

### Bước 1: Cấu Hình Database

1. Mở file `src/java/utils/DBConnection.java`
2. Cập nhật thông tin kết nối:
   ```java
   private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;...";
   private static final String DB_USER = "sa";
   private static final String DB_PASSWORD = "your_password"; // Đổi password của bạn
   ```

3. Chạy script `database_setup.sql` để tạo dữ liệu mẫu (các role)

### Bước 2: Cấu Hình Google OAuth

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo OAuth 2.0 Client ID
3. Thêm Redirect URI: `http://localhost:8080/DigitalLibrary/auth/google/callback`
4. Mở file `src/java/utils/GoogleOAuthUtil.java` và cập nhật:
   ```java
   private static final String CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID";
   private static final String CLIENT_SECRET = "YOUR_GOOGLE_CLIENT_SECRET";
   ```

### Bước 3: Build và Deploy

1. Clean và Build project trong NetBeans
2. Deploy lên Tomcat
3. Truy cập: `http://localhost:8080/DigitalLibrary/login`

## 📁 Cấu Trúc File Đã Tạo

### Java Classes

**Model:**
- `model/Role.java` - Model cho bảng Role
- `model/Reader.java` - Model cho bảng Reader
- `model/ReaderAccount.java` - Model cho bảng Reader_Account

**DAO (Data Access Object):**
- `dao/RoleDAO.java` - Truy vấn bảng Role
- `dao/ReaderDAO.java` - Truy vấn và xác thực Reader
- `dao/ReaderAccountDAO.java` - Quản lý tài khoản OAuth

**Controller (Servlet):**
- `controller/LoginServlet.java` - Xử lý đăng nhập email/password
- `controller/GoogleAuthServlet.java` - Redirect đến Google OAuth
- `controller/GoogleCallbackServlet.java` - Xử lý callback từ Google
- `controller/LogoutServlet.java` - Xử lý đăng xuất

**Utils:**
- `utils/DBConnection.java` - Kết nối database
- `utils/PasswordUtil.java` - Hash và verify password
- `utils/GoogleOAuthUtil.java` - Utility cho Google OAuth

### Web Files

- `web/login.jsp` - Trang đăng nhập
- `web/home.jsp` - Trang chủ sau khi đăng nhập
- `web/css/login.css` - Stylesheet cho login
- `web/js/login.js` - JavaScript validation
- `web/WEB-INF/web.xml` - Cấu hình servlet

## 🎨 Tính Năng Giao Diện

### Login Page
- Design hiện đại với gradient background
- Responsive cho mobile và desktop
- Animation và transition mượt mà
- Validation real-time
- Toggle password visibility
- Loading state khi submit

### Validation
- Email format validation
- Password minimum length (6 ký tự)
- Error messages rõ ràng
- Client-side và server-side validation

## 🔐 Bảo Mật

- Password được hash bằng SHA-256
- Session management
- Kiểm tra trạng thái tài khoản (active/inactive)
- OAuth 2.0 flow cho Google login

## 👥 Phân Quyền

Sau khi đăng nhập, user được redirect theo role:
- **ADMIN** → `/admin/dashboard`
- **LIBRARIAN** → `/librarian/dashboard`
- **SELLER** → `/seller/dashboard`
- **USER** → `/home`

## 📝 Session Attributes

Sau khi đăng nhập thành công, session chứa:
- `reader` - Object Reader đầy đủ
- `readerId` - ID của reader
- `readerName` - Tên đầy đủ
- `readerEmail` - Email
- `readerRole` - Tên role

## 🛠️ Thư Viện Sử Dụng

Dự án sử dụng:
- **Jakarta Servlet API** (có sẵn trong Tomcat)
- **SQL Server JDBC Driver** (sqljdbc42.jar)
- **JSTL** (jakarta.servlet.jsp.jstl)
- **Font Awesome** (CDN) - Icons
- **Google Fonts** (Poppins) - Font chữ

**Không cần thư viện JSON bên ngoài** - đã implement simple JSON parser

## ⚠️ Lưu Ý Quan Trọng

1. **Database**: Đảm bảo SQL Server đang chạy và database đã được tạo
2. **Google OAuth**: Phải cấu hình đúng Client ID và Secret
3. **Password**: Hiện tại dùng SHA-256, có thể nâng cấp lên BCrypt
4. **Port**: Mặc định port 8080, thay đổi nếu cần

## 🐛 Troubleshooting

### Lỗi kết nối database
```
- Kiểm tra SQL Server service đã chạy
- Kiểm tra thông tin trong DBConnection.java
- Đảm bảo database DigitalLibraryDB đã tồn tại
```

### Lỗi Google OAuth
```
- Kiểm tra Client ID và Secret đã đúng
- Kiểm tra Redirect URI trong Google Console
- Đảm bảo OAuth consent screen đã được cấu hình
```

### Lỗi compile
```
- Java version >= 17 (cho Jakarta EE)
- Kiểm tra các JAR trong WEB-INF/lib
- Clean và rebuild project
```

## 📚 Tài Liệu Tham Khảo

- [Jakarta Servlet Documentation](https://jakarta.ee/specifications/servlet/)
- [Google OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
- [SQL Server JDBC Driver](https://docs.microsoft.com/en-us/sql/connect/jdbc/)

## ✨ Tính Năng Có Thể Mở Rộng

- [ ] Remember me với cookie
- [ ] Forgot password
- [ ] Email verification
- [ ] Two-factor authentication
- [ ] Rate limiting
- [ ] CAPTCHA
- [ ] Social login khác (Facebook, GitHub)

---

**Chúc bạn code vui vẻ! 🎉**
