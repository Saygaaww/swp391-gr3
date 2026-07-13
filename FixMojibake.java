import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class FixMojibake {
    public static void main(String[] args) throws Exception {
        Files.walk(Paths.get("src/java"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".java"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    if (content.contains("Ã") || content.contains("áº") || content.contains("Ä") || content.contains("Æ")) {
                        byte[] raw = content.getBytes(StandardCharsets.ISO_8859_1);
                        String fixed = new String(raw, StandardCharsets.UTF_8);
                        Files.write(p, fixed.getBytes(StandardCharsets.UTF_8));
                        System.out.println("Fixed: " + p);
                    }
                } catch (Exception e) {
                    System.out.println("Error on " + p + ": " + e.getMessage());
                }
            });
    }
}