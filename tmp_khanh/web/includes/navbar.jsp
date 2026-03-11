<%--
    Navbar: Home / Logo → /home (trang chung có nút quay dashboard) nếu đã đăng nhập, không thì trang chủ công khai
--%>
<%
    String homeUrl = request.getContextPath() + "/";
    if (session != null) {
        if (session.getAttribute("user") != null) {
            homeUrl = request.getContextPath() + "/customer/home";
        } else if (session.getAttribute("employee") != null) {
            homeUrl = request.getContextPath() + "/home";
        }
    }
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-black sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="<%= homeUrl %>">
            <i class="fa fa-book"></i> LIBRARIA
        </a>

        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div id="menu" class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="<%= homeUrl %>">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/customer/browse-books">Books & Media</a></li>
                <% if (session != null && session.getAttribute("user") != null) { %>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/customer/cart">Cart</a></li>
                <% } %>
                <li class="nav-item"><a class="nav-link" href="#">News</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
                <li class="nav-item"><a class="nav-link" href="<%= request.getContextPath() %>/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
