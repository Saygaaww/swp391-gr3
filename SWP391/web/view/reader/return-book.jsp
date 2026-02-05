<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trả sách</title>
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
                max-width: 600px;
                margin: 0 auto;
            }
            
            .card {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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
                <h1>Trả sách</h1>
                
                <c:if test="${not empty borrowItem}">
                    <div class="info-section">
                        <div class="info-row">
                            <span class="info-label">Mã mượn:</span>
                            <span class="info-value">#${borrowItem.borrowId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Mã bản sao:</span>
                            <span class="info-value">#${borrowItem.copyId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Hạn trả:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${borrowItem.dueDate}" pattern="dd/MM/yyyy"/>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Trạng thái:</span>
                            <span class="info-value">${borrowItem.status}</span>
                        </div>
                    </div>
                    
                    <div class="actions">
                        <form method="post" action="readerBorrow" style="display: inline;">
                            <input type="hidden" name="action" value="return">
                            <input type="hidden" name="borrowItemId" value="${borrowItem.borrowItemId}">
                            <button type="submit" class="btn btn-success">Xác nhận trả sách</button>
                        </form>
                        <a href="readerBorrow?action=myBorrows" class="btn btn-secondary">Hủy</a>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>
