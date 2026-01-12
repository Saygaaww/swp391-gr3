package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Class kết nối SQL Server Database
 * @author Member E
 */
public class DBContext {
    
    // Thông tin kết nối - ĐÃ CẬP NHẬT
    private static final String SERVER = "localhost";
    private static final String PORT = "1433";
    private static final String DATABASE = "DigitalLibraryDB"; // Tên database của bạn
    private static final String USERNAME = "sa"; // Username của bạn
    private static final String PASSWORD = "123"; // Password của bạn
    
    /**
     * Lấy kết nối tới database
     */
    public Connection getConnection() throws SQLException, ClassNotFoundException {
        // URL kết nối SQL Server
        String url = "jdbc:sqlserver://" + SERVER + ":" + PORT + 
                     ";databaseName=" + DATABASE + 
                     ";encrypt=true;trustServerCertificate=true";
        
        // Load driver JDBC
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        
        // Tạo kết nối
        return DriverManager.getConnection(url, USERNAME, PASSWORD);
    }
    
    /**
     * Đóng kết nối
     */
    public void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✅ Đã đóng kết nối database");
            } catch (SQLException e) {
                System.err.println("❌ Lỗi đóng kết nối: " + e.getMessage());
            }
        }
    }
    
    /**
     * Test kết nối - CHẠY THỬ FILE NÀY
     */
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("🔍 BẮT ĐẦU TEST KẾT NỐI DATABASE");
        System.out.println("========================================");
        
        DBContext db = new DBContext();
        Connection conn = null;
        
        try {
            System.out.println("📡 Đang kết nối đến: " + DATABASE);
            conn = db.getConnection();
            
            if (conn != null) {
                System.out.println("✅ KẾT NỐI THÀNH CÔNG!");
                System.out.println("📊 Database: " + DATABASE);
                System.out.println("🖥️  Server: " + SERVER + ":" + PORT);
                System.out.println("👤 User: " + USERNAME);
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ LỖI: Không tìm thấy JDBC Driver!");
            System.err.println("💡 Hãy thêm file mssql-jdbc-12.4.0.jre8.jar vào project");
            e.printStackTrace();
            
        } catch (SQLException e) {
            System.err.println("❌ LỖI KẾT NỐI DATABASE!");
            System.err.println("Kiểm tra:");
            System.err.println("  1. SQL Server đã chạy chưa?");
            System.err.println("  2. Tên database 'DigitalLibraryDB' đã tạo chưa?");
            System.err.println("  3. Username/Password đúng chưa?");
            System.err.println("  4. TCP/IP đã enable chưa?");
            e.printStackTrace();
            
        } finally {
            db.closeConnection(conn);
        }
        
        System.out.println("========================================");
    }
}