<%--
    Document   : pending-requests
    Librarian: view pending borrow requests, approve or reject
--%>
<%@page import="model.Reader"%>
<%@page import="model.BorrowRequest"%>
<%@page import="model.BorrowRequestItem"%>
<%@page import="java.util.List"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null || !"LIBRARIAN".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    List<BorrowRequest> pending = (List<BorrowRequest>) request.getAttribute("pendingRequests");
    if (pending == null) pending = java.util.Collections.emptyList();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2 class="mb-4">Pending Borrow Requests</h2>
    <% if ("approved".equals(success)) { %>
        <div class="alert alert-success">Borrow request approved.</div>
    <% } %>
    <% if ("rejected".equals(success)) { %>
        <div class="alert alert-info">Borrow request rejected.</div>
    <% } %>
    <% if ("approve_failed".equals(error)) { %>
        <div class="alert alert-danger">Approval failed (possibly not enough copies).</div>
    <% } %>
    <% if ("reject_failed".equals(error)) { %>
        <div class="alert alert-danger">Reject failed.</div>
    <% } %>

    <% if (pending.isEmpty()) { %>
        <div class="alert alert-info">No pending requests.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Request #</th>
                        <th>Borrower</th>
                        <th>Email</th>
                        <th>Requested At</th>
                        <th>Books</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BorrowRequest req : pending) { %>
                    <tr>
                        <td><%= req.getRequestId() %></td>
                        <td><%= req.getReaderName() != null ? req.getReaderName() : "" %></td>
                        <td><%= req.getReaderEmail() != null ? req.getReaderEmail() : "" %></td>
                        <td><%= req.getRequestedAt() != null ? req.getRequestedAt().toString() : "" %></td>
                        <td>
                            <% for (BorrowRequestItem item : req.getItems()) { %>
                                <%= item.getBookTitle() %> (x<%= item.getQuantity() %>)<br>
                            <% } %>
                        </td>
                        <td>
                            <div class="d-flex flex-wrap gap-2 align-items-center">
                                <form action="<%= request.getContextPath() %>/ApproveBorrowServlet" method="post" class="d-inline">
                                    <input type="hidden" name="request_id" value="<%= req.getRequestId() %>">
                                    <input type="hidden" name="decision_note" value="">
                                    <button type="submit" class="btn btn-success btn-sm">Approve</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/RejectBorrowServlet" method="post" class="d-inline d-flex gap-1 align-items-center">
                                    <input type="hidden" name="request_id" value="<%= req.getRequestId() %>">
                                    <input type="text" name="decision_note" placeholder="Rejection reason (optional)" class="form-control form-control-sm" style="max-width: 180px;">
                                    <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
    <a href="<%= request.getContextPath() %>/librarian/home.jsp" class="btn btn-outline-dark">Back to Librarian Home</a>
</div>

<%@include file="/includes/footer.jsp"%>
