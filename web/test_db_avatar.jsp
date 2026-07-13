<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test DB Avatar Update</title>
    </head>
    <body>
        <h1>Testing Avatar Update Directly</h1>
        <pre>
<%
    String result = "";
    Connection conn = null;
    PreparedStatement ps = null;
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://localhost:1433;databaseName=LibraryDB;encrypt=false";
        String user = "sa"; // Replace with actual user if needed, or rely on DataSource
        String password = "sa"; // Replace with actual password

        // Try getting connection directly or via DAO logic if simple
        dao.ReaderDAO rDao = new dao.ReaderDAO();
        
        // Generate a dummy large string (> 500 chars)
        StringBuilder sb = new StringBuilder();
        sb.append("data:image/png;base64,");
        for(int i=0; i<1000; i++) {
            sb.append("A");
        }
        String largeAvatar = sb.toString();
        
        // Ensure test user exists or just try update on User ID 1 if possible
        model.Reader r = new model.Reader();
        r.setReaderId(2); // assuming user 2 exists based on earlier context
        r.setFullName("Test User");
        r.setPhone("0123456789");
        r.setAvatarUrl(largeAvatar);
        
        boolean success = rDao.updateProfile(r);
        result += "Update success: " + success + "\n";
        
        rDao.close();
    } catch (Exception e) {
        result += "Error: " + e.getMessage() + "\n";
        e.printStackTrace(new java.io.PrintWriter(out));
    }
    out.println(result);
%>
        </pre>
    </body>
</html>
