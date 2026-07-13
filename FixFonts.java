import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

public class FixFonts {
    private static int filesFixed = 0;
    private static final String R = "\uFFFD";
    
    private static final Map<String, String> REPLACEMENTS = new HashMap<>();
    
    static {
        REPLACEMENTS.put("Ti" + R + "?n phạt", "Tiền phạt");
        REPLACEMENTS.put("Ti" + R + "?n mặt", "Tiền mặt");
        REPLACEMENTS.put("Ti" + R + "?n (Amount)", "Tiền (Amount)");
        REPLACEMENTS.put("ngư" + R + "?i dùng", "người dùng");
        REPLACEMENTS.put("Ngư" + R + "?i nhận", "Người nhận");
        REPLACEMENTS.put("quy" + R + "?n", "quyền");
        REPLACEMENTS.put("V" + R + "? trang chủ", "Về trang chủ");
        REPLACEMENTS.put(R + "Về Trang chủ", "Về Trang chủ");
        REPLACEMENTS.put(R + "?" + R + "?c lúc", "Đọc lúc");
        REPLACEMENTS.put(R + "Để lần sau", "Để lần sau");
        REPLACEMENTS.put(R + "? My Library", "Về My Library");
        REPLACEMENTS.put(R + "? Trang", "Về Trang");
        REPLACEMENTS.put(R + "? Quay lại đơn", "Quay lại đơn");
        REPLACEMENTS.put(R + "?" + R + "?c sách", "Đọc sách");
        REPLACEMENTS.put(R + "?" + R + "?c ngay", "Đọc ngay");
        REPLACEMENTS.put("S" + R + "ch", "Sách");
        REPLACEMENTS.put("Giá" + R, "Giá");
        REPLACEMENTS.put("C" + R + "n", "Còn");
        REPLACEMENTS.put("X" + R + "a S" + R + "ch N" + R + "y?", "Xóa Sách Này?");
        REPLACEMENTS.put("X" + R + "a", "Xóa");
        REPLACEMENTS.put("VNĐ?", "VNĐ");
        REPLACEMENTS.put(R + "? Duyệt sách", "Duyệt sách");
        REPLACEMENTS.put("bộ l" + R + "?c", "bộ lọc");
        REPLACEMENTS.put("Nguyễn Nhật " + R + "?nh", "Nguyễn Nhật Ánh");
    }

    public static void main(String[] args) throws Exception {
        String rootDir = args.length > 0 ? args[0] : "c:\\Users\\tenma\\Downloads\\swp391-gr3-dung-merge-hao-borrow\\web\\jsp";
        System.out.println("Scanning: " + rootDir);
        try (Stream<Path> paths = Files.walk(new File(rootDir).toPath())) {
            paths.filter(Files::isRegularFile)
                 .filter(p -> p.toString().endsWith(".jsp"))
                 .forEach(path -> {
                     try { fixFile(path); }
                     catch (Exception e) { System.err.println("Error: " + path + " - " + e.getMessage()); }
                 });
        }
        System.out.println("Done. Files fixed: " + filesFixed);
    }

    private static void fixFile(Path path) throws Exception {
        String content = Files.readString(path, StandardCharsets.UTF_8);
        String original = content;

        for (Map.Entry<String, String> entry : REPLACEMENTS.entrySet()) {
            content = content.replace(entry.getKey(), entry.getValue());
        }

        if (!content.equals(original)) {
            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            filesFixed++;
            System.out.println("Fixed: " + path.getFileName());
        }
    }
}
