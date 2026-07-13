import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchNotif3 {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("src/java/controller/NotificationController.java");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        text = text.replace(".getEmpId()", ".getEmployeeId()");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Modified NotificationController.java getEmployeeId");
    }
}
