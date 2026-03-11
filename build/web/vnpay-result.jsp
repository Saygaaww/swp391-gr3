<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<%@include file="/includes/header.jsp"%>
<%@include file="/includes/navbar.jsp"%>
<div class="bg-light" style="min-height: 80vh;">
<div class="container py-5">
    <div class="card shadow">
        <div class="card-body text-center p-5">
            <% if (Boolean.TRUE.equals(request.getAttribute("success"))) { %>
                <h2 class="text-success mb-3">Thanh toán thành công</h2>
                <p class="text-muted">${message}</p>
                <a href="<%= ctx %>/customer/orders" class="btn btn-primary mt-3">Xem đơn hàng</a>
            <% } else { %>
                <h2 class="text-danger mb-3">Thanh toán thất bại</h2>
                <p class="text-muted">${message}</p>
                <a href="<%= ctx %>/customer/cart" class="btn btn-outline-secondary mt-3">Quay lại giỏ hàng</a>
            <% } %>
            <a href="<%= ctx %>/customer/home" class="btn btn-outline-primary mt-3">Về trang chủ</a>
        </div>
    </div>
</div>
</div>
<%@include file="/includes/footer.jsp"%>
