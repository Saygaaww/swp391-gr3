<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mock Login - INTER 1 ONLY</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            padding: 50px;
            max-width: 450px;
            width: 100%;
            animation: slideUp 0.5s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .warning-banner {
            background: linear-gradient(135deg, #ff9800 0%, #ff5722 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
        }
        
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .logo-icon {
            font-size: 50px;
            margin-bottom: 10px;
        }
        
        h1 {
            text-align: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 10px;
            font-size: 32px;
            font-weight: 700;
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        label {
            display: block;
            color: #333;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        select {
            width: 100%;
            padding: 15px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s;
            background: white;
            cursor: pointer;
            color: #333;
        }
        
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        select option {
            padding: 10px;
        }
        
        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-login:active {
            transform: translateY(-1px);
        }
        
        .info-box {
            margin-top: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .info-box h3 {
            color: #333;
            font-size: 14px;
            margin-bottom: 12px;
            font-weight: 700;
        }
        
        .info-box ul {
            list-style: none;
            font-size: 13px;
            color: #555;
        }
        
        .info-box li {
            margin-bottom: 8px;
            padding-left: 25px;
            position: relative;
            line-height: 1.5;
        }
        
        .info-box li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #4caf50;
            font-weight: bold;
            font-size: 16px;
        }
        
        .role-preview {
            margin-top: 15px;
            padding: 15px;
            background: white;
            border-radius: 8px;
            font-size: 13px;
            color: #666;
        }
        
        .role-preview strong {
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="warning-banner">
            ⚠️ MOCK LOGIN - CHỈ DÙNG CHO INTER 1 - DEMO CHO THẦY
        </div>
        
        <div class="logo">
            <div class="logo-icon">📚</div>
            <h1>Digital Library</h1>
            <p class="subtitle">Hệ thống thư viện số - Phần Admin</p>
        </div>
        
        <form action="${pageContext.request.contextPath}/mock-login" method="post">
            <div class="form-group">
                <label for="role">🔑 Chọn vai trò để test:</label>
                <select id="role" name="role" required>
                    <option value="">-- Chọn role để đăng nhập --</option>
                    <option value="admin" selected>👨‍💼 Admin - Quản trị viên hệ thống</option>
                    <option value="librarian">📖 Librarian - Thủ thư (quản lý mượn sách)</option>
                    <option value="seller">💰 Seller - Nhân viên bán hàng</option>
                </select>
            </div>
            
            <button type="submit" class="btn-login">
                🚀 Đăng nhập ngay (Mock)
            </button>
            
            <div class="role-preview">
                <strong>💡 Sau khi login:</strong> Bạn sẽ được chuyển đến trang Admin Book List
            </div>
        </form>
        
        <div class="info-box">
            <h3>📌 Lưu ý khi demo cho thầy:</h3>
            <ul>
                <li>Đây là <strong>login giả</strong> chỉ dùng cho Inter 1</li>
                <li>Không cần username/password (để test nhanh)</li>
                <li>Sẽ thay bằng <strong>login thật</strong> ở Inter 2</li>
                <li>Member A đang làm authentication (Google OAuth)</li>
                <li>Dễ dàng ghép code sau (chỉ thay 1 chỗ)</li>
            </ul>
        </div>
    </div>
    
    <script>
        // Hiển thị thông tin role khi chọn
        document.getElementById('role').addEventListener('change', function() {
            const roleInfo = {
                'admin': 'Quyền: Quản lý toàn bộ hệ thống, CRUD sách, duyệt mượn sách, quản lý user',
                'librarian': 'Quyền: Quản lý mượn/trả sách, duyệt yêu cầu mượn, quản lý phạt',
                'seller': 'Quyền: Quản lý đơn hàng, thanh toán, xem báo cáo bán hàng'
            };
            
            const preview = document.querySelector('.role-preview');
            if (this.value) {
                preview.innerHTML = '<strong>💡 ' + this.options[this.selectedIndex].text + ':</strong> ' + roleInfo[this.value];
            } else {
                preview.innerHTML = '<strong>💡 Sau khi login:</strong> Bạn sẽ được chuyển đến trang Admin Book List';
            }
        });
    </script>
</body>
</html>
