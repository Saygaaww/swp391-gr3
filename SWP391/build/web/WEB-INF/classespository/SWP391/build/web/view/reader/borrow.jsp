<%-- 
    Document   : borrow
    Created on : Jan 23, 2026
    Author     : damha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Mượn sách</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                padding: 20px;
            }
            
            .container {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 30px;
            }
            
            h1 {
                color: #333;
                margin-bottom: 30px;
                text-align: center;
            }
            
            .book-selection {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            
            .book-item {
                display: flex;
                align-items: center;
                gap: 15px;
                padding: 15px;
                background: white;
                border-radius: 5px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
            }
            
            .book-item:last-child {
                margin-bottom: 0;
            }
            
            .book-checkbox {
                width: 20px;
                height: 20px;
                cursor: pointer;
            }
            
            .book-info {
                flex: 1;
            }
            
            .book-title {
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }
            
            .book-meta {
                font-size: 14px;
                color: #666;
            }
            
            .quantity-input {
                width: 80px;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 5px;
                text-align: center;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: bold;
            }
            
            .form-group textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-family: inherit;
                resize: vertical;
                min-height: 100px;
            }
            
            .form-actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }
            
            .btn {
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                transition: background-color 0.3s;
            }
            
            .btn-primary {
                background-color: #2196F3;
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #0b7dda;
            }
            
            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background-color: #5a6268;
            }
            
            .error {
                background-color: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            
            .add-book-btn {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin-top: 15px;
            }
            
            .add-book-btn:hover {
                background-color: #45a049;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📚 Đơn mượn sách</h1>
            
            <c:if test="${not empty error}">
                <div class="error">
                    <c:out value="${error}"/>
                </div>
            </c:if>
            
            <form method="post" action="borrow">
                <input type="hidden" name="action" value="create">
                
                <div class="book-selection">
                    <h2 style="margin-bottom: 15px; font-size: 18px;">Chọn sách muốn mượn:</h2>
                    
                    <c:if test="${not empty book}">
                        <div class="book-item">
                            <input type="checkbox" name="bookId" value="${book.bookId}" class="book-checkbox" checked>
                            <div class="book-info">
                                <div class="book-title"><c:out value="${book.title}"/></div>
                                <div class="book-meta">
                                    Tác giả: <c:out value="${book.authorName != null ? book.authorName : 'Chưa xác định'}"/> | 
                                    Còn lại: <c:out value="${availableCopies}"/> bản
                                </div>
                            </div>
                            <input type="number" name="quantity" value="1" min="1" max="${availableCopies}" 
                                   class="quantity-input" required>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty book}">
                        <p style="color: #666; margin-bottom: 15px;">Vui lòng chọn sách từ danh sách để mượn.</p>
                        <a href="book" class="btn btn-primary">Chọn sách</a>
                    </c:if>
                </div>
                
                <div class="form-group">
                    <label for="note">Ghi chú (tùy chọn):</label>
                    <textarea id="note" name="note" placeholder="Nhập ghi chú nếu có..."></textarea>
                </div>
                
                <div class="form-actions">
                    <a href="book" class="btn btn-secondary">Hủy</a>
                    <c:if test="${not empty book}">
                        <button type="submit" class="btn btn-primary">Gửi yêu cầu mượn</button>
                    </c:if>
                </div>
            </form>
        </div>
    </body>
</html>

