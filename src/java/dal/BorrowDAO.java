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
}