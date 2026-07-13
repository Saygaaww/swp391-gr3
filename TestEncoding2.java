import java.io.File;
import java.nio.file.Files;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

public class TestEncoding2 {
    public static void main(String[] args) throws Exception {
        File file = new File("web/jsp/books/list.jsp");
        String content = Files.readString(file.toPath(), StandardCharsets.UTF_8);
        if (content.startsWith("\uFEFF")) content = content.substring(1);

        String[] charsets = {"windows-1252", "windows-1258", "Cp1252", "Cp1258", "ISO-8859-1"};
        
        for (String csName : charsets) {
            try {
                Charset cs = Charset.forName(csName);
                byte[] rawBytes = content.getBytes(cs);
                String restored = new String(rawBytes, StandardCharsets.UTF_8);
                
                // Let's just write to a file so we can view it
                Files.write(new File("list_restored_" + csName + ".txt").toPath(), restored.getBytes(StandardCharsets.UTF_8));
                System.out.println("Finished " + csName);
            } catch (Exception e) {
                System.out.println("Error with " + csName + ": " + e.getMessage());
            }
        }
    }
}
