<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Employee" %>
<%
    Employee user = (Employee) session.getAttribute("employee");
    if (user == null || !"LIBRARIAN".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Librarian Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark bg-dark px-4">
        <span class="navbar-brand">Librarian - <%= user.getFullName() %></span>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-light btn-sm">Dang xuat</a>
    </nav>
    <div class="container my-5">
        <h2>Librarian Dashboard</h2>
        <p>Chao, <b><%= user.getFullName() %></b></p>
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card p-4 shadow text-center">
                    <h5>Duyet muon sach</h5>
                    <a href="<%= request.getContextPath() %>/admin/borrow-approve" class="btn btn-primary mt-2">Xem yeu cau</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>