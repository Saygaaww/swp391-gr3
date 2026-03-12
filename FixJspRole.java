import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.IOException;

public class FixJspRole {
    public static void main(String[] args) {
        try {
            Path path = Paths.get(
                    "c:\\Users\\tenma\\OneDrive\\Documents\\NetBeansProjects\\Library\\web\\WEB-INF\\jsp\\admin\\users.jsp");
            String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);
            System.out.println("Read file success, length=" + content.length());

            // Thay the vung chua role badge hoac select form
            String targetRegex = "<td>\\s*<span\\s+class=\"role-badge\">\\s*\\$\\{r\\.roleName\\}\\s*</span>\\s*</td>";

            String replacementRole = "<td>\n" +
                    "                                                                <form action=\"${pageContext.request.contextPath}/admin/readers\" method=\"post\" style=\"display:inline;\">\n"
                    +
                    "                                                                    <input type=\"hidden\" name=\"action\" value=\"change_role\">\n"
                    +
                    "                                                                    <input type=\"hidden\" name=\"id\" value=\"${r.readerId}\">\n"
                    +
                    "                                                                    <select name=\"roleId\" class=\"form-select form-select-sm shadow-none\" style=\"width:110px; display:inline-block;\"\n"
                    +
                    "                                                                        onchange=\"if(confirm('Thay dổi vai trò nguòi dùng này sang ' + this.options[this.selectedIndex].text + '?')) this.form.submit(); else this.value='${r.roleId}';\">\n"
                    +
                    "                                                                        <c:forEach var=\"role\" items=\"${roles}\">\n"
                    +
                    "                                                                            <option value=\"${role.roleId}\" ${r.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>\n"
                    +
                    "                                                                        </c:forEach>\n" +
                    "                                                                    </select>\n" +
                    "                                                                </form>\n" +
                    "                                                            </td>";

            String orig = content;
            content = content.replaceAll(targetRegex, java.util.regex.Matcher.quoteReplacement(replacementRole));
            if (!orig.equals(content)) {
                System.out.println("Replaced role-badge span with select dropdown.");
            }

            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            System.out.println("Done rewriting jsp.");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
