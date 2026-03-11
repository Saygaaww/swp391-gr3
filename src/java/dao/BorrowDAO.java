package dao;

import model.BorrowHistoryItem;
import util.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BorrowDAO {

    /**
     * List borrow history for a reader: all Borrow_Item with book title, ordered by borrow_date desc.
     */
    public List<BorrowHistoryItem> listHistoryByReader(int readerId) {
        String sql = """
            SELECT b.borrow_id, b.borrow_date, b.status AS borrow_status,
                   bi.borrow_item_id, bi.due_date, bi.returned_at, bi.status AS item_status,
                   bk.book_id, bk.title AS book_title, bc.copy_code
            FROM Borrow b
            JOIN Borrow_Item bi ON b.borrow_id = bi.borrow_id
            JOIN BookCopy bc ON bi.copy_id = bc.copy_id
            JOIN Book bk ON bc.book_id = bk.book_id
            WHERE b.reader_id = ?
            ORDER BY b.borrow_date DESC, bi.borrow_item_id
            """;
        List<BorrowHistoryItem> list = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Return a book: set Borrow_Item.returned_at, status='returned' and BookCopy.status='available'.
     * Only allowed if the borrow_item belongs to this reader and is not yet returned.
     */
    public boolean returnItem(int borrowItemId, int readerId) {
        String getCopyId = """
            SELECT bi.copy_id FROM Borrow_Item bi
            JOIN Borrow b ON bi.borrow_id = b.borrow_id
            WHERE bi.borrow_item_id = ? AND b.reader_id = ? AND bi.status IN ('borrowed', 'overdue')
            """;
        String updateItem = "UPDATE Borrow_Item SET returned_at = ?, status = 'returned' WHERE borrow_item_id = ?";
        String updateCopy = "UPDATE BookCopy SET status = 'available' WHERE copy_id = ?";
        try (Connection con = DBContext.getConnection()) {
            int copyId = -1;
            try (PreparedStatement ps = con.prepareStatement(getCopyId)) {
                ps.setInt(1, borrowItemId);
                ps.setInt(2, readerId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) return false;
                copyId = rs.getInt("copy_id");
            }
            con.setAutoCommit(false);
            try {
                try (PreparedStatement ps = con.prepareStatement(updateItem)) {
                    ps.setObject(1, LocalDateTime.now());
                    ps.setInt(2, borrowItemId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = con.prepareStatement(updateCopy)) {
                    ps.setInt(1, copyId);
                    ps.executeUpdate();
                }
                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Kiểm tra reader có đang mượn sách này chưa (status borrowed/overdue). */
    public boolean isCurrentlyBorrowing(int readerId, int bookId) {
        String sql = """
            SELECT 1 FROM Borrow b
            JOIN Borrow_Item bi ON b.borrow_id = bi.borrow_id
            JOIN BookCopy bc ON bi.copy_id = bc.copy_id
            WHERE b.reader_id = ? AND bc.book_id = ? AND bi.status IN ('borrowed', 'overdue')
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Đếm tổng số bản sách reader đang mượn (status borrowed/overdue). */
    public int countActiveBorrows(int readerId) {
        String sql = """
            SELECT COUNT(*) FROM Borrow b
            JOIN Borrow_Item bi ON b.borrow_id = bi.borrow_id
            WHERE b.reader_id = ? AND bi.status IN ('borrowed', 'overdue')
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private BorrowHistoryItem mapRow(ResultSet rs) throws SQLException {
        BorrowHistoryItem item = new BorrowHistoryItem();
        item.setBorrowId(rs.getInt("borrow_id"));
        Timestamp ts = rs.getTimestamp("borrow_date");
        if (ts != null) item.setBorrowDate(ts.toLocalDateTime());
        item.setBorrowStatus(rs.getNString("borrow_status"));
        item.setBorrowItemId(rs.getInt("borrow_item_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setBookTitle(rs.getNString("book_title"));
        item.setCopyCode(rs.getNString("copy_code"));
        ts = rs.getTimestamp("due_date");
        if (ts != null) item.setDueDate(ts.toLocalDateTime());
        ts = rs.getTimestamp("returned_at");
        if (ts != null) item.setReturnedAt(ts.toLocalDateTime());
        item.setItemStatus(rs.getNString("item_status"));
        return item;
    }
}
