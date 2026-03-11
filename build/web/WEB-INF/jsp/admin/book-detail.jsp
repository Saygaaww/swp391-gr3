<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.Book, model.Author, model.Category, model.Employee, util.AuthUtil" %>
        <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null) {
            response.sendRedirect(request.getContextPath() + "/auth/login" ); return; } Book book=(Book)
            request.getAttribute("book"); if(book==null) { response.sendRedirect(request.getContextPath()
            + "/admin/book-list" ); return; } Author author=(Author) request.getAttribute("author"); Category
            category=(Category) request.getAttribute("category"); String statusLabel=(String)
            request.getAttribute("statusLabel"); String statusColor=(String) request.getAttribute("statusColor"); %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Chi Tiết Sách: <%= book.getTitle() %> - Admin</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

                    .top-actions {
                        display: flex;
                        gap: 10px;
                    }

                    .btn-action {
                        padding: 8px 16px;
                        border-radius: 8px;
                        font-weight: 500;
                        font-size: 0.9rem;
                        text-decoration: none;
                        color: white;
                        transition: opacity 0.2s;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .btn-action:hover {
                        opacity: 0.9;
                    }

                    .edit-btn {
                        background: #3b82f6;
                    }

                    .delete-btn {
                        background: #ef4444;
                    }

                    /* Book Grid Strategy - 1/3 and 2/3 */
                    .book-layout {
                        display: grid;
                        grid-template-columns: 300px 1fr;
                        gap: 24px;
                        align-items: start;
                    }

                    /* Left: Cover */
                    .book-cover-panel {
                        background: #fff;
                        border-radius: 16px;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                        padding: 24px;
                        text-align: center;
                    }

                    .book-cover-img {
                        width: 100%;
                        max-width: 250px;
                        height: auto;
                        aspect-ratio: 2/3;
                        object-fit: cover;
                        border-radius: 8px;
                        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                        margin-bottom: 16px;
                    }

                    .book-cover-placeholder {
                        width: 100%;
                        aspect-ratio: 2/3;
                        background: #e5e7eb;
                        border-radius: 8px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #9ca3af;
                        font-size: 1.5rem;
                        margin-bottom: 16px;
                    }

                    .status-badge {
                        display: inline-block;
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: white;
                    }

                    /* Right: Info */
                    .book-info-panel {
                        background: #fff;
                        border-radius: 16px;
                        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                        padding: 30px;
                    }

                    .book-title {
                        font-size: 1.75rem;
                        font-weight: 700;
                        color: #111827;
                        margin-bottom: 8px;
                        line-height: 1.3;
                    }

                    .book-meta {
                        font-size: 0.95rem;
                        color: #6b7280;
                        margin-bottom: 24px;
                        display: flex;
                        flex-wrap: wrap;
                        gap: 16px;
                    }

                    .book-meta span {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .info-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 20px;
                        margin-bottom: 30px;
                    }

                    .info-item {
                        display: flex;
                        flex-direction: column;
                        gap: 4px;
                    }

                    .info-label {
                        font-size: 0.85rem;
                        font-weight: 600;
                        color: #6b7280;
                        text-transform: uppercase;
                    }

                    .info-value {
                        font-size: 1rem;
                        font-weight: 500;
                        color: #111827;
                    }

                    .section-title {
                        font-size: 1.1rem;
                        font-weight: 600;
                        margin-bottom: 12px;
                        color: #111827;
                        border-bottom: 1px solid #e5e7eb;
                        padding-bottom: 8px;
                    }

                    .book-desc {
                        font-size: 0.95rem;
                        line-height: 1.6;
                        color: #4b5563;
                        white-space: pre-line;
                    }

                    /* PDF Preview Block */
                    .pdf-block {
                        margin-top: 30px;
                        background: #f9fafb;
                        border: 1px solid #e5e7eb;
                        border-radius: 8px;
                        padding: 20px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .pdf-info {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .pdf-icon {
                        font-size: 2rem;
                        color: #ef4444;
                    }

                    .pdf-text h4 {
                        margin: 0;
                        font-size: 1rem;
                        color: #111827;
                    }

                    .pdf-text p {
                        margin: 4px 0 0 0;
                        font-size: 0.85rem;
                        color: #6b7280;
                    }

                    .btn-view-pdf {
                        padding: 8px 16px;
                        background: #fff;
                        border: 1px solid #d1d5db;
                        border-radius: 6px;
                        font-weight: 500;
                        color: #374151;
                        text-decoration: none;
                        transition: all 0.2s;
                    }

                    .btn-view-pdf:hover {
                        background: #f3f4f6;
                        border-color: #9ca3af;
                    }

                    @media (max-width: 768px) {
                        .book-layout {
                            grid-template-columns: 1fr;
                        }

                        .book-cover-panel {
                            max-width: 400px;
                            margin: 0 auto;
                            width: 100%;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <!-- Top Bar -->
                    <div class="top-bar">
                        <a href="<%= request.getContextPath() %>/admin/book-list" class="back-btn"><i
                                class="fas fa-arrow-left"></i> Danh sách sách</a>
                        <div class="top-actions">
                            <a href="<%= request.getContextPath() %>/admin/book-form?id=<%= book.getId() %>"
                                class="btn-action edit-btn"><i class="fas fa-edit"></i> Sửa sách</a>
                            <a href="<%= request.getContextPath() %>/admin/book-delete?id=<%= book.getId() %>"
                                class="btn-action delete-btn" onclick="return confirm('Xóa sách này?');"><i
                                    class="fas fa-trash"></i> Xóa sách</a>
                        </div>
                    </div>

                    <div class="book-layout">
                        <!-- Left: Cover -->
                        <div class="book-cover-panel">
                            <% if(book.getCoverUrl() !=null && !book.getCoverUrl().isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= book.getCoverUrl() %>" alt="Cover"
                                    class="book-cover-img">
                                <% } else { %>
                                    <div class="book-cover-placeholder"><i class="fas fa-book"></i></div>
                                    <% } %>

                                        <div class="status-badge" style="background: <%= statusColor %>">
                                            <%= statusLabel %>
                                        </div>
                        </div>

                        <!-- Right: Info -->
                        <div class="book-info-panel">
                            <h1 class="book-title">
                                <%= book.getTitle() %>
                            </h1>
                            <div class="book-meta">
                                <span><i class="fas fa-user-pen"></i>
                                    <%= author !=null ? author.getName() : "Không rõ tác giả" %>
                                </span>
                                <span><i class="fas fa-folder"></i>
                                    <%= category !=null ? category.getName() : "Không có danh mục" %>
                                </span>
                            </div>

                            <% if(book.getSummary() !=null && !book.getSummary().isEmpty()) { %>
                                <div
                                    style="font-size: 1.05rem; font-style: italic; color: #4b5563; margin-bottom: 24px; padding-left: 12px; border-left: 4px solid #4f46e5;">
                                    <%= book.getSummary() %>
                                </div>
                                <% } %>

                                    <div class="info-grid">
                                        <div class="info-item">
                                            <span class="info-label">Giá niêm yết</span>
                                            <span class="info-value"
                                                style="color: #4f46e5; font-size: 1.1rem; font-weight: 700;">
                                                <%= book.getPrice() %>
                                                    <%= book.getCurrency() %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Số lượng bản cứng</span>
                                            <span class="info-value">
                                                <%= book.getQuantity() %> cuốn
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Tổng số trang</span>
                                            <span class="info-value">
                                                <%= book.getTotalPages()> 0 ? book.getTotalPages() + " trang" : "Chưa
                                                    cập nhật" %>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Cho phép xem trước</span>
                                            <span class="info-value">
                                                <%= book.getPreviewPages()> 0 ? book.getPreviewPages() + " trang" :
                                                    "Không hỗ trợ xem trước" %>
                                            </span>
                                        </div>
                                    </div>

                                    <div class="section-title">Mô tả chi tiết</div>
                                    <div class="book-desc">
                                        <%= book.getDescription() !=null && !book.getDescription().isEmpty() ?
                                            book.getDescription() : "Chưa có bài mô tả cho sách này." %>
                                    </div>

                                    <div class="pdf-block">
                                        <div class="pdf-info">
                                            <i class="fas fa-file-pdf pdf-icon"></i>
                                            <div class="pdf-text">
                                                <h4>File Nội dung PDF</h4>
                                                <% if(book.getContentPath() !=null && !book.getContentPath().isEmpty())
                                                    { %>
                                                    <p>Đã tải lên file: <%= book.getContentPath() %>
                                                    </p>
                                                    <% } else { %>
                                                        <p style="color: #ef4444;">Chưa tải lên file PDF nào!</p>
                                                        <% } %>
                                            </div>
                                        </div>
                                        <% if(book.getContentPath() !=null && !book.getContentPath().isEmpty()) { %>
                                            <a href="<%= request.getContextPath() %>/<%= book.getContentPath() %>"
                                                target="_blank" class="btn-view-pdf"><i
                                                    class="fas fa-external-link-alt"></i> Mở PDF</a>
                                            <% } %>
                                    </div>
                        </div>
                    </div>
                </div>
            </body>

            </html>
