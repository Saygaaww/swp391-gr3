package util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import model.GoogleAccount;

/**
 * Hỗ trợ ??ăng nhập Google OAuth2
 */
public class GoogleUtils {

    // Legacy fallback to avoid breaking existing environments if not configured yet.
    private static final String LEGACY_GOOGLE_CLIENT_ID = "427012296318-vp0ktmvucmettvj9ejttj6oo9uqtcqqg.apps.googleusercontent.com";
    private static final String LEGACY_GOOGLE_CLIENT_SECRET = "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";
    private static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/Library/auth/google-callback";
    private static final String GOOGLE_GRANT_TYPE = "authorization_code";
    private static final String GOOGLE_AUTH_URL = "https://accounts.google.com/o/oauth2/v2/auth";
    private static final String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";
    private static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";

    public static boolean isConfigured() {
        return isNonBlank(getClientId()) && isNonBlank(getClientSecret());
    }

    public static String buildAuthUrl(String redirectUri, String state) throws IOException {
        return GOOGLE_AUTH_URL
                + "?client_id=" + encode(getClientId())
                + "&redirect_uri=" + encode(redirectUri)
                + "&response_type=code"
                + "&scope=" + encode("openid email profile")
                + "&access_type=offline"
                + "&prompt=select_account"
                + "&state=" + encode(state);
    }

    public static String getToken(String code) throws IOException {
        return getTokenWithRedirect(code, GOOGLE_REDIRECT_URI);
    }

    public static String getTokenWithRedirect(String code, String redirectUri) throws IOException {
        String urlParameters = "client_id=" + encode(getClientId())
                + "&client_secret=" + encode(getClientSecret())
                + "&redirect_uri=" + redirectUri
                + "&code=" + code
                + "&grant_type=" + GOOGLE_GRANT_TYPE;

        URL url = new URL(GOOGLE_LINK_GET_TOKEN);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = urlParameters.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }

        JsonObject jobj = new Gson().fromJson(response.toString(), JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    public static GoogleAccount getUserInfo(String accessToken) throws IOException {
        String link = GOOGLE_LINK_GET_USER_INFO + accessToken;
        URL url = new URL(link);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }

        return new Gson().fromJson(response.toString(), GoogleAccount.class);
    }

    private static String getClientId() {
        String configured = OAuthConfig.get("oauth.google.client.id", "google.client.id", "GOOGLE_CLIENT_ID");
        return configured != null ? configured : LEGACY_GOOGLE_CLIENT_ID;
    }

    private static String getClientSecret() {
        String configured = OAuthConfig.get("oauth.google.client.secret", "google.client.secret", "GOOGLE_CLIENT_SECRET");
        return configured != null ? configured : LEGACY_GOOGLE_CLIENT_SECRET;
    }

    private static boolean isNonBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private static String encode(String value) throws IOException {
        return URLEncoder.encode(value, StandardCharsets.UTF_8.name());
    }
}
