<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Duyệt yêu cầu mượn sách</title>
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
            }
            
            .card {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }
            
            h1 {
                color: #333;
                margin-bottom: 20px;
            }
            
            .info-section {
                margin-bottom: 25px;
            }
            
            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .info-label {
                font-weight: 500;
                color: #666;
            }
            
            .info-value {
                color: #333;
            }
            
            .items-list {
                margin-top: 20px;
            }
            
            .item-card {
                background-color: #f9f9f9;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 15px;
            }
            
            .item-title {
                font-weight: bold;
                color: #333;
                margin-bottom: 10px;
            }
            
            .item-details {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 10px;
                font-size: 14px;
                color: #666;
            }
            
            .availability {
                padding: 5px 10px;
                border-radius: 5px;
                font-size: 12px;
                font-weight: bold;
                display: inline-block;
                margin-top: 5px;
            }
            
            .available {
                background-color: #d4edda;
                color: #155724;
            }
            
            .unavailable {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                transition: background-color 0.3s;
                margin-right: 10px;
            }
            
            .btn-success {
                background-color: #4CAF50;
                color: white;
            }
            
            .btn-success:hover {
                background-color: #45a049;
            }
            
            .btn-secondary {
                background-color: #9e9e9e;
                color: white;
            }
            
            .btn-secondary:hover {
                background-color: #757575;
            }
            
            .actions {
                margin-top: 30px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <h1>Duyệt yêu cầu mượn sách</h1>
                
                <c:if test="${not empty borrowRequest}">
                    <div class="info-section">
                        <div class="info-row">
                            <span class="info-label">Mã yêu cầu:</span>
                            <span class="info-value">#${borrowRequest.requestId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Người đọc ID:</span>
                            <span class="info-value">#${borrowRequest.readerId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Ngày yêu cầu:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${borrowRequest.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Ghi chú:</span>
                            <span class="info-value">${borrowRequest.note != null ? borrowRequest.note : 'Không có'}</span>
                        </div>
                    </div>
                    
                    <div class="items-list">
                        <h3 style="margin-bottom: 15px;">Danh sách sách:</h3>
                        <c:forEach var="item" items="${borrowRequest.requestItems}">
                            <div class="item-card">
                                <div class="item-title">
                                    ${item.book != null ? item.book.title : 'Sách ID: '}${item.bookId}
                                </div>
                                <div class="item-details">
                                    <div>
                                        <strong>Số lượng yêu cầu:</strong> ${item.quantity}
                                    </div>
                                    <div>
                                        <strong>Có sẵn:</strong> ${item.availableCopies} bản
                                    </div>
                                </div>
                                <span class="availability ${item.availableCopies >= item.quantity ? 'available' : 'unavailable'}">
                                    ${item.availableCopies >= item.quantity ? 'Đủ số lượng' : 'Không đủ số lượng'}
                                </span>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div class="actions">
                        <form method="post" action="librarian" style="display: inline;">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="requestId" value="${borrowRequest.requestId}">
                            <button type="submit" class="btn btn-success">Xác nhận duyệt</button>
                        </form>
                        <a href="librarian?action=dashboard" class="btn btn-secondary">Hủy</a>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>
