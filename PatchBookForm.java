import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchBookForm {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/books/form.jsp");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        // Add required to select authorId
        text = text.replace("<select name=\"authorId\" class=\"form-control\">", "<select name=\"authorId\" class=\"form-control\" required>");
        
        // Add required to select categoryId
        text = text.replace("<select name=\"categoryId\" class=\"form-control\">", "<select name=\"categoryId\" class=\"form-control\" required>");
        
        // Add required to summary
        text = text.replace("<textarea name=\"summary\" class=\"form-control\"\n", "<textarea name=\"summary\" class=\"form-control\" required\n");
        text = text.replace("<textarea name=\"summary\"\n                                          class=\"form-control\"", "<textarea name=\"summary\"\n                                          class=\"form-control\" required");

        // Add required to language
        text = text.replace("<select name=\"language\" class=\"form-control\">", "<select name=\"language\" class=\"form-control\" required>");
        
        // Add required to publicationYear
        text = text.replace("<input type=\"number\" name=\"publicationYear\" class=\"form-control\"", "<input type=\"number\" name=\"publicationYear\" class=\"form-control\" required");

        // Add required to totalPages
        text = text.replace("<input type=\"number\" name=\"totalPages\" class=\"form-control\"", "<input type=\"number\" name=\"totalPages\" class=\"form-control\" required");

        // Add required to contentPath or description maybe? Let's just make sure summary is enough or add to description.
        text = text.replace("<textarea name=\"description\"\n                                          class=\"form-control\"", "<textarea name=\"description\"\n                                          class=\"form-control\" required");

        // Add required to price
        // actually price can be free, in UI it says "Giá (VNÐ) — d? tr?ng n?u mi?n phí" so it shouldn't be required.
        // Wait, "Giá (VNÐ) — d? tr?ng n?u mi?n phí" -> price is not required.

        // Also let's update backend BookController to handle blank better
        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Patched web/jsp/books/form.jsp");
    }
}
