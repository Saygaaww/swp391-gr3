package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBUtil - Database connection utility
 * @author FPT Student Team
 */
public class DBUtil {
    
    private static final Logger LOGGER = Logger.getLogger(DBUtil.class.getName());
    
    // Database connection parameters
    private static final String DRIVER_CLASS = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String DATABASE_URL = "jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB;trustServerCertificate=true";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123"; // Change this to your actual password
    
    // Connection pool settings (simple implementation)
    private static final int MAX_CONNECTIONS = 10;
    private static Connection[] connectionPool = new Connection[MAX_CONNECTIONS];
    private static boolean[] connectionInUse = new boolean[MAX_CONNECTIONS];
    private static int currentConnections = 0;
    
    static {
        try {
            // Load SQL Server JDBC driver
            Class.forName(DRIVER_CLASS);
            LOGGER.info("SQL Server JDBC driver loaded successfully");
            
            // Initialize connection pool
            initializeConnectionPool();
            
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Failed to load SQL Server JDBC driver", e);
            throw new RuntimeException("Database driver not found", e);
        }
    }
    
    /**
     * Initialize connection pool
     */
    private static void initializeConnectionPool() {
        try {
            for (int i = 0; i < MAX_CONNECTIONS; i++) {
                connectionPool[i] = createNewConnection();
                connectionInUse[i] = false;
            }
            currentConnections = MAX_CONNECTIONS;
            LOGGER.info("Connection pool initialized with " + MAX_CONNECTIONS + " connections");
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize connection pool", e);
        }
    }
    
    /**
     * Create a new database connection
     */
    private static Connection createNewConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DATABASE_URL, USERNAME, PASSWORD);
            connection.setAutoCommit(true);
            LOGGER.fine("New database connection created");
            return connection;
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Failed to create database connection", e);
            throw e;
        }
    }
    
    /**
     * Get a connection from the pool
     */
    public static synchronized Connection getConnection() throws SQLException {
        // Look for an available connection in the pool
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            if (!connectionInUse[i]) {
                // Check if connection is still valid
                if (connectionPool[i] != null && !connectionPool[i].isClosed()) {
                    connectionInUse[i] = true;
                    LOGGER.fine("Retrieved connection from pool (index: " + i + ")");
                    return connectionPool[i];
                } else {
                    // Connection is closed, create a new one
                    connectionPool[i] = createNewConnection();
                    connectionInUse[i] = true;
                    LOGGER.fine("Created new connection for pool (index: " + i + ")");
                    return connectionPool[i];
                }
            }
        }
        
        // No available connections, create a temporary one
        LOGGER.warning("Connection pool exhausted, creating temporary connection");
        return createNewConnection();
    }
    
    /**
     * Return a connection to the pool
     */
    public static synchronized void releaseConnection(Connection connection) {
        if (connection == null) {
            return;
        }
        
        try {
            // Find the connection in the pool and mark it as available
            for (int i = 0; i < MAX_CONNECTIONS; i++) {
                if (connectionPool[i] == connection) {
                    connectionInUse[i] = false;
                    LOGGER.fine("Released connection back to pool (index: " + i + ")");
                    return;
                }
            }
            
            // Connection not from pool, close it
            connection.close();
            LOGGER.fine("Closed temporary connection");
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error releasing connection", e);
        }
    }
    
    /**
     * Close all connections in the pool
     */
    public static synchronized void closeAllConnections() {
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            if (connectionPool[i] != null) {
                try {
                    connectionPool[i].close();
                    connectionPool[i] = null;
                    connectionInUse[i] = false;
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Error closing connection " + i, e);
                }
            }
        }
        currentConnections = 0;
        LOGGER.info("All connections closed");
    }
    
    /**
     * Get pool status for monitoring
     */
    public static synchronized String getPoolStatus() {
        int availableConnections = 0;
        int usedConnections = 0;
        
        for (int i = 0; i < MAX_CONNECTIONS; i++) {
            if (connectionPool[i] != null) {
                if (connectionInUse[i]) {
                    usedConnections++;
                } else {
                    availableConnections++;
                }
            }
        }
        
        return String.format("Pool Status - Total: %d, Available: %d, In Use: %d", 
                           MAX_CONNECTIONS, availableConnections, usedConnections);
    }
    
    /**
     * Test database connection
     */
    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database connection test failed", e);
            return false;
        }
    }
    
    /**
     * Execute a simple query to check database connectivity
     */
    public static boolean isDatabaseAvailable() {
        String testQuery = "SELECT 1";
        
        try (Connection connection = getConnection();
             java.sql.PreparedStatement ps = connection.prepareStatement(testQuery);
             java.sql.ResultSet rs = ps.executeQuery()) {
            
            return rs.next() && rs.getInt(1) == 1;
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Database availability check failed", e);
            return false;
        }
    }
    
    /**
     * Get database connection info
     */
    public static String getDatabaseInfo() {
        try (Connection connection = getConnection()) {
            String url = connection.getMetaData().getURL();
            String driver = connection.getMetaData().getDriverName();
            String version = connection.getMetaData().getDatabaseProductVersion();
            
            return String.format("Database: %s, Driver: %s, Version: %s", url, driver, version);
            
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Failed to get database info", e);
            return "Database info unavailable";
        }
    }
}
