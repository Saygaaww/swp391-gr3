<%--
    Document   : my-borrow-history
    Borrow history for user
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.BorrowHistoryItem"%>
<%@page import="java.util.List"%>
<%@page import="util.VnDisplayUtil"%>
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
    String q = (String) request.getAttribute("q");
    if (q == null) q = request.getParameter("q");
    if (q == null) q = "";
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2 class="mb-4">Lịch sử mượn sách</h2>
    <p class="text-muted">Các sách bạn đã mượn hoặc đang mượn. Trả sách tại đây.</p>

    <form class="row g-2 mb-3" method="get" action="<%= request.getContextPath() %>/MyBorrowHistoryServlet">
        <div class="col-sm-9 col-md-10">
            <input class="form-control" type="text" name="q" value="<%= q %>"
                   placeholder="Tìm theo tên sách đã mượn...">
        </div>
        <div class="col-sm-3 col-md-2 d-grid">
            <button class="btn btn-outline-dark" type="submit">Tìm kiếm</button>
        </div>
    </form>
    <% if ("returned".equals(success)) { %>
        <div class="alert alert-success">Đã trả sách thành công.</div>
    <% } %>
    <% if ("return_failed".equals(error)) { %>
        <div class="alert alert-danger">Trả sách thất bại. Có thể sách đã được trả hoặc không thuộc về bạn.</div>
    <% } %>
    <% if ("invalid".equals(error)) { %>
        <div class="alert alert-danger">Yêu cầu không hợp lệ.</div>
    <% } %>

    <% if (history.isEmpty()) { %>
        <div class="alert alert-info">Bạn chưa có lịch sử mượn sách.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Mã mượn</th>
                        <th>Tên sách</th>
                        <th>Số lần mượn</th>
                        <th>Mã bản</th>
                        <th>Ngày mượn</th>
                        <th>Hạn trả</th>
                        <th>Ngày trả</th>
                        <th>Trạng thái</th>
                        <th>Số ngày trễ</th>
                        <th>Tiền phạt</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BorrowHistoryItem item : history) {
                        boolean canReturn = item.getItemStatus() != null
                            && ("borrowed".equalsIgnoreCase(item.getItemStatus()) || "overdue".equalsIgnoreCase(item.getItemStatus()));
                        String statusLabel = VnDisplayUtil.statusBorrowVn(item.getItemStatus() != null ? item.getItemStatus() : item.getBorrowStatus());
                    %>
                    <tr>
                        <td><%= item.getBorrowId() %></td>
                        <td><%= item.getBookTitle() != null ? item.getBookTitle() : "" %></td>
                        <td><%= item.getBorrowCountForBook() > 0 ? item.getBorrowCountForBook() : 1 %></td>
                        <td><%= item.getCopyCode() != null ? item.getCopyCode() : "" %></td>
                        <td><%= VnDisplayUtil.formatDateTime(item.getBorrowDate()) %></td>
                        <td><%= VnDisplayUtil.formatDateTime(item.getDueDate()) %></td>
                        <td><%= item.getReturnedAt() != null ? VnDisplayUtil.formatDateTime(item.getReturnedAt()) : "—" %></td>
                        <td>
                            <span class="badge <%= "returned".equalsIgnoreCase(item.getItemStatus()) ? "bg-success" : "overdue".equalsIgnoreCase(item.getItemStatus()) ? "bg-danger" : "bg-primary" %>">
                                <%= statusLabel %>
                            </span>
                        </td>
                        <td><%= item.getLateDays() > 0 ? item.getLateDays() : 0 %></td>
                        <td><%= item.getLateFee() != null && item.getLateFee().compareTo(java.math.BigDecimal.ZERO) > 0 ? item.getLateFee().toPlainString() : "0" %> đ</td>
                        <td>
                            <% if (canReturn) { %>
                                <form action="<%= request.getContextPath() %>/ReturnBookServlet" method="post" class="d-inline">
                                    <input type="hidden" name="borrow_item_id" value="<%= item.getBorrowItemId() %>">
                                    <button type="submit" class="btn btn-sm btn-outline-primary">Trả sách</button>
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
    <a href="<%= request.getContextPath() %>/customer/home_1.jsp" class="btn btn-outline-dark">Về trang chủ</a>
</div>

<%@include file="/includes/footer.jsp"%>
