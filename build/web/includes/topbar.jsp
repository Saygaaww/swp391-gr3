<%-- 
    Document   : topbar
    Created on : Jan 26, 2026, 4:34:09 PM
    Author     : admin
--%>

<div class="bg-dark text-light py-2">
    <div class="container d-flex justify-content-between">
        <div>
            <i class="fa fa-phone"></i> +61-3-8376-6284
            &nbsp;&nbsp;
            <i class="fa fa-envelope"></i> support@libraria.com
        </div>
        <div>
            <%
                model.Reader user = (model.Reader) session.getAttribute("user");
                if (user == null) {
            %>
                <a href="<%=request.getContextPath()%>/auth/login.jsp" class="text-light text-decoration-none me-3">
                    <i class="fa fa-user"></i> Login
                </a>
                <a href="<%=request.getContextPath()%>/auth/register.jsp" class="text-light text-decoration-none">
                    <i class="fa fa-user-plus"></i> Register
                </a>
            <%
                } else {
            %>
                <span class="me-3">
                    <i class="fa fa-user"></i> <%= user.getFullName() %>
                </span>
                <a href="<%=request.getContextPath()%>/LogoutServlet" class="text-light text-decoration-none">
                    <i class="fa fa-sign-out"></i> Logout
                </a>
            <%
                }
            %>
        </div>
    </div>
</div>
