<%-- Checkout - Thanh toán theo theme đen/trắng --%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <h2 class="fw-bold mb-4">Checkout</h2>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="row">
        <div class="col-md-8">
            <div class="card mb-3">
                <div class="card-header fw-bold">Giỏ hàng</div>
                <div class="card-body">
                    <c:forEach items="${cart.items}" var="item">
                        <div class="d-flex justify-content-between border-bottom py-2">
                            <span>${item.bookTitle} x ${item.quantity}</span>
                            <span><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card">
                <div class="card-header fw-bold">Tổng: <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></div>
                <div class="card-body">
                    <p class="text-muted small">Chọn phương thức thanh toán:</p>
                    <form action="<%= ctx %>/customer/checkout" method="post">
                        <button type="submit" name="paymentMethod" value="cod" class="btn btn-card w-100 mb-2">
                            Thanh toán khi nhận hàng (COD)
                        </button>
                        <button type="submit" name="paymentMethod" value="vnpay" class="btn btn-dark w-100">
                            <img src="https://tse2.mm.bing.net/th/id/OIP.pn3RUm1xk1HiAxWIgC6CIwHaHa?rs=1&pid=ImgDetMain&o=7&rm=3" height="24" alt="VNPay"> Thanh toán VNPay
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <a href="<%= ctx %>/customer/cart" class="btn btn-outline-dark mt-3">← Giỏ Hàng</a>
</div>
</div>
<%@include file="/includes/footer.jsp"%>
