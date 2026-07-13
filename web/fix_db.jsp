<%@ page import="java.sql.*, util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Fix Database Schema</title>
</head>
<body>
<%
    Connection conn = null;
    Statement stmt = null;
    try {
        conn = DBUtil.getConnection();
        stmt = conn.createStatement();
        
        // Increase column size for avatar and avatar_url to support Base64
        stmt.execute("ALTER TABLE Reader ALTER COLUMN avatar_url NVARCHAR(MAX)");
        stmt.execute("ALTER TABLE Reader ALTER COLUMN avatar NVARCHAR(MAX)");
        
        out.println("<h2 style='color:green;'>Thành công: Đã cập nhật kích thước cột avatar_url và avatar thành NVARCHAR(MAX).</h2>");
        out.println("<p>Bây giờ bạn có thể lưu ảnh đại diện với dung lượng lớn hơn.</p>");
        
    } catch (Exception e) {
        out.println("<h2 style='color:red;'>Lỗi: " + e.getMessage() + "</h2>");
        e.printStackTrace(new java.io.PrintWriter(out));
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) DBUtil.releaseConnection(conn);
    }
%>
<br>
<a href="profile/view">Quay lại trang cá nhân</a>
</body>
</html>
