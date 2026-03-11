<%-- Trang chủ thủ thư --%>
<%@page pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null || !"LIBRARIAN".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2>Trang quản lý thủ thư</h2>
    <p>Xin chào, <b><%= user.getFullName() %></b></p>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Quản lý sách</h5>
                <p>Thêm / cập nhật sách thư viện</p>
                <a href="#" class="btn btn-primary">Sách</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Yêu cầu mượn sách</h5>
                <p>Duyệt hoặc từ chối yêu cầu mượn</p>
                <a href="<%= request.getContextPath() %>/PendingBorrowRequestsServlet" class="btn btn-primary">Xem yêu cầu</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Báo cáo</h5>
                <p>Thống kê thư viện</p>
                <a href="#" class="btn btn-primary">Báo cáo</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
