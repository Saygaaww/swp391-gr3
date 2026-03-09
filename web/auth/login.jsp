<%-- 
    Document   : login
    Created on : Jan 26, 2026, 4:35:00 PM
    Author     : admin
--%>

<%@include file="/includes/header.jsp"%>

<style>
    body { background: #f4f5f7; }
    .login-wrapper {
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .login-card {
        width: 420px;
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 24px rgba(0,0,0,0.08);
        padding: 40px 36px;
        border: 1px solid #e8e8e8;
    }
    .login-card h3 {
        text-align: center;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 8px;
    }
    .login-subtitle {
        text-align: center;
        color: #888;
        font-size: 14px;
        margin-bottom: 28px;
    }
    .login-card .form-control {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 12px 14px;
        font-size: 14px;
    }
    .login-card .form-control:focus {
        border-color: #1a1a2e;
        box-shadow: 0 0 0 3px rgba(26,26,46,0.08);
    }
    .btn-login-main {
        background: #1a1a2e;
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 12px;
        font-size: 15px;
        font-weight: 600;
        width: 100%;
        transition: background 0.2s;
    }
    .btn-login-main:hover { background: #2d2d4e; }
    .btn-google {
        background: #fff;
        color: #333;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 12px;
        font-size: 14px;
        font-weight: 600;
        width: 100%;
        transition: all 0.2s;
    }
    .btn-google:hover { background: #f8f8f8; border-color: #bbb; }
    .btn-google i { color: #ea4335; margin-right: 8px; }
    .login-links { font-size: 13px; color: #888; }
    .login-links a { color: #1a1a2e; font-weight: 600; text-decoration: none; }
    .login-links a:hover { text-decoration: underline; }
    .divider { text-align: center; color: #bbb; font-size: 13px; margin: 16px 0; position: relative; }
    .divider::before, .divider::after {
        content: ''; position: absolute; top: 50%; width: 40%; height: 1px; background: #e0e0e0;
    }
    .divider::before { left: 0; }
    .divider::after { right: 0; }
    .home-link {
        display: block;
        text-align: center;
        margin-top: 20px;
        color: #888;
        font-size: 13px;
        text-decoration: none;
    }
    .home-link:hover { color: #1a1a2e; }
    .home-link i { margin-right: 4px; }
</style>

<div class="login-wrapper">
    <div>
        <div class="login-card">
            <h3><i class="fas fa-book-open"></i> Digital Library</h3>
            <p class="login-subtitle">Dang nhap de tiep tuc</p>

            <form action="<%=request.getContextPath()%>/login" method="post">
                <input class="form-control mb-3" type="email" name="email"
                       placeholder="Email" required
                       value="${inputEmail}">

                <input class="form-control mb-3" type="password" name="password"
                       placeholder="Mat khau" required>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger text-center py-2" style="font-size:14px;">
                        ${error}
                    </div>
                </c:if>

                <button type="submit" class="btn-login-main mb-3">
                    <i class="fas fa-sign-in-alt"></i> Dang nhap
                </button>
            </form>

            <div class="d-flex justify-content-between login-links mb-3">
                <a href="<%=request.getContextPath()%>/auth/forgot-password.jsp">Quen mat khau?</a>
                <span>Chua co tai khoan? <a href="<%=request.getContextPath()%>/register">Dang ky</a></span>
            </div>

            <div class="divider">hoac</div>

            <a href="<%=request.getContextPath()%>/google-login" class="btn-google text-center d-block">
                <i class="fab fa-google"></i> Dang nhap voi Google
            </a>
        </div>

        <a href="<%=request.getContextPath()%>/home" class="home-link">
            <i class="fas fa-arrow-left"></i> Quay ve trang chu
        </a>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
