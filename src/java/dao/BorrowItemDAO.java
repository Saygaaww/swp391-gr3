package dao;

import model.OverdueItem;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Đọc dữ liệu Borrow_Item (mượn quá hạn) – chỉ dùng để hiển thị, không CRUD.
 */
public class BorrowItemDAO {

    /** Danh sách mục mượn quá hạn (due_date &lt; hiện tại, chưa trả). */
    public List<OverdueItem> getOverdueItems() {
        List<OverdueItem> list = new ArrayList<>();
        String sql = """
            SELECT bi.borrow_item_id, r.full_name AS reader_name, b.title AS book_title, bi.due_date
            FROM Borrow_Item bi
            JOIN Borrow bor ON bi.borrow_id = bor.borrow_id
            JOIN Reader r ON bor.reader_id = r.reader_id
            JOIN BookCopy bc ON bi.copy_id = bc.copy_id
            JOIN Book b ON bc.book_id = b.book_id
            WHERE bi.due_date < SYSUTCDATETIME()
              AND bi.status IN ('borrowed', 'overdue')
            ORDER BY bi.due_date ASC
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OverdueItem o = new OverdueItem();
                o.setBorrowItemId(rs.getInt("borrow_item_id"));
                o.setReaderName(rs.getString("reader_name"));
                o.setBookTitle(rs.getString("book_title"));
                Timestamp t = rs.getTimestamp("due_date");
                o.setDueDate(t != null ? t.toLocalDateTime() : null);
                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
