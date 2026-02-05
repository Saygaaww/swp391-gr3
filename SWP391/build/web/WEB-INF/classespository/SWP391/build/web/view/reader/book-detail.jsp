<%-- 
    Document   : book-detail
    Created on : Jan 23, 2026
    Author     : damha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi tiết sách</title>
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
                max-width: 1000px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 30px;
            }
            
            .book-header {
                display: flex;
                gap: 30px;
                margin-bottom: 30px;
            }
            
            .book-cover-wrapper {
                width: 220px;
                height: 320px;
                flex-shrink: 0;
                border-radius: 10px;
                overflow: hidden;
                background-color: #e0e0e0;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            
            .book-cover-wrapper img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }
            
            .book-details {
                flex: 1;
            }
            
            .book-title {
                font-size: 28px;
                font-weight: bold;
                color: #333;
                margin-bottom: 15px;
            }
            
            .book-meta {
                margin-bottom: 15px;
            }
            
            .book-meta-item {
                margin-bottom: 8px;
                color: #666;
            }
            
            .book-meta-label {
                font-weight: bold;
                color: #333;
            }
            
            .book-description {
                margin-top: 20px;
                line-height: 1.6;
                color: #555;
            }
            
            .book-actions {
                margin-top: 30px;
                display: flex;
                gap: 15px;
            }
            
            .btn {
                padding: 12px 25px;
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
            
            .btn-success {
                background-color: #4CAF50;
                color: white;
            }
            
            .btn-success:hover {
                background-color: #45a049;
            }
            
            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }
            
            .btn-secondary:hover {
                background-color: #5a6268;
            }
            
            .availability-badge {
                display: inline-block;
                padding: 8px 15px;
                border-radius: 20px;
                font-weight: bold;
                margin-top: 10px;
            }
            
            .available {
                background-color: #d4edda;
                color: #155724;
            }
            
            .unavailable {
                background-color: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <c:if test="${not empty book}">
                <div class="book-header">
                    <div class="book-cover-wrapper">
                        <c:choose>
                            <c:when test="${not empty book.coverUrl}">
                                <img src="<%=request.getContextPath()%>${book.coverUrl}" alt="${book.title}" />
                            </c:when>
                            <c:otherwise>
                                <span style="font-size: 80px;">📖</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="book-details">
                        <h1 class="book-title"><c:out value="${book.title}"/></h1>
                        
                        <div class="book-meta">
                            <div class="book-meta-item">
                                <span class="book-meta-label">Tác giả:</span> 
                                <c:out value="${book.authorName != null ? book.authorName : 'Chưa xác định'}"/>
                            </div>
                            <div class="book-meta-item">
                                <span class="book-meta-label">Thể loại:</span> 
                                <c:out value="${book.categoryName != null ? book.categoryName : 'Chưa phân loại'}"/>
                            </div>
                            <c:if test="${book.totalPages != null}">
                                <div class="book-meta-item">
                                    <span class="book-meta-label">Số trang:</span> 
                                    <c:out value="${book.totalPages}"/>
                                </div>
                            </c:if>
                            <c:if test="${book.price != null}">
                                <div class="book-meta-item">
                                    <span class="book-meta-label">Giá:</span> 
                                    <c:out value="${book.price}"/> <c:out value="${book.currency != null ? book.currency : 'VND'}"/>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="availability-badge ${book.availableCopies > 0 ? 'available' : 'unavailable'}">
                            <c:choose>
                                <c:when test="${book.availableCopies > 0}">
                                    ✓ Còn <c:out value="${book.availableCopies}"/> bản có sẵn
                                </c:when>
                                <c:otherwise>
                                    ✗ Hết sách
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="book-actions">
                            <a href="book" class="btn btn-secondary">← Quay lại</a>
                            <c:if test="${book.availableCopies > 0}">
                                <a href="borrow?action=form&bookId=${book.bookId}" class="btn btn-success">Mượn sách này</a>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty book.summary}">
                    <div class="book-description">
                        <h2>Tóm tắt:</h2>
                        <p><c:out value="${book.summary}"/></p>
                    </div>
                </c:if>
                
                <c:if test="${not empty book.description}">
                    <div class="book-description">
                        <h2>Mô tả chi tiết:</h2>
                        <p><c:out value="${book.description}"/></p>
                    </div>
                </c:if>
            </c:if>
            
            <c:if test="${empty book}">
                <div style="text-align: center; padding: 50px;">
                    <p style="font-size: 18px; color: #666;">Không tìm thấy sách.</p>
                    <a href="book" class="btn btn-primary" style="margin-top: 20px;">Quay lại danh sách</a>
                </div>
            </c:if>
        </div>
    </body>
</html>

