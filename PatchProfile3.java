import java.nio.file.*;
import java.util.regex.*;
import java.nio.charset.StandardCharsets;

public class PatchProfile3 {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/view-profile.jsp");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        String newHead = "<%\n" +
            "    Object sessionUser = session.getAttribute(AuthUtil.SESSION_USER);\n" +
            "    String pName = \"—\";\n" +
            "    String pEmail = \"—\";\n" +
            "    String pPhone = \"—\";\n" +
            "    String pRole = \"—\";\n" +
            "    String pAvatar = null;\n" +
            "    String pInitials = \"?\";\n" +
            "    boolean isReader = false;\n" +
            "    boolean hasPwd = false;\n" +
            "    \n" +
            "    if (sessionUser instanceof model.Reader) {\n" +
            "        model.Reader r = (model.Reader) sessionUser;\n" +
            "        pName = r.getFullName();\n" +
            "        pEmail = r.getEmail();\n" +
            "        pPhone = r.getPhone() != null && !r.getPhone().isEmpty() ? r.getPhone() : \"Chua c?p nh?t\";\n" +
            "        pRole = r.getRoleName() != null ? r.getRoleName() : \"Ð?c gi?\";\n" +
            "        pAvatar = r.getAvatarUrl();\n" +
            "        pInitials = r.getInitials();\n" +
            "        isReader = true;\n" +
            "        hasPwd = r.hasPassword();\n" +
            "    } else if (sessionUser instanceof model.Employee) {\n" +
            "        model.Employee e = (model.Employee) sessionUser;\n" +
            "        pName = e.getFullName();\n" +
            "        pEmail = e.getEmail();\n" +
            "        pRole = e.getRoleName() != null ? e.getRoleName() : \"Nhân viên\";\n" +
            "        pInitials = pName != null && pName.length() > 0 ? String.valueOf(pName.charAt(0)).toUpperCase() : \"?\";\n" +
            "        hasPwd = e.hasPassword();\n" +
            "    }\n" +
            "%>";

        text = text.replaceAll("<%\\s*Reader currentReader\\s*=\\s*\\(Reader\\)\\s*session\\.getAttribute\\(AuthUtil\\.SESSION_USER\\);\\s*Employee currentEmployee\\s*=\\s*\\(Employee\\)\\s*session\\.getAttribute\\(AuthUtil\\.SESSION_EMPLOYEE_ID\\);\\s*%>", Matcher.quoteReplacement(newHead));
        text = text.replaceAll("<%\\s*String phone\\s*=\\s*currentReader\\s*!=\\s*null\\s*\\?\\s*currentReader\\.getPhone\\(\\)\\s*:\\s*null;\\s*%>", "<% String phone = pPhone; %>");
        text = text.replaceAll("<%\\s*boolean hasPwd\\s*=\\s*currentReader\\s*!=\\s*null\\s*&&\\s*currentReader\\.hasPassword\\(\\);\\s*%>", "");
        
        text = text.replace("<% if (currentReader != null && currentReader.getAvatarUrl() != null", "<% if (pAvatar != null");
        text = text.replace("&& !currentReader.getAvatarUrl().isBlank()) {%>", "&& !pAvatar.trim().isEmpty()) {%>");
        
        text = text.replace("<%= currentReader != null && currentReader.getAvatarUrl() != null ?", "<%= pAvatar != null ?");
        text = text.replace("currentReader.getAvatarUrl() : \"\"%>", "pAvatar : \"\"%>");
        
        text = text.replace("<%= currentReader != null && currentReader.getFullName() != null ?", "<%= pName != null ?");
        text = text.replace("currentReader.getFullName() : \"\"%>", "pName : \"\"%>");
        
        text = text.replace("<%= currentReader != null && currentReader.getEmail() != null ?", "<%= pEmail != null ?");
        text = text.replace("currentReader.getEmail() : \"\"%>", "pEmail : \"\"%>");
        
        text = text.replace("<%= currentReader != null && currentReader.getPhone() != null ?", "<%= pPhone != null ?");
        text = text.replace("currentReader.getPhone() : \"\"%>", "pPhone : \"\"%>");

        text = text.replace("<% if (currentReader == null) { %>", "<% if (!isReader) { %>");

        // wrap modal
        text = text.replace("<div class=\"modal-overlay\" id=\"editModal\">", "<% if (isReader) { %><div class=\"modal-overlay\" id=\"editModal\">");
        text = text.replace("</form>\r\n            </div>\r\n        </div>", "</form>\r\n            </div>\r\n        </div><% } %>");
        text = text.replace("</form>\n            </div>\n        </div>", "</form>\n            </div>\n        </div><% } %>");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done Patch Profile 3!");
    }
}
