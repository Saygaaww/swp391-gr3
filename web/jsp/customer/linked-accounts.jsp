<%-- Linked Accounts - Tài khoản liên kết theo theme đen/trắng --%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@include file="/includes/header.jsp"%>
<% String ctx = request.getContextPath(); %>
<style>
    .user-home { background: #fff; min-height: 100vh; color: #333; }
    .user-home .card { border: 1px solid #e0e0e0; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
    .user-home .btn-card { border: 2px solid #000; color: #000; background: #fff; font-weight: 500; }
    .user-home .btn-card:hover { background: #000; color: #fff; }
</style>
<%@include file="/includes/navbar.jsp"%>
<div class="user-home">
<div class="container py-5">
    <h2 class="fw-bold mb-4">Linked Accounts</h2>
    <p class="text-muted">Tài khoản Google đã liên kết.</p>
    <p class="text-muted small">Chưa liên kết tài khoản ngoài.</p>
    <a href="<%= ctx %>/customer/home" class="btn btn-card">← Trang chủ</a>
</div>
</div>
<%@include file="/includes/footer.jsp"%>
