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
                "f.reason, f.amount, f.status, f.created_at, f.paid_at, " +
                "b.title AS book_title, bc.copy_code " +
                "FROM Fine f " +
                "JOIN Fine_Type ft ON f.fine_type_id = ft.fine_type_id " +
                "JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id " +
                "JOIN BookCopy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.BookID " +
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
                    v.setReason(rs.getString("reason"));
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

    public List<FineView> getPaidFinesByReader(int readerId) {
        List<FineView> list = new ArrayList<>();
        String sql = "SELECT f.fine_id, f.borrow_item_id, f.fine_type_id, ft.name AS fine_type_name, " +
                "f.reason, f.amount, f.status, f.created_at, f.paid_at, " +
                "b.title AS book_title, bc.copy_code " +
                "FROM Fine f " +
                "JOIN Fine_Type ft ON f.fine_type_id = ft.fine_type_id " +
                "JOIN Borrow_Item bi ON f.borrow_item_id = bi.borrow_item_id " +
                "JOIN BookCopy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.BookID " +
                "WHERE f.reader_id = ? AND LOWER(ISNULL(f.status, '')) = 'paid' " +
                "ORDER BY f.paid_at DESC, f.created_at DESC";
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
                    v.setReason(rs.getString("reason"));
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
            System.err.println("getPaidFinesByReader Error: " + e.getMessage());
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

    public int markAllUnpaidFinesPaid(int readerId) {
        String sql = "UPDATE Fine SET status = 'paid', paid_at = SYSUTCDATETIME() " +
                "WHERE reader_id = ? AND (status IS NULL OR status <> 'paid')";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            return ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("markAllUnpaidFinesPaid Error: " + e.getMessage());
            return 0;
        }
    }

    public List<FineView> getAllFines() {
        List<FineView> list = new ArrayList<>();
        String sql = "SELECT f.fine_id, f.borrow_item_id, f.fine_type_id, ft.name AS fine_type_name, " +
                "f.reason, f.amount, f.status, f.created_at, f.paid_at, " +
                "b.title AS book_title, bc.copy_code, " +
                "r.reader_id, r.full_name AS reader_name, r.email AS reader_email " +
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
                v.setReason(rs.getString("reason"));
                v.setAmount(rs.getBigDecimal("amount"));
                v.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_at");
                v.setCreatedAt(created != null ? created.toLocalDateTime() : null);
                Timestamp paid = rs.getTimestamp("paid_at");
                v.setPaidAt(paid != null ? paid.toLocalDateTime() : null);
                v.setBookTitle(rs.getString("book_title"));
                v.setCopyCode(rs.getString("copy_code"));
                v.setReaderName(rs.getString("reader_name"));
                v.setReaderEmail(rs.getString("reader_email"));
                list.add(v);
            }
        } catch (Exception e) {
            System.err.println("getAllFines Error: " + e.getMessage());
        }
        return list;
    }

    public boolean markFinePaidByAdmin(int fineId, Integer employeeId) {
        String sql = "UPDATE Fine SET status = 'paid', paid_at = SYSUTCDATETIME(), " +
                "handled_by_employee_id = COALESCE(?, handled_by_employee_id) " +
                "WHERE fine_id = ? AND (status IS NULL OR LOWER(status) <> 'paid')";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            if (employeeId != null && employeeId > 0) {
                ps.setInt(1, employeeId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setInt(2, fineId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("markFinePaidByAdmin Error: " + e.getMessage());
            return false;
        }
    }

}

