<%-- Navbar --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-black sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">
            <i class="fa fa-book"></i> LIBRARIA
        </a>

        <button class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#menu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div id="menu" class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/BookListServlet">Books & Borrow</a></li>
                <% if (session.getAttribute("user") != null && "USER".equals(((model.Reader)session.getAttribute("user")).getRoleName())) { %>
                <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/MyBorrowHistoryServlet">Borrow History</a></li>
                <% } %>
                <li class="nav-item"><a class="nav-link" href="#">News</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
                <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath()%>/LogoutServlet">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>
