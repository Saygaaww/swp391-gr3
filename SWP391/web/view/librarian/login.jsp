<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng nhập - Thủ thư</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }
            
            .login-container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                padding: 40px;
                width: 100%;
                max-width: 400px;
            }
            
            h1 {
                color: #333;
                margin-bottom: 10px;
                text-align: center;
                font-size: 28px;
            }
            
            .subtitle {
                text-align: center;
                color: #666;
                margin-bottom: 30px;
                font-size: 14px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
            }
            
            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 12px 15px;
                font-size: 16px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                transition: border-color 0.3s;
            }
            
            input[type="email"]:focus,
            input[type="password"]:focus {
                outline: none;
                border-color: #f5576c;
            }
            
            .btn {
                width: 100%;
                padding: 12px;
                font-size: 16px;
                font-weight: 600;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            
            .btn-primary {
                background-color: #f5576c;
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #e0455a;
            }
            
            .error {
                background-color: #fee;
                color: #c33;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #c33;
            }
            
            .links {
                text-align: center;
                margin-top: 20px;
            }
            
            .links a {
                color: #f5576c;
                text-decoration: none;
                margin: 0 10px;
            }
            
            .links a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h1>📚 Đăng nhập</h1>
            <p class="subtitle">Thủ thư</p>
            
            <c:if test="${not empty error}">
                <div class="error">
                    <c:out value="${error}"/>
                </div>
            </c:if>
            
            <form method="post" action="login">
                <input type="hidden" name="userType" value="librarian">
                
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Mật khẩu:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit" class="btn btn-primary">Đăng nhập</button>
            </form>
            
            <div class="links">
                <a href="book">Về trang chủ</a>
                <a href="login">Đăng nhập người đọc</a>
            </div>
        </div>
    </body>
</html>
