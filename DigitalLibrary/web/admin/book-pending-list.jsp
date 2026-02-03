<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Sách - Admin</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .panel { background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 4px rgba(0,0,0,0.1); }
        table { width:100%; border-collapse: collapse; }
        th, td { padding:12px; border-bottom:1px solid #e5e7eb; text-align:left; }
        th { background:#f3f4f6; }
        .badge { padding:4px 10px; border-radius:999px; font-size:12px; display:inline-block; }
        .badge-pending { background:#fef3c7; color:#92400e; }
        .btn { padding:8px 12px; border:none; border-radius:6px; cursor:pointer; }
        .btn-approve { background:#10b981; color:#fff; }
        .btn-reject { background:#ef4444; color:#fff; }
        .notes { width:100%; padding:8px; border:1px solid #e5e7eb; border-radius:6px; }
        .row-actions { display:flex; gap:8px; align-items:center; flex-wrap:wrap; }
    </style>
</head>
<body>
<%
    Employee employee = (Employee) session.getAttribute("employee");
    String userRole = (String) session.getAttribute("userRole");
    if (employee == null || userRole == null || !"ADMIN".equals(userRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<Book> books = (List<Book>) request.getAttribute("books");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalBooks = (Integer) request.getAttribute("totalBooks");
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>

<div class="dashboard-container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="<%= request.getContextPath() %>/admin/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-book-reader"></i>
                <h2>Digital Library</h2>
            </a>
        </div>
        <nav class="sidebar-nav">
            <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-item">
                <i class="fas fa-home"></i>
                <span>Trang Chủ</span>
            </a>
            <a href="<%= request.getContextPath() %>/admin/books/pending" class="nav-item active">
                <i class="fas fa-check"></i>
                <span>Duyệt Sách</span>
            </a>
            <a href="<%= request.getContextPath() %>/books" class="nav-item">
                <i class="fas fa-book"></i>
                <span>Danh Sách Sách</span>
            </a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="dashboard-header">
            <div class="header-left">
                <h1>Duyệt Sách (Chờ duyệt)</h1>
            </div>
            <div class="header-right">
                <div class="user-menu">
                    <div class="user-info">
                        <i class="fas fa-user-circle"></i>
                        <span><%= employee.getFullName() != null ? employee.getFullName() : employee.getEmail() %></span>
                    </div>
                    <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                        <i class="fas fa-sign-out-alt"></i>
                        Đăng Xuất
                    </a>
                </div>
            </div>
        </header>

        <div class="dashboard-content">
            <% if (message != null) { %>
                <div class="panel" style="background:#d1fae5; color:#065f46; margin-bottom: 12px;">
                    <i class="fas fa-check-circle"></i> Đã cập nhật trạng thái.
                </div>
            <% } %>
            <% if (error != null) { %>
                <div class="panel" style="background:#fee2e2; color:#991b1b; margin-bottom: 12px;">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <% } %>

            <div class="panel">
                <div style="margin-bottom:12px; color:#6b7280;">
                    Tổng: <strong><%= totalBooks != null ? totalBooks : 0 %></strong> sách chờ duyệt
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tiêu đề</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (books != null && !books.isEmpty()) { %>
                        <% for (Book b : books) { %>
                        <tr>
                            <td>#<%= b.getBookId() %></td>
                            <td><strong><%= b.getTitle() %></strong></td>
                            <td><span class="badge badge-pending"><%= b.getApprovalStatusDisplay() %></span></td>
                            <td style="width: 35%;">
                                <input class="notes" form="f-approve-<%= b.getBookId() %>" name="notes" placeholder="Ghi chú (tuỳ chọn)">
                                <input class="notes" form="f-reject-<%= b.getBookId() %>" name="notes" placeholder="Lý do từ chối (khuyến nghị)">
                            </td>
                            <td>
                                <div class="row-actions">
                                    <form id="f-approve-<%= b.getBookId() %>" method="POST" action="<%= request.getContextPath() %>/admin/books/approve" style="margin:0;">
                                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                                        <button class="btn btn-approve" type="submit"><i class="fas fa-check"></i> Duyệt</button>
                                    </form>
                                    <form id="f-reject-<%= b.getBookId() %>" method="POST" action="<%= request.getContextPath() %>/admin/books/reject" style="margin:0;">
                                        <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                                        <button class="btn btn-reject" type="submit"><i class="fas fa-times"></i> Từ chối</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    <% } else { %>
                        <tr><td colspan="5" style="color:#6b7280; padding:18px;">Không có sách chờ duyệt.</td></tr>
                    <% } %>
                    </tbody>
                </table>

                <% if (totalPages != null && totalPages > 1) { %>
                <div style="padding: 16px; text-align:center;">
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <a href="<%= request.getContextPath() %>/admin/books/pending?page=<%= i %>"
                           style="padding:8px 10px; margin:0 2px; border-radius:6px; text-decoration:none; border:1px solid #e5e7eb; <%= (currentPage != null && i == currentPage) ? "background:#6366f1;color:white;" : "color:#111827;background:#f9fafb;" %>">
                            <%= i %>
                        </a>
                    <% } %>
                </div>
                <% } %>
            </div>
        </div>
    </main>
</div>

</body>
</html>

