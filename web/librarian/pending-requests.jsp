<%--
    Document   : pending-requests
    Librarian: view pending borrow requests, approve or reject
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.BorrowRequest"%>
<%@page import="model.BorrowRequestItem"%>
<%@page import="java.util.List"%>
<%@page import="util.VnDisplayUtil"%>
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
    <h2 class="mb-4">Yêu cầu mượn sách chờ duyệt</h2>
    <% if ("approved".equals(success)) { %>
        <div class="alert alert-success">Đã duyệt yêu cầu mượn sách.</div>
    <% } %>
    <% if ("rejected".equals(success)) { %>
        <div class="alert alert-info">Đã từ chối yêu cầu mượn sách.</div>
    <% } %>
    <% if ("approve_failed".equals(error)) { %>
        <div class="alert alert-danger">Duyệt thất bại (có thể không đủ bản sách).</div>
    <% } %>
    <% if ("reject_failed".equals(error)) { %>
        <div class="alert alert-danger">Từ chối thất bại.</div>
    <% } %>
    <% if ("invalid_borrow_date".equals(error)) { %>
        <div class="alert alert-warning">Ngày bắt đầu mượn không hợp lệ. Không được chọn ngày quá 1 ngày trong quá khứ.</div>
    <% } %>

    <% if (pending.isEmpty()) { %>
        <div class="alert alert-info">Không có yêu cầu chờ duyệt.</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered">
                <thead class="table-light">
                    <tr>
                        <th>Mã yêu cầu</th>
                        <th>Người mượn</th>
                        <th>Email</th>
                        <th>Ngày yêu cầu</th>
                        <th>Sách</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BorrowRequest req : pending) { %>
                    <tr>
                        <td><%= req.getRequestId() %></td>
                        <td><%= req.getReaderName() != null ? req.getReaderName() : "" %></td>
                        <td><%= req.getReaderEmail() != null ? req.getReaderEmail() : "" %></td>
                        <td><%= VnDisplayUtil.formatDateTime(req.getRequestedAt()) %></td>
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
                                    <div class="d-flex flex-column gap-1 mb-1">
                                        <label class="small text-muted mb-0">Từ ngày (trống = hôm nay)</label>
                                        <input type="datetime-local" name="borrow_from" class="form-control form-control-sm" style="min-width: 180px;">
                                    </div>
                                    <div class="d-flex flex-column gap-1 mb-1">
                                        <label class="small text-muted mb-0">Đến ngày / hạn trả (trống = +1 tuần)</label>
                                        <input type="datetime-local" name="due_date" class="form-control form-control-sm" style="min-width: 180px;">
                                    </div>
                                    <button type="submit" class="btn btn-success btn-sm mt-1">Duyệt</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/RejectBorrowServlet" method="post" class="d-inline d-flex gap-1 align-items-center">
                                    <input type="hidden" name="request_id" value="<%= req.getRequestId() %>">
                                    <input type="text" name="decision_note" placeholder="Lý do từ chối (tùy chọn)" class="form-control form-control-sm" style="max-width: 180px;">
                                    <button type="submit" class="btn btn-danger btn-sm">Từ chối</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
    <a href="<%= request.getContextPath() %>/librarian/home.jsp" class="btn btn-outline-dark">Về trang thủ thư</a>
</div>

<%@include file="/includes/footer.jsp"%>
