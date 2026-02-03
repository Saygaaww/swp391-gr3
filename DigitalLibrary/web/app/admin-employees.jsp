<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý nhân viên - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý nhân viên (Mock - Admin)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Họ tên</th><th>Email</th><th>Vai trò</th><th></th></tr></thead>
                <tbody>
                <% List<Employee> eList = (List<Employee>)request.getAttribute("employees"); if (eList == null) eList = java.util.Collections.emptyList();
                for (Employee e : eList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= e.getEmployeeId() %></td>
                    <td><%= e.getFullName() %></td>
                    <td><%= e.getEmail() %></td>
                    <td><%= e.getRole() != null ? e.getRole().getRoleName() : "-" %></td>
                    <td><a href="#">Sửa</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
