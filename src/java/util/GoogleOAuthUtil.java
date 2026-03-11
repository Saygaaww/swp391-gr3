/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestFactory;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.gson.GsonFactory;

import java.util.Arrays;

import model.GoogleUser;

public class GoogleOAuthUtil {

    private static final String CLIENT_ID =
            "503115234921-s2h67f1celedb9ra02va2hvcc39dbikv.apps.googleusercontent.com";

    private static final String CLIENT_SECRET =
            "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";

    private static final String REDIRECT_URI =
            "http://localhost:8080/DigitalLibrary/google-callback";

    private static final String USER_INFO_URL =
            "https://www.googleapis.com/oauth2/v2/userinfo";

    private static final HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static final JsonFactory JSON_FACTORY = GsonFactory.getDefaultInstance();

    public static String getGoogleLoginUrl() {
        GoogleAuthorizationCodeFlow flow =
                new GoogleAuthorizationCodeFlow.Builder(
                        HTTP_TRANSPORT,
                        JSON_FACTORY,
                        CLIENT_ID,
                        CLIENT_SECRET,
                        Arrays.asList("email", "profile")
                )
                .setAccessType("offline")
                .build();

        return flow.newAuthorizationUrl()
                .setRedirectUri(REDIRECT_URI)
                .build();
    }

    public static String getAccessToken(String code) throws Exception {
        GoogleAuthorizationCodeFlow flow =
                new GoogleAuthorizationCodeFlow.Builder(
                        HTTP_TRANSPORT,
                        JSON_FACTORY,
                        CLIENT_ID,
                        CLIENT_SECRET,
                        Arrays.asList("email", "profile")
                ).build();

        GoogleTokenResponse tokenResponse =
                flow.newTokenRequest(code)
                        .setRedirectUri(REDIRECT_URI)
                        .execute();

        return tokenResponse.getAccessToken();
    }

    public static GoogleUser getUserInfo(String accessToken) throws Exception {
        HttpRequestFactory requestFactory =
                HTTP_TRANSPORT.createRequestFactory();

        GenericUrl url = new GenericUrl(USER_INFO_URL);
        HttpRequest request = requestFactory.buildGetRequest(url);
        request.getHeaders().setAuthorization("Bearer " + accessToken);

        String json = request.execute().parseAsString();

        return JSON_FACTORY.createJsonParser(json).parse(GoogleUser.class);
    }
}
