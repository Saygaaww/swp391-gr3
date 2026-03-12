import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.IOException;

public class FixJsp {
    public static void main(String[] args) {
        try {
            Path path = Paths.get(
                    "c:\\Users\\tenma\\OneDrive\\Documents\\NetBeansProjects\\Library\\web\\WEB-INF\\jsp\\admin\\users.jsp");
            String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

            // Fix form URLs
            content = content.replace("/admin/users", "/admin/readers");

            if (!content.contains("grant_seller")) {
                String target = "                                                            <td>\r\n" +
                        "                                                                <c:choose>";
                String targetUnix = "                                                            <td>\n" +
                        "                                                                <c:choose>";

                String injection = "                                                            <td>\n" +
                        "                                                                <c:choose>\n" +
                        "                                                                    <c:when test=\"${not empty r.roleName and r.roleName.equalsIgnoreCase('SELLER')}\">\n"
                        +
                        "                                                                        <!-- Da la Seller -->\n"
                        +
                        "                                                                    </c:when>\n" +
                        "                                                                    <c:otherwise>\n" +
                        "                                                                        <form action=\"${pageContext.request.contextPath}/admin/readers\" method=\"post\" style=\"display:inline;\">\n"
                        +
                        "                                                                            <input type=\"hidden\" name=\"action\" value=\"grant_seller\">\n"
                        +
                        "                                                                            <input type=\"hidden\" name=\"id\" value=\"${r.readerId}\">\n"
                        +
                        "                                                                            <button type=\"submit\" class=\"btn btn-sm btn-outline-success me-1\" onclick=\"return confirm('Cap quyen Seller cho tk nay?')\"><i class=\"fas fa-user-tag\"></i> Cap Seller</button>\n"
                        +
                        "                                                                        </form>\n" +
                        "                                                                    </c:otherwise>\n" +
                        "                                                                </c:choose>\n" +
                        "                                                                <c:choose>";

                if (content.contains(target)) {
                    content = content.replace(target, injection);
                    System.out.println("Replaced (CRLF)");
                } else if (content.contains(targetUnix)) {
                    content = content.replace(targetUnix, injection);
                    System.out.println("Replaced (LF)");
                } else {
                    System.out.println("Target string not found in users.jsp!");
                }
            } else {
                System.out.println("grant_seller is already present!");
            }

            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            System.out.println("Done processing.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
