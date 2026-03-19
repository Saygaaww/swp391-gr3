<%-- Reading History - Tiến độ đọc, vị trí cuối --%>
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
        <h2 class="fw-bold mb-4">Reading History</h2>
        <p class="text-muted">Tiến độ đọc và vị trí cuối mỗi sách.</p>

        <c:choose>
            <c:when test="${empty historyList}">
                <p class="text-muted">Chưa có lịch sử đọc. Mở sách trong My Library và đọc để
                    lưu tiến độ.</p>
                </c:when>
                <c:otherwise>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Sách</th>
                                <th>Trang đã đọc</th>
                                <th>Tiến độ</th>
                                <th>Đọc lúc</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${historyList}" var="h">
                                <tr>
                                    <td><strong>${h.bookTitle}</strong></td>
                                    <td>${h.lastReadPosition != null ? h.lastReadPosition : 0}
                                        <c:if test="${h.bookTotalPages != null}"> /
                                            ${h.bookTotalPages}</c:if>
                                        </td>
                                        <td>
                                        <c:if test="${h.progressPercent != null}">
                                            ${h.progressPercent}%</c:if>
                                        </td>
                                        <td>${h.lastReadAt}</td>
                                    <td><a href="<%= ctx%>/customer/read?bookId=${h.bookId}"
                                           class="btn btn-outline-dark btn-sm">Tiếp tục đọc</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
        <a href="<%= ctx%>" class="btn btn-card mt-3">← Trang chủ</a>
    </div>
</div>
<%@include file="/includes/footer.jsp" %>