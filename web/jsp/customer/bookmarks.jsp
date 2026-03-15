<%-- Bookmark Management - Tạo/xem/xóa bookmark theo trang và ghi chú --%>
    <%@ page language="java" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                                <h2 class="fw-bold mb-4">Bookmark Management</h2>
                                <p class="text-muted">Đánh dấu trang và ghi chú cho sách bạn sở hữu.</p>

                                <c:if test="${not empty bookmarkError}">
                                    <div class="alert alert-danger">${bookmarkError}</div>
                                    <% session.removeAttribute("bookmarkError"); %>
                                </c:if>

                                <c:if test="${not empty ownedBooks}">
                                    <div class="card mb-4">
                                        <div class="card-header fw-bold">Thêm bookmark</div>
                                        <div class="card-body">
                                            <form action="<%= ctx %>/customer/bookmarks" method="post"
                                                class="row g-2 align-items-end">
                                                <input type="hidden" name="action" value="create">
                                                <div class="col-md-4">
                                                    <label class="form-label">Sách</label>
                                                    <select name="bookId" class="form-select" required>
                                                        <option value="">-- Chọn sách --</option>
                                                        <c:forEach items="${ownedBooks}" var="ob">
                                                            <option value="${ob.bookId}" ${param.addBookId !=null &&
                                                                param.addBookId==ob.bookId ? 'selected' : '' }>
                                                                ${ob.bookTitle}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-2">
                                                    <label class="form-label">Trang</label>
                                                    <input type="number" name="pageNumber" min="1" class="form-control"
                                                        required placeholder="Số trang">
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label">Ghi chú</label>
                                                    <input type="text" name="note" class="form-control"
                                                        placeholder="Tùy chọn">
                                                </div>
                                                <div class="col-md-2">
                                                    <button type="submit" class="btn btn-card w-100">Thêm</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:if>

                                <h5 class="mt-4">Danh sách bookmark</h5>
                                <c:choose>
                                    <c:when test="${empty bookmarks}">
                                        <p class="text-muted">Chưa có bookmark. Chỉ thêm được với sách bạn đã sở hữu.
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th>Sách</th>
                                                        <th>Trang</th>
                                                        <th>Ghi chú</th>
                                                        <th>Ngày tạo</th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${bookmarks}" var="bm">
                                                        <tr>
                                                            <td>${bm.bookTitle}</td>
                                                            <td>${bm.pageNumber}<c:if
                                                                    test="${bm.bookTotalPages != null}"> /
                                                                    ${bm.bookTotalPages}</c:if>
                                                            </td>
                                                            <td>${bm.note != null ? bm.note : '-'}</td>
                                                            <td>${bm.createdAt}</td>
                                                            <td>
                                                                <form action="<%= ctx %>/customer/bookmarks"
                                                                    method="post" class="d-inline"
                                                                    onsubmit="return confirm('Xóa bookmark này?');">
                                                                    <input type="hidden" name="action" value="delete">
                                                                    <input type="hidden" name="bookmarkId"
                                                                        value="${bm.bookmarkId}">
                                                                    <button type="submit"
                                                                        class="btn btn-outline-danger btn-sm">Xóa</button>
                                                                </form>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <a href="<%= ctx %>/customer/home" class="btn btn-card mt-3">← Trang chủ</a>
                            </div>
                        </div>
                        <%@include file="/includes/footer.jsp" %>