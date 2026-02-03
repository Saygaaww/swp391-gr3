package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.DBConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

@WebServlet(name = "TestConnectionServlet", urlPatterns = {"/test-connection"})
public class TestConnectionServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Test Database Connection</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #333; }");
        out.println(".info { background: #e3f2fd; padding: 15px; border-radius: 5px; margin: 10px 0; }");
        out.println(".success { background: #c8e6c9; padding: 15px; border-radius: 5px; margin: 10px 0; color: #2e7d32; }");
        out.println(".error { background: #ffcdd2; padding: 15px; border-radius: 5px; margin: 10px 0; color: #c62828; }");
        out.println(".code { background: #f5f5f5; padding: 10px; border-radius: 5px; font-family: monospace; margin: 10px 0; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>🔍 Kiểm Tra Kết Nối Database</h1>");
        
        // Hiển thị thông tin cấu hình
        out.println("<div class='info'>");
        out.println("<h3>📋 Thông Tin Cấu Hình (từ DBConnection.java):</h3>");
        out.println("<div class='code'>");
        out.println("DB URL: jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;<br>");
        out.println("Username: sa<br>");
        out.println("Password: 123 (đã được cấu hình)");
        out.println("</div>");
        out.println("</div>");
        
        // Test kết nối
        Connection conn = null;
        try {
            out.println("<h3>🔌 Đang thử kết nối...</h3>");
            conn = DBConnection.getConnection();
            
            if (conn != null && !conn.isClosed()) {
                out.println("<div class='success'>");
                out.println("<h3>✅ Kết nối thành công!</h3>");
                
                // Lấy thông tin database
                DatabaseMetaData metaData = conn.getMetaData();
                out.println("<p><strong>Database Product:</strong> " + metaData.getDatabaseProductName() + "</p>");
                out.println("<p><strong>Database Version:</strong> " + metaData.getDatabaseProductVersion() + "</p>");
                out.println("<p><strong>Driver Name:</strong> " + metaData.getDriverName() + "</p>");
                out.println("<p><strong>Driver Version:</strong> " + metaData.getDriverVersion() + "</p>");
                out.println("<p><strong>URL:</strong> " + metaData.getURL() + "</p>");
                out.println("<p><strong>Username:</strong> " + metaData.getUserName() + "</p>");
                out.println("</div>");
            }
            
        } catch (SQLException e) {
            out.println("<div class='error'>");
            out.println("<h3>❌ Lỗi kết nối!</h3>");
            out.println("<p><strong>Error Message:</strong></p>");
            out.println("<div class='code'>" + e.getMessage().replace("\n", "<br>") + "</div>");
            
            // Hướng dẫn khắc phục
            String errorMsg = e.getMessage();
            if (errorMsg != null) {
                out.println("<h4>💡 Hướng dẫn khắc phục:</h4>");
                out.println("<ul>");
                
                if (errorMsg.contains("Connection refused") || errorMsg.contains("TCP/IP")) {
                    out.println("<li>Kiểm tra SQL Server Service đã được khởi động chưa</li>");
                    out.println("<li>Kiểm tra TCP/IP Protocol đã được bật trong SQL Server Configuration Manager</li>");
                    out.println("<li>Kiểm tra port 1433 có đang mở không (dùng lệnh: <code>netstat -an | findstr 1433</code>)</li>");
                    out.println("<li>Kiểm tra Firewall có chặn port 1433 không</li>");
                } else if (errorMsg.contains("Login failed")) {
                    out.println("<li>Kiểm tra username và password trong file <code>DBConnection.java</code></li>");
                    out.println("<li>Đảm bảo SQL Server Authentication mode đã được bật</li>");
                } else if (errorMsg.contains("database") && errorMsg.contains("not found")) {
                    out.println("<li>Database 'DigitalLibraryDB' chưa được tạo</li>");
                    out.println("<li>Chạy script SQL để tạo database</li>");
                } else {
                    out.println("<li>Xem file <code>HUONG_DAN_KIEM_TRA_SQL_SERVER.md</code> để biết thêm chi tiết</li>");
                }
                
                out.println("</ul>");
            }
            
            out.println("</div>");
            
            // Hiển thị stack trace (chỉ trong development)
            out.println("<details>");
            out.println("<summary style='cursor: pointer; color: #666;'>📄 Chi tiết lỗi (click để xem)</summary>");
            out.println("<div class='code' style='max-height: 300px; overflow: auto;'>");
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            e.printStackTrace(pw);
            out.println(sw.toString().replace("\n", "<br>").replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;"));
            out.println("</div>");
            out.println("</details>");
            
        } catch (Exception e) {
            out.println("<div class='error'>");
            out.println("<h3>❌ Lỗi không xác định!</h3>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("</div>");
        } finally {
            if (conn != null) {
                try {
                    DBConnection.closeConnection(conn);
                    out.println("<p style='color: #666;'>Connection đã được đóng.</p>");
                } catch (Exception e) {
                    out.println("<p style='color: #f44336;'>Lỗi khi đóng connection: " + e.getMessage() + "</p>");
                }
            }
        }
        
        out.println("<hr>");
        out.println("<p><a href='" + request.getContextPath() + "/'>← Quay về trang chủ</a></p>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
