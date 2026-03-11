import java.nio.file.*;
import java.nio.charset.*;
import java.io.*;

public class RescueMojibake {
    public static void main(String[] args) throws Exception {
        Charset win1252 = Charset.forName("windows-1252");
        
        Files.walk(Paths.get("src/java"))
            .filter(Files::isRegularFile)
            .filter(p -> p.toString().endsWith(".java"))
            .forEach(p -> {
                try {
                    String content = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                    
                    // \u00E1 is 'á', \u00C3 is 'Ã', \u00C4 is 'Ä', \u00C6 is 'Æ'
                    if (content.contains("\u00E1") || content.contains("\u00C3") || content.contains("\u00C4") || content.contains("\u00C6")) {
                        byte[] raw = content.getBytes(win1252);
                        String fixed = new String(raw, StandardCharsets.UTF_8);
                        
                        // Small sanity check to ensure we didn't destroy known UTF-8 correctly translated strings.
                        // If it's ALREADY correct, it might contain \u00E1 (á) natively. 
                        // But wait, if it's native UTF-8 and contains 'á', it won't be full of 'Ã' and 'Ä'.
                        // To be 100% safe, we only rescue if we see typical double-encoded sequences:
                        // "Ã" (\u00C3) is almost ALWAYS present in double encoded Vietnamese.
                        // "áº" (\u00E1\u00BA) is another dead giveaway.
                        
                        if (content.contains("\u00C3") || content.contains("\u00E1\u00BA") || content.contains("\u00C4\u2018") || content.contains("\u00E1\u00BB")) {
                            Files.write(p, fixed.getBytes(StandardCharsets.UTF_8));
                            System.out.println("Rescued: " + p);
                        }
                    }
                } catch (Exception e) {}
            });
    }
}