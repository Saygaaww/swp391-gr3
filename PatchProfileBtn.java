import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class PatchProfileBtn {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("web/jsp/profile/view-profile.jsp");
        String text = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

        text = text.replace("<button class=\"edit-btn\" onclick=\"openModal()\">", "<% if (isReader) { %><button class=\"edit-btn\" onclick=\"openModal()\">");
        text = text.replace("<i class=\"fas fa-pen\"></i> Ch?nh s?a\r\n                </button>", "<i class=\"fas fa-pen\"></i> Ch?nh s?a\r\n                </button>\n<% } %>");
        text = text.replace("<i class=\"fas fa-pen\"></i> Ch?nh s?a\n                </button>", "<i class=\"fas fa-pen\"></i> Ch?nh s?a\n                </button>\n<% } %>");

        Files.write(path, text.getBytes(StandardCharsets.UTF_8));
        System.out.println("Done Patch Profile Button!");
    }
}
