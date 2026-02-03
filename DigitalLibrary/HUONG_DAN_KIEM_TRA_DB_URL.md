# Hướng Dẫn Kiểm Tra DB URL

## 📍 Vị Trí File Cấu Hình Database

File cấu hình database nằm tại:
```
src/java/utils/DBConnection.java
```

## 🔍 Cách Kiểm Tra DB URL

### 1. Mở File DBConnection.java

Trong NetBeans:
1. Mở Project Explorer
2. Mở thư mục `src/java/utils/`
3. Double-click file `DBConnection.java`

### 2. Kiểm Tra Thông Tin Cấu Hình

Trong file `DBConnection.java`, bạn sẽ thấy:

```java
private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
private static final String DB_USER = "sa";
private static final String DB_PASSWORD = "123"; // Thay đổi password của bạn
```

**Giải thích các thông số:**
- `localhost:1433` - Địa chỉ server và port
- `databaseName=DigitalLibraryDB` - Tên database
- `encrypt=true` - Mã hóa kết nối
- `trustServerCertificate=true` - Tin tưởng certificate của server

### 3. Các Trường Hợp Đặc Biệt

#### Nếu dùng Named Instance (ví dụ: SQLEXPRESS):
```java
private static final String DB_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

#### Nếu dùng port khác (ví dụ: 1434):
```java
private static final String DB_URL = "jdbc:sqlserver://localhost:1434;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

#### Nếu SQL Server ở máy khác:
```java
private static final String DB_URL = "jdbc:sqlserver://192.168.1.100:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

## 🧪 Cách Test Kết Nối

### Cách 1: Dùng Test Connection Servlet (Khuyến nghị)

1. Build và deploy project
2. Mở trình duyệt
3. Truy cập: `http://localhost:8080/DigitalLibrary/test-connection`
4. Trang sẽ hiển thị:
   - Thông tin cấu hình hiện tại
   - Kết quả test kết nối
   - Thông tin database nếu kết nối thành công
   - Hướng dẫn khắc phục nếu có lỗi

### Cách 2: Test Bằng SQL Server Management Studio

1. Mở **SQL Server Management Studio (SSMS)**
2. Server name: `localhost` (hoặc `localhost\SQLEXPRESS` nếu dùng named instance)
3. Authentication: **SQL Server Authentication**
4. Login: `sa` (hoặc username trong DBConnection.java)
5. Password: password của bạn
6. Click **Connect**

Nếu kết nối thành công → Thông tin đúng
Nếu thất bại → Kiểm tra lại username/password

### Cách 3: Test Bằng Command Line

```cmd
sqlcmd -S localhost -U sa -P 123
```

Hoặc nếu dùng named instance:
```cmd
sqlcmd -S localhost\SQLEXPRESS -U sa -P 123
```

### Cách 4: Test Bằng Java Code

Tạo file test đơn giản:

```java
import java.sql.Connection;
import java.sql.DriverManager;

public class TestDB {
    public static void main(String[] args) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
            Connection conn = DriverManager.getConnection(url, "sa", "123");
            System.out.println("✅ Kết nối thành công!");
            System.out.println("URL: " + url);
            conn.close();
        } catch (Exception e) {
            System.out.println("❌ Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

## 🔧 Cách Thay Đổi DB URL

### Bước 1: Xác Định Thông Tin SQL Server

**Kiểm tra SQL Server đang chạy:**
```cmd
# Mở Command Prompt
sc query MSSQLSERVER
```

**Kiểm tra port:**
```cmd
netstat -an | findstr 1433
```

**Kiểm tra instance name:**
- Mở SQL Server Configuration Manager
- Xem trong **SQL Server Services** → Instance name

### Bước 2: Cập Nhật DBConnection.java

1. Mở file `src/java/utils/DBConnection.java`
2. Sửa các giá trị:
   - `DB_URL` - URL kết nối
   - `DB_USER` - Username
   - `DB_PASSWORD` - Password
3. Save file
4. Clean and Build project
5. Redeploy

### Bước 3: Test Lại

Truy cập: `http://localhost:8080/DigitalLibrary/test-connection`

## 📝 Ví Dụ Các DB URL Phổ Biến

### SQL Server Default Instance (Port 1433):
```java
"jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;"
```

### SQL Server Named Instance (SQLEXPRESS):
```java
"jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;"
```

### SQL Server trên máy khác:
```java
"jdbc:sqlserver://192.168.1.100:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;"
```

### SQL Server với port tùy chỉnh:
```java
"jdbc:sqlserver://localhost:1434;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;"
```

### SQL Server không mã hóa (không khuyến nghị):
```java
"jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=false;"
```

## ⚠️ Lưu Ý Bảo Mật

1. **Không commit password vào Git:**
   - Sử dụng environment variables
   - Hoặc file cấu hình riêng (không commit)

2. **Sử dụng connection pool** cho production

3. **Mã hóa kết nối** (`encrypt=true`) cho bảo mật

## 🆘 Troubleshooting

### Lỗi: "Connection refused"
→ Kiểm tra SQL Server Service đã chạy chưa

### Lỗi: "Login failed"
→ Kiểm tra username/password

### Lỗi: "Database not found"
→ Chạy script SQL để tạo database

### Lỗi: "Port not found"
→ Kiểm tra port trong SQL Server Configuration Manager

Xem thêm: `HUONG_DAN_KIEM_TRA_SQL_SERVER.md`
