<%-- Order History - Lịch sử đơn hàng theo theme đen/trắng --%>
    <%@ page language="java" pageEncoding="UTF-8" %>
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
                                    <h2 class="fw-bold mb-4">Order History</h2>

                                    <c:choose>
                                        <c:when test="${empty orders}">
                                            <p class="text-muted">Chưa có đơn hàng nào.</p>
                                            <a href="<%= ctx %>/customer/browse-books" class="btn btn-card">Mua sách</a>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="list-group">
                                                <c:forEach items="${orders}" var="o">
                                                    <div class="list-group-item">
                                                        <div class="d-flex justify-content-between align-items-start">
                                                            <div>
                                                                <strong>#${o.orderId}</strong> - ${o.createdAt}
                                                                <span class="badge bg-secondary ms-2">${o.status}</span>
                                                                <a href="<%= ctx %>/customer/order-detail?orderId=${o.orderId}"
                                                                    class="btn btn-link btn-sm ms-2 p-0">Xem chi
                                                                    tiết</a>
                                                            </div>
                                                            <strong>
                                                                <fmt:formatNumber value="${o.totalAmount}"
                                                                    type="currency" currencySymbol="₫" />
                                                            </strong>
                                                        </div>
                                                        <c:if test="${not empty o.orderBooks}">
                                                            <ul class="mb-0 mt-2 text-muted small">
                                                                <c:forEach items="${o.orderBooks}" var="ob">
                                                                    <li>${ob.bookTitle} x ${ob.quantity}</li>
                                                                </c:forEach>
                                                            </ul>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <a href="<%= ctx %>/customer/home_1.jsp" class="btn btn-outline-dark mt-3">← Trang
                                        chủ</a>
                                </div>
                            </div>
                            <%@include file="/includes/footer.jsp" %>