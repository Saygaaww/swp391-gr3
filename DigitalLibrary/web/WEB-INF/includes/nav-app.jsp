<% String ctx = request.getContextPath(); %>
<nav class="navbar">
    <div class="nav-container">
        <div class="nav-logo">
            <a href="<%= ctx %>/" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-book-reader"></i>
                <span>Digital Library</span>
            </a>
        </div>
        <div class="nav-menu">
            <a href="<%= ctx %>/home" class="nav-link">Trang chủ</a>
            <a href="<%= ctx %>/pages/browse" class="nav-link">Duyệt sách</a>
            <a href="<%= ctx %>/pages/my-library" class="nav-link">Tủ sách của tôi</a>
            <a href="<%= ctx %>/pages/cart" class="nav-link"><i class="fas fa-shopping-cart"></i> Giỏ hàng</a>
            <a href="<%= ctx %>/pages/notifications" class="nav-link"><i class="fas fa-bell"></i></a>
            <a href="<%= ctx %>/login" class="btn-login-nav"><i class="fas fa-sign-in-alt"></i> Đăng nhập</a>
        </div>
    </div>
</nav>
