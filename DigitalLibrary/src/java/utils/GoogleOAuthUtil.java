package utils;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.http.HttpServletRequest;

public class GoogleOAuthUtil {
    // Thay đổi các giá trị này bằng thông tin từ Google Cloud Console
    private static final String CLIENT_ID = "503115234921-s2h67f1celedb9ra02va2hvcc39dbikv.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String SCOPE = "openid email profile";
    
    public static String getAuthorizationUrl(HttpServletRequest request) {
        String baseUrl = getBaseUrl(request);
        String redirectUri = baseUrl + "/auth/google/callback";
        
        try {
            return "https://accounts.google.com/o/oauth2/v2/auth?"
                    + "client_id=" + URLEncoder.encode(CLIENT_ID, StandardCharsets.UTF_8)
                    + "&redirect_uri=" + URLEncoder.encode(redirectUri, StandardCharsets.UTF_8)
                    + "&response_type=code"
                    + "&scope=" + URLEncoder.encode(SCOPE, StandardCharsets.UTF_8)
                    + "&access_type=online"
                    + "&prompt=select_account";
        } catch (Exception e) {
            throw new RuntimeException("Error building authorization URL", e);
        }
    }
    
    public static String getClientId() {
        return CLIENT_ID;
    }
    
    public static String getClientSecret() {
        return CLIENT_SECRET;
    }
    
    public static String getRedirectUri(HttpServletRequest request) {
        String baseUrl = getBaseUrl(request);
        return baseUrl + "/auth/google/callback";
    }
    
    private static String getBaseUrl(HttpServletRequest request) {
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();
        
        StringBuilder url = new StringBuilder();
        url.append(scheme).append("://").append(serverName);
        if ((scheme.equals("http") && serverPort != 80) || 
            (scheme.equals("https") && serverPort != 443)) {
            url.append(":").append(serverPort);
        }
        url.append(contextPath);
        return url.toString();
    }
}
