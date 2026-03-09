package util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.nio.charset.StandardCharsets;

/**
 * PasswordUtil - Hash và verify mật khẩu dùng SHA-256 + Salt
 */
public class PasswordUtil {

    private static final String FIXED_PEPPER = "DL@SWP391#2024";

    /**
     * Hash mật khẩu với salt ngẫu nhiên
     * 
     * @return chuỗi dạng "salt:hash" để lưu vào DB
     */
    public static String hashPassword(String rawPassword) {
        try {
            // Tạo salt ngẫu nhiên 16 bytes
            SecureRandom random = new SecureRandom();
            byte[] saltBytes = new byte[16];
            random.nextBytes(saltBytes);
            String salt = bytesToHex(saltBytes);

            String hash = computeHash(rawPassword, salt);
            return salt + ":" + hash;

        } catch (Exception e) {
            throw new RuntimeException("Lỗi hash mật khẩu", e);
        }
    }

    /**
     * Xác minh mật khẩu với hash đã lưu
     * 
     * @param rawPassword mật khẩu người dùng nhập
     * @param storedHash  chuỗi "salt:hash" lưu trong DB
     */
    public static boolean verifyPassword(String rawPassword, String storedHash) {
        if (rawPassword == null || storedHash == null || !storedHash.contains(":")) {
            return false;
        }
        try {
            String[] parts = storedHash.split(":", 2);
            String salt = parts[0];
            String expectedHash = parts[1];
            String actualHash = computeHash(rawPassword, salt);
            return constantTimeEquals(expectedHash, actualHash);
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Kiểm tra độ mạnh mật khẩu
     * Tối thiểu 8 ký tự, có chữ hoa, chữ thường, số
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8)
            return false;
        boolean hasUpper = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLower = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit = password.chars().anyMatch(Character::isDigit);
        return hasUpper && hasLower && hasDigit;
    }

    // ==================== Private Helpers ====================

    private static String computeHash(String password, String salt) throws Exception {
        String combined = salt + password + FIXED_PEPPER;
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(combined.getBytes(StandardCharsets.UTF_8));
        return bytesToHex(hashBytes);
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    /** So sánh constant-time để tránh timing attack */
    private static boolean constantTimeEquals(String a, String b) {
        if (a.length() != b.length())
            return false;
        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= a.charAt(i) ^ b.charAt(i);
        }
        return result == 0;
    }
}
