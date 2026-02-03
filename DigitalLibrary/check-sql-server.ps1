# Script kiểm tra SQL Server trên Windows
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KIỂM TRA SQL SERVER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Kiểm tra SQL Server Services
Write-Host "1. Kiểm tra SQL Server Services:" -ForegroundColor Yellow
$services = Get-Service | Where-Object {$_.DisplayName -like "*SQL Server*"}
if ($services.Count -eq 0) {
    Write-Host "   ❌ Không tìm thấy SQL Server Service!" -ForegroundColor Red
    Write-Host "   → Có thể SQL Server chưa được cài đặt" -ForegroundColor Yellow
} else {
    foreach ($service in $services) {
        $status = if ($service.Status -eq "Running") { "✅ Đang chạy" } else { "❌ Dừng" }
        $color = if ($service.Status -eq "Running") { "Green" } else { "Red" }
        Write-Host "   $status - $($service.DisplayName)" -ForegroundColor $color
        if ($service.Status -ne "Running") {
            Write-Host "   → Khởi động service: Start-Service -Name '$($service.Name)'" -ForegroundColor Yellow
        }
    }
}
Write-Host ""

# 2. Kiểm tra port 1433
Write-Host "2. Kiểm tra port 1433:" -ForegroundColor Yellow
$port1433 = Get-NetTCPConnection -LocalPort 1433 -ErrorAction SilentlyContinue
if ($port1433) {
    Write-Host "   ✅ Port 1433 đang được sử dụng" -ForegroundColor Green
    Write-Host "   State: $($port1433.State)" -ForegroundColor Cyan
    Write-Host "   LocalAddress: $($port1433.LocalAddress)" -ForegroundColor Cyan
} else {
    Write-Host "   ❌ Port 1433 không được sử dụng" -ForegroundColor Red
    Write-Host "   → SQL Server có thể chưa được khởi động hoặc đang dùng port khác" -ForegroundColor Yellow
}
Write-Host ""

# 3. Kiểm tra SQL Server Browser
Write-Host "3. Kiểm tra SQL Server Browser:" -ForegroundColor Yellow
$browser = Get-Service | Where-Object {$_.Name -like "*SQLBrowser*" -or $_.DisplayName -like "*SQL Server Browser*"}
if ($browser) {
    $status = if ($browser.Status -eq "Running") { "✅ Đang chạy" } else { "❌ Dừng" }
    $color = if ($browser.Status -eq "Running") { "Green" } else { "Red" }
    Write-Host "   $status - $($browser.DisplayName)" -ForegroundColor $color
} else {
    Write-Host "   ⚠️  Không tìm thấy SQL Server Browser (có thể không cần thiết)" -ForegroundColor Yellow
}
Write-Host ""

# 4. Kiểm tra Firewall
Write-Host "4. Kiểm tra Firewall Rules cho port 1433:" -ForegroundColor Yellow
$firewallRule = Get-NetFirewallRule | Where-Object {$_.DisplayName -like "*1433*" -or $_.DisplayName -like "*SQL*"} | Select-Object -First 1
if ($firewallRule) {
    Write-Host "   ✅ Tìm thấy firewall rule: $($firewallRule.DisplayName)" -ForegroundColor Green
    Write-Host "   Enabled: $($firewallRule.Enabled)" -ForegroundColor Cyan
    Write-Host "   Direction: $($firewallRule.Direction)" -ForegroundColor Cyan
} else {
    Write-Host "   ⚠️  Không tìm thấy firewall rule cho port 1433" -ForegroundColor Yellow
    Write-Host "   → Có thể cần tạo rule mới hoặc tạm thời tắt firewall để test" -ForegroundColor Yellow
}
Write-Host ""

# 5. Thử kết nối bằng Test-NetConnection
Write-Host "5. Test kết nối TCP đến localhost:1433:" -ForegroundColor Yellow
$test = Test-NetConnection -ComputerName localhost -Port 1433 -WarningAction SilentlyContinue
if ($test.TcpTestSucceeded) {
    Write-Host "   ✅ Kết nối TCP thành công!" -ForegroundColor Green
} else {
    Write-Host "   ❌ Không thể kết nối TCP đến port 1433" -ForegroundColor Red
    Write-Host "   → SQL Server có thể chưa được khởi động hoặc TCP/IP chưa được bật" -ForegroundColor Yellow
}
Write-Host ""

# 6. Hướng dẫn
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "HƯỚNG DẪN KHẮC PHỤC" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Nếu SQL Server Service chưa chạy:" -ForegroundColor Yellow
Write-Host "1. Mở Services (Win + R → services.msc)" -ForegroundColor White
Write-Host "2. Tìm 'SQL Server (MSSQLSERVER)' hoặc 'SQL Server (SQLEXPRESS)'" -ForegroundColor White
Write-Host "3. Click chuột phải → Start" -ForegroundColor White
Write-Host ""
Write-Host "Hoặc dùng lệnh PowerShell:" -ForegroundColor Yellow
Write-Host "   Start-Service -Name 'MSSQLSERVER'" -ForegroundColor Cyan
Write-Host "   hoặc" -ForegroundColor White
Write-Host "   Start-Service -Name 'MSSQL`$SQLEXPRESS'" -ForegroundColor Cyan
Write-Host ""
Write-Host "Nếu TCP/IP chưa được bật:" -ForegroundColor Yellow
Write-Host "1. Mở SQL Server Configuration Manager" -ForegroundColor White
Write-Host "2. SQL Server Network Configuration → Protocols for MSSQLSERVER" -ForegroundColor White
Write-Host "3. Click chuột phải TCP/IP → Enable" -ForegroundColor White
Write-Host "4. Click chuột phải TCP/IP → Properties → IP Addresses" -ForegroundColor White
Write-Host "5. Scroll xuống IPAll → TCP Port = 1433" -ForegroundColor White
Write-Host "6. Restart SQL Server Service" -ForegroundColor White
Write-Host ""
Write-Host "Để test kết nối, truy cập:" -ForegroundColor Yellow
Write-Host "   http://localhost:8080/DigitalLibrary/test-connection" -ForegroundColor Cyan
Write-Host ""
