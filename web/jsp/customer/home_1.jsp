<%--
    User (Reader) Dashboard - Giao diện theo theme đen/trắng
--%>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>
<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null || !"USER".equalsIgnoreCase(user.getRoleName() != null ? user.getRoleName() : "")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>
<style>
    .user-home {
        background: #fff;
        min-height: 100vh;
        color: #333;
    }
    .user-home .card {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        box-shadow: 0 1px 4px rgba(0,0,0,0.08);
        transition: box-shadow 0.2s;
    }
    .user-home .card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.12);
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
<%@include file="/includes/navbar.jsp"%>

<div class="user-home">
    <div class="container py-5">
        <h1 class="mb-1 fw-bold">Welcome to Digital Library</h1>
        <p class="text-muted mb-4">Hello, <b><%= user.getFullName() != null ? user.getFullName() : "Reader"%></b></p>

        <!-- Sách & Tìm kiếm -->
        <h5 class="text-uppercase text-muted mb-3">Sách & Tìm kiếm</h5>
        <div class="row g-3 mb-5">
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Browse Books</h5>
                    <p class="text-muted small mb-3">Duyệt danh mục sách, phân trang và lọc nhanh</p>
                    <a href="<%= ctx%>/customer/browse-books" class="btn btn-card w-100">View Books</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Search & Filter</h5>
                    <p class="text-muted small mb-3">Tìm theo tiêu đề, tác giả, từ khóa, ISBN</p>
                    <a href="<%= ctx%>/customer/browse-books" class="btn btn-card w-100">Search</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">My Library</h5>
                    <p class="text-muted small mb-3">Sách bạn sở hữu vĩnh viễn, mở đọc</p>
                    <a href="<%= ctx%>/customer/my-library" class="btn btn-card w-100">My Books</a>
                </div>
            </div>
        </div>

        <!-- Mượn sách -->
        <h5 class="text-uppercase text-muted mb-3">Mượn sách</h5>
        <div class="row g-3 mb-5">
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Borrowed Items</h5>
                    <p class="text-muted small mb-3">Sách đang mượn, ngày hết hạn</p>
                    <a href="<%= ctx%>/customer/borrowed-items" class="btn btn-card w-100">My Borrows</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Borrow Request</h5>
                    <p class="text-muted small mb-3">Tạo yêu cầu mượn sách mới</p>
                    <a href="<%= ctx%>/customer/borrow-request" class="btn btn-card w-100">Request</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Request Status</h5>
                    <p class="text-muted small mb-3">Trạng thái yêu cầu mượn</p>
                    <a href="<%= ctx%>/customer/borrow-requests" class="btn btn-card w-100">Status</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Reservation</h5>
                    <p class="text-muted small mb-3">Đặt chỗ khi hết bản</p>
                    <a href="<%= ctx%>/customer/reservations" class="btn btn-card w-100">Reserve</a>
                </div>
            </div>
        </div>

        <!-- Mua sách & Đơn hàng -->
        <h5 class="text-uppercase text-muted mb-3">Mua sách & Đơn hàng</h5>
        <div class="row g-3 mb-5">
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Cart</h5>
                    <p class="text-muted small mb-3">Giỏ hàng, cập nhật số lượng</p>
                    <a href="<%= ctx%>/customer/cart" class="btn btn-card w-100">View Cart</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Checkout</h5>
                    <p class="text-muted small mb-3">Xác nhận đơn, thanh toán</p>
                    <a href="<%= ctx%>/customer/checkout" class="btn btn-card w-100">Checkout</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Order History</h5>
                    <p class="text-muted small mb-3">Lịch sử đơn hàng, trạng thái</p>
                    <a href="<%= ctx%>/customer/orders" class="btn btn-card w-100">Orders</a>
                </div>
            </div>
        </div>

        <!-- Đọc & Đánh dấu -->
        <h5 class="text-uppercase text-muted mb-3">Đọc & Đánh dấu</h5>
        <div class="row g-3 mb-5">
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Reading History</h5>
                    <p class="text-muted small mb-3">Tiến độ đọc, vị trí cuối</p>
                    <a href="<%= ctx%>/customer/reading-history" class="btn btn-card w-100">History</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Bookmarks</h5>
                    <p class="text-muted small mb-3">Đánh dấu trang, ghi chú</p>
                    <a href="<%= ctx%>/customer/bookmarks" class="btn btn-card w-100">Bookmarks</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Review & Rating</h5>
                    <p class="text-muted small mb-3">Đánh giá và nhận xét sách</p>
                    <a href="<%= ctx%>/customer/reviews" class="btn btn-card w-100">Reviews</a>
                </div>
            </div>
        </div>

        <!-- Tài khoản & Khác -->
        <h5 class="text-uppercase text-muted mb-3">Tài khoản</h5>
        <div class="row g-3 mb-5">
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Edit Profile</h5>
                    <p class="text-muted small mb-3">Cập nhật thông tin cá nhân</p>
                    <a href="<%= ctx%>/customer/profile" class="btn btn-card w-100">Profile</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Change Password</h5>
                    <p class="text-muted small mb-3">Đổi mật khẩu bảo mật</p>
                    <a href="<%= ctx%>/customer/change-password" class="btn btn-card w-100">Password</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Linked Accounts</h5>
                    <p class="text-muted small mb-3">Google, Facebook đã liên kết</p>
                    <a href="<%= ctx%>/customer/linked-accounts" class="btn btn-card w-100">Accounts</a>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Notifications</h5>
                    <p class="text-muted small mb-3">Thông báo, nhắc nhở</p>
                    <a href="<%= ctx%>/customer/notifications" class="btn btn-card w-100">Inbox</a>
                </div>
            </div>
        </div>

        <!-- Phạt & Gia hạn -->
        <h5 class="text-uppercase text-muted mb-3">Phạt & Gia hạn</h5>
        <div class="row g-3 mb-5">
            <div class="col-md-6">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Fine Summary</h5>
                    <p class="text-muted small mb-3">Tổng hợp phạt trả muộn</p>
                    <a href="<%= ctx%>/customer/fines" class="btn btn-card w-100">View Fines</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card p-4 h-100">
                    <h5 class="fw-bold">Extend Request</h5>
                    <p class="text-muted small mb-3">Gia hạn mượn sách</p>
                    <a href="<%= ctx%>/customer/extend-requests" class="btn btn-card w-100">Extend</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
