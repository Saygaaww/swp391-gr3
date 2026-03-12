import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class FixEncoding {
    public static void main(String[] args) throws Exception {
        Files.walk(Paths.get("c:/Users/tenma/OneDrive/Documents/NetBeansProjects/Library/src/java"))
                .filter(Files::isRegularFile)
                .filter(p -> p.toString().endsWith(".java"))
                .forEach(p -> {
                    try {
                        // Current corrupted file is valid UTF-8, but the CONTENT contains
                        // double-encoded characters.
                        // Because Get-Content read UTF-8 files as Windows-1252, the resulting
                        // characters are
                        // the cp1252 interpretations of the raw UTF-8 bytes.
                        String corruptedText = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);

                        // We extract back the raw bytes by forcing it to encode back into cp1252
                        byte[] originalUtf8Bytes = corruptedText.getBytes(Charset.forName("windows-1252"));

                        // Now we decode the real bytes as UTF-8
                        String fixedText = new String(originalUtf8Bytes, StandardCharsets.UTF_8);

                        // Ensure the package is jakarta.servlet
                        fixedText = fixedText.replace("javax.servlet", "jakarta.servlet");

                        // Remove BOM if any just in case
                        if (fixedText.startsWith("\uFEFF")) {
                            fixedText = fixedText.substring(1);
                        }

                        Files.write(p, fixedText.getBytes(StandardCharsets.UTF_8));
                    } catch (Exception e) {
                        System.out.println("Failed on " + p + ": " + e.getMessage());
                    }
                });
    }
}
