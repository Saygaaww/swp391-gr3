import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchProfileController {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/ProfileController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);
        
        text = text.replace("if (!requireReaderLogin(request, response))", "if (!requireLogin(request, response))");

        String oldRequire = "private boolean requireReaderLogin(HttpServletRequest request, HttpServletResponse response)\r\n" +
            "            throws IOException {\r\n" +
            "        String role = AuthUtil.getUserRole(request);\r\n" +
            "        boolean allowed = AuthUtil.isLoggedIn(request) &&\r\n" +
            "                (AuthUtil.ROLE_READER.equals(role) || \"User\".equals(role));\r\n" +
            "        if (!allowed) {\r\n" +
            "            String currentPath = request.getRequestURI().replace(request.getContextPath(), \"\");\r\n" +
            "            response.sendRedirect(request.getContextPath() + \"/auth/login?redirect=\" + currentPath);\r\n" +
            "            return false;\r\n" +
            "        }\r\n" +
            "        return true;\r\n" +
            "    }";

        String oldRequireLF = "private boolean requireReaderLogin(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws IOException {\n" +
            "        String role = AuthUtil.getUserRole(request);\n" +
            "        boolean allowed = AuthUtil.isLoggedIn(request) &&\n" +
            "                (AuthUtil.ROLE_READER.equals(role) || \"User\".equals(role));\n" +
            "        if (!allowed) {\n" +
            "            String currentPath = request.getRequestURI().replace(request.getContextPath(), \"\");\n" +
            "            response.sendRedirect(request.getContextPath() + \"/auth/login?redirect=\" + currentPath);\n" +
            "            return false;\n" +
            "        }\n" +
            "        return true;\n" +
            "    }";

        String newRequire = "private boolean requireLogin(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws IOException {\n" +
            "        if (!AuthUtil.isLoggedIn(request)) {\n" +
            "            String currentPath = request.getRequestURI().replace(request.getContextPath(), \"\");\n" +
            "            response.sendRedirect(request.getContextPath() + \"/auth/login?redirect=\" + currentPath);\n" +
            "            return false;\n" +
            "        }\n" +
            "        return true;\n" +
            "    }";

        text = text.replace(oldRequire, newRequire);
        text = text.replace(oldRequireLF, newRequire);

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done!");
    }
}
