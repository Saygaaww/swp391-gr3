<%--
    Document   : my-borrow-history
    Borrow history for user
--%>
<%@page import="model.Reader"%>
<%@page import="model.BorrowHistoryItem"%>
<%@page import="java.util.List"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    List<BorrowHistoryItem> history = (List<BorrowHistoryItem>) request.getAttribute("history");
    if (history == null) history = java.util.Collections.emptyList();
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2 class="mb-4">Borrow History</h2>
    <p class="text-muted">All books you have borrowed or are currently borrowing. Return books from here.</p>
    <% if ("returned".equals(success)) { %>
        <div class="alert alert-success">Book returned successfully.</div>
    <% } %>
    <% if ("return_failed".equals(error)) { %>
        <div class="alert alert-danger">Return failed. The item may already be returned or not belong to you.</div>
    <% } %>
    <% if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">Invalid request.</div>
    <% } %>

    <% if (history.isEmpty()) { %>
        <div class="alert alert-info">You have no borrow history yet.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Borrow #</th>
                        <th>Book Title</th>
                        <th>Copy</th>
                        <th>Borrow Date</th>
                        <th>Due Date</th>
                        <th>Returned</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BorrowHistoryItem item : history) {
                        boolean canReturn = item.getItemStatus() != null
                            && ("borrowed".equalsIgnoreCase(item.getItemStatus()) || "overdue".equalsIgnoreCase(item.getItemStatus()));
                    %>
                    <tr>
                        <td><%= item.getBorrowId() %></td>
                        <td><%= item.getBookTitle() != null ? item.getBookTitle() : "" %></td>
                        <td><%= item.getCopyCode() != null ? item.getCopyCode() : "" %></td>
                        <td><%= item.getBorrowDate() != null ? item.getBorrowDate().toString() : "" %></td>
                        <td><%= item.getDueDate() != null ? item.getDueDate().toString() : "" %></td>
                        <td><%= item.getReturnedAt() != null ? item.getReturnedAt().toString() : "—" %></td>
                        <td>
                            <span class="badge <%= "returned".equalsIgnoreCase(item.getItemStatus()) ? "bg-success" : "overdue".equalsIgnoreCase(item.getItemStatus()) ? "bg-danger" : "bg-primary" %>">
                                <%= item.getItemStatus() != null ? item.getItemStatus() : item.getBorrowStatus() %>
                            </span>
                        </td>
                        <td>
                            <% if (canReturn) { %>
                                <form action="<%= request.getContextPath() %>/ReturnBookServlet" method="post" class="d-inline">
                                    <input type="hidden" name="borrow_item_id" value="<%= item.getBorrowItemId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-primary">Return</button>
                                </form>
                            <% } else { %>
                                —
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
    <a href="<%= request.getContextPath() %>/customer/home_1.jsp" class="btn btn-outline-dark">Back to Home</a>
</div>

<%@include file="/includes/footer.jsp"%>
