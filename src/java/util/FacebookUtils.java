package util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import model.FacebookAccount;

/**
 * Utility for Facebook OAuth login/link flow.
 */
public class FacebookUtils {

    private static final String FACEBOOK_AUTH_URL = "https://www.facebook.com/v20.0/dialog/oauth";
    private static final String FACEBOOK_TOKEN_URL = "https://graph.facebook.com/v20.0/oauth/access_token";
    private static final String FACEBOOK_USER_INFO_URL = "https://graph.facebook.com/me?fields=id,name,email&access_token=";

    private FacebookUtils() {
    }

    public static boolean isConfigured() {
        return isNonBlank(getClientId()) && isNonBlank(getClientSecret());
    }

    public static String buildAuthUrl(String redirectUri, String state) throws IOException {
        return FACEBOOK_AUTH_URL
            + "?client_id=" + encode(getClientId())
                + "&redirect_uri=" + encode(redirectUri)
                + "&state=" + encode(state)
                + "&scope=email,public_profile";
    }

    public static String getTokenWithRedirect(String code, String redirectUri) throws IOException {
        String urlParameters = "client_id=" + encode(getClientId())
            + "&client_secret=" + encode(getClientSecret())
                + "&redirect_uri=" + encode(redirectUri)
                + "&code=" + encode(code);

        URL url = new URL(FACEBOOK_TOKEN_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = urlParameters.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }

        JsonObject jobj = new Gson().fromJson(response.toString(), JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    public static FacebookAccount getUserInfo(String accessToken) throws IOException {
        URL url = new URL(FACEBOOK_USER_INFO_URL + encode(accessToken));
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        StringBuilder response = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
            String responseLine;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
        }

        return new Gson().fromJson(response.toString(), FacebookAccount.class);
    }

    private static String encode(String value) throws IOException {
        return URLEncoder.encode(value, StandardCharsets.UTF_8.name());
    }

    private static boolean isNonBlank(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private static String getClientId() {
        String configured = OAuthConfig.get("oauth.facebook.client.id", "facebook.client.id", "FACEBOOK_CLIENT_ID");
        return configured != null ? configured : "";
    }

    private static String getClientSecret() {
        String configured = OAuthConfig.get("oauth.facebook.client.secret", "facebook.client.secret", "FACEBOOK_CLIENT_SECRET");
        return configured != null ? configured : "";
    }
}
