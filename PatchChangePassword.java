import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchChangePassword {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/change-password.jsp");
        if (!Files.exists(path)) return;
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        String oldHead = "        <% Reader currentReader=(Reader) session.getAttribute(AuthUtil.SESSION_USER); %>";
        String oldHead2 = "<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER); %>";
        String oldHead3 = "<% Reader currentReader=(Reader) session.getAttribute(AuthUtil.SESSION_USER); %>";

        String newHead = "<% Object su = session.getAttribute(AuthUtil.SESSION_USER); boolean isReader = (su instanceof model.Reader); %>";
        
        text = text.replace(oldHead, newHead);
        text = text.replace(oldHead2, newHead);
        text = text.replace(oldHead3, newHead);

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        
        Path path2 = Paths.get("web/jsp/profile/linked-accounts.jsp");
        if (Files.exists(path2)) {
            String t2 = new String(Files.readAllBytes(path2), StandardCharsets.UTF_8);
            t2 = t2.replace(oldHead, newHead).replace(oldHead2, newHead).replace(oldHead3, newHead);
            // hide linked accounts UI for non-readers
            t2 = t2.replace("<div class=\"linked-accounts-container\">", "<% if (!isReader) { %><div class=\"alert alert-error\">Tài kho?n nhân viên không h? tr? liên k?t.</div><% } else { %><div class=\"linked-accounts-container\">");
            t2 = t2.replace("</body>", "<% } %></body>");
            Files.write(path2, t2.getBytes(StandardCharsets.UTF_8));
        }

        Path pathC = Paths.get("src/java/controller/ProfileController.java");
        String tc = new String(Files.readAllBytes(pathC), StandardCharsets.UTF_8);
        String oldGet = "case \"/change-password\":\n                request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n                break;";
        String oldGet2 = "case \"/change-password\":\r\n                request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\r\n                break;";
        
        // No need to redirect for change-password.jsp if they can just view it. 
        // We'll update handleChangePassword later.
        
        System.out.println("Done patch change-password jsp!");
    }
}
