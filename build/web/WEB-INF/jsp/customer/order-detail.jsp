<%-- Order Detail - Chi tiết đơn hàng --%>
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
                                    <c:if test="${empty order}">
                                        <p class="text-muted">Không tìm thấy đơn hàng.</p>
                                        <a href="<%= ctx %>/customer/orders" class="btn btn-card">← Quay lại đơn
                                            hàng</a>
                                    </c:if>

                                    <c:if test="${not empty order}">
                                        <h2 class="fw-bold mb-4">Chi tiết đơn hàng #${order.orderId}</h2>

                                        <div class="card mb-4">
                                            <div class="card-body">
                                                <div class="row mb-2">
                                                    <div class="col-md-6"><strong>Ngày đặt:</strong> ${order.createdAt}
                                                    </div>
                                                    <div class="col-md-6"><strong>Trạng thái:</strong> <span
                                                            class="badge bg-secondary">${order.status}</span></div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-md-6"><strong>Người nhận:</strong>
                                                        ${order.readerName}</div>
                                                    <div class="col-md-6"><strong>Email:</strong> ${order.readerEmail}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card mb-4">
                                            <div class="card-header fw-bold">Sản phẩm</div>
                                            <div class="card-body p-0">
                                                <table class="table table-hover mb-0">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Sách</th>
                                                            <th class="text-center">Số lượng</th>
                                                            <th class="text-end">Đơn giá</th>
                                                            <th class="text-end">Thành tiền</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach items="${order.orderBooks}" var="ob">
                                                            <tr>
                                                                <td>
                                                                    <div class="d-flex align-items-center">
                                                                        <c:if test="${not empty ob.bookCoverUrl}">
                                                                            <img src="${ob.bookCoverUrl}" alt=""
                                                                                class="rounded me-2"
                                                                                style="width:48px;height:64px;object-fit:cover;">
                                                                        </c:if>
                                                                        <div>
                                                                            <strong>${ob.bookTitle}</strong>
                                                                            <c:if test="${not empty ob.authorName}">
                                                                                <br><span
                                                                                    class="text-muted small">${ob.authorName}</span>
                                                                            </c:if>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td class="text-center">${ob.quantity}</td>
                                                                <td class="text-end">
                                                                    <fmt:formatNumber value="${ob.price}"
                                                                        type="currency" currencySymbol="₫" />
                                                                </td>
                                                                <td class="text-end">
                                                                    <fmt:formatNumber value="${ob.subtotal}"
                                                                        type="currency" currencySymbol="₫" />
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <div class="card-footer text-end">
                                                <strong>Tổng cộng:
                                                    <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                        currencySymbol="₫" />
                                                </strong>
                                            </div>
                                        </div>

                                        <c:if test="${not empty payment}">
                                            <div class="card mb-4">
                                                <div class="card-header fw-bold">Thanh toán</div>
                                                <div class="card-body">
                                                    <p class="mb-1"><strong>Phương thức:</strong>
                                                        ${payment.paymentMethod}</p>
                                                    <p class="mb-1"><strong>Trạng thái:</strong>
                                                        ${payment.paymentStatus}</p>
                                                    <c:if test="${not empty payment.transactionCode}">
                                                        <p class="mb-1"><strong>Mã giao dịch:</strong>
                                                            ${payment.transactionCode}</p>
                                                    </c:if>
                                                    <c:if test="${not empty payment.paidAt}">
                                                        <p class="mb-0"><strong>Thanh toán lúc:</strong>
                                                            ${payment.paidAt}</p>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>

                                        <a href="<%= ctx %>/customer/orders" class="btn btn-card">← Quay lại đơn
                                            hàng</a>
                                    </c:if>
                                </div>
                            </div>
                            <%@include file="/includes/footer.jsp" %>