import java.security.MessageDigest;
import java.security.SecureRandom;
import java.nio.charset.StandardCharsets;

public class GenHash {
    private static final String FIXED_PEPPER = "DL@SWP391#2024";

    public static String hashPassword(String rawPassword) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] saltBytes = new byte[16];
            random.nextBytes(saltBytes);
            String salt = bytesToHex(saltBytes);
            String hash = computeHash(rawPassword, salt);
            return salt + ":" + hash;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

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

    public static void main(String[] args) {
        String[] passwords = {"admin123", "librarian123", "seller123", "password123"};
        String[] labels = {"ADMIN", "LIBRARIAN", "SELLER", "READER"};
        for (int i = 0; i < passwords.length; i++) {
            String hash = hashPassword(passwords[i]);
            System.out.println("-- " + labels[i] + " (" + passwords[i] + "):");
            System.out.println("-- Hash: " + hash);
            System.out.println();
        }
    }
}
