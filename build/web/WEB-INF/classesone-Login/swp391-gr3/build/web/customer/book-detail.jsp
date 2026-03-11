<%--
    Document   : book-detail
    Book detail - show book info and "Mượn sách" button
--%>
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
        <div class="alert alert-success">Borrow request sent. The librarian will review and notify you.</div>
    <% } %>
    <% if ("not_enough".equals(error)) { %>
        <div class="alert alert-warning">Not enough copies available. Please try again later or contact the librarian.</div>
    <% } %>
    <% if ("already_requested".equals(error)) { %>
        <div class="alert alert-warning">You have already sent a borrow request for this book. Only one request per book is allowed.</div>
    <% } %>
    <% if ("create_failed".equals(error)) { %>
        <div class="alert alert-danger">Failed to create request. Please try again.</div>
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
                <p class="text-muted">Author: <%= book.getAuthorName() %></p>
            <% } %>
            <% if (book.getCategoryName() != null) { %>
                <p class="text-muted">Category: <%= book.getCategoryName() %></p>
            <% } %>
            <p class="mb-2"><strong>Copies available:</strong> <%= availableCount %></p>
            <% if (book.getSummary() != null && !book.getSummary().isEmpty()) { %>
                <p><%= book.getSummary() %></p>
            <% } %>
            <% if (book.getDescription() != null && !book.getDescription().isEmpty()) { %>
                <div class="mt-3"><%= book.getDescription() %></div>
            <% } %>

            <div class="mt-4">
                <% if ("USER".equals(user.getRoleName())) { %>
                    <% if (hasPendingRequest) { %>
                        <button type="button" class="btn btn-secondary" disabled>Request already sent</button>
                        <p class="small text-muted mt-1">You cannot send multiple requests for the same book.</p>
                    <% } else if (availableCount < 1) { %>
                        <button type="button" class="btn btn-secondary" disabled>Not enough copies</button>
                        <p class="small text-muted mt-1">There are not enough copies available. The librarian will be notified when stock is updated.</p>
                    <% } else { %>
                        <form action="<%= request.getContextPath() %>/RequestBorrowServlet" method="post" class="d-inline">
                            <input type="hidden" name="book_id" value="<%= book.getBookId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-primary">Request to Borrow</button>
                        </form>
                    <% } %>
                <% } %>
                <a href="<%= request.getContextPath() %>/BookListServlet" class="btn btn-outline-dark ms-2">Back to List</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
