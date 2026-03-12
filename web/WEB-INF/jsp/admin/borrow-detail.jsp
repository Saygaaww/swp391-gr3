<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiet yeu cau muon - Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f0f0f0; min-height: 100vh; }
        
        .header {
            background: #5a5a5a; color: white; padding: 20px 40px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .header h1 { font-size: 24px; }
        .header-right { display: flex; gap: 10px; }
        .btn-back {
            padding: 8px 16px; background: rgba(255,255,255,0.2);
            border: 2px solid white; color: white; border-radius: 8px;
            text-decoration: none; font-weight: 600;
        }
        .btn-back:hover { background: white; color: #5a5a5a; }
        
        .container { max-width: 900px; margin: 20px auto; padding: 0 20px; }
        
        .back-link { display: inline-block; margin-bottom: 15px; color: #5a5a5a; text-decoration: none; font-weight: 600; }
        .back-link:hover { text-decoration: underline; }
        
        .alert {
            padding: 12px 18px; border-radius: 8px; margin-bottom: 15px;
            font-weight: 500; font-size: 14px;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        
        .detail-card {
            background: white; border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08); overflow: hidden;
            margin-bottom: 20px;
        }
        .card-header {
            background: #5a5a5a; color: white; padding: 15px 25px;
            display: flex; justify-content: space-between; align-items: center;
        }
        .card-header h2 { font-size: 18px; }
        .card-body { padding: 25px; }
        
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 20px;
        }
        .info-row {
            display: flex; flex-direction: column; gap: 4px;
            padding: 10px 0; border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label { font-size: 12px; color: #888; text-transform: uppercase; font-weight: 600; }
        .info-value { font-size: 15px; color: #333; }
        
        .info-full { grid-column: 1 / -1; }
        
        .badge {
            display: inline-block; padding: 6px 14px; border-radius: 20px;
            font-size: 13px; font-weight: 600;
        }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-approved { background: #d4edda; color: #155724; }
        .badge-rejected { background: #f8d7da; color: #721c24; }
        
        .note-box {
            background: #f8f9fa; padding: 15px; border-radius: 8px;
            margin-top: 5px; line-height: 1.6; color: #555;
        }
        
        .action-card {
            background: white; border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08); padding: 25px;
        }
        .action-card h3 { font-size: 16px; margin-bottom: 15px; color: #333; }
        
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: 600; font-size: 13px; color: #555; margin-bottom: 6px; }
        .form-group textarea {
            width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 8px;
            font-size: 14px; font-family: inherit; resize: vertical; min-height: 80px;
        }
        .form-group textarea:focus { outline: none; border-color: #5a5a5a; }
        
        .action-buttons { display: flex; gap: 12px; }
        .btn {
            padding: 12px 24px; border: none; border-radius: 8px;
            font-size: 14px; font-weight: 600; cursor: pointer; flex: 1;
        }
        .btn-approve { background: #28a745; color: white; }
        .btn-approve:hover { background: #218838; }
        .btn-reject { background: #dc3545; color: white; }
        .btn-reject:hover { background: #c82333; }
        
        .processed-info {
            background: #e9ecef; padding: 15px; border-radius: 8px;
            text-align: center; color: #555; font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .info-grid { grid-template-columns: 1fr; }
            .action-buttons { flex-direction: column; }
            .header { flex-direction: column; gap: 10px; }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Chi tiet yeu cau muon</h1>
        <div class="header-right">
            <a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn-back">&laquo; Danh sach</a>
        </div>
    </div>
    
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin/borrow-list" class="back-link">&laquo; Quay lai lich su yeu cau</a>
        
        <%-- Thong bao --%>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-error">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">${errorMessage}</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty borrowRequest}">
                <div class="detail-card">
                    <div class="card-body" style="text-align:center; padding:50px;">
                        <h3>Khong tim thay yeu cau</h3>
                        <p style="color:#666; margin-top:10px;">Yeu cau khong ton tai hoac da bi xoa</p>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <%-- Thong tin yeu cau --%>
                <div class="detail-card">
                    <div class="card-header">
                        <h2>Yeu cau #${borrowRequest.requestId}</h2>
                        <c:choose>
                            <c:when test="${borrowRequest.status == 'pending'}">
                                <span class="badge badge-pending">Cho duyet</span>
                            </c:when>
                            <c:when test="${borrowRequest.status == 'approved'}">
                                <span class="badge badge-approved">Da duyet</span>
                            </c:when>
                            <c:when test="${borrowRequest.status == 'rejected'}">
                                <span class="badge badge-rejected">Tu choi</span>
                            </c:when>
                        </c:choose>
                    </div>
                    <div class="card-body">
                        <div class="info-grid">
                            <div class="info-row">
                                <span class="info-label">Doc gia</span>
                                <span class="info-value">${borrowRequest.readerName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Email</span>
                                <span class="info-value">${borrowRequest.readerEmail}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Dien thoai</span>
                                <span class="info-value">${not empty borrowRequest.readerPhone ? borrowRequest.readerPhone : '-'}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Ngay gui yeu cau</span>
                                <span class="info-value">
                                    <fmt:formatDate value="${borrowRequest.requestedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                </span>
                            </div>
                            
                            <c:if test="${not empty borrowRequest.note}">
                                <div class="info-row info-full">
                                    <span class="info-label">Ghi chu cua doc gia</span>
                                    <div class="note-box">${borrowRequest.note}</div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <%-- Thong tin xu ly (neu da xu ly) --%>
                <c:if test="${borrowRequest.status != 'pending'}">
                    <div class="detail-card">
                        <div class="card-header">
                            <h2>Thong tin xu ly</h2>
                        </div>
                        <div class="card-body">
                            <div class="info-grid">
                                <div class="info-row">
                                    <span class="info-label">Nguoi xu ly</span>
                                    <span class="info-value">${not empty borrowRequest.employeeName ? borrowRequest.employeeName : '-'}</span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label">Ngay xu ly</span>
                                    <span class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty borrowRequest.processedAt}">
                                                <fmt:formatDate value="${borrowRequest.processedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <c:if test="${not empty borrowRequest.decisionNote}">
                                    <div class="info-row info-full">
                                        <span class="info-label">Ghi chu xu ly</span>
                                        <div class="note-box">${borrowRequest.decisionNote}</div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <%-- Form duyet/tu choi (chi hien khi dang pending) --%>
                <c:if test="${borrowRequest.status == 'pending'}">
                    <div class="action-card">
                        <h3>Xu ly yeu cau nay</h3>
                        
                        <div class="form-group">
                            <label for="decisionNote">Ghi chu xu ly (khong bat buoc, toi da 500 ky tu):</label>
                            <textarea id="decisionNote" maxlength="500" 
                                      placeholder="Nhap ghi chu cho quyet dinh duyet hoac tu choi..."></textarea>
                        </div>
                        
                        <div class="action-buttons">
                            <form action="${pageContext.request.contextPath}/admin/borrow-detail" method="post">
                                <input type="hidden" name="requestId" value="${borrowRequest.requestId}">
                                <input type="hidden" name="action" value="approve">
                                <input type="hidden" name="note" id="approveNote" value="">
                                <button type="submit" class="btn btn-approve" style="width:100%;"
                                        onclick="document.getElementById('approveNote').value=document.getElementById('decisionNote').value; return confirm('Xac nhan DUYET yeu cau #${borrowRequest.requestId}?')">
                                    Duyet yeu cau
                                </button>
                            </form>
                            
                            <form action="${pageContext.request.contextPath}/admin/borrow-detail" method="post">
                                <input type="hidden" name="requestId" value="${borrowRequest.requestId}">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="note" id="rejectNote" value="">
                                <button type="submit" class="btn btn-reject" style="width:100%;"
                                        onclick="document.getElementById('rejectNote').value=document.getElementById('decisionNote').value; return confirm('Xac nhan TU CHOI yeu cau #${borrowRequest.requestId}?')">
                                    Tu choi yeu cau
                                </button>
                            </form>
                        </div>
                    </div>
                </c:if>
                
                <%-- Da xu ly roi --%>
                <c:if test="${borrowRequest.status != 'pending'}">
                    <div class="processed-info">
                        Yeu cau nay da duoc xu ly. Trang thai: 
                        <strong>${borrowRequest.status == 'approved' ? 'DA DUYET' : 'TU CHOI'}</strong>
                    </div>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>