import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class CleanFFFD {
    public static void main(String[] args) throws Exception {
        Files.walk(Paths.get("src/java"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".java"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    if (content.contains("\uFFFD")) {
                        content = content.replace("\uFFFD", "");
                        Files.write(p, content.getBytes(StandardCharsets.UTF_8));
                        System.out.println("Cleaned \uFFFD from: " + p);
                    }
                } catch (Exception e) {}
            });
    }
}