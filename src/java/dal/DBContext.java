package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    
    private static final String SERVER = "localhost";
    private static final String PORT = "1433";
    private static final String DATABASE = "DigitalLibraryDB";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "sa";
    
    public Connection getConnection() throws SQLException, ClassNotFoundException {
        String url = "jdbc:sqlserver://" + SERVER + ":" + PORT + 
                     ";databaseName=" + DATABASE + 
                     ";encrypt=true;trustServerCertificate=true";
        
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, USERNAME, PASSWORD);
    }
    
    public void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    public static void main(String[] args) {
        System.out.println("========================================");
        System.out.println("TEST KET NOI DATABASE");
        System.out.println("========================================");
        
        DBContext db = new DBContext();
        Connection conn = null;
        
        try {
            System.out.println("Dang ket noi den: " + DATABASE);
            conn = db.getConnection();
            
            if (conn != null) {
                System.out.println("KET NOI THANH CONG!");
                System.out.println("Database: " + DATABASE);
            }
            
        } catch (Exception e) {
            System.err.println("LOI: " + e.getMessage());
            e.printStackTrace();
        } finally {
            db.closeConnection(conn);
        }
        
        System.out.println("========================================");
    }
}