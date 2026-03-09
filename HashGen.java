import java.security.MessageDigest;
import java.security.SecureRandom;
import java.nio.charset.StandardCharsets;

public class HashGen {
    static final String PEPPER = "DL@SWP391#2024";

    static String hash(String password) throws Exception {
        SecureRandom random = new SecureRandom();
        byte[] saltBytes = new byte[16];
        random.nextBytes(saltBytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : saltBytes)
            sb.append(String.format("%02x", b));
        String salt = sb.toString();
        String combined = salt + password + PEPPER;
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(combined.getBytes(StandardCharsets.UTF_8));
        StringBuilder hs = new StringBuilder();
        for (byte b : hashBytes)
            hs.append(String.format("%02x", b));
        return salt + ":" + hs.toString();
    }

    public static void main(String[] args) throws Exception {
        System.out.println("admin123=" + hash("admin123"));
        System.out.println("librarian123=" + hash("librarian123"));
        System.out.println("seller123=" + hash("seller123"));
        System.out.println("password123=" + hash("password123"));
    }
}
