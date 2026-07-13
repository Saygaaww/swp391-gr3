import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchPass {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/change-password.jsp");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        text = text.replace("<% if (currentReader !=null && !currentReader.hasPassword()) { %>", "<% boolean hasPwd = false;\nif (su instanceof model.Reader) hasPwd = ((model.Reader)su).hasPassword();\nelse if (su instanceof model.Employee) hasPwd = ((model.Employee)su).hasPassword();\nif (isReader && !hasPwd) { %>");

        // Hide new password and confirm password until old password is confirmed... we can just do JS logic. Or hide them with CSS and add an "Next" button.
        String formHtml = "                                                    <div class=\"form-group\" id=\"currentPwdGroup\">\n" +
            "                                                        <label for=\"currentPassword\">M?t kh?u hi?n t?i *</label>\n" +
            "                                                        <div class=\"input-wrap\">\n" +
            "                                                            <i class=\"fas fa-lock icon\"></i>\n" +
            "                                                            <input type=\"password\" id=\"currentPassword\"\n" +
            "                                                                name=\"currentPassword\" placeholder=\"M?t kh?u hi?n t?i\"\n" +
            "                                                                required>\n" +
            "                                                            <button type=\"button\"\n" +
            "                                                                class=\"toggle-password\"\n" +
            "                                                                onclick=\"togglePwd('currentPassword','i1')\"><i\n" +
            "                                                                    class=\"fas fa-eye\" id=\"i1\"></i></button>\n" +
            "                                                        </div>\n" +
            "                                                    </div>\n" +
            "                                                    <button type=\"button\" id=\"btnNext\" class=\"btn-primary\" onclick=\"showNewPwd()\" style=\"margin-bottom:15px;\">Ti?p t?c</button>\n" +
            "                                                    <div id=\"newPwdFields\" style=\"display:none;\">\n" +
            "                                                    <div class=\"form-group\">\n" +
            "                                                        <label for=\"newPassword\">M?t kh?u m?i *</label>\n" +
            "                                                        <div class=\"input-wrap\">\n" +
            "                                                            <i class=\"fas fa-key icon\"></i>\n" +
            "                                                            <input type=\"password\" id=\"newPassword\" name=\"newPassword\"\n" +
            "                                                                placeholder=\"T?i thi?u 8 ký t?\" required>\n" +
            "                                                            <button type=\"button\"\n" +
            "                                                                class=\"toggle-password\"\n" +
            "                                                                onclick=\"togglePwd('newPassword','i2')\"><i\n" +
            "                                                                    class=\"fas fa-eye\" id=\"i2\"></i></button>\n" +
            "                                                        </div>\n" +
            "                                                    </div>\n";

        text = text.replace("                                                    <div class=\"form-group\">\r\n                                                        <label for=\"currentPassword\">", formHtml.substring(0, formHtml.indexOf("<label for=\"currentPassword\">")));
        text = text.replace("                                                    <div class=\"form-group\">\n                                                        <label for=\"currentPassword\">", formHtml.substring(0, formHtml.indexOf("<label for=\"currentPassword\">")));
        
        text = text.replace("<button type=\"submit\" class=\"btn-primary\">C?p nh?t m?t kh?u</button>", "<button type=\"submit\" class=\"btn-primary\">C?p nh?t m?t kh?u</button>\n</div>");
        
        // Let's just simply replace the whole form element instead to be safe.
        // It's safer to just provide the frontend logic without breaking things.
        
        System.out.println("Wait, safer approach next.");
    }
}
