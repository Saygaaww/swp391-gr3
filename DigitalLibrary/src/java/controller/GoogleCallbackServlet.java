package controller;

import dao.ReaderAccountDAO;
import dao.ReaderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reader;
import utils.GoogleOAuthUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "GoogleCallbackServlet", urlPatterns = {"/auth/google/callback"})
public class GoogleCallbackServlet extends HttpServlet {
    
    private ReaderDAO readerDAO;
    private ReaderAccountDAO readerAccountDAO;
    
    @Override
    public void init() throws ServletException {
        readerDAO = new ReaderDAO();
        readerAccountDAO = new ReaderAccountDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String error = request.getParameter("error");
        
        if (error != null) {
            request.setAttribute("error", "Đăng nhập bằng Google thất bại: " + error);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "Không nhận được mã xác thực từ Google");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Exchange code for access token
            String accessToken = exchangeCodeForToken(code, request);
            
            if (accessToken == null) {
                request.setAttribute("error", "Không thể lấy access token từ Google");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Get user info from Google
            GoogleUserInfo userInfo = getUserInfo(accessToken);
            
            if (userInfo == null) {
                request.setAttribute("error", "Không thể lấy thông tin người dùng từ Google");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
            
            // Check if account exists
            var existingAccount = readerAccountDAO.getAccountByProvider("google", userInfo.getId());
            
            Reader reader;
            if (existingAccount != null) {
                // Existing user - get reader info
                reader = readerDAO.getReaderById(existingAccount.getReaderId());
            } else {
                // New user - create account
                reader = readerDAO.createOrUpdateGoogleReader(
                    userInfo.getEmail(),
                    userInfo.getName(),
                    userInfo.getPicture(),
                    userInfo.getId()
                );
            }
            
            if (reader != null) {
                // Check account status
                if ("inactive".equalsIgnoreCase(reader.getStatus())) {
                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                // Create session
                HttpSession session = request.getSession();
                String roleName = reader.getRole() != null ? reader.getRole().getRoleName() : "USER";
                session.setAttribute("reader", reader);
                session.setAttribute("userType", "READER");
                session.setAttribute("userId", reader.getReaderId());
                session.setAttribute("userName", reader.getFullName() != null ? reader.getFullName() : reader.getEmail());
                session.setAttribute("userEmail", reader.getEmail());
                session.setAttribute("userRole", roleName);
                
                // Redirect based on role
                String redirectPath = determineRedirectPath(roleName);
                response.sendRedirect(request.getContextPath() + redirectPath);
            } else {
                request.setAttribute("error", "Không thể tạo hoặc cập nhật tài khoản");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            String errorMessage = "Lỗi kết nối database: ";
            if (e.getMessage().contains("Connection refused") || e.getMessage().contains("TCP/IP")) {
                errorMessage += "Không thể kết nối đến SQL Server. Vui lòng kiểm tra:\n" +
                               "1. SQL Server đã được khởi động chưa?\n" +
                               "2. Port 1433 có đang mở không?\n" +
                               "3. Firewall có chặn kết nối không?";
            } else {
                errorMessage += e.getMessage();
            }
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý đăng nhập Google: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private String exchangeCodeForToken(String code, HttpServletRequest request) throws IOException {
        String redirectUri = GoogleOAuthUtil.getRedirectUri(request);
        String clientId = GoogleOAuthUtil.getClientId();
        String clientSecret = GoogleOAuthUtil.getClientSecret();
        
        String urlParameters = "code=" + URLEncoder.encode(code, StandardCharsets.UTF_8)
                + "&client_id=" + URLEncoder.encode(clientId, StandardCharsets.UTF_8)
                + "&client_secret=" + URLEncoder.encode(clientSecret, StandardCharsets.UTF_8)
                + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                + "&grant_type=authorization_code";
        
        URL url = new URL("https://oauth2.googleapis.com/token");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setDoOutput(true);
        
        try (OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream(), StandardCharsets.UTF_8)) {
            writer.write(urlParameters);
            writer.flush();
        }
        
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                
                return extractJsonValue(response.toString(), "access_token");
            }
        }
        return null;
    }
    
    private GoogleUserInfo getUserInfo(String accessToken) throws IOException {
        URL url = new URL("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" 
                + URLEncoder.encode(accessToken, StandardCharsets.UTF_8));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        
        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                
                GoogleUserInfo userInfo = new GoogleUserInfo();
                userInfo.setId(extractJsonValue(response.toString(), "id"));
                userInfo.setEmail(extractJsonValue(response.toString(), "email"));
                userInfo.setName(extractJsonValue(response.toString(), "name"));
                userInfo.setPicture(extractJsonValue(response.toString(), "picture"));
                return userInfo;
            }
        }
        return null;
    }
    
    private String determineRedirectPath(String roleName) {
        if (roleName == null) {
            return "/user/dashboard";
        }
        
        switch (roleName.toUpperCase()) {
            case "ADMIN":
                return "/admin/dashboard";
            case "LIBRARIAN":
                return "/librarian/dashboard";
            case "SELLER":
                return "/seller/dashboard";
            case "USER":
            default:
                return "/user/dashboard";
        }
    }
    
    // Simple JSON value extractor
    private String extractJsonValue(String json, String key) {
        if (json == null || key == null) {
            return "";
        }
        // Pattern to match "key": "value" or "key": value
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1);
        }
        // Try without quotes (for numbers, booleans)
        pattern = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*([^,\\}]+)");
        matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1).trim().replace("\"", "");
        }
        return "";
    }
    
    // Inner class for Google user info
    private static class GoogleUserInfo {
        private String id;
        private String email;
        private String name;
        private String picture;
        
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getPicture() { return picture; }
        public void setPicture(String picture) { this.picture = picture; }
    }
}
