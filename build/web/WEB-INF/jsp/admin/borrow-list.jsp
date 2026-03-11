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
                    <title>Quáº£n lÃ½ YÃªu cáº§u MÆ°á»£n SÃ¡ch - Admin Control Panel</title>
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
                        }

                        /* Stats Grid */
                        .stats-grid {
                            display: grid;
                            grid-template-columns: repeat(4, 1fr);
                            gap: 20px;
                            margin-bottom: 24px;
                        }

                        .stat-card {
                            background: #fff;
                            border-radius: 12px;
                            padding: 20px;
                            display: flex;
                            align-items: center;
                            gap: 16px;
                            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
                        }

                        .stat-icon {
                            width: 48px;
                            height: 48px;
                            border-radius: 12px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1.25rem;
                            flex-shrink: 0;
                        }

                        .stat-card.total .stat-icon {
                            background: #eff6ff;
                            color: #3b82f6;
                        }

                        .stat-card.pending .stat-icon {
                            background: #fefce8;
                            color: #eab308;
                        }

                        .stat-card.approved .stat-icon {
                            background: #dcfce3;
                            color: #16a34a;
                        }

                        .stat-card.rejected .stat-icon {
                            background: #fee2e2;
                            color: #dc2626;
                        }

                        .stat-info .stat-value {
                            font-size: 1.5rem;
                            font-weight: 700;
                            line-height: 1.2;
                        }

                        .stat-info .stat-label {
                            font-size: 0.75rem;
                            font-weight: 600;
                            color: #6b7280;
                            text-transform: uppercase;
                            margin-top: 4px;
                        }

                        /* Content Panel */
                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 24px;
                        }

                        .toolbar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                            flex-wrap: wrap;
                            gap: 16px;
                        }

                        .filter-form {
                            display: flex;
                            gap: 12px;
                            flex-wrap: wrap;
                        }

                        .filter-form input,
                        .filter-form select {
                            padding: 8px 12px;
                            border: 1px solid #d1d5db;
                            border-radius: 6px;
                            outline: none;
                            font-family: inherit;
                        }

                        .filter-form button {
                            background: #f3f4f6;
                            border: 1px solid #d1d5db;
                            padding: 8px 16px;
                            border-radius: 6px;
                            cursor: pointer;
                            font-weight: 500;
                        }

                        .filter-form button:hover {
                            background: #e5e7eb;
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

                        .status-badge {
                            padding: 4px 10px;
                            border-radius: 20px;
                            font-size: 0.8rem;
                            font-weight: 600;
                            display: inline-block;
                        }

                        .status-pending {
                            background: #fefce8;
                            color: #a16207;
                        }

                        .status-approved {
                            background: #dcfce3;
                            color: #16a34a;
                        }

                        .status-rejected {
                            background: #fee2e2;
                            color: #dc2626;
                        }

                        .status-returned {
                            background: #e0e7ff;
                            color: #4338ca;
                        }

                        .status-cancelled {
                            background: #f3f4f6;
                            color: #4b5563;
                        }

                        .actions-cell {
                            display: flex;
                            gap: 8px;
                        }

                        .btn-action {
                            padding: 6px 12px;
                            border-radius: 6px;
                            font-size: 0.85rem;
                            font-weight: 500;
                            text-decoration: none;
                            color: white;
                            transition: opacity 0.2s;
                        }

                        .btn-action:hover {
                            opacity: 0.9;
                        }

                        .view-btn {
                            background: #3b82f6;
                        }

                        .approve-btn {
                            background: #10b981;
                        }

                        /* Pagination */
                        .pagination {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: 24px;
                            padding-top: 16px;
                            border-top: 1px solid #e5e7eb;
                        }

                        .page-info {
                            color: #6b7280;
                            font-size: 0.9rem;
                        }

                        .page-buttons {
                            display: flex;
                            gap: 8px;
                        }

                        .page-btn {
                            padding: 6px 12px;
                            border: 1px solid #d1d5db;
                            background: #fff;
                            border-radius: 6px;
                            color: #374151;
                            text-decoration: none;
                            transition: all 0.2s;
                        }

                        .page-btn.active {
                            background: #4f46e5;
                            color: white;
                            border-color: #4f46e5;
                        }

                        .page-btn:hover:not(.active) {
                            background: #f3f4f6;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="back-btn"><i
                                    class="fas fa-arrow-left"></i> Quay láº¡i Dashboard</a>
                            <h1 class="page-title">Quáº£n lÃ½ YÃªu cáº§u MÆ°á»£n tráº£</h1>
                            <div style="width: 165px;"></div>
                        </div>

                        <% if (request.getAttribute("message") !=null) { %>
                            <div
                                style="background:#dcfce3; color:#16a34a; padding:12px 16px; border-radius:8px; margin-bottom:20px;">
                                <i class="fas fa-check-circle"></i>
                                <%= request.getAttribute("message") %>
                            </div>
                            <% } %>
                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                    <div
                                        style="background:#fee2e2; color:#dc2626; padding:12px 16px; border-radius:8px; margin-bottom:20px;">
                                        <i class="fas fa-exclamation-circle"></i>
                                        <%= request.getAttribute("errorMessage") %>
                                    </div>
                                    <% } %>

                                        <!-- Stats Grid -->
                                        <div class="stats-grid">
                                            <div class="stat-card total">
                                                <div class="stat-icon"><i class="fas fa-list-ul"></i></div>
                                                <div class="stat-info">
                                                    <div class="stat-value">
                                                        <%= request.getAttribute("totalRequests") !=null ?
                                                            request.getAttribute("totalRequests") : "0" %>
                                                    </div>
                                                    <div class="stat-label">Tá»ng YÃªu Cáº§u</div>
                                                </div>
                                            </div>
                                            <div class="stat-card pending">
                                                <div class="stat-icon"><i class="fas fa-clock"></i></div>
                                                <div class="stat-info">
                                                    <div class="stat-value">
                                                        <%= request.getAttribute("countPending") !=null ?
                                                            request.getAttribute("countPending") : "0" %>
                                                    </div>
                                                    <div class="stat-label">Chá» Duyá»t</div>
                                                </div>
                                            </div>
                                            <div class="stat-card approved">
                                                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                                                <div class="stat-info">
                                                    <div class="stat-value">
                                                        <%= request.getAttribute("countApproved") !=null ?
                                                            request.getAttribute("countApproved") : "0" %>
                                                    </div>
                                                    <div class="stat-label">Äang MÆ°á»£n</div>
                                                </div>
                                            </div>
                                            <div class="stat-card rejected">
                                                <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                                                <div class="stat-info">
                                                    <div class="stat-value">
                                                        <%= request.getAttribute("countRejected") !=null ?
                                                            request.getAttribute("countRejected") : "0" %>
                                                    </div>
                                                    <div class="stat-label">ÄÃ£ Tá»« Chá»i</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="content-panel">
                                            <div class="toolbar">
                                                <form action="<%= request.getContextPath() %>/admin/borrow-list"
                                                    method="GET" class="filter-form">
                                                    <input type="text" name="keyword"
                                                        placeholder="TÃ¬m kiáº¿m theo tÃªn ngÆ°á»i mÆ°á»£n..."
                                                        value="<%= request.getAttribute(" keyword") !=null ?
                                                        request.getAttribute("keyword") : "" %>" style="width:250px;">

                                                    <select name="status">
                                                        <option value="">Táº¥t cáº£ tráº¡ng thÃ¡i</option>
                                                        <% String statusFilter=(String)
                                                            request.getAttribute("filterStatus"); %>
                                                            <option value="pending" <%="pending" .equals(statusFilter)
                                                                ? "selected" : "" %>>Chá» duyá»t</option>
                                                            <option value="approved" <%="approved" .equals(statusFilter)
                                                                ? "selected" : "" %>>ÄÃ£ duyá»t/Äang mÆ°á»£n</option>
                                                            <option value="rejected" <%="rejected" .equals(statusFilter)
                                                                ? "selected" : "" %>>ÄÃ£ tá»« chá»i</option>
                                                            <option value="returned" <%="returned" .equals(statusFilter)
                                                                ? "selected" : "" %>>ÄÃ£ tráº£</option>
                                                            <option value="cancelled" <%="cancelled"
                                                                .equals(statusFilter) ? "selected" : "" %>>ÄÃ£ há»§y
                                                            </option>
                                                    </select>

                                                    <button type="submit"><i class="fas fa-search"></i> TÃ¬m
                                                        kiáº¿m</button>
                                                    <a href="<%= request.getContextPath() %>/admin/borrow-list"
                                                        style="padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 500; background: #6b7280; color: white;">Äáº·t
                                                        láº¡i</a>
                                                </form>
                                            </div>

                                            <div class="table-container">
                                                <table>
                                                    <thead>
                                                        <tr>
                                                            <th>MÃ£ MÆ°á»£n</th>
                                                            <th>NgÆ°á»i mÆ°á»£n</th>
                                                            <th>Email/SÄT</th>
                                                            <th>Thá»i gian gá»­i</th>
                                                            <th>Tráº¡ng thÃ¡i</th>
                                                            <th>HÃ nh Äá»ng</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% List<BorrowRequest> requests = (List<BorrowRequest>)
                                                                request.getAttribute("requestList");
                                                                if(requests != null && !requests.isEmpty()) {
                                                                for(BorrowRequest req : requests) {
                                                                String statusCls = "status-cancelled";
                                                                String statusText = "KhÃ¡c";
                                                                if("pending".equals(req.getStatus())) { statusCls =
                                                                "status-pending"; statusText = "Chá» duyá»t"; }
                                                                else if("approved".equals(req.getStatus())) { statusCls
                                                                = "status-approved"; statusText = "Äang mÆ°á»£n"; }
                                                                else if("rejected".equals(req.getStatus())) { statusCls
                                                                = "status-rejected"; statusText = "Tá»« chá»i"; }
                                                                else if("returned".equals(req.getStatus())) { statusCls
                                                                = "status-returned"; statusText = "ÄÃ£ tráº£ xong"; }
                                                                else if("cancelled".equals(req.getStatus())) { statusCls
                                                                = "status-cancelled"; statusText = "Bá» há»§y"; }
                                                                %>
                                                                <tr>
                                                                    <td style="font-weight: 600;">#BR-<%=
                                                                            String.format("%04d", req.getRequestId()) %>
                                                                    </td>
                                                                    <td style="font-weight: 500;">
                                                                        <%= req.getReaderName() !=null ?
                                                                            req.getReaderName() : "Unknown Reader" %>
                                                                    </td>
                                                                    <td>
                                                                        <%= req.getReaderEmail() !=null ?
                                                                            req.getReaderEmail() : (req.getReaderPhone()
                                                                            !=null ? req.getReaderPhone() : "N/A" ) %>
                                                                    </td>
                                                                    <td>
                                                                        <%= req.getRequestedAt() !=null ?
                                                                            req.getRequestedAt().format(formatter) : ""
                                                                            %>
                                                                    </td>
                                                                    <td><span class="status-badge <%= statusCls %>">
                                                                            <%= statusText %>
                                                                        </span></td>
                                                                    <td>
                                                                        <div class="actions-cell">
                                                                            <a href="<%= request.getContextPath() %>/admin/borrow-detail?id=<%= req.getRequestId() %>"
                                                                                class="btn-action view-btn"><i
                                                                                    class="fas fa-eye"></i> Chi tiáº¿t</a>
                                                                            <% if("pending".equals(req.getStatus())) {
                                                                                %>
                                                                                <a href="<%= request.getContextPath() %>/admin/borrow-approve?id=<%= req.getRequestId() %>"
                                                                                    class="btn-action approve-btn"><i
                                                                                        class="fas fa-gavel"></i>
                                                                                    Duyá»t/Tá»« chá»i</a>
                                                                                <% } %>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <% } } else { %>
                                                                    <tr>
                                                                        <td colspan="6"
                                                                            style="text-align: center; padding: 40px 0; color: #6b7280;">
                                                                            KhÃ´ng cÃ³ yÃªu cáº§u mÆ°á»£n tráº£ nÃ o.</td>
                                                                    </tr>
                                                                    <% } %>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- Pagination -->
                                            <% Integer totalPages=(Integer) request.getAttribute("totalPages"); Integer
                                                currentPageId=(Integer) request.getAttribute("currentPage");
                                                if(totalPages !=null && totalPages> 1) {
                                                %>
                                                <div class="pagination">
                                                    <div class="page-info">
                                                        Äang hiá»n thá» trang <%= currentPageId %> trÃªn tá»ng <%=
                                                                totalPages %> trang
                                                    </div>
                                                    <div class="page-buttons">
                                                        <% if(currentPageId> 1) { %>
                                                            <a href="?page=<%= currentPageId - 1 %>&keyword=<%= request.getParameter("
                                                                keyword")!=null?request.getParameter("keyword"):""
                                                                %>&status=<%=
                                                                    request.getParameter("status")!=null?request.getParameter("status"):""
                                                                    %>" class="page-btn"><i
                                                                        class="fas fa-chevron-left"></i></a>
                                                            <% } %>

                                                                <% for(int i=1; i<=totalPages; i++) { %>
                                                                    <a href="?page=<%= i %>&keyword=<%= request.getParameter("
                                                                        keyword")!=null?request.getParameter("keyword"):""
                                                                        %>&status=<%=
                                                                            request.getParameter("status")!=null?request.getParameter("status"):""
                                                                            %>" class="page-btn <%= i==currentPageId
                                                                                ? "active" : "" %>"><%= i %></a>
                                                                    <% } %>

                                                                        <% if(currentPageId < totalPages) { %>
                                                                            <a href="?page=<%= currentPageId + 1 %>&keyword=<%= request.getParameter("
                                                                                keyword")!=null?request.getParameter("keyword"):""
                                                                                %>&status=<%=
                                                                                    request.getParameter("status")!=null?request.getParameter("status"):""
                                                                                    %>" class="page-btn"><i
                                                                                        class="fas fa-chevron-right"></i></a>
                                                                            <% } %>
                                                    </div>
                                                </div>
                                                <% } %>
                                        </div>
                    </div>
                </body>

                </html>
