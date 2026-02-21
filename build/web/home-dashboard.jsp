<%--
    Trang Home chung - hiển thị theo role, có nút quay về dashboard/khu vực riêng
--%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<%@include file="/includes/header.jsp"%>
<%
    Reader user = (Reader) session.getAttribute("user");
    Employee employee = (Employee) session.getAttribute("employee");
    String displayName = "";
    String roleLabel = "";
    String dashboardUrl = request.getContextPath() + "/";

    if (user != null) {
        displayName = user.getFullName() != null ? user.getFullName() : "Reader";
        roleLabel = "Độc giả (USER)";
        dashboardUrl = request.getContextPath() + "/customer/home_1.jsp";
    } else if (employee != null) {
        displayName = employee.getFullName() != null ? employee.getFullName() : "Employee";
        String role = employee.getRoleName() != null ? employee.getRoleName().toUpperCase() : "";
        switch (role) {
            case "ADMIN":
                roleLabel = "Quản trị viên";
                dashboardUrl = request.getContextPath() + "/admin/dashboard";
                break;
            case "LIBRARIAN":
                roleLabel = "Thủ thư";
                dashboardUrl = request.getContextPath() + "/librarian/dashboard";
                break;
            case "SELLER":
                roleLabel = "Nhân viên bán hàng";
                dashboardUrl = request.getContextPath() + "/seller/dashboard";
                break;
            default:
                roleLabel = role;
                dashboardUrl = request.getContextPath() + "/";
        }
    }
%>
<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <div class="card shadow p-5 text-center">
        <h2 class="mb-3">Chào mừng, <b><%= displayName %></b></h2>
        <p class="text-muted mb-4"><%= roleLabel %></p>
        <p class="mb-4">Đây là trang Home chung. Bạn có thể quay lại khu vực làm việc của mình.</p>
        <a href="<%= dashboardUrl %>" class="btn btn-dark btn-lg px-5">
            <i class="fas fa-arrow-right me-2"></i>Vào khu vực của tôi
        </a>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
