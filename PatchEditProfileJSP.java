import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchEditProfileJSP {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/edit-profile.jsp");
        if (!Files.exists(path)) return;
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        String oldHead = "<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER); %>";
        String oldHead2 = "<% Reader currentReader=(Reader) session.getAttribute(AuthUtil.SESSION_USER); %>";
        String newHead = "<% Object su = session.getAttribute(AuthUtil.SESSION_USER); Reader currentReader = (su instanceof model.Reader) ? (model.Reader)su : null; %>";
        
        text = text.replace(oldHead, newHead);
        text = text.replace(oldHead2, newHead);

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done patch edit-profile jsp!");
    }
}
