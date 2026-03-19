import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchProfile {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/view-profile.jsp");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);
        
        String oldHead = "<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER); \r\n   Employee currentEmployee = (Employee) session.getAttribute(AuthUtil.SESSION_EMPLOYEE_ID);\r\n%>";
        String oldHeadFallback = "<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER); \n   Employee currentEmployee = (Employee) session.getAttribute(AuthUtil.SESSION_EMPLOYEE_ID);\n%>";
        
        String newHead = "<%\n" +
            "    Object sessionUser = session.getAttribute(AuthUtil.SESSION_USER);\n" +
            "    String pName = \"—\";\n" +
            "    String pEmail = \"—\";\n" +
            "    String pPhone = \"—\";\n" +
            "    String pRole = \"—\";\n" +
            "    String pAvatar = null;\n" +
            "    String pInitials = \"?\";\n" +
            "    boolean isReader = false;\n" +
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
            "    } else if (sessionUser instanceof model.Employee) {\n" +
            "        model.Employee e = (model.Employee) sessionUser;\n" +
            "        pName = e.getFullName();\n" +
            "        pEmail = e.getEmail();\n" +
            "        pRole = e.getRoleName() != null ? e.getRoleName() : \"Nhân viên\";\n" +
            "        pInitials = pName != null && pName.length() > 0 ? String.valueOf(pName.charAt(0)).toUpperCase() : \"?\";\n" +
            "    }\n" +
            "%>";

        text = text.replace(oldHead, newHead);
        text = text.replace(oldHeadFallback, newHead);

        text = text.replace("<% if (currentReader != null && currentReader.getAvatarUrl() != null\r\n                                && !currentReader.getAvatarUrl().isBlank()) {%>", "<% if (pAvatar != null && !pAvatar.trim().isEmpty()) {%>");
        text = text.replace("<% if (currentReader != null && currentReader.getAvatarUrl() != null\n                                && !currentReader.getAvatarUrl().isBlank()) {%>", "<% if (pAvatar != null && !pAvatar.trim().isEmpty()) {%>");
        text = text.replace("<img src=\"<%= currentReader.getAvatarUrl()%>\"", "<img src=\"<%= pAvatar %>\"");
        text = text.replace("<%= currentReader != null ? currentReader.getInitials() : \"?\"%>", "<%= pInitials %>");
        text = text.replace("<%= currentReader != null ? currentReader.getFullName() : \"—\"%>", "<%= pName %>");
        text = text.replace("<%= currentReader != null ? currentReader.getEmail() : \"—\"%>", "<%= pEmail %>");
        text = text.replace("<span class=\"role-badge\"><i class=\"fas fa-shield-alt\"></i> <%= currentReader != null && currentReader.getRoleName() != null ? currentReader.getRoleName() : \"Ð?c gi?\"%></span>", "<span class=\"role-badge\"><i class=\"fas fa-shield-alt\"></i> <%= pRole %></span>");
        text = text.replace("<button class=\"edit-btn\" onclick=\"openEditModal()\">", "<% if (isReader) { %><button class=\"edit-btn\" onclick=\"openEditModal()\">\n<i class=\"fas fa-pen\"></i> Ch?nh s?a</button>\n<% } %>");
        text = text.replace("<div class=\"info-val\"><%= currentReader != null && currentReader.getPhone() != null ? currentReader.getPhone() : \"Chua c?p nh?t\"%></div>", "<div class=\"info-val\"><%= pPhone %></div>");
        text = text.replace("<div class=\"info-val\"><%= currentReader != null && currentReader.getRoleName() != null ? currentReader.getRoleName() : \"Ð?c gi?\"%></div>", "<div class=\"info-val\"><%= pRole %></div>");
        text = text.replace("if (currentReader == null) {", "if (!isReader) {");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done!");
    }
}
