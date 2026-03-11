import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.IOException;

public class ReplaceImports {
    public static void main(String[] args) throws IOException {
        Files.walk(Paths.get("src/java"))
                .filter(Files::isRegularFile)
                .filter(p -> p.toString().endsWith(".java"))
                .forEach(p -> {
                    try {
                        String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                        if (content.contains("javax.servlet")) {
                            content = content.replace("javax.servlet", "jakarta.servlet");
                            Files.write(p, content.getBytes(StandardCharsets.UTF_8));
                            System.out.println("Updated " + p);
                        }
                    } catch (Exception e) {
                        System.err.println("Failed to read " + p + ": " + e.getMessage());
                    }
                });
    }
}
