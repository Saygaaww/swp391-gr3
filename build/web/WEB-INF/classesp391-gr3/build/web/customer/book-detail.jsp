<%--
    Document   : book-detail
    Book detail - show book info and "Mượn sách" button
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.Book"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    Book book = (Book) request.getAttribute("book");
    if (book == null) {
        response.sendRedirect(request.getContextPath() + "/BookListServlet");
        return;
    }
    Integer availableCount = (Integer) request.getAttribute("availableCount");
    if (availableCount == null) availableCount = 0;
    Boolean hasPendingRequest = (Boolean) request.getAttribute("hasPendingRequest");
    if (hasPendingRequest == null) hasPendingRequest = false;

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <% if ("request_sent".equals(success)) { %>
        <div class="alert alert-success">Đã gửi yêu cầu mượn sách. Thủ thư sẽ xem xét và thông báo cho bạn.</div>
    <% } %>
    <% if ("not_enough".equals(error)) { %>
        <div class="alert alert-warning">Không đủ bản sách. Vui lòng thử lại sau hoặc liên hệ thủ thư.</div>
    <% } %>
    <% if ("already_requested".equals(error)) { %>
        <div class="alert alert-warning">Bạn đã gửi yêu cầu mượn sách này rồi. Mỗi sách chỉ được gửi một yêu cầu.</div>
    <% } %>
    <% if ("already_borrowing".equals(error)) { %>
        <div class="alert alert-warning">Bạn đang mượn cuốn sách này rồi. Vui lòng trả sách trước khi mượn lại.</div>
    <% } %>
    <% if ("quantity_exceeded".equals(error)) { %>
        <div class="alert alert-warning">Số lượng mượn tối đa mỗi lần là 3 cuốn.</div>
    <% } %>
    <% if ("borrow_limit_exceeded".equals(error)) { %>
        <div class="alert alert-warning">Bạn đang mượn quá số lượng cho phép (tối đa 5 cuốn). Vui lòng trả bớt sách trước.</div>
    <% } %>
    <% if ("create_failed".equals(error)) { %>
        <div class="alert alert-danger">Tạo yêu cầu thất bại. Vui lòng thử lại.</div>
    <% } %>

    <div class="row">
        <div class="col-md-4">
            <% if (book.getCoverUrl() != null && !book.getCoverUrl().isEmpty()) { %>
                <img src="<%= book.getCoverUrl() %>" class="img-fluid rounded shadow" alt="<%= book.getTitle() %>">
            <% } else { %>
                <div class="bg-light rounded d-flex align-items-center justify-content-center shadow" style="height: 350px;">
                    <i class="fa fa-book fa-5x text-secondary"></i>
                </div>
            <% } %>
        </div>
        <div class="col-md-8">
            <h2><%= book.getTitle() %></h2>
            <% if (book.getAuthorName() != null) { %>
                <p class="text-muted">Tác giả: <%= book.getAuthorName() %></p>
            <% } %>
            <% if (book.getCategoryName() != null) { %>
                <p class="text-muted">Thể loại: <%= book.getCategoryName() %></p>
            <% } %>
            <p class="mb-2"><strong>Số bản còn:</strong> <%= availableCount %></p>
            <% if (book.getSummary() != null && !book.getSummary().isEmpty()) { %>
                <p><%= book.getSummary() %></p>
            <% } %>
            <% if (book.getDescription() != null && !book.getDescription().isEmpty()) { %>
                <div class="mt-3"><%= book.getDescription() %></div>
            <% } %>

            <div class="mt-4">
                <% if ("USER".equals(user.getRoleName())) { %>
                    <% if (hasPendingRequest) { %>
                        <button type="button" class="btn btn-secondary" disabled>Đã gửi yêu cầu</button>
                        <p class="small text-muted mt-1">Bạn không thể gửi nhiều yêu cầu cho cùng một cuốn sách.</p>
                    <% } else if (availableCount < 1) { %>
                        <button type="button" class="btn btn-secondary" disabled>Không đủ bản</button>
                        <p class="small text-muted mt-1">Hiện không đủ bản sách. Thủ thư sẽ cập nhật khi có sách trả.</p>
                    <% } else { %>
                        <form action="<%= request.getContextPath() %>/RequestBorrowServlet" method="post" class="d-inline">
                            <input type="hidden" name="book_id" value="<%= book.getBookId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-primary">Gửi yêu cầu mượn</button>
                        </form>
                    <% } %>
                <% } %>
                <a href="<%= request.getContextPath() %>/BookListServlet" class="btn btn-outline-dark ms-2">Về danh sách sách</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
