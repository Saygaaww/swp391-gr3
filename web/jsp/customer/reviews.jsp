<%-- Review & Rating - Đánh giá sách (1-5 sao), chỉ sách đã sở hữu --%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/includes/header.jsp" %>
<% String ctx = request.getContextPath();%>
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
        <h2 class="fw-bold mb-4">Review & Rating</h2>
        <p class="text-muted">Đánh giá và nhận xét sách bạn đã sở hữu (1–5 sao). Mỗi sách một
            đánh giá.</p>

        <c:if test="${not empty reviewError}">
            <div class="alert alert-danger">${reviewError}</div>
            <% session.removeAttribute("reviewError");%>
        </c:if>

        <c:if test="${not empty ownedBooks}">
            <div class="card mb-4">
                <div class="card-header fw-bold">Thêm / Cập nhật đánh giá</div>
                <div class="card-body">
                    <form action="<%= ctx%>/customer/reviews" method="post"
                          class="row g-2 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label">Sách</label>
                            <select name="bookId" class="form-select" required>
                                <option value="">-- Chọn sách --</option>
                                <c:forEach items="${ownedBooks}" var="ob">
                                    <option value="${ob.bookId}">${ob.bookTitle}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label">Số sao (1-5)</label>
                            <select name="rating" class="form-select" required>
                                <option value="5">5 sao</option>
                                <option value="4">4 sao</option>
                                <option value="3">3 sao</option>
                                <option value="2">2 sao</option>
                                <option value="1">1 sao</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Nhận xét</label>
                            <input type="text" name="comment" class="form-control"
                                   placeholder="Tùy chọn">
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-card w-100">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </c:if>

        <h5 class="mt-4">Đánh giá của tôi</h5>
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="text-muted">Chưa có đánh giá nào.</p>
            </c:when>
            <c:otherwise>
                <div class="list-group">
                    <c:forEach items="${reviews}" var="r">
                        <div class="list-group-item">
                            <strong>${r.bookTitle}</strong>
                            <span class="ms-2">${r.rating} sao</span>
                            <c:if test="${r.comment != null && !r.comment.isEmpty()}">
                                <p class="mb-0 mt-1 text-muted">${r.comment}</p>
                            </c:if>
                            <small class="text-secondary">${r.updatedAt != null ? r.updatedAt :
                                                            r.createdAt}</small>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
        <a href="<%= ctx%>/customer/home" class="btn btn-card mt-3">← Trang chủ</a>
    </div>
</div>
<%@include file="/includes/footer.jsp" %>