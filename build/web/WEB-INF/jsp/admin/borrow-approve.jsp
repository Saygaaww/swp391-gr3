<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.BorrowRequest, model.Employee, util.AuthUtil" %>
        <%@ page import="java.util.List, java.time.format.DateTimeFormatter" %>
            <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null) {
                response.sendRedirect(request.getContextPath() + "/auth/login" ); return; } DateTimeFormatter
                formatter=DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"); %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Duyệt Yêu Cầu Mượn Sách - Admin Control Panel</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                    <style>
                        *,
                        *::before,
                        *::after {
                            box-sizing: border-box;
                            margin: 0;
                            padding: 0;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            background: #f4f7fe;
                            color: #111827;
                            min-height: 100vh;
                            padding: 24px;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                        }

                        .container {
                            width: 100%;
                            max-width: 1200px;
                        }

                        .top-bar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                        }

                        .back-btn {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            color: #4b5563;
                            text-decoration: none;
                            font-weight: 500;
                            background: #fff;
                            padding: 8px 16px;
                            border-radius: 8px;
                            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                            transition: all 0.2s;
                        }

                        .back-btn:hover {
                            color: #111827;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        }

                        .page-title {
                            font-size: 1.5rem;
                            font-weight: 700;
                        }

                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 24px;
                        }

                        .header-section {
                            margin-bottom: 24px;
                            padding-bottom: 16px;
                            border-bottom: 1px solid #e5e7eb;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }

                        .header-section span {
                            background: #fefce8;
                            color: #a16207;
                            padding: 6px 12px;
                            border-radius: 20px;
                            font-weight: 600;
                            font-size: 0.9rem;
                        }

                        /* Table */
                        .table-container {
                            overflow-x: auto;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        th,
                        td {
                            padding: 12px 16px;
                            text-align: left;
                            border-bottom: 1px solid #e5e7eb;
                            vertical-align: middle;
                        }

                        th {
                            background: #f9fafb;
                            font-weight: 600;
                            color: #4b5563;
                            font-size: 0.85rem;
                            text-transform: uppercase;
                        }

                        td {
                            color: #111827;
                            font-size: 0.95rem;
                        }

                        .req-note {
                            font-size: 0.85rem;
                            color: #6b7280;
                            font-style: italic;
                            max-width: 250px;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }

                        /* Action Form */
                        .action-form {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .action-input {
                            padding: 8px 12px;
                            border: 1px solid #d1d5db;
                            border-radius: 6px;
                            outline: none;
                            font-family: inherit;
                            font-size: 0.85rem;
                            flex: 1;
                            min-width: 150px;
                        }

                        .btn-action {
                            padding: 8px 16px;
                            border-radius: 6px;
                            font-size: 0.85rem;
                            font-weight: 600;
                            border: none;
                            cursor: pointer;
                            color: white;
                            transition: opacity 0.2s;
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                        }

                        .btn-action:hover {
                            opacity: 0.9;
                        }

                        .approve-btn {
                            background: #10b981;
                        }

                        .reject-btn {
                            background: #ef4444;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="back-btn"><i
                                    class="fas fa-arrow-left"></i> Quay lại</a>
                            <h1 class="page-title">Duyệt Yêu Cầu Gần Đây</h1>
                            <div style="width: 100px;"></div>
                        </div>

                        <div class="content-panel">
                            <div class="header-section">
                                <h2>Danh sách chờ duyệt</h2>
                                <span><i class="fas fa-clock"></i>
                                    <%= request.getAttribute("totalRequests") !=null ?
                                        request.getAttribute("totalRequests") : "0" %> yêu cầu
                                </span>
                            </div>

                            <div class="table-container">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Mã MC</th>
                                            <th>Độc giả</th>
                                            <th>Ngày mượn</th>
                                            <th>Lời nhắn</th>
                                            <th style="min-width: 350px;">Xử lý ngay</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<BorrowRequest> requests = (List<BorrowRequest>)
                                                request.getAttribute("pendingRequests");
                                                if(requests != null && !requests.isEmpty()) {
                                                for(BorrowRequest req : requests) {
                                                %>
                                                <tr>
                                                    <td style="font-weight: 600; color: #4f46e5;">#BR-<%=
                                                            String.format("%04d", req.getRequestId()) %>
                                                    </td>
                                                    <td>
                                                        <div style="font-weight: 600;">
                                                            <%= req.getReaderName() !=null ? req.getReaderName()
                                                                : "Unknown Reader" %>
                                                        </div>
                                                        <div style="font-size: 0.8rem; color: #6b7280;">
                                                            <%= req.getReaderEmail() !=null ? req.getReaderEmail() : ""
                                                                %>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <%= req.getRequestedAt() !=null ?
                                                            req.getRequestedAt().format(formatter) : "" %>
                                                    </td>
                                                    <td>
                                                        <div class="req-note"
                                                            title="<%= req.getNote() != null ? req.getNote() : "" %>">
                                                            <%= req.getNote() !=null && !req.getNote().isEmpty() ?
                                                                req.getNote() : "Không có lời nhắn" %>
                                                        </div>
                                                        <a href="<%= request.getContextPath() %>/admin/borrow-detail?id=<%= req.getRequestId() %>"
                                                            style="font-size:0.8rem; color:#3b82f6; text-decoration:none;">Xem
                                                            chi tiết sách</a>
                                                    </td>
                                                    <td>
                                                        <form
                                                            action="<%= request.getContextPath() %>/admin/borrow-approve"
                                                            method="POST" class="action-form">
                                                            <input type="hidden" name="requestId"
                                                                value="<%= req.getRequestId() %>">
                                                            <input type="text" name="note" class="action-input"
                                                                placeholder="Ghi chú (Tùy chọn)...">
                                                            <button type="submit" name="action" value="approve"
                                                                class="btn-action approve-btn" title="Duyệt"><i
                                                                    class="fas fa-check"></i> Duyệt</button>
                                                            <button type="submit" name="action" value="reject"
                                                                class="btn-action reject-btn" title="Từ chối"
                                                                onclick="return confirm('Bạn chắc chắn muốn từ chối yêu cầu mượn này?');"><i
                                                                    class="fas fa-times"></i></button>
                                                        </form>
                                                    </td>
                                                </tr>
                                                <% } } else { %>
                                                    <tr>
                                                        <td colspan="5"
                                                            style="text-align: center; padding: 40px 0; color: #6b7280;">
                                                            Hệ thống hiện không có yêu cầu nào đang chờ duyệt. Tuyệt
                                                            vời!</td>
                                                    </tr>
                                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </body>

                </html>
