<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.BorrowRequest, model.BorrowRequestItem, model.Employee, util.AuthUtil" %>
        <%@ page import="java.util.List, java.time.format.DateTimeFormatter" %>
            <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null) {
                response.sendRedirect(request.getContextPath() + "/auth/login" ); return; } BorrowRequest
                borrowRequest=(BorrowRequest) request.getAttribute("borrowRequest"); if(borrowRequest==null) {
                response.sendRedirect(request.getContextPath() + "/admin/borrow-list" ); return; } DateTimeFormatter
                formatter=DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"); String statusCls="status-cancelled" ; String
                statusText="Khác" ; String statusBg="#f3f4f6" ; String statusColor="#4b5563" ;
                if("pending".equals(borrowRequest.getStatus())) { statusCls="status-pending" ; statusText="Chờ duyệt" ;
                statusBg="#fefce8" ; statusColor="#a16207" ; } else if("approved".equals(borrowRequest.getStatus())) {
                statusCls="status-approved" ; statusText="Đang mượn / Đã duyệt" ; statusBg="#dcfce3" ;
                statusColor="#16a34a" ; } else if("rejected".equals(borrowRequest.getStatus())) {
                statusCls="status-rejected" ; statusText="Từ chối" ; statusBg="#fee2e2" ; statusColor="#dc2626" ; } else
                if("returned".equals(borrowRequest.getStatus())) { statusCls="status-returned" ; statusText="Đã trả" ;
                statusBg="#e0e7ff" ; statusColor="#4338ca" ; } else if("cancelled".equals(borrowRequest.getStatus())) {
                statusCls="status-cancelled" ; statusText="Bị hủy" ; } %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Chi Tiết Đơn Mượn #BR-<%= String.format("%04d", borrowRequest.getRequestId()) %> - Admin
                            Control Panel</title>
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
                            max-width: 1000px;
                        }

                        /* Top Bar */
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
                            display: flex;
                            align-items: center;
                            gap: 12px;
                        }

                        .status-badge {
                            padding: 4px 10px;
                            border-radius: 20px;
                            font-size: 0.85rem;
                            font-weight: 600;
                            background: <%=statusBg %>;
                            color: <%=statusColor %>;
                        }

                        .alert {
                            padding: 12px 16px;
                            border-radius: 8px;
                            margin-bottom: 24px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .alert-success {
                            background: #dcfce3;
                            color: #16a34a;
                        }

                        .alert-error {
                            background: #fee2e2;
                            color: #dc2626;
                        }

                        /* Main Grid */
                        .main-grid {
                            display: grid;
                            grid-template-columns: 2fr 1fr;
                            gap: 24px;
                        }

                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 24px;
                            margin-bottom: 24px;
                        }

                        .section-title {
                            font-size: 1.1rem;
                            font-weight: 600;
                            margin-bottom: 16px;
                            padding-bottom: 12px;
                            border-bottom: 1px solid #e5e7eb;
                            color: #111827;
                        }

                        /* Info List */
                        .info-list {
                            display: flex;
                            flex-direction: column;
                            gap: 12px;
                        }

                        .info-item {
                            display: flex;
                            justify-content: space-between;
                            font-size: 0.95rem;
                        }

                        .info-label {
                            color: #6b7280;
                            font-weight: 500;
                        }

                        .info-value {
                            font-weight: 600;
                            color: #111827;
                            text-align: right;
                        }

                        /* Book Table */
                        .book-table {
                            width: 100%;
                            border-collapse: collapse;
                            margin-top: 10px;
                        }

                        .book-table th,
                        .book-table td {
                            padding: 12px;
                            text-align: left;
                            border-bottom: 1px solid #e5e7eb;
                        }

                        .book-table th {
                            background: #f9fafb;
                            font-weight: 600;
                            font-size: 0.85rem;
                            color: #4b5563;
                            text-transform: uppercase;
                        }

                        .book-item-row {
                            display: flex;
                            align-items: center;
                            gap: 12px;
                        }

                        .book-cover {
                            width: 40px;
                            height: 60px;
                            object-fit: cover;
                            border-radius: 4px;
                            background: #e5e7eb;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 10px;
                            color: #9ca3af;
                        }

                        .book-title {
                            font-weight: 600;
                            color: #111827;
                        }

                        /* Action Box */
                        .action-box {
                            background: #f9fafb;
                            border: 1px dashed #d1d5db;
                            border-radius: 12px;
                            padding: 20px;
                            text-align: center;
                        }

                        .action-title {
                            font-weight: 600;
                            margin-bottom: 16px;
                            color: #374151;
                        }

                        .action-form {
                            display: flex;
                            flex-direction: column;
                            gap: 12px;
                        }

                        .action-input {
                            padding: 10px 12px;
                            border: 1px solid #d1d5db;
                            border-radius: 8px;
                            width: 100%;
                            font-family: inherit;
                            font-size: 0.9rem;
                            resize: vertical;
                            min-height: 80px;
                        }

                        .action-buttons {
                            display: flex;
                            gap: 10px;
                        }

                        .btn-action {
                            flex: 1;
                            padding: 10px;
                            border-radius: 8px;
                            font-weight: 600;
                            border: none;
                            cursor: pointer;
                            color: white;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            gap: 8px;
                            transition: opacity 0.2s;
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

                        .note-box {
                            background: #fefce8;
                            border: 1px solid #fef08a;
                            padding: 12px;
                            border-radius: 8px;
                            font-size: 0.9rem;
                            color: #854d0e;
                            margin-top: 10px;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/borrow-list" class="back-btn"><i
                                    class="fas fa-arrow-left"></i> Danh sách yêu cầu</a>
                            <div class="page-title">
                                Chi Tiết Đơn: #BR-<%= String.format("%04d", borrowRequest.getRequestId()) %>
                                    <span class="status-badge">
                                        <%= statusText %>
                                    </span>
                            </div>
                            <div style="width: 150px;"></div>
                        </div>

                        <% String successMsg=(String) session.getAttribute("successMessage"); if(successMsg !=null) {
                            session.removeAttribute("successMessage"); %>
                            <div class="alert alert-success"><i class="fas fa-check-circle"></i>
                                <%= successMsg %>
                            </div>
                            <% } %>

                                <% String errorMsg=(String) session.getAttribute("errorMessage"); if(errorMsg !=null) {
                                    session.removeAttribute("errorMessage"); %>
                                    <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i>
                                        <%= errorMsg %>
                                    </div>
                                    <% } %>

                                        <div class="main-grid">
                                            <!-- Left Column: Books and Details -->
                                            <div class="left-col">
                                                <div class="content-panel">
                                                    <h2 class="section-title">Danh sách sách trong yêu cầu</h2>
                                                    <table class="book-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Sách</th>
                                                                <th>Trạng thái hiện tại</th>
                                                                <th>Ngày trả dự kiến/thực tế</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% List<BorrowRequestItem> items = borrowRequest.getItems();
                                                                if(items != null && !items.isEmpty()) {
                                                                for(BorrowRequestItem item : items) {
                                                                %>
                                                                <tr>
                                                                    <td>
                                                                        <div class="book-item-row">
                                                                            <% if(item.getBook() !=null &&
                                                                                item.getBook().getCoverUrl() !=null &&
                                                                                !item.getBook().getCoverUrl().isEmpty())
                                                                                { %>
                                                                                <img src="<%= request.getContextPath() %>/<%= item.getBook().getCoverUrl() %>"
                                                                                    class="book-cover">
                                                                                <% } else { %>
                                                                                    <div class="book-cover">No img</div>
                                                                                    <% } %>
                                                                                        <div>
                                                                                            <div class="book-title">
                                                                                                <%= item.getBook()
                                                                                                    !=null ?
                                                                                                    item.getBook().getTitle()
                                                                                                    : "Sách không tồn tại"
                                                                                                    %>
                                                                                            </div>
                                                                                            <div
                                                                                                style="font-size:0.8rem; color:#6b7280;">
                                                                                                ID: <%= item.getBookId()
                                                                                                    %>
                                                                                            </div>
                                                                                        </div>
                                                                        </div>
                                                                    </td>
                                                                    <td>
                                                                        <% String itemStatus=item.getStatus(); String
                                                                            isText="Chưa rõ" ;
                                                                            if("pending".equals(itemStatus))
                                                                            isText="Đang chờ" ; else
                                                                            if("borrowing".equals(itemStatus))
                                                                            isText="<span style='color:#16a34a; font-weight:600;'>Đang mượn</span>"
                                                                            ; else if("returned".equals(itemStatus))
                                                                            isText="<span style='color:#4338ca;'>Đã trả</span>"
                                                                            ; else if("cancelled".equals(itemStatus))
                                                                            isText="Bị hủy" ; out.print(isText); %>
                                                                    </td>
                                                                    <td>
                                                                        <% if (item.getReturnedAt() !=null) { %>
                                                                            <span
                                                                                style="color:#16a34a; font-size:0.85rem;"><i
                                                                                    class="fas fa-check-circle"></i> Đã
                                                                                trả lúc: <%=
                                                                                    item.getReturnedAt().format(formatter)
                                                                                    %></span>
                                                                            <% } else if (item.getDueDate() !=null) { %>
                                                                                <span style="font-size:0.85rem;">Hạn
                                                                                    trả: <%=
                                                                                        item.getDueDate().format(formatter)
                                                                                        %></span>
                                                                                <% } else { %>
                                                                                    <span
                                                                                        style="color:#9ca3af; font-size:0.85rem;">Chưa
                                                                                        xác định</span>
                                                                                    <% } %>
                                                                    </td>
                                                                </tr>
                                                                <% } } else { %>
                                                                    <tr>
                                                                        <td colspan="3"
                                                                            style="text-align:center; padding: 20px 0; color:#6b7280;">
                                                                            Không có sách nào trong yêu cầu này.</td>
                                                                    </tr>
                                                                    <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>

                                                <% if(borrowRequest.getNote() !=null &&
                                                    !borrowRequest.getNote().isEmpty()) { %>
                                                    <div class="content-panel">
                                                        <h2 class="section-title">Lời nhắn từ độc giả</h2>
                                                        <div class="note-box">
                                                            "<%= borrowRequest.getNote() %>"
                                                        </div>
                                                    </div>
                                                    <% } %>
                                            </div>

                                            <!-- Right Column: Reader Info and Actions -->
                                            <div class="right-col">
                                                <div class="content-panel">
                                                    <h2 class="section-title">Thông tin Người mượn</h2>
                                                    <div class="info-list">
                                                        <div class="info-item">
                                                            <span class="info-label">Độc giả</span>
                                                            <span class="info-value">
                                                                <%= borrowRequest.getReaderName() !=null ?
                                                                    borrowRequest.getReaderName() : "N/A" %>
                                                            </span>
                                                        </div>
                                                        <div class="info-item">
                                                            <span class="info-label">Email</span>
                                                            <span class="info-value">
                                                                <%= borrowRequest.getReaderEmail() !=null ?
                                                                    borrowRequest.getReaderEmail() : "N/A" %>
                                                            </span>
                                                        </div>
                                                        <div class="info-item">
                                                            <span class="info-label">Điện thoại</span>
                                                            <span class="info-value">
                                                                <%= borrowRequest.getReaderPhone() !=null &&
                                                                    !borrowRequest.getReaderPhone().isEmpty() ?
                                                                    borrowRequest.getReaderPhone() : "Chưa cung cấp" %>
                                                            </span>
                                                        </div>
                                                        <div class="info-item"
                                                            style="margin-top: 10px; border-top: 1px dashed #e5e7eb; padding-top: 10px;">
                                                            <span class="info-label">Ngày gửi Yêu cầu</span>
                                                            <span class="info-value">
                                                                <%= borrowRequest.getRequestedAt() !=null ?
                                                                    borrowRequest.getRequestedAt().format(formatter)
                                                                    : "" %>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <% if("pending".equals(borrowRequest.getStatus())) { %>
                                                    <div class="content-panel action-box">
                                                        <div class="action-title">Xử lý Yêu cầu ngay</div>
                                                        <form
                                                            action="<%= request.getContextPath() %>/admin/borrow-detail"
                                                            method="POST" class="action-form">
                                                            <input type="hidden" name="requestId"
                                                                value="<%= borrowRequest.getRequestId() %>">
                                                            <textarea name="note" class="action-input"
                                                                placeholder="Nhập lý do hoặc lời nhắn cho độc giả (Tùy chọn)..."></textarea>
                                                            <div class="action-buttons">
                                                                <button type="submit" name="action" value="approve"
                                                                    class="btn-action approve-btn"><i
                                                                        class="fas fa-check"></i> Duyệt (Cho
                                                                    mượn)</button>
                                                                <button type="submit" name="action" value="reject"
                                                                    class="btn-action reject-btn"
                                                                    onclick="return confirm('Xác nhận TỪ CHỐI yêu cầu mượn này?');"><i
                                                                        class="fas fa-times"></i> Từ chối</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                    <% } else { %>
                                                        <div class="content-panel">
                                                            <h2 class="section-title">Thông tin phê duyệt</h2>
                                                            <div class="info-list">
                                                                <div class="info-item">
                                                                    <span class="info-label">Người duyệt</span>
                                                                    <span class="info-value">
                                                                        <%= borrowRequest.getEmployeeName() !=null ?
                                                                            borrowRequest.getEmployeeName() : "Hệ thống"
                                                                            %>
                                                                    </span>
                                                                </div>
                                                                <div class="info-item">
                                                                    <span class="info-label">Thời gian duyệt</span>
                                                                    <span class="info-value">
                                                                        <%= borrowRequest.getProcessedAt() !=null ?
                                                                            borrowRequest.getProcessedAt().format(formatter)
                                                                            : "N/A" %>
                                                                    </span>
                                                                </div>
                                                            </div>
                                                            <% if(borrowRequest.getDecisionNote() !=null &&
                                                                !borrowRequest.getDecisionNote().isEmpty()) { %>
                                                                <div style="margin-top: 15px;">
                                                                    <span class="info-label"
                                                                        style="display:block; margin-bottom:5px;">Lời
                                                                        nhắn phản hồi:</span>
                                                                    <div
                                                                        style="background:#f3f4f6; padding:10px; border-radius:6px; font-size:0.9rem; color:#374151; font-style:italic;">
                                                                        "<%= borrowRequest.getDecisionNote() %>"
                                                                    </div>
                                                                </div>
                                                                <% } %>
                                                        </div>
                                                        <% } %>
                                            </div>
                                        </div>
                    </div>
                </body>

                </html>
