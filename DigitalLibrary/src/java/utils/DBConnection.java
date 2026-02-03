package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;encrypt=true;trustServerCertificate=true;";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "123"; // Thay đổi password của bạn
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            return conn;
        } catch (ClassNotFoundException e) {
            throw new SQLException("SQL Server Driver not found. Please ensure sqljdbc42.jar is in WEB-INF/lib", e);
        } catch (SQLException e) {
            // Cải thiện thông báo lỗi
            String errorMsg = e.getMessage();
            if (errorMsg != null) {
                if (errorMsg.contains("Connection refused") || errorMsg.contains("TCP/IP")) {
                    throw new SQLException(
                        "Không thể kết nối đến SQL Server tại localhost:1433.\n" +
                        "Vui lòng kiểm tra:\n" +
                        "1. SQL Server đã được khởi động (SQL Server Service đang chạy)\n" +
                        "2. SQL Server đang lắng nghe trên port 1433\n" +
                        "3. TCP/IP Protocol đã được bật trong SQL Server Configuration Manager\n" +
                        "4. Firewall không chặn port 1433\n" +
                        "5. Thông tin đăng nhập (username/password) đúng",
                        e
                    );
                } else if (errorMsg.contains("Login failed")) {
                    throw new SQLException(
                        "Đăng nhập SQL Server thất bại. Vui lòng kiểm tra username và password trong DBConnection.java",
                        e
                    );
                } else if (errorMsg.contains("database") && errorMsg.contains("not found")) {
                    throw new SQLException(
                        "Database 'DigitalLibraryDB' không tồn tại. Vui lòng chạy script SQL để tạo database.",
                        e
                    );
                }
            }
            throw e;
        }
    }
    
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
