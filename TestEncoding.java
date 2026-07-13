import java.io.File;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class TestEncoding {
    public static void main(String[] args) throws Exception {
        File file = new File("web/jsp/books/list.jsp");
        String content = Files.readString(file.toPath(), StandardCharsets.UTF_8);
        
        // Remove BOM if present
        if (content.startsWith("\uFEFF")) {
            content = content.substring(1);
        }

        // The default charset in Windows PowerShell usually maps to windows-1252
        // Try Windows-1252 and Windows-1258 to see which one restores correctly without loss
        String[] charsets = {"windows-1252", "windows-1258", "Cp1252", "Cp1258"};
        
        for (String csName : charsets) {
            try {
                Charset cs = Charset.forName(csName);
                byte[] rawBytes = content.getBytes(cs);
                String restored = new String(rawBytes, StandardCharsets.UTF_8);
                System.out.println("--- Test with " + csName + " ---");
                System.out.println(restored.substring(0, Math.min(200, restored.length())));
                
                if (restored.contains("Tìm kiếm sách")) {
                    System.out.println("SUCCESS: Found 'Tìm kiếm sách' with " + csName);
                    // Write test file
                    Files.write(new File("list_restored.jsp").toPath(), rawBytes);
                }
            } catch (Exception e) {
                System.out.println("Error with " + csName + ": " + e.getMessage());
            }
        }
    }
}
