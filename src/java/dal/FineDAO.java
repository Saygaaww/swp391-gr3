package dal;

import model.FineView;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FineDAO extends DBContext {

    public List<FineView> getFinesByReader(int readerId) {
        List<FineView> list = new ArrayList<>();
        String sql = "SELECT f.fine_id, f.borrow_item_id, f.fine_type_id, ft.name AS fine_type_name, " +
                "f.amount, f.status, f.created_at, f.paid_at, " +
                "b.title AS book_title, bc.copy_code " +
                "FROM Fine f " +
                "JOIN Fine_Type ft ON f.fine_type_id = ft.fine_type_id " +
                "JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id " +
                "JOIN Book_Copy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.book_id " +
                "WHERE f.reader_id = ? " +
                "ORDER BY f.created_at DESC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    FineView v = new FineView();
                    v.setFineId(rs.getInt("fine_id"));
                    v.setBorrowItemId(rs.getInt("borrow_item_id"));
                    v.setFineTypeId(rs.getInt("fine_type_id"));
                    v.setFineTypeName(rs.getString("fine_type_name"));
                    v.setAmount(rs.getBigDecimal("amount"));
                    v.setStatus(rs.getString("status"));
                    Timestamp created = rs.getTimestamp("created_at");
                    v.setCreatedAt(created != null ? created.toLocalDateTime() : null);
                    Timestamp paid = rs.getTimestamp("paid_at");
                    v.setPaidAt(paid != null ? paid.toLocalDateTime() : null);
                    v.setBookTitle(rs.getString("book_title"));
                    v.setCopyCode(rs.getString("copy_code"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            System.err.println("getFinesByReader Error: " + e.getMessage());
        }
        return list;
    }

    public boolean markFinePaid(int readerId, int fineId) {
        String sql = "UPDATE Fine SET status = 'paid', paid_at = SYSUTCDATETIME() " +
                "WHERE fine_id = ? AND reader_id = ? AND (status IS NULL OR status <> 'paid')";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fineId);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("markFinePaid Error: " + e.getMessage());
            return false;
        }
    }

    public List<FineView> getAllFines() {
        List<FineView> list = new ArrayList<>();
        String sql = "SELECT f.fine_id, f.borrow_item_id, f.fine_type_id, ft.name AS fine_type_name, " +
                "f.amount, f.status, f.created_at, f.paid_at, " +
                "b.title AS book_title, bc.copy_code, " +
                "r.reader_id, r.first_name + ' ' + r.last_name AS reader_name, r.email AS reader_email " +
                "FROM Fine f " +
                "JOIN Fine_Type ft ON f.fine_type_id = ft.fine_type_id " +
                "JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id " +
                "JOIN BookCopy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.BookID " +
                "JOIN Reader r ON f.reader_id = r.reader_id " +
                "ORDER BY f.created_at DESC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                FineView v = new FineView();
                v.setFineId(rs.getInt("fine_id"));
                v.setBorrowItemId(rs.getInt("borrow_item_id"));
                v.setFineTypeId(rs.getInt("fine_type_id"));
                v.setFineTypeName(rs.getString("fine_type_name"));
                v.setAmount(rs.getBigDecimal("amount"));
                v.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_at");
                v.setCreatedAt(created != null ? created.toLocalDateTime() : null);
                Timestamp paid = rs.getTimestamp("paid_at");
                v.setPaidAt(paid != null ? paid.toLocalDateTime() : null);
                v.setBookTitle(rs.getString("book_title"));
                v.setCopyCode(rs.getString("copy_code"));
                
                // FineView currently does not have reader info. We might need to handle it or just use it.
                // It's good to add readerName and readerEmail to FineView
                try {
                    v.getClass().getMethod("setReaderName", String.class).invoke(v, rs.getString("reader_name"));
                    v.getClass().getMethod("setReaderEmail", String.class).invoke(v, rs.getString("reader_email"));
                } catch (Exception e) {}
                
                list.add(v);
            }
        } catch (Exception e) {
            System.err.println("getAllFines Error: " + e.getMessage());
        }
        return list;
    }

}

