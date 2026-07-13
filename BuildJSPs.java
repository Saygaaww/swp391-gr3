import java.io.*;
import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class BuildJSPs {
    public static void main(String[] args) throws Exception {
        String dashPath = "web/WEB-INF/jsp/admin/dashboard.jsp";
        String readersIn = "dung_reader_list.jsp";
        String employeesIn = "dung_employee_list.jsp";
        String readersOut = "web/WEB-INF/jsp/admin/users.jsp";
        String employeesOut = "web/WEB-INF/jsp/admin/employees.jsp";

        String dashHtml = new String(Files.readAllBytes(Paths.get(dashPath)), StandardCharsets.UTF_8);

        int sbStart = dashHtml.indexOf("<!-- SIDEBAR -->");
        int sbEnd = dashHtml.indexOf("<!-- MAIN CONTENT -->");
        String sidebar = dashHtml.substring(sbStart, sbEnd);

        int styleStart = dashHtml.indexOf("<style>");
        int styleEnd = dashHtml.indexOf("</style>");
        String dashStyles = dashHtml.substring(styleStart + 7, styleEnd);

        processJsp(readersIn, readersOut, "fa-users", "Quản lý Độc giả", sidebar, dashStyles);
        processJsp(employeesIn, employeesOut, "fa-user-tie", "Quản lý Nhân viên", sidebar, dashStyles);
        System.out.println("Done!");
    }

    private static void processJsp(String inPath, String outPath, String titleIcon, String titleText, String sidebar,
            String dashStyles) throws Exception {
        String html = new String(Files.readAllBytes(Paths.get(inPath)), StandardCharsets.UTF_8);

        html = html.replace("<%@ page contentType=\"text/html; charset=UTF-8\" pageEncoding=\"UTF-8\"%>",
                "<%@ page contentType=\"text/html;charset=UTF-8\" language=\"java\" %>\n<%@ page import=\"model.Employee, util.AuthUtil\" %>\n<% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); %>");

        html = html.replace("<style>", "<style>\n" + dashStyles + "\n/* DUNG STYLES */\n");
        html = html.replace("body { font-family:", "/* body { font-family:");
        html = html.replace(".header { background:", "/* .header { background:");
        html = html.replace(".container { max-width:", "/* .container { max-width:");

        int headStart = html.indexOf("<div class=\"header\">");
        int headEnd = html.indexOf("<div class=\"container\">");

        if (headStart != -1 && headEnd != -1) {
            String newBody = "<body>\n" + sidebar + "\n<!-- MAIN CONTENT -->\n<main class=\"main-content\">\n";
            newBody += "<div class=\"page-header\"><h1 class=\"page-title\"><i class=\"fas " + titleIcon + "\"></i> "
                    + titleText + "</h1></div>\n";
            newBody += "<div style=\"max-width: 100%;\">";

            html = html.substring(0, html.indexOf("<body>")) + newBody + html.substring(headEnd + 23);
            html = html.replace("</body>", "</div>\n</main>\n</body>");
        }

        Files.write(Paths.get(outPath), html.getBytes(StandardCharsets.UTF_8));
    }
}
