package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * TestConnection - Simple database connection test
 * @author FPT Student Team
 */
public class TestConnection {
    
    // Database connection parameters - UPDATE THESE!
    private static final String DRIVER_CLASS = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DATABASE_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123"; // ← Change this!
    
    public static void main(String[] args) {
        System.out.println("=== Testing Database Connection ===");
        
        try {
            // Load SQL Server JDBC driver
            System.out.println("1. Loading JDBC driver...");
            Class.forName(DRIVER_CLASS);
            System.out.println("✅ Driver loaded successfully!");
            
            // Test connection
            System.out.println("2. Connecting to database...");
            Connection conn = DriverManager.getConnection(DATABASE_URL, USERNAME, PASSWORD);
            System.out.println("✅ Database connection successful!");
            
            // Test simple query
            System.out.println("3. Testing simple query...");
            java.sql.Statement stmt = conn.createStatement();
            java.sql.ResultSet rs = stmt.executeQuery("SELECT 1 as test_value");
            
            if (rs.next()) {
                int testValue = rs.getInt("test_value");
                System.out.println("✅ Query test successful! Result: " + testValue);
            }
            
            // Close connections
            rs.close();
            stmt.close();
            conn.close();
            System.out.println("✅ All tests passed! Database is ready.");
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver not found!");
            System.err.println("Make sure you've added SQL Server JDBC driver to Libraries");
            e.printStackTrace();
            
        } catch (SQLException e) {
            System.err.println("❌ Database connection failed!");
            System.err.println("Check:");
            System.err.println("- SQL Server is running");
            System.err.println("- Database name is correct: DigitalLibraryDB");
            System.err.println("- Username/password is correct");
            System.err.println("- Port 1433 is accessible");
            System.err.println("Error details:");
            e.printStackTrace();
            
        } catch (Exception e) {
            System.err.println("❌ Unexpected error!");
            e.printStackTrace();
        }
        
        System.out.println("=== Test Complete ===");
    }
    
    /**
     * Test method that can be called from other classes
     */
    public static boolean isConnectionWorking() {
        try {
            Class.forName(DRIVER_CLASS);
            Connection conn = DriverManager.getConnection(DATABASE_URL, USERNAME, PASSWORD);
            conn.close();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}