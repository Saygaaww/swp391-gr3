import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import java.util.stream.Stream;

public class FixReplacement {
    private static int filesFixed = 0;
    private static final String R = "\uFFFD";

    public static void main(String[] args) throws Exception {
        String rootDir = args.length > 0 ? args[0] : "c:\\Users\\tenma\\Downloads\\swp391-gr3-dung-merge-hao-borrow\\web";
        System.out.println("Scanning: " + rootDir);
        try (Stream<Path> paths = Files.walk(new File(rootDir).toPath())) {
            paths.filter(Files::isRegularFile)
                 .filter(p -> p.toString().endsWith(".jsp"))
                 .forEach(path -> {
                     try { fixFile(path); }
                     catch (Exception e) { System.err.println("Error: " + path + " - " + e.getMessage()); }
                 });
        }
        System.out.println("Done. Files fixed: " + filesFixed);
    }

    private static void fixFile(Path path) throws Exception {
        String content = Files.readString(path, StandardCharsets.UTF_8);
        if (!content.contains(R)) return;
        String original = content;

        // Uppercase Đ patterns
        content = content.replace(R + "?\u0103ng", "\u0110\u0103ng");
        content = content.replace(R + "?\u00e1nh", "\u0110\u00e1nh");
        content = content.replace(R + "?\u01a1n", "\u0110\u01a1n");
        content = content.replace(R + "?\u1ea9y", "\u0110\u1ea9y");
        content = content.replace(R + "?\u1eb7t", "\u0110\u1eb7t");
        content = content.replace(R + "?\u1ed9c", "\u0110\u1ed9c");
        content = content.replace(R + "?\u1ea7u", "\u0110\u1ea7u");
        content = content.replace(R + "?\u1ed3ng", "\u0110\u1ed3ng");
        content = content.replace(R + "?\u00e3", "\u0110\u00e3");
        content = content.replace(R + "?i\u1ec3m", "\u0110i\u1ec3m");
        content = content.replace(R + "?\u01b0\u1ee3c", "\u0110\u01b0\u1ee3c");
        content = content.replace(R + "?\u01b0\u1eddng", "\u0110\u01b0\u1eddng");
        content = content.replace(R + "?ang", "\u0110ang");
        content = content.replace(R + "?\u1ecbnh", "\u0110\u1ecbnh");
        content = content.replace(R + "?\u1ecda", "\u0110\u1ecba");
        content = content.replace(R + "?\u1ed5i", "\u0110\u1ed5i");
        content = content.replace(R + "?\u00f3ng", "\u0110\u00f3ng");
        content = content.replace(R + "?\u00e0o", "\u0110\u00e0o");
        content = content.replace(R + "?\u00e2y", "\u0110\u00e2y");
        content = content.replace(R + "?\u1ec1u", "\u0110\u1ec1u");

        // Lowercase replacement patterns  
        content = content.replace("\u0111" + R + "?c", "\u0111\u1ecdc");
        content = content.replace("ti" + R + "?n", "ti\u1ec1n");
        content = content.replace("Gi" + R + "?", "Gi\u1ecf");
        content = content.replace("bi" + R + "?n", "bi\u1ebfn");
        content = content.replace("\u0111i" + R + "?n", "\u0111i\u1ec1n");
        content = content.replace("hi" + R + "?n", "hi\u1ec7n");
        content = content.replace("ki" + R + "?n", "ki\u1ec7n");
        content = content.replace("li" + R + "?u", "li\u1ec7u");
        content = content.replace("nhi" + R + "?u", "nhi\u1ec1u");
        content = content.replace("phi" + R + "?u", "phi\u1ebfu");
        content = content.replace("chi" + R + "?u", "chi\u1ec1u");
        content = content.replace("gi" + R + "?i", "gi\u1edbi");
        content = content.replace("th" + R + "?i", "th\u1eddi");
        content = content.replace("m" + R + "?i", "m\u1edbi");
        content = content.replace("l" + R + "?i", "l\u1ed7i");
        content = content.replace("tu" + R + "?i", "tu\u1ed5i");
        content = content.replace("ng" + R + "?i", "ng\u01b0\u1eddi");
        content = content.replace("b" + R + "?i", "b\u1edfi");
        content = content.replace("d" + R + "?i", "d\u01b0\u1edbi");
        content = content.replace("h" + R + "?p", "h\u1ee3p");
        content = content.replace("b" + R + "? sung", "b\u1ed5 sung");
        content = content.replace("h" + R + "? tr\u1ee3", "h\u1ed7 tr\u1ee3");
        content = content.replace("s" + R + "?", "s\u1ed1");
        content = content.replace("T" + R + "?ng", "T\u1ed5ng");

        if (!content.equals(original)) {
            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            filesFixed++;
            long remaining = content.chars().filter(c -> c == 0xFFFD).count();
            System.out.println("Fixed: " + path.getFileName() + (remaining > 0 ? " (" + remaining + " remaining)" : ""));
        }
    }
}
