<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="login-container">
        <div class="login-wrapper">
            <div class="login-left">
                <div class="login-content">
                    <div class="logo">
                        <a href="<%= request.getContextPath() %>/" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; align-items: center; gap: 10px;">
                            <i class="fas fa-book-reader"></i>
                            <h1>Digital Library</h1>
                        </a>
                    </div>
                    <p class="subtitle">Chào mừng bạn trở lại!</p>
                    <p class="description">Đăng nhập để truy cập vào thư viện số của chúng tôi</p>
                </div>
            </div>
            
            <div class="login-right">
                <div class="login-form-container">
                    <h2>Đăng Nhập</h2>
                    
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    
                    <% if (request.getAttribute("success") != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <%= request.getAttribute("success") %>
                        </div>
                    <% } %>
                    
                    <form id="loginForm" method="POST" action="<%= request.getContextPath() %>/login">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i>
                                Email
                            </label>
                            <input 
                                type="email" 
                                id="email" 
                                name="email" 
                                placeholder="Nhập email của bạn"
                                required
                                autocomplete="email"
                            >
                            <span class="error-message" id="emailError"></span>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i>
                                Mật khẩu
                            </label>
                            <div class="password-input-wrapper">
                                <input 
                                    type="password" 
                                    id="password" 
                                    name="password" 
                                    placeholder="Nhập mật khẩu"
                                    required
                                    autocomplete="current-password"
                                >
                                <button type="button" class="toggle-password" id="togglePassword">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                            <span class="error-message" id="passwordError"></span>
                        </div>
                        
                        <div class="form-options">
                            <label class="remember-me">
                                <input type="checkbox" name="remember" id="remember">
                                <span>Ghi nhớ đăng nhập</span>
                            </label>
                            <a href="<%= request.getContextPath() %>/pages/forgot-password" class="forgot-password">Quên mật khẩu?</a>
                        </div>
                        
                        <button type="submit" class="btn-login">
                            <i class="fas fa-sign-in-alt"></i>
                            Đăng Nhập
                        </button>
                    </form>
                    
                    <div class="divider">
                        <span>Hoặc</span>
                    </div>
                    
                    <a href="<%= request.getAttribute("googleAuthUrl") != null ? request.getAttribute("googleAuthUrl") : "#" %>" 
                       class="btn-google" id="googleLoginBtn">
                        <i class="fab fa-google"></i>
                        Đăng nhập bằng Google
                    </a>
                    
                    <div class="register-link">
                        <p>Chưa có tài khoản? <a href="<%= request.getContextPath() %>/pages/register">Đăng ký ngay</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="<%= request.getContextPath() %>/js/login.js"></script>
</body>
</html>
