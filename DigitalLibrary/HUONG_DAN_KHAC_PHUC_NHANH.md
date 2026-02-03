# Hướng Dẫn Khắc Phục Lỗi Kết Nối SQL Server - Nhanh

## 🚨 Lỗi Hiện Tại

```
Connection refused: getsockopt
The TCP/IP connection to the host localhost, port 1433 has failed
```

## ⚡ Khắc Phục Nhanh (5 Phút)

### Bước 1: Kiểm Tra SQL Server Service (1 phút)

**Cách 1: Dùng PowerShell (Khuyến nghị)**
```powershell
# Mở PowerShell (Run as Administrator)
Get-Service | Where-Object {$_.DisplayName -like "*SQL Server*"}
```

**Cách 2: Dùng Services**
1. Nhấn `Win + R`
2. Gõ `services.msc` → Enter
3. Tìm các service:
   - `SQL Server (MSSQLSERVER)` 
   - `SQL Server (SQLEXPRESS)`
4. Kiểm tra Status:
   - ✅ **Running** = Đang chạy
   - ❌ **Stopped** = Dừng → Click chuột phải → **Start**

**Cách 3: Dùng Command Prompt**
```cmd
sc query MSSQLSERVER
```

### Bước 2: Khởi Động SQL Server (Nếu chưa chạy)

**PowerShell (Run as Administrator):**
```powershell
Start-Service -Name "MSSQLSERVER"
```

Hoặc nếu dùng SQLEXPRESS:
```powershell
Start-Service -Name "MSSQL$SQLEXPRESS"
```

**Command Prompt (Run as Administrator):**
```cmd
net start MSSQLSERVER
```

### Bước 3: Kiểm Tra Port 1433 (1 phút)

**PowerShell:**
```powershell
Test-NetConnection -ComputerName localhost -Port 1433
```

**Command Prompt:**
```cmd
netstat -an | findstr 1433
```

Nếu thấy `0.0.0.0:1433` hoặc `127.0.0.1:1433` → Port đang mở ✅

### Bước 4: Bật TCP/IP Protocol (2 phút)

1. **Mở SQL Server Configuration Manager**
   - Tìm trong Start Menu: "SQL Server Configuration Manager"
   - Hoặc: `C:\Windows\SysWOW64\SQLServerManagerXX.msc` (XX = version)

2. **Bật TCP/IP:**
   - Mở rộng: **SQL Server Network Configuration**
   - Click: **Protocols for MSSQLSERVER** (hoặc instance của bạn)
   - Tìm **TCP/IP** trong danh sách
   - Click chuột phải → **Enable**

3. **Cấu hình Port:**
   - Click chuột phải **TCP/IP** → **Properties**
   - Tab **IP Addresses**
   - Scroll xuống **IPAll**
   - **TCP Port** = `1433`
   - Click **OK**

4. **Restart SQL Server Service:**
   ```powershell
   Restart-Service -Name "MSSQLSERVER"
   ```

### Bước 5: Test Kết Nối (1 phút)

**Cách 1: Dùng Test Connection Servlet**
1. Build và deploy project
2. Truy cập: `http://localhost:8080/DigitalLibrary/test-connection`
3. Xem kết quả

**Cách 2: Dùng SQL Server Management Studio**
1. Mở SSMS
2. Server name: `localhost`
3. Authentication: SQL Server Authentication
4. Login: `sa`
5. Password: `123` (hoặc password của bạn)
6. Click **Connect**

**Cách 3: Dùng Command Line**
```cmd
sqlcmd -S localhost -U sa -P 123
```

## 🔧 Script Tự Động Kiểm Tra

Đã tạo file `check-sql-server.ps1` - chạy script này để tự động kiểm tra:

```powershell
# Mở PowerShell (Run as Administrator)
cd "C:\Users\xuank\OneDrive\Documents\NetBeansProjects\DigitalLibrary"
.\check-sql-server.ps1
```

Script sẽ kiểm tra:
- ✅ SQL Server Services
- ✅ Port 1433
- ✅ SQL Server Browser
- ✅ Firewall Rules
- ✅ Test TCP Connection

## ⚠️ Các Trường Hợp Đặc Biệt

### Nếu dùng Named Instance (SQLEXPRESS)

**Cập nhật DBConnection.java:**
```java
private static final String DB_URL = "jdbc:sqlserver://localhost\\SQLEXPRESS:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

**Khởi động service:**
```powershell
Start-Service -Name "MSSQL$SQLEXPRESS"
```

### Nếu dùng Port Khác

1. Kiểm tra port trong SQL Server Configuration Manager
2. Cập nhật DBConnection.java:
```java
private static final String DB_URL = "jdbc:sqlserver://localhost:PORT_NUMBER;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
```

### Nếu Firewall Chặn

**Tạm thời tắt Firewall để test:**
```powershell
# PowerShell (Run as Administrator)
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

**Hoặc mở port 1433:**
```powershell
New-NetFirewallRule -DisplayName "SQL Server 1433" -Direction Inbound -LocalPort 1433 -Protocol TCP -Action Allow
```

## 📋 Checklist Nhanh

- [ ] SQL Server Service đang chạy
- [ ] TCP/IP Protocol đã được bật
- [ ] Port 1433 đã được cấu hình
- [ ] SQL Server Service đã được restart sau khi thay đổi
- [ ] Firewall không chặn port 1433
- [ ] Username/password đúng trong DBConnection.java
- [ ] Database 'DigitalLibraryDB' đã được tạo

## 🆘 Vẫn Không Kết Nối Được?

1. **Kiểm tra SQL Server đã được cài đặt:**
   ```powershell
   Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "*SQL Server*"}
   ```

2. **Kiểm tra log SQL Server:**
   - Mở SQL Server Management Studio
   - Connect với Windows Authentication
   - Xem SQL Server Logs

3. **Thử kết nối với Windows Authentication:**
   - Thay đổi DBConnection.java để dùng Windows Authentication
   - Hoặc test trong SSMS với Windows Authentication

4. **Xem chi tiết trong:**
   - `HUONG_DAN_KIEM_TRA_SQL_SERVER.md`
   - `HUONG_DAN_KIEM_TRA_DB_URL.md`

## ✅ Sau Khi Khắc Phục

1. Test lại bằng: `http://localhost:8080/DigitalLibrary/test-connection`
2. Thử đăng nhập lại bằng Google
3. Nếu vẫn lỗi, kiểm tra log trong console của NetBeans
