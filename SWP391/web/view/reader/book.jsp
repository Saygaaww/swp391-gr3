<%-- 
    Document   : book
    Created on : Jan 23, 2026, 11:26:19 PM
    Author     : damha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách sách</title>
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
                max-width: 1200px;
                margin: 0 auto;
            }
            
            h1 {
                color: #333;
                margin-bottom: 30px;
                text-align: center;
            }
            
            .search-bar {
                margin-bottom: 30px;
                display: flex;
                gap: 10px;
                justify-content: center;
            }
            
            .search-bar input {
                padding: 10px 15px;
                font-size: 16px;
                border: 1px solid #ddd;
                border-radius: 5px;
                width: 400px;
            }
            
            .search-bar button {
                padding: 10px 20px;
                font-size: 16px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            
            .search-bar button:hover {
                background-color: #45a049;
            }
            
            .books-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 25px;
                margin-top: 20px;
            }
            
            .book-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                overflow: hidden;
                transition: transform 0.3s, box-shadow 0.3s;
            }
            
            .book-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            
            .book-cover {
                width: 100%;
                height: 300px;
                object-fit: cover;
                background-color: #e0e0e0;
                display: flex;
                align-items: center;
                justify-content: center;
                color: #999;
            }
            
            .book-info {
                padding: 15px;
            }
            
            .book-title {
                font-size: 18px;
                font-weight: bold;
                color: #333;
                margin-bottom: 8px;
                line-height: 1.3;
                height: 46px;
                overflow: hidden;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
            }
            
            .book-author {
                color: #666;
                font-size: 14px;
                margin-bottom: 5px;
            }
            
            .book-category {
                color: #888;
                font-size: 12px;
                margin-bottom: 10px;
            }
            
            .book-availability {
                color: #4CAF50;
                font-size: 14px;
                font-weight: bold;
                margin-bottom: 10px;
            }
            
            .book-actions {
                display: flex;
                gap: 10px;
            }
            
            .btn {
                padding: 8px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
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
            
            .no-books {
                text-align: center;
                padding: 50px;
                color: #666;
                font-size: 18px;
            }
            
            .keyword-highlight {
                background-color: #fff3cd;
                padding: 2px 4px;
                border-radius: 3px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📚 Thư viện sách</h1>
            
            <div class="search-bar">
                <form method="get" action="book">
                    <input type="hidden" name="action" value="search">
                    <input type="text" name="keyword" placeholder="Tìm kiếm sách theo tên, tác giả, thể loại..." 
                           value="<c:out value='${keyword}'/>">
                    <button type="submit">Tìm kiếm</button>
                </form>
            </div>
            
            <c:if test="${not empty books and books.size() > 0}">
                <div class="books-grid">
                    <c:forEach var="book" items="${books}">
                        <div class="book-card">
                            <div class="book-cover">
                                <c:choose>
                                    <c:when test="${not empty book.coverUrl}">
                                        <img src="<c:out value='${book.coverUrl}'/>" alt="<c:out value='${book.title}'/>" 
                                             style="width: 100%; height: 100%; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <span>📖</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="book-info">
                                <div class="book-title">
                                    <c:out value="${book.title}"/>
                                </div>
                                <div class="book-author">
                                    Tác giả: <c:out value="${book.authorName != null ? book.authorName : 'Chưa xác định'}"/>
                                </div>
                                <div class="book-category">
                                    Thể loại: <c:out value="${book.categoryName != null ? book.categoryName : 'Chưa phân loại'}"/>
                                </div>
                                <div class="book-availability">
                                    Còn lại: <c:out value="${book.availableCopies}"/> bản
                                </div>
                                <div class="book-actions">
                                    <a href="book?action=detail&id=${book.bookId}" class="btn btn-primary">Chi tiết</a>
                                    <c:if test="${book.availableCopies > 0}">
                                        <a href="borrow?action=form&bookId=${book.bookId}" class="btn btn-success">Mượn sách</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
            
            <c:if test="${empty books or books.size() == 0}">
                <div class="no-books">
                    <p>Không tìm thấy sách nào.</p>
                    <a href="book" class="btn btn-primary" style="margin-top: 20px;">Xem tất cả sách</a>
                </div>
            </c:if>
        </div>
    </body>
</html>
