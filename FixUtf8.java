import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class FixUtf8 {
    public static void main(String[] args) {
        try {
            Path path = Paths.get(
                    "c:\\Users\\tenma\\OneDrive\\Documents\\NetBeansProjects\\Library\\web\\WEB-INF\\jsp\\admin\\users.jsp");
            String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

            // Xoa bo phan Cap Seller hien tai
            String grantSellerCode = "                                                                <c:choose>\n" +
                    "                                                                    <c:when test=\"${not empty r.roleName and r.roleName.equalsIgnoreCase('SELLER')}\">\n"
                    +
                    "                                                                        <!-- Da la Seller -->\n" +
                    "                                                                    </c:when>\n" +
                    "                                                                    <c:otherwise>\n" +
                    "                                                                        <form action=\"${pageContext.request.contextPath}/admin/readers\" method=\"post\" style=\"display:inline;\">\n"
                    +
                    "                                                                            <input type=\"hidden\" name=\"action\" value=\"grant_seller\">\n"
                    +
                    "                                                                            <input type=\"hidden\" name=\"id\" value=\"${r.readerId}\">\n"
                    +
                    "                                                                            <button type=\"submit\" class=\"btn btn-sm btn-outline-success me-1\" onclick=\"return confirm('Cap quyen Seller cho tk nay?')\"><i class=\"fas fa-user-tag\"></i> Cap Seller</button>\n"
                    +
                    "                                                                        </form>\n" +
                    "                                                                    </c:otherwise>\n" +
                    "                                                                </c:choose>";
            content = content.replace(grantSellerCode + "\n", "");
            content = content.replace(grantSellerCode + "\r\n", "");

            String replaceRole = "<td>\n" +
                    "                                                                <form action=\"${pageContext.request.contextPath}/admin/readers\" method=\"post\" style=\"display:inline;\">\n"
                    +
                    "                                                                    <input type=\"hidden\" name=\"action\" value=\"change_role\">\n"
                    +
                    "                                                                    <input type=\"hidden\" name=\"id\" value=\"${r.readerId}\">\n"
                    +
                    "                                                                    <select name=\"roleId\" class=\"form-select form-select-sm shadow-none\" style=\"width:110px; display:inline-block;\"\n"
                    +
                    "                                                                        onchange=\"if(confirm('Thay đổi vai trò người dùng này sang ' + this.options[this.selectedIndex].text + '?')) this.form.submit(); else this.value='${r.roleId}';\">\n"
                    +
                    "                                                                        <c:forEach var=\"role\" items=\"${roles}\">\n"
                    +
                    "                                                                            <option value=\"${role.roleId}\" ${r.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>\n"
                    +
                    "                                                                        </c:forEach>\n" +
                    "                                                                    </select>\n" +
                    "                                                                </form>\n" +
                    "                                                            </td>";

            content = content.replace("<td><span class=\"role-badge\">${r.roleName}</span></td>", replaceRole);

            Map<String, String> d = new HashMap<>();
            d.put("Qu?n lï¿½ ï¿½?c gi?", "Quản lý độc giả");
            d.put("Trang ch?", "Trang chủ");
            d.put("T?ng d?c gi?", "Tổng độc giả");
            d.put("ï¿½ang ho?t d?ng", "Đang hoạt động");
            d.put("ï¿½ï¿½ khï¿½a", "Đã khóa");
            d.put("Trang hi?n t?i", "Trang hiện tại");
            d.put("Lï¿½m m?i", "Làm mới");
            d.put("Tï¿½m theo tï¿½n ho?c email...", "Tìm theo tên hoặc email...");
            d.put("Tï¿½m", "Tìm");
            d.put("Tr?ng thï¿½i...", "Trạng thái...");
            d.put("Vai trï¿½...", "Vai trò...");
            d.put("T?t c?", "Tất cả");
            d.put("L?c", "Lọc");
            d.put("Xï¿½a l?c", "Xóa lọc");
            d.put("Khï¿½ng cï¿½ d? li?u d?c gi?", "Không có dữ liệu độc giả");
            d.put("Khï¿½ng tï¿½m th?y k?t qu? phï¿½ h?p.", "Không tìm thấy kết quả phù hợp.");
            d.put("H? th?ng\n                                                    chua cï¿½ d?c gi?.",
                    "Hệ thống chưa có độc giả.");
            d.put("H? tï¿½n", "Họ tên");
            d.put("Sï¿½T", "SĐT");
            d.put("Vai trï¿½", "Vai trò");
            d.put("Tr?ng thï¿½i", "Trạng thái");
            d.put("Ngï¿½y t?o", "Ngày tạo");
            d.put("Thao tï¿½c", "Thao tác");
            d.put("M? khï¿½a", "Mở khóa");
            d.put("Khï¿½a", "Khóa");
            d.put("Tru?c", "Trước");
            d.put("Sau", "Sau");
            d.put("T?ng:", "Tổng:");
            d.put("M? khï¿½a d?c gi? nï¿½y?", "Mở khóa độc giả này?");
            d.put("Khï¿½a d?c gi? nï¿½y?", "Khóa độc giả này?");

            for (Map.Entry<String, String> enc : d.entrySet()) {
                content = content.replace(enc.getKey(), enc.getValue());
            }

            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            System.out.println("Done utf-8 fixing and replacing dropdown role.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
