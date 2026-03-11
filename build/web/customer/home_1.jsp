<%-- Trang chủ độc giả --%>
<%@page pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null || !"USER".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2>Chào mừng đến Thư viện số</h2>
    <p>Xin chào, <b><%= user.getFullName() %></b></p>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-4 shadow text-center">
                <h5>Xem sách</h5>
                <p>Xem chi tiết và gửi yêu cầu mượn</p>
                <a href="<%= request.getContextPath() %>/BookListServlet" class="btn btn-outline-dark">Xem kho sách</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow text-center">
                <h5>Lịch sử mượn</h5>
                <p>Sách bạn đã mượn hoặc đang mượn</p>
                <a href="<%= request.getContextPath() %>/MyBorrowHistoryServlet" class="btn btn-outline-dark">Lịch sử mượn của tôi</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow text-center">
                <h5>Tài khoản</h5>
                <p>Cập nhật thông tin cá nhân</p>
                <a href="#" class="btn btn-outline-dark">Hồ sơ</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
