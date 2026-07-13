import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class FixMojibakeWin1252 {
    public static void main(String[] args) throws Exception {
        Charset win1252 = Charset.forName("windows-1252");
        
        Files.walk(Paths.get("src/java"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".java"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    if (content.contains("Ã") || content.contains("á") || content.contains("Ä") || content.contains("Æ")) {
                        byte[] raw = content.getBytes(win1252);
                        String fixed = new String(raw, StandardCharsets.UTF_8);
                        Files.write(p, fixed.getBytes(StandardCharsets.UTF_8));
                        System.out.println("Fixed Java: " + p);
                    }
                } catch (Exception e) {}
            });
            
        Files.walk(Paths.get("web"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".jsp"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    // Exception for correct files: if it already contains "á" but ALSO contains valid VN characters like "ể", "ữ", etc. we shouldn't touch it.
                    // But to be safe, since these were already mojibake, let's just use the same heuristic. 
                    // Actually wait, list.jsp HAS correct "Sách" inside it! It will trigger!
                    // Let's NOT touch JSP files with this broad brush unless we know they are purely mojibake.
                    // Let's only fix Java files for now.
                } catch (Exception e) {}
            });
    }
}