<%-- Cart hÃ ng - theme den/trang --%>
    <%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@include file="/includes/header.jsp" %>
                    <% String ctx=request.getContextPath(); %>
                        <style>
                            .user-home {
                                background: #fff;
                                min-height: 100vh;
                                color: #333;
                            }

                            .user-home .card {
                                border: 1px solid #e0e0e0;
                                border-radius: 8px;
                                box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
                            }

                            .user-home .btn-card {
                                border: 2px solid #000;
                                color: #000;
                                background: #fff;
                                font-weight: 500;
                            }

                            .user-home .btn-card:hover {
                                background: #000;
                                color: #fff;
                            }
                        </style>
                        <%@include file="/includes/navbar.jsp" %>

                            <div class="user-home">
                                <div class="container py-5">
                                    <h2 class="fw-bold mb-4">Cart</h2>

                                    <c:if test="${not empty cartMessage}">
                                        <div class="alert alert-success">${cartMessage}</div>
                                        <% session.removeAttribute("cartMessage"); %>
                                    </c:if>
                                    <c:if test="${not empty cartError}">
                                        <div class="alert alert-danger">${cartError}</div>
                                        <% session.removeAttribute("cartError"); %>
                                    </c:if>

                                    <c:choose>
                                        <c:when test="${empty cart || empty cart.items}">
                                            <p class="text-muted">Giỏ hàng của bạn đang trống.</p>
                                            <!-- Nút xem lịch sử đơn hàng -->
                                            <a href="<%= ctx %>/customer/orders" class="btn btn-card me-2">Xem đơn hàng</a>
                                            <!-- Nút quay lại trang mua sách -->
                                            <a href="<%= ctx %>/books" class="btn btn-outline-secondary">Mua sách</a>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Sách</th>
                                                            <th>Giá</th>
                                                            <th>Số Lượng</th>
                                                            <th>Thành Tiền</th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${cart.items}" var="item">
                                                            <tr>
                                                                <td>
                                                                    <strong>${item.bookTitle}</strong>
                                                                    <c:if test="${not empty item.authorName}">
                                                                        <br><small
                                                                            class="text-muted">${item.authorName}</small>
                                                                    </c:if>
                                                                    <br><small class="text-secondary">Còn
                                                                        ${item.availableStock} cuốn</small>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${item.unitPrice}"
                                                                        type="currency" currencySymbol="₫" />
                                                                </td>
                                                                <td>
                                                                    <form action="<%= ctx %>/customer/cart/update"
                                                                        method="post" class="d-inline">
                                                                        <input type="hidden" name="cartItemId"
                                                                            value="${item.cartItemId}">
                                                                        <input type="number" name="quantity"
                                                                            value="${item.quantity}" min="1"
                                                                            max="${item.availableStock}"
                                                                            class="form-control form-control-sm"
                                                                            style="width:70px"
                                                                            onchange="this.form.submit()">
                                                                    </form>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatNumber value="${item.subtotal}"
                                                                        type="currency" currencySymbol="₫" />
                                                                </td>
                                                                <td>
                                                                    <form action="<%= ctx %>/customer/cart/remove"
                                                                        method="post" class="d-inline"
                                                                        onsubmit="return confirm('Xóa Sách Này?')">
                                                                        <input type="hidden" name="cartItemId"
                                                                            value="${item.cartItemId}">
                                                                        <button type="submit"
                                                                            class="btn btn-outline-danger btn-sm">Xóa</button>
                                                                    </form>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mt-3">
                                                <a href="<%= ctx %>/books" class="btn btn-outline-dark">Về Kho
                                                    Sách</a>
                                                <div>
                                                    <strong>Tổng:
                                                        <fmt:formatNumber value="${cartTotal}" type="currency"
                                                            currencySymbol="₫" />
                                                    </strong>
                                                    <a href="<%= ctx %>/customer/checkout"
                                                        class="btn btn-card ms-3">Checkout</a>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <%@include file="/includes/footer.jsp" %>