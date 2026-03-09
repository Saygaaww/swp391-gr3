<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Employee" %>
<%
    Employee user = (Employee) session.getAttribute("employee");
    if (user == null || !"SELLER".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Seller Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark px-4">
        <span class="navbar-brand">Seller - <%= user.getFullName() %></span>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Dang xuat</a>
    </nav>
    <div class="container my-5">
        <h2>Seller Dashboard</h2>
        <p>Chao, <b><%= user.getFullName() %></b></p>
        <p>Chuc nang dang phat trien.</p>
    </div>
</body>
</html>