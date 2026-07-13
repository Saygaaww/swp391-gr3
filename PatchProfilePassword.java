import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchProfilePassword {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/ProfileController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        // Replace handleChangePassword entirely
        int start = text.indexOf("private void handleChangePassword");
        int end = text.indexOf("private void handleShowLinkedAccounts", start);
        if (start != -1 && end != -1) {
            String newMethod = "private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)\n" +
                "            throws ServletException, IOException {\n" +
                "\n" +
                "        Object userAttr = request.getSession().getAttribute(AuthUtil.SESSION_USER);\n" +
                "        if (userAttr == null) {\n" +
                "            response.sendRedirect(request.getContextPath() + \"/auth/login\");\n" +
                "            return;\n" +
                "        }\n" +
                "\n" +
                "        boolean isReader = userAttr instanceof model.Reader;\n" +
                "        boolean hasPassword = false;\n" +
                "        int userId = -1;\n" +
                "        String currentHash = \"\";\n" +
                "        \n" +
                "        if (isReader) {\n" +
                "            model.Reader r = (model.Reader) userAttr;\n" +
                "            hasPassword = r.hasPassword();\n" +
                "            userId = r.getReaderId();\n" +
                "            currentHash = r.getPasswordHash();\n" +
                "        } else if (userAttr instanceof model.Employee) {\n" +
                "            model.Employee e = (model.Employee) userAttr;\n" +
                "            hasPassword = e.hasPassword();\n" +
                "            userId = e.getEmployeeId();\n" +
                "            currentHash = e.getPasswordHash();\n" +
                "        }\n" +
                "\n" +
                "        if (isReader && !hasPassword) {\n" +
                "            request.setAttribute(\"error\", \"Tài kho?n c?a b?n dang nh?p qua m?ng xã h?i. Vui lòng thi?t l?p m?t kh?u.\");\n" +
                "            request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n" +
                "            return;\n" +
                "        }\n" +
                "\n" +
                "        String currentPassword = request.getParameter(\"currentPassword\");\n" +
                "        String newPassword = request.getParameter(\"newPassword\");\n" +
                "        String confirmPassword = request.getParameter(\"confirmPassword\");\n" +
                "\n" +
                "        try {\n" +
                "            if (!util.PasswordUtil.verifyPassword(currentPassword, currentHash)) {\n" +
                "                request.setAttribute(\"error\", \"M?t kh?u hi?n t?i không dúng.\");\n" +
                "                request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n" +
                "                return;\n" +
                "            }\n" +
                "            if (!util.PasswordUtil.isStrongPassword(newPassword)) {\n" +
                "                request.setAttribute(\"error\", \"M?t kh?u m?i ph?i có ít nh?t 8 ký t?, ch? hoa, ch? thu?ng và s?.\");\n" +
                "                request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n" +
                "                return;\n" +
                "            }\n" +
                "            if (!newPassword.equals(confirmPassword)) {\n" +
                "                request.setAttribute(\"error\", \"Xác nh?n m?t kh?u m?i không kh?p.\");\n" +
                "                request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n" +
                "                return;\n" +
                "            }\n" +
                "\n" +
                "            boolean success = false;\n" +
                "            if (isReader) {\n" +
                "                dao.ReaderDAO readerDAO = new dao.ReaderDAO();\n" +
                "                success = readerDAO.updatePasswordHash(userId, util.PasswordUtil.hashPassword(newPassword));\n" +
                "                if (success) {\n" +
                "                   model.Reader updatedReader = readerDAO.findById(userId);\n" +
                "                   request.getSession().setAttribute(util.AuthUtil.SESSION_USER, updatedReader);\n" +
                "                }\n" +
                "                readerDAO.close();\n" +
                "            } else {\n" +
                "                dao.EmployeeDAO empDAO = new dao.EmployeeDAO();\n" +
                "                success = empDAO.updatePasswordHash(userId, util.PasswordUtil.hashPassword(newPassword));\n" +
                "                if (success) {\n" +
                "                   model.Employee updatedEmp = empDAO.findById(userId);\n" +
                "                   request.getSession().setAttribute(util.AuthUtil.SESSION_USER, updatedEmp);\n" +
                "                }\n" +
                "                empDAO.close();\n" +
                "            }\n" +
                "\n" +
                "            if (success) {\n" +
                "                request.setAttribute(\"success\", \"Ð?i m?t kh?u thành công!\");\n" +
                "            } else {\n" +
                "                request.setAttribute(\"error\", \"Không th? d?i m?t kh?u. Vui lòng th? l?i.\");\n" +
                "            }\n" +
                "            request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n" +
                "        } catch (Exception e) {\n" +
                "            e.printStackTrace();\n" +
                "            request.setAttribute(\"error\", \"Có l?i x?y ra.\");\n" +
                "            request.getRequestDispatcher(\"/jsp/profile/change-password.jsp\").forward(request, response);\n" +
                "        }\n" +
                "    }\n\n    ";
            
            text = text.substring(0, start) + newMethod + text.substring(end);
        } else {
            System.out.println("Could not find method handleShowLinkedAccounts to replace.");
        }

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done patch ProfileController password!");
    }
}
