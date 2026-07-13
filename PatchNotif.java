import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchNotif {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/NotificationController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        // Fix requireReaderLogin regex replacement that I missed because of exact spacing
        text = text.replaceAll("(?s)private boolean requireReaderLogin\\(HttpServletRequest request.*?\\}\\s*return true;\\s*\\}", 
            "private boolean requireReaderLogin(HttpServletRequest request, HttpServletResponse response) throws IOException { if (!util.AuthUtil.isLoggedIn(request)) { response.sendRedirect(request.getContextPath() + \"/auth/login?redirect=/notifications\"); return false; } return true; }");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Modified NotificationController.java exactly");
    }
}
