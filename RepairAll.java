import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.stream.Stream;

public class RepairAll {
    private static final Charset CP1252 = Charset.forName("Cp1252");
    private static int fixed = 0;
    private static int skipped = 0;

    public static void main(String[] args) throws Exception {
        String rootDir = args.length > 0 ? args[0] : "c:\\Users\\tenma\\Downloads\\swp391-gr3-dung-merge-hao-borrow\\web";
        System.out.println("Starting repair in: " + rootDir);

        try (Stream<Path> paths = Files.walk(new File(rootDir).toPath())) {
            paths.filter(Files::isRegularFile)
                 .filter(p -> p.toString().endsWith(".jsp"))
                 .forEach(path -> {
                     try {
                         repairFile(path);
                     } catch (Exception e) {
                         System.err.println("ERROR " + path.getFileName() + ": " + e.getMessage());
                     }
                 });
        }
        System.out.println("Done. Fixed=" + fixed + " Skipped=" + skipped);
    }

    private static void repairFile(Path path) throws Exception {
        // Read the corrupted file as UTF-8
        String content = Files.readString(path, StandardCharsets.UTF_8);

        // Remove BOM if present
        if (content.startsWith("\uFEFF")) {
            content = content.substring(1);
        }

        // Check for mojibake signature: 'Ã' followed by typical patterns
        // UTF-8 Vietnamese chars encoded as CP1252 produce sequences like Ã¡ Ã  Ã© etc.
        if (!content.contains("\u00C3")) {
            // No mojibake signature found, skip this file
            skipped++;
            return;
        }

        // Reverse the damage: UTF-8 string -> CP1252 bytes -> UTF-8 string
        byte[] rawBytes = content.getBytes(CP1252);
        String restored = new String(rawBytes, StandardCharsets.UTF_8);

        // Write restored content
        Files.write(path, restored.getBytes(StandardCharsets.UTF_8));
        fixed++;
        System.out.println("Fixed: " + path.getFileName());
    }
}
