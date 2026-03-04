package dal;

import model.BorrowRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý yêu cầu mượn sách
 * @author Member E - Dũng
 */
public class BorrowDAO extends DBContext {
    
    /**
     * Đếm số yêu cầu mượn đang chờ duyệt
     */
    public int getPendingRequestsCount() {
        String sql = "SELECT COUNT(*) FROM Borrow_Request WHERE status = 'pending'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("Error in getPendingRequestsCount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Đếm số lượt mượn đang hoạt động
     */
    public int getActiveBorrowsCount() {
        String sql = "SELECT COUNT(*) FROM Borrow WHERE status = 'active'";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("Error in getActiveBorrowsCount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Lấy danh sách yêu cầu mượn đang chờ duyệt
     */
    public List<BorrowRequest> getPendingRequests() {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT br.*, r.full_name AS reader_name, r.email " +
                     "FROM Borrow_Request br " +
                     "JOIN Reader r ON br.reader_id = r.reader_id " +
                     "WHERE br.status = 'pending' " +
                     "ORDER BY br.requested_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                BorrowRequest request = new BorrowRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setReaderId(rs.getInt("reader_id"));
                request.setStatus(rs.getString("status"));
                request.setRequestedAt(rs.getTimestamp("requested_at"));
                request.setNote(rs.getString("note"));
                request.setReaderName(rs.getString("reader_name"));
                request.setReaderEmail(rs.getString("email"));
                requests.add(request);
            }
            
        } catch (Exception e) {
            System.err.println("Error in getPendingRequests: " + e.getMessage());
            e.printStackTrace();
        }
        
        return requests;
    }
    
    /**
     * Duyệt yêu cầu mượn sách
     */
    public boolean approveRequest(int requestId, int employeeId, String note) {
        String sql = "UPDATE Borrow_Request SET " +
                     "status = 'approved', " +
                     "processed_by_employee_id = ?, " +
                     "processed_at = SYSUTCDATETIME(), " +
                     "decision_note = ? " +
                     "WHERE request_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ps.setString(2, note);
            ps.setInt(3, requestId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("Error in approveRequest: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Từ chối yêu cầu mượn sách
     */
    public boolean rejectRequest(int requestId, int employeeId, String note) {
        String sql = "UPDATE Borrow_Request SET " +
                     "status = 'rejected', " +
                     "processed_by_employee_id = ?, " +
                     "processed_at = SYSUTCDATETIME(), " +
                     "decision_note = ? " +
                     "WHERE request_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, employeeId);
            ps.setString(2, note);
            ps.setInt(3, requestId);
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("Error in rejectRequest: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Lay danh sach yeu cau co loc + phan trang
    public List<BorrowRequest> getRequestsFiltered(String keyword, String status, int page, int pageSize) {
        List<BorrowRequest> requests = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT br.*, r.full_name AS reader_name, r.email, ");
        sql.append("e.full_name AS employee_name ");
        sql.append("FROM Borrow_Request br ");
        sql.append("JOIN Reader r ON br.reader_id = r.reader_id ");
        sql.append("LEFT JOIN Employee e ON br.processed_by_employee_id = e.employee_id ");
        sql.append("WHERE 1=1 ");
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND br.status = ? ");
        }
        
        sql.append("ORDER BY br.requested_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            int offset = (page - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSet(rs));
                }
            }
            
        } catch (Exception e) {
            System.err.println("getRequestsFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }
    
    // Dem so yeu cau co loc
    public int countRequestsFiltered(String keyword, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Borrow_Request br ");
        sql.append("JOIN Reader r ON br.reader_id = r.reader_id ");
        sql.append("WHERE 1=1 ");
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND br.status = ? ");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("countRequestsFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Dem theo tung trang thai
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Borrow_Request WHERE status = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("countByStatus Error: " + e.getMessage());
        }
        return 0;
    }
    
    // Map ResultSet thanh BorrowRequest
    private BorrowRequest mapResultSet(ResultSet rs) throws SQLException {
        BorrowRequest req = new BorrowRequest();
        req.setRequestId(rs.getInt("request_id"));
        req.setReaderId(rs.getInt("reader_id"));
        req.setStatus(rs.getString("status"));
        req.setRequestedAt(rs.getTimestamp("requested_at"));
        req.setNote(rs.getString("note"));
        req.setDecisionNote(rs.getString("decision_note"));
        req.setReaderName(rs.getString("reader_name"));
        req.setReaderEmail(rs.getString("email"));
        
        int processedBy = rs.getInt("processed_by_employee_id");
        if (!rs.wasNull()) {
            req.setProcessedByEmployeeId(processedBy);
        }
        req.setProcessedAt(rs.getTimestamp("processed_at"));
        
        try {
            req.setEmployeeName(rs.getString("employee_name"));
        } catch (SQLException e) {

        }
        return req;
    }
}