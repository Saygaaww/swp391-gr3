import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchNotif2 {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/NotificationController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        text = text.replaceAll("Reader reader = \\(Reader\\)\\s*request\\.getSession\\(\\)\\.getAttribute\\(AuthUtil\\.SESSION_USER\\);\\s*NotificationDAO dao = null;\\s*try \\{\\s*dao = new NotificationDAO\\(\\);\\s*request\\.setAttribute\\(\"notifications\",\\s*dao\\.getAllNotifications\\(reader\\.getReaderId\\(\\)\\)\\);\\s*request\\.setAttribute\\(\"unreadCount\",\\s*dao\\.getUnreadCount\\(reader\\.getReaderId\\(\\)\\)\\);", "Object su = request.getSession().getAttribute(AuthUtil.SESSION_USER);\n          int rId = 0;\n          if (su instanceof model.Reader) { rId = ((model.Reader)su).getReaderId(); } else if (su instanceof model.Employee) { rId = ((model.Employee)su).getEmpId(); }\n          NotificationDAO dao = null;\n          try {\n              dao = new NotificationDAO();\n              request.setAttribute(\"notifications\",\n                      dao.getAllNotifications(rId));\n              request.setAttribute(\"unreadCount\",\n                      dao.getUnreadCount(rId));");
        
        text = text.replaceAll("Reader reader = \\(Reader\\)\\s*request\\.getSession\\(\\)\\.getAttribute\\(AuthUtil\\.SESSION_USER\\);\\s*String pathInfo = request\\.getPathInfo\\(\\);\\s*if \\(pathInfo == null\\)\\s*pathInfo = \"\";\\s*NotificationDAO dao = null;\\s*try \\{\\s*dao = new NotificationDAO\\(\\);\\s*if \\(\"/mark-read\"\\.equals\\(pathInfo\\)\\) \\{\\s*String notifIdStr = request\\.getParameter\\(\"notificationId\"\\);\\s*if \\(\"all\"\\.equals\\(notifIdStr\\)\\) \\{\\s*dao\\.markAllAsRead\\(reader\\.getReaderId\\(\\)\\);\\s*\\} else \\{\\s*int notifId = Integer\\.parseInt\\(notifIdStr\\);\\s*dao\\.markAsRead\\(notifId, reader\\.getReaderId\\(\\)\\);", "Object su = request.getSession().getAttribute(AuthUtil.SESSION_USER);\n          int rId = 0;\n          if (su instanceof model.Reader) { rId = ((model.Reader)su).getReaderId(); } else if (su instanceof model.Employee) { rId = ((model.Employee)su).getEmpId(); }\n\n          String pathInfo = request.getPathInfo();\n          if (pathInfo == null)\n              pathInfo = \"\";\n\n          NotificationDAO dao = null;\n          try {\n              dao = new NotificationDAO();\n              if (\"/mark-read\".equals(pathInfo)) {\n                  String notifIdStr = request.getParameter(\"notificationId\");\n                  if (\"all\".equals(notifIdStr)) {\n                      dao.markAllAsRead(rId);\n                  } else {\n                      int notifId = Integer.parseInt(notifIdStr);\n                      dao.markAsRead(notifId, rId);");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Modified NotificationController.java fully");
    }
}
