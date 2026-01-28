<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt yêu cầu mượn sách - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f0f0;
            min-height: 100vh;
        }
        
        .header {
            background: #5a5a5a;
            color: white;
            padding: 20px 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 600;
        }
        
        .btn-back {
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border: 2px solid white;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            background: white;
            color: #667eea;
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .stats-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            text-align: center;
        }
        
        .stats-card h3 {
            font-size: 42px;
            color: #888888;
            margin-bottom: 5px;
        }
        
        .stats-card p {
            color: #666;
            font-size: 14px;
        }
        
        .requests-container {
            display: grid;
            gap: 20px;
        }
        
        .request-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: all 0.3s;
        }
        
        .request-card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }
        
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .request-id {
            background: #888888;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
        }
        
        .request-date {
            color: #666;
            font-size: 13px;
        }
        
        .request-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .info-label {
            font-size: 12px;
            color: #666;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .info-value {
            font-size: 15px;
            color: #333;
            font-weight: 500;
        }
        
        .request-note {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .request-note strong {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }
        
        .request-note p {
            color: #666;
            line-height: 1.5;
        }
        
        .request-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-approve {
            background: #28a745;
            color: white;
            flex: 1;
        }
        
        .btn-approve:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .btn-reject {
            background: #dc3545;
            color: white;
            flex: 1;
        }
        
        .btn-reject:hover {
            background: #c82333;
            transform: translateY(-2px);
        }
        
        .empty-state {
            background: white;
            border-radius: 12px;
            padding: 60px 20px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }
        
        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #666;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>✅ Duyệt yêu cầu mượn sách</h1>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-back">
            ← Dashboard
        </a>
    </div>
    
    <div class="container">
        
        <!-- Stats -->
        <div class="stats-card">
            <h3>${totalRequests}</h3>
            <p>Yêu cầu đang chờ duyệt</p>
        </div>
        
        <!-- Requests List -->
        <c:choose>
            <c:when test="${empty pendingRequests}">
                <div class="empty-state">
                    <div class="empty-state-icon">✅</div>
                    <h3>Không có yêu cầu nào</h3>
                    <p>Tất cả yêu cầu mượn sách đã được xử lý</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="requests-container">
                    <c:forEach var="req" items="${pendingRequests}">
                        <div class="request-card">
                            <div class="request-header">
                                <span class="request-id">Yêu cầu #${req.requestId}</span>
                                <span class="request-date">
                                    <fmt:formatDate value="${req.requestedAt}" pattern="dd/MM/yyyy HH:mm" />
                                </span>
                            </div>
                            
                            <div class="request-info">
                                <div class="info-item">
                                    <span class="info-label">👤 Độc giả</span>
                                    <span class="info-value">${req.readerName}</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">📧 Email</span>
                                    <span class="info-value">${req.readerEmail}</span>
                                </div>
                            </div>
                            
                            <c:if test="${not empty req.note}">
                                <div class="request-note">
                                    <strong>📝 Ghi chú từ độc giả:</strong>
                                    <p>${req.note}</p>
                                </div>
                            </c:if>
                            
                            <div class="request-actions">
                                <form action="${pageContext.request.contextPath}/admin/borrow-approve" 
                                      method="post" style="flex: 1;">
                                    <input type="hidden" name="requestId" value="${req.requestId}">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-approve">
                                        ✅ Duyệt
                                    </button>
                                </form>
                                
                                <form action="${pageContext.request.contextPath}/admin/borrow-approve" 
                                      method="post" style="flex: 1;">
                                    <input type="hidden" name="requestId" value="${req.requestId}">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-reject" 
                                            onclick="return confirm('Bạn có chắc muốn từ chối yêu cầu này?')">
                                        ❌ Từ chối
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
        
    </div>
</body>
</html>