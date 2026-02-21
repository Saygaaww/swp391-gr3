<%-- Edit Profile - Chỉnh sửa thông tin theo theme đen/trắng --%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>
<%
    Reader u = (Reader) session.getAttribute("user");
    if (u == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    String ctx = request.getContextPath();
%>
<style>
    .user-home { background: #fff; min-height: 100vh; color: #333; }
    .user-home .card { border: 1px solid #e0e0e0; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
    .user-home .btn-card { border: 2px solid #000; color: #000; background: #fff; font-weight: 500; }
    .user-home .btn-card:hover { background: #000; color: #fff; }
</style>
<%@include file="/includes/navbar.jsp"%>
<div class="user-home">
<div class="container py-5">
    <h2 class="fw-bold mb-4">Edit Profile</h2>
    <p class="text-muted">Cập nhật thông tin cá nhân.</p>
    <p><b>Họ tên:</b> <%= u.getFullName() %></p>
    <p><b>Email:</b> <%= u.getEmail() %></p>
    <p class="text-muted small">Form chỉnh sửa sẽ được thêm sau.</p>
    <a href="<%= ctx %>/customer/home" class="btn btn-card">← Trang chủ</a>
</div>
</div>
<%@include file="/includes/footer.jsp"%>
