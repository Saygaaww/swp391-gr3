# Hướng Dẫn Kiểm Tra và Khắc Phục Lỗi Kết Nối SQL Server

## Lỗi Thường Gặp

```
The TCP/IP connection to the host localhost, port 1433 has failed. 
Error: "Connection refused: getsockopt"
```

## Các Bước Kiểm Tra và Khắc Phục

### 1. Kiểm Tra SQL Server Service Đang Chạy

**Windows:**
1. Mở **Services** (nhấn `Win + R`, gõ `services.msc`)
2. Tìm các service sau và đảm bảo chúng đang **Running**:
   - `SQL Server (MSSQLSERVER)` hoặc `SQL Server (SQLEXPRESS)`
   - `SQL Server Browser` (nếu dùng named instance)
3. Nếu service chưa chạy, click chuột phải → **Start**

**Hoặc dùng Command Prompt:**
```cmd
net start MSSQLSERVER
```
hoặc
```cmd
net start MSSQL$SQLEXPRESS
```

### 2. Kiểm Tra SQL Server Đang Lắng Nghe Trên Port 1433

**Cách 1: Dùng SQL Server Configuration Manager**
1. Mở **SQL Server Configuration Manager**
2. Mở rộng **SQL Server Network Configuration**
3. Click **Protocols for MSSQLSERVER** (hoặc instance của bạn)
4. Đảm bảo **TCP/IP** đang **Enabled**
5. Click chuột phải **TCP/IP** → **Properties**
6. Tab **IP Addresses** → Scroll xuống **IPAll**
7. Đảm bảo **TCP Port** = `1433` (hoặc port bạn đang dùng)
8. **Restart SQL Server Service** sau khi thay đổi

**Cách 2: Kiểm tra bằng Command Prompt**
```cmd
netstat -an | findstr 1433
```
Nếu thấy `0.0.0.0:1433` hoặc `127.0.0.1:1433` → Port đang mở

### 3. Kiểm Tra Firewall

**Windows Firewall:**
1. Mở **Windows Defender Firewall**
2. Click **Advanced settings**
3. Click **Inbound Rules** → **New Rule**
4. Chọn **Port** → **Next**
5. Chọn **TCP**, nhập port `1433` → **Next**
6. Chọn **Allow the connection** → **Next**
7. Chọn tất cả profiles → **Next**
8. Đặt tên "SQL Server 1433" → **Finish**

**Hoặc tạm thời tắt Firewall để test:**
```cmd
netsh advfirewall set allprofiles state off
```
(Nhớ bật lại sau khi test!)

### 4. Kiểm Tra Thông Tin Kết Nối

Mở file `src/java/utils/DBConnection.java` và kiểm tra:

```java
private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
private static final String DB_USER = "sa";
private static final String DB_PASSWORD = "123"; // Đổi thành password của bạn
```

**Nếu dùng Named Instance (ví dụ: SQLEXPRESS):**
```java
private static final String DB_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

**Nếu dùng port khác:**
```java
private static final String DB_URL = "jdbc:sqlserver://localhost:PORT_NUMBER;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

### 5. Kiểm Tra Database Đã Tồn Tại

1. Mở **SQL Server Management Studio (SSMS)**
2. Kết nối với server
3. Kiểm tra xem database `DigitalLibraryDB` đã tồn tại chưa
4. Nếu chưa, chạy script SQL để tạo database

### 6. Test Kết Nối Bằng SQL Server Management Studio

1. Mở **SSMS**
2. Server name: `localhost` hoặc `localhost\SQLEXPRESS`
3. Authentication: **SQL Server Authentication**
4. Login: `sa`
5. Password: password của bạn
6. Click **Connect**

Nếu kết nối thành công → Thông tin đăng nhập đúng
Nếu thất bại → Kiểm tra lại username/password

### 7. Kiểm Tra SQL Server Authentication Mode

1. Mở **SSMS**
2. Connect với **Windows Authentication**
3. Click chuột phải server → **Properties**
4. Tab **Security**
5. Đảm bảo **SQL Server and Windows Authentication mode** được chọn
6. **Restart SQL Server Service**

### 8. Kiểm Tra SQL Server Browser Service (Cho Named Instance)

Nếu dùng named instance (ví dụ: `SQLEXPRESS`):
1. Mở **Services**
2. Tìm **SQL Server Browser**
3. Đảm bảo service đang **Running**
4. Nếu chưa, click chuột phải → **Start**

## Test Kết Nối Từ Java

Tạo file test đơn giản:

```java
import java.sql.Connection;
import java.sql.DriverManager;

public class TestConnection {
    public static void main(String[] args) {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
            Connection conn = DriverManager.getConnection(url, "sa", "123");
            System.out.println("Kết nối thành công!");
            conn.close();
        } catch (Exception e) {
            System.out.println("Lỗi: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

## Các Lỗi Thường Gặp Khác

### Lỗi: "Login failed for user 'sa'"
- **Nguyên nhân:** Password sai hoặc tài khoản bị vô hiệu hóa
- **Giải pháp:** 
  - Đổi password trong SSMS
  - Cập nhật password trong `DBConnection.java`

### Lỗi: "Cannot open database 'DigitalLibraryDB'"
- **Nguyên nhân:** Database chưa được tạo
- **Giải pháp:** Chạy script SQL để tạo database

### Lỗi: "The TCP/IP connection to the host localhost, port 1433 has failed"
- **Nguyên nhân:** SQL Server không chạy hoặc TCP/IP chưa được bật
- **Giải pháp:** Làm theo các bước 1-3 ở trên

## Lệnh Hữu Ích

**Kiểm tra SQL Server đang chạy:**
```cmd
sc query MSSQLSERVER
```

**Khởi động SQL Server:**
```cmd
net start MSSQLSERVER
```

**Dừng SQL Server:**
```cmd
net stop MSSQLSERVER
```

**Kiểm tra port đang mở:**
```cmd
netstat -an | findstr 1433
```

**Test kết nối TCP/IP:**
```cmd
telnet localhost 1433
```
(Nếu kết nối thành công, sẽ thấy màn hình đen)

## Liên Hệ Hỗ Trợ

Nếu vẫn gặp vấn đề sau khi thử tất cả các bước trên, vui lòng cung cấp:
1. Version SQL Server (SQL Server 2019, 2022, Express, etc.)
2. Log lỗi đầy đủ từ console
3. Kết quả của các lệnh kiểm tra ở trên
