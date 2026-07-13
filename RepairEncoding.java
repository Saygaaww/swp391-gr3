import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.stream.Stream;

public class RepairEncoding {
    private static final Charset CP1252 = Charset.forName("Cp1252");

    public static void main(String[] args) throws Exception {
        String rootDir = "c:\\Users\\tenma\\Downloads\\swp391-gr3-dung-merge-hao-borrow\\web";
        System.out.println("Starting repair in: " + rootDir);
        
        try (Stream<Path> paths = Files.walk(new File(rootDir).toPath())) {
            paths.filter(Files::isRegularFile)
                 .filter(p -> p.toString().endsWith(".jsp"))
                 .forEach(path -> {
                     try {
                         repairFile(path);
                     } catch (Exception e) {
                         System.err.println("Error repairing " + path + ": " + e.getMessage());
                     }
                 });
        }
        System.out.println("Repair complete.");
    }

    private static void repairFile(Path path) throws Exception {
        // Read the "corrupted" file as UTF-8 string
        String content = Files.readString(path, StandardCharsets.UTF_8);
        
        // Skip files that don't seem like they need repair (e.g. no garbled characters)
        // A simple check: if it contains "Ã" or other common mojibake characters
        // But for safety, we should only apply this to files that were likely touched
        // The most common garbled character for 'á' is 'Ã¡'
        if (!content.contains("Ã") && !content.contains("Â") && !content.contains("â")) {
             // Some files might not have garbled text if they only had ASCII
             // But the JSTL fix applied to all JSP files.
             // Let's check for 'Ã' specifically as it's the signature of CP1252-reading-UTF8
        }

        // Apply reversal: String (UTF-8) -> Bytes (CP1252) -> String (UTF-8)
        byte[] originalUtf8Bytes = content.getBytes(CP1252);
        String restored = new String(originalUtf8Bytes, StandardCharsets.UTF_8);
        
        // Consistency check: only write if we actually see Vietnamese characters now
        if (restored.contains("ế") || restored.contains("á") || restored.contains("à") || restored.contains("đ") || restored.contains("ô")) {
            Files.write(path, restored.getBytes(StandardCharsets.UTF_8));
            System.out.println("Repaired: " + path.getFileName());
        } else {
            // Optional: check if it's purely ASCII or if the mapping didn't find Vietnamese
            // We'll skip for now to avoid breaking files that might use different patterns
            // System.out.println("Skipped (no Vietnamese found): " + path.getFileName());
        }
    }
}
