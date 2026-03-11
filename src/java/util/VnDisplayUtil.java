package util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Hiển thị dữ liệu theo định dạng tiếng Việt: ngày giờ, trạng thái.
 */
public final class VnDisplayUtil {

    private static final DateTimeFormatter VN_DATETIME =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.forLanguageTag("vi"));

    private VnDisplayUtil() {}

    /** Định dạng ngày giờ: dd/MM/yyyy HH:mm */
    public static String formatDateTime(LocalDateTime dt) {
        return dt == null ? "" : dt.format(VN_DATETIME);
    }

    /** Nhãn trạng thái mượn/trả bằng tiếng Việt */
    public static String statusBorrowVn(String status) {
        if (status == null || status.isEmpty()) return "";
        switch (status.toLowerCase()) {
            case "borrowed": return "Đang mượn";
            case "returned": return "Đã trả";
            case "overdue": return "Quá hạn";
            case "active": return "Đang mượn";
            case "completed": return "Hoàn thành";
            case "cancelled": return "Đã hủy";
            case "pending": return "Chờ duyệt";
            case "approved": return "Đã duyệt";
            case "rejected": return "Đã từ chối";
            case "lost": return "Mất";
            case "damaged": return "Hư hỏng";
            default: return status;
        }
    }
}
