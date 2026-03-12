import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class CheckMojibake {
    public static void main(String[] args) throws Exception {
        Files.walk(Paths.get("src/java"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".java"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    // broadly check for typical iso-8859-1 characters that shouldn't be in Vietnamese utf-8
                    // like "Ã", "á", "Ä", "Æ" except if it's already fixed (a fixed file wouldn't have Ã unless it's talking about portuguese)
                    if (content.contains("Ã") || content.contains("á") || content.contains("Ä") || content.contains("Æ")) {
                        System.out.println("Mangled: " + p);
                        // Convert test
                        byte[] raw = content.getBytes(StandardCharsets.ISO_8859_1);
                        String fixed = new String(raw, StandardCharsets.UTF_8);
                        
                        // Overwrite immediately
                        Files.write(p, fixed.getBytes(StandardCharsets.UTF_8));
                    }
                } catch (Exception e) {}
            });
            
        Files.walk(Paths.get("web"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".jsp"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    if (content.contains("Ã") || content.contains("á") || content.contains("Ä") || content.contains("Æ")) {
                        System.out.println("Mangled JSP: " + p);
                        byte[] raw = content.getBytes(StandardCharsets.ISO_8859_1);
                        String fixed = new String(raw, StandardCharsets.UTF_8);
                        Files.write(p, fixed.getBytes(StandardCharsets.UTF_8));
                    }
                } catch (Exception e) {}
            });
    }
}