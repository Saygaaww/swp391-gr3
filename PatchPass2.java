import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchPass2 {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/change-password.jsp");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        // We replace form content to include UI separation logic
        String oldFormPart = "<div class=\"form-group\">\n" +
            "                                                        <label for=\"newPassword\">";
        String oldFormPartR = "<div class=\"form-group\">\r\n" +
            "                                                        <label for=\"newPassword\">";

        String btnHtmlStr = "         <button type=\"button\" id=\"btnNext\" class=\"btn-primary\" onclick=\"showNewPwd()\" style=\"margin-bottom:15px; width: 100%;\">Ti?p t?c</button>\n" +
                            "         <div id=\"newPwdFields\" style=\"display:none;\">\n";

        text = text.replace(oldFormPart, btnHtmlStr + oldFormPart);
        text = text.replace(oldFormPartR, btnHtmlStr + oldFormPartR);

        String endFormPart = "<button type=\"submit\" class=\"btn-primary\">C?p nh?t m?t kh?u</button>\n" +
            "                                                </form>";
        String endFormPartR = "<button type=\"submit\" class=\"btn-primary\">C?p nh?t m?t kh?u</button>\r\n" +
            "                                                </form>";

        String endBtnStr = "<button type=\"submit\" class=\"btn-primary\" style=\"width: 100%;\">C?p nh?t m?t kh?u</button>\n</div>\n</form>";
        text = text.replace(endFormPart, endBtnStr);
        text = text.replace(endFormPartR, endBtnStr);
        
        // Add javascript at the bottom of the JSP
        String js = "<script>\n" +
            "function showNewPwd() {\n" +
            "    var current = document.getElementById('currentPassword').value;\n" +
            "    if (current.trim().length === 0) {\n" +
            "        alert('Vui lòng nh?p m?t kh?u hi?n t?i tru?c!');\n" +
            "        document.getElementById('currentPassword').focus();\n" +
            "        return;\n" +
            "    }\n" +
            "    document.getElementById('newPwdFields').style.display = 'block';\n" +
            "    document.getElementById('btnNext').style.display = 'none';\n" +
            "    document.getElementById('currentPassword').setAttribute('readonly', 'true');\n" +
            "    document.getElementById('currentPassword').style.backgroundColor = '#e5e7eb';\n" +
            "    document.getElementById('newPassword').focus();\n" +
            "}\n" +
            "</script>\n";

        text = text.replace("</body>", js + "</body>");

        // fix currentReader inside change-password.jsp one more time thoroughly
        text = text.replaceAll("<% if \\(currentReader !=null && !currentReader.hasPassword\\(\\)\\) \\{ %>", 
                   "<% boolean hasPwd = false; if (su instanceof model.Reader) hasPwd = ((model.Reader)su).hasPassword(); else if (su instanceof model.Employee) hasPwd = ((model.Employee)su).hasPassword(); if (!hasPwd) { %>");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done frontend password patch!");
    }
}
