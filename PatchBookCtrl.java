import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchBookCtrl {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/BookController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        // Fix logic where error happens and book is not restored
        text = text.replaceAll("if \\(StringUtil\\.isBlank\\(title\\)\\) \\{\\s*request\\.setAttribute\\(\"error\", \"[^\"]*\"\\);\\s*handleBookForm\\(request, response, formPath\\);\\s*return;\\s*\\}",
            "if (StringUtil.isBlank(title)) { request.setAttribute(\"error\", \"Tựa sách không được để trống.\"); handleBookForm(request, response, formPath); return; }");

        // Actually wait, let's look at what handleBookForm does.
        // It always queries a new book if pathInfo is null. It doesn't retain user input when there's an error.
        
        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Modified BookController.java slightly");
    }
}
