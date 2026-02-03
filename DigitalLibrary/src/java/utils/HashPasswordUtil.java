package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

/**
 * Utility class để tính toán password hash
 * Sử dụng để tính hash cho SQL script
 */
public class HashPasswordUtil {
    private static final String ALGORITHM = "SHA-256";
    
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            byte[] hash = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    public static void main(String[] args) {
        System.out.println("=== Password Hashes ===");
        System.out.println("admin123:     " + hashPassword("admin123"));
        System.out.println("librarian123: " + hashPassword("librarian123"));
        System.out.println("seller123:    " + hashPassword("seller123"));
        System.out.println("=======================");
    }
}
