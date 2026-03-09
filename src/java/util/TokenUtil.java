package util;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * TokenUtil - Tạo secure token cho password reset và verification
 */
public class TokenUtil {

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final int TOKEN_LENGTH_BYTES = 32; // 256-bit token

    /**
     * Tạo một secure random token (URL-safe Base64)
     */
    public static String generateToken() {
        byte[] bytes = new byte[TOKEN_LENGTH_BYTES];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    /**
     * Kiểm tra token có hợp lệ (không rỗng, đúng độ dài)
     */
    public static boolean isValidTokenFormat(String token) {
        if (token == null || token.isBlank())
            return false;
        // URL-safe base64, khoảng 43 ký tự cho 32 bytes
        return token.length() >= 40 && token.matches("[A-Za-z0-9_\\-]+");
    }
}
