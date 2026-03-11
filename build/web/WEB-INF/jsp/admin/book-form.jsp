<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.Book, model.Category, model.Author, model.Employee, util.AuthUtil" %>
        <%@ page import="java.util.List" %>
            <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null) {
                response.sendRedirect(request.getContextPath() + "/auth/login" ); return; } Book book=(Book)
                request.getAttribute("book"); String mode=(String) request.getAttribute("mode"); boolean isEdit="edit"
                .equals(mode); %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <%= isEdit ? "Sửa thông tin sách" : "Thêm sách mới" %> - Admin Control Panel
                    </title>
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
                            max-width: 900px;
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

                        /* Content Panel */
                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 30px;
                        }

                        .alert {
                            padding: 12px 16px;
                            border-radius: 8px;
                            margin-bottom: 24px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .alert-error {
                            background: #fee2e2;
                            color: #dc2626;
                            border: 1px solid #f87171;
                        }

                        /* Form Grid */
                        .form-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 20px;
                        }

                        .form-group {
                            margin-bottom: 20px;
                        }

                        .form-group.full-width {
                            grid-column: span 2;
                        }

                        .form-label {
                            display: block;
                            font-size: 0.9rem;
                            font-weight: 600;
                            color: #374151;
                            margin-bottom: 8px;
                        }

                        .form-control {
                            width: 100%;
                            padding: 10px 14px;
                            border: 1px solid #d1d5db;
                            border-radius: 8px;
                            font-family: inherit;
                            font-size: 0.95rem;
                            color: #111827;
                            outline: none;
                            transition: border-color 0.2s;
                        }

                        .form-control:focus {
                            border-color: #4f46e5;
                            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                        }

                        textarea.form-control {
                            resize: vertical;
                            min-height: 100px;
                        }

                        .upload-area {
                            border: 2px dashed #d1d5db;
                            border-radius: 8px;
                            padding: 20px;
                            text-align: center;
                            background: #f9fafb;
                            cursor: pointer;
                            transition: all 0.2s;
                            position: relative;
                        }

                        .upload-area:hover {
                            border-color: #4f46e5;
                            background: #eff6ff;
                        }

                        .upload-area input[type="file"] {
                            position: absolute;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            opacity: 0;
                            cursor: pointer;
                        }

                        .upload-icon {
                            font-size: 2rem;
                            color: #9ca3af;
                            margin-bottom: 10px;
                        }

                        .upload-text {
                            font-size: 0.9rem;
                            color: #6b7280;
                        }

                        .form-actions {
                            display: flex;
                            justify-content: flex-end;
                            gap: 12px;
                            margin-top: 30px;
                            padding-top: 20px;
                            border-top: 1px solid #e5e7eb;
                        }

                        .btn {
                            padding: 10px 24px;
                            border-radius: 8px;
                            font-weight: 600;
                            font-size: 0.95rem;
                            cursor: pointer;
                            border: none;
                            transition: all 0.2s;
                        }

                        .btn-cancel {
                            background: #f3f4f6;
                            color: #4b5563;
                            text-decoration: none;
                        }

                        .btn-cancel:hover {
                            background: #e5e7eb;
                        }

                        .btn-submit {
                            background: #4f46e5;
                            color: white;
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .btn-submit:hover {
                            background: #4338ca;
                            box-shadow: 0 4px 6px rgba(79, 70, 229, 0.2);
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/book-list" class="back-btn"><i
                                    class="fas fa-arrow-left"></i> Quay lại</a>
                            <h1 class="page-title">
                                <%= isEdit ? "Sửa thông tin sách" : "Thêm sách mới" %>
                            </h1>
                            <div style="width: 100px;"></div>
                        </div>

                        <div class="content-panel">
                            <% if (request.getAttribute("error") !=null) { %>
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <%= request.getAttribute("error") %>
                                </div>
                                <% } %>

                                    <form action="<%= request.getContextPath() %>/admin/book-form" method="POST"
                                        enctype="multipart/form-data">
                                        <% if(isEdit) { %>
                                            <input type="hidden" name="bookId" value="<%= book.getId() %>">
                                            <input type="hidden" name="oldCoverUrl"
                                                value="<%= book.getCoverUrl() != null ? book.getCoverUrl() : "" %>">
                                            <input type="hidden" name="oldContentPath"
                                                value="<%= book.getContentPath() != null ? book.getContentPath() : "" %>">
                                            <% } %>

                                                <div class="form-grid">
                                                    <div class="form-group full-width">
                                                        <label class="form-label">Tên sách <span
                                                                style="color:red">*</span></label>
                                                        <input type="text" name="title" class="form-control"
                                                            value="<%= book.getTitle() != null ? book.getTitle() : "" %>"
                                                            required>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Tác giả <span
                                                                style="color:red">*</span></label>
                                                        <select name="authorId" class="form-control" required>
                                                            <option value="">Chọn tác giả</option>
                                                            <% List<Author> authors = (List<Author>)
                                                                    request.getAttribute("authors");
                                                                    if(authors != null) {
                                                                    for(Author a : authors) {
                                                                    %>
                                                                    <option value="<%= a.getId() %>"
                                                                        <%=book.getAuthorId()==a.getId() ? "selected"
                                                                        : "" %>><%= a.getName() %>
                                                                    </option>
                                                                    <% } } %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Danh mục <span
                                                                style="color:red">*</span></label>
                                                        <select name="categoryId" class="form-control" required>
                                                            <option value="">Chọn danh mục</option>
                                                            <% List<Category> categories = (List<Category>)
                                                                    request.getAttribute("categories");
                                                                    if(categories != null) {
                                                                    for(Category c : categories) {
                                                                    %>
                                                                    <option value="<%= c.getId() %>"
                                                                        <%=book.getCategoryId()==c.getId() ? "selected"
                                                                        : "" %>><%= c.getName() %>
                                                                    </option>
                                                                    <% } } %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Giá tiền (VND) <span
                                                                style="color:red">*</span></label>
                                                        <input type="number" name="price" class="form-control"
                                                            value="<%= book.getPrice() != null ? book.getPrice() : " 0"
                                                            %>" min="0" required>
                                                        <input type="hidden" name="currency" value="VND">
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Trạng thái phát hành</label>
                                                        <select name="status" class="form-control">
                                                            <option value="active" <%="active" .equals(book.getStatus())
                                                                ? "selected" : "" %>>Đang phát hành (Active)</option>
                                                            <option value="inactive" <%="inactive"
                                                                .equals(book.getStatus()) ? "selected" : "" %>>Ngừng
                                                                phát hành (Inactive)</option>
                                                            <option value="draft" <%="draft" .equals(book.getStatus())
                                                                ? "selected" : "" %>>Bản nháp (Draft)</option>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Tổng số trang</label>
                                                        <input type="number" name="totalPages" class="form-control"
                                                            value="<%= book.getTotalPages() > 0 ? book.getTotalPages() : "" %>"
                                                            min="1">
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Số trang xem trước</label>
                                                        <input type="number" name="previewPages" class="form-control"
                                                            value="<%= book.getPreviewPages() > 0 ? book.getPreviewPages() : "" %>"
                                                            min="0">
                                                    </div>

                                                    <div class="form-group full-width">
                                                        <label class="form-label">Tóm tắt ngắn</label>
                                                        <input type="text" name="summary" class="form-control"
                                                            value="<%= book.getSummary() != null ? book.getSummary() : "" %>"
                                                            placeholder="Tóm tắt nội dung trong 1 câu...">
                                                    </div>

                                                    <div class="form-group full-width">
                                                        <label class="form-label">Mô tả đầy đủ giới thiệu sách</label>
                                                        <textarea name="description" class="form-control"
                                                            placeholder="Viết giới thiệu về cuốn sách..."><%= book.getDescription() != null ? book.getDescription() : "" %></textarea>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Ảnh bìa sách (JPG, PNG)</label>
                                                        <div class="upload-area">
                                                            <input type="file" name="coverFile"
                                                                accept="image/png, image/jpeg, image/gif">
                                                            <i class="fas fa-image upload-icon"></i>
                                                            <div class="upload-text">Kéo thả hoặc click để tải ảnh lên
                                                            </div>
                                                            <% if(isEdit && book.getCoverUrl() !=null &&
                                                                !book.getCoverUrl().isEmpty()) { %>
                                                                <div
                                                                    style="margin-top: 10px; color: #10b981; font-weight: 600;">
                                                                    <i class="fas fa-check"></i> Đã có ảnh bìa</div>
                                                                <% } %>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Nội dung sách (Chỉ nhận PDF)</label>
                                                        <div class="upload-area">
                                                            <input type="file" name="contentFile"
                                                                accept="application/pdf">
                                                            <i class="fas fa-file-pdf upload-icon"></i>
                                                            <div class="upload-text">Kéo thả hoặc click để tải file PDF
                                                                lên</div>
                                                            <% if(isEdit && book.getContentPath() !=null &&
                                                                !book.getContentPath().isEmpty()) { %>
                                                                <div
                                                                    style="margin-top: 10px; color: #10b981; font-weight: 600;">
                                                                    <i class="fas fa-check"></i> Đã có file nội dung
                                                                </div>
                                                                <% } %>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="form-actions">
                                                    <a href="<%= request.getContextPath() %>/admin/book-list"
                                                        class="btn btn-cancel">Hủy bỏ</a>
                                                    <button type="submit" class="btn btn-submit"><i
                                                            class="fas fa-save"></i>
                                                        <%= isEdit ? "Cập nhật sách" : "Lưu sách mới" %>
                                                    </button>
                                                </div>
                                    </form>
                        </div>
                    </div>
                </body>

                </html>
