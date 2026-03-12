import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class DetectMojibake {
    public static void main(String[] args) throws Exception {
        String content = new String(Files.readAllBytes(Paths.get("web/WEB-INF/jsp/books/list.jsp")), StandardCharsets.UTF_8);
        if (content.contains("Ã")) {
            System.out.println("list.jsp has corrupted chars");
        }
        
        String emailUtil = new String(Files.readAllBytes(Paths.get("src/java/util/EmailUtil.java")), StandardCharsets.UTF_8);
        if (emailUtil.contains("Ã")) {
            System.out.println("EmailUtil has corrupted chars");
            // Test convert
            byte[] rawBytes = emailUtil.getBytes(StandardCharsets.ISO_8859_1);
            String fixed = new String(rawBytes, StandardCharsets.UTF_8);
            System.out.println("Preview fixed: " + fixed.substring(0, Math.min(300, fixed.length())));
        }
    }
}
