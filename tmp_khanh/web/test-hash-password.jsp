<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="util.PasswordUtil" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Password Hash</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
        }
        .form-group {
            margin: 20px 0;
        }
        label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }
        input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 2px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        button {
            background: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #0056b3;
        }
        .result {
            margin-top: 20px;
            padding: 15px;
            background: #e7f3ff;
            border: 2px solid #007bff;
            border-radius: 4px;
        }
        .hash {
            font-family: monospace;
            font-size: 14px;
            word-break: break-all;
            background: #f8f9fa;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
        }
        .credentials {
            background: #fff3cd;
            border: 2px solid #ffc107;
            padding: 15px;
            border-radius: 4px;
            margin: 20px 0;
        }
        .credentials h3 {
            margin-top: 0;
            color: #856404;
        }
        .cred-item {
            margin: 10px 0;
            padding: 10px;
            background: white;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔐 Test Password Hash Generator</h1>
        
        <div class="credentials">
            <h3>📋 Thông Tin Đăng Nhập Employee</h3>
            <div class="cred-item">
                <strong>ADMIN:</strong><br>
                Email: admin@library.com<br>
                Password: admin123<br>
                Hash: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
            </div>
            <div class="cred-item">
                <strong>LIBRARIAN:</strong><br>
                Email: librarian@library.com<br>
                Password: librarian123<br>
                Hash: a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
            </div>
            <div class="cred-item">
                <strong>SELLER:</strong><br>
                Email: seller@library.com<br>
                Password: seller123<br>
                Hash: e606e38b0d8c19b24cf0ee3808183162ea7cd63ff7912dbb22b5e803286b4446
            </div>
        </div>

        <form method="post">
            <div class="form-group">
                <label for="password">Nhập mật khẩu để tạo hash:</label>
                <input type="text" id="password" name="password" 
                       placeholder="Ví dụ: admin123" required>
            </div>
            <button type="submit">Generate Hash</button>
        </form>

        <%
            String password = request.getParameter("password");
            if (password != null && !password.isEmpty()) {
                String hash = PasswordUtil.hash(password);
        %>
        <div class="result">
            <strong>Password:</strong> <%= password %><br>
            <strong>Hash (SHA-256):</strong>
            <div class="hash"><%= hash %></div>
        </div>
        <%
            }
        %>

        <div style="margin-top: 30px; padding: 15px; background: #d4edda; border: 2px solid #28a745; border-radius: 4px;">
            <h3 style="margin-top: 0; color: #155724;">✅ Cách Sử Dụng:</h3>
            <ol>
                <li>Chạy file SQL: <code>FIX_EMPLOYEE_PASSWORDS.sql</code></li>
                <li>Hoặc cập nhật database thủ công với hash ở trên</li>
                <li>Đăng nhập tại: <a href="<%= request.getContextPath() %>/employee/login">/employee/login</a></li>
            </ol>
        </div>
    </div>
</body>
</html>
