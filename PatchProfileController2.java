import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchProfileController2 {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/ProfileController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        // handleShowEditProfile
        String oldShowEdit = "private void handleShowEditProfile(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws ServletException, IOException {\n" +
            "        // Reader dã có trong session\n" +
            "        request.getRequestDispatcher(\"/jsp/profile/edit-profile.jsp\").forward(request, response);\n" +
            "    }";
            
        String newShowEdit = "private void handleShowEditProfile(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws ServletException, IOException {\n" +
            "        if (!(request.getSession().getAttribute(AuthUtil.SESSION_USER) instanceof Reader)) {\n" +
            "            response.sendRedirect(request.getContextPath() + \"/profile/view\");\n" +
            "            return;\n" +
            "        }\n" +
            "        request.getRequestDispatcher(\"/jsp/profile/edit-profile.jsp\").forward(request, response);\n" +
            "    }";
        text = text.replace(oldShowEdit, newShowEdit);
        text = text.replace(oldShowEdit.replace("\n", "\r\n"), newShowEdit);

        // handleUpdateProfile
        text = text.replace("Reader sessionReader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);",
            "Object userAttr = request.getSession().getAttribute(AuthUtil.SESSION_USER);\n" +
            "        if (!(userAttr instanceof Reader)) {\n" +
            "            response.sendRedirect(request.getContextPath() + \"/profile/view\");\n" +
            "            return;\n" +
            "        }\n" +
            "        Reader sessionReader = (Reader) userAttr;");

        // allow Employee to see linked accounts? No, just block them.
        String oldShowLinked = "private void handleShowLinkedAccounts(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws ServletException, IOException {\n" +
            "        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);";
        String newShowLinked = "private void handleShowLinkedAccounts(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws ServletException, IOException {\n" +
            "        Object userAttr = request.getSession().getAttribute(AuthUtil.SESSION_USER);\n" +
            "        if (!(userAttr instanceof Reader)) {\n" +
            "            response.sendRedirect(request.getContextPath() + \"/profile/view\");\n" +
            "            return;\n" +
            "        }\n" +
            "        Reader reader = (Reader) userAttr;";
        text = text.replace(oldShowLinked, newShowLinked);
        text = text.replace(oldShowLinked.replace("\n", "\r\n"), newShowLinked);
        
        String oldUnlink = "private void handleUnlinkAccount(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws ServletException, IOException {\n" +
            "        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);";
        String newUnlink = "private void handleUnlinkAccount(HttpServletRequest request, HttpServletResponse response)\n" +
            "            throws ServletException, IOException {\n" +
            "        Object userAttr = request.getSession().getAttribute(AuthUtil.SESSION_USER);\n" +
            "        if (!(userAttr instanceof Reader)) {\n" +
            "            response.sendRedirect(request.getContextPath() + \"/profile/view\");\n" +
            "            return;\n" +
            "        }\n" +
            "        Reader reader = (Reader) userAttr;";
        text = text.replace(oldUnlink, newUnlink);
        text = text.replace(oldUnlink.replace("\n", "\r\n"), newUnlink);

        // Ensure imports
        if (!text.contains("import model.Employee;")) {
            text = text.replace("import model.Reader;", "import model.Reader;\nimport model.Employee;\nimport dao.EmployeeDAO;");
        }

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Part 2 Done!");
    }
}
