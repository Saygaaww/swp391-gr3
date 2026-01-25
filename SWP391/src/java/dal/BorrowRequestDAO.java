package dal;

import model.BorrowRequest;
import model.BorrowRequestItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowRequestDAO extends DBContext {
    
    public int createBorrowRequest(BorrowRequest request, List<BorrowRequestItem> items) {
        String sqlRequest = "INSERT INTO Borrow_Request (reader_id, status, requested_at, note) VALUES (?, ?, GETDATE(), ?)";
        String sqlItem = "INSERT INTO Borrow_Request_Item (request_id, book_id, quantity) VALUES (?, ?, ?)";
        
        try {
            connection.setAutoCommit(false);
            
            // Insert borrow request
            PreparedStatement psRequest = connection.prepareStatement(sqlRequest, Statement.RETURN_GENERATED_KEYS);
            psRequest.setInt(1, request.getReaderId());
            psRequest.setString(2, "pending");
            psRequest.setString(3, request.getNote());
            
            int affectedRows = psRequest.executeUpdate();
            if (affectedRows == 0) {
                connection.rollback();
                return -1;
            }
            
            // Get generated request_id
            int requestId = -1;
            ResultSet rs = psRequest.getGeneratedKeys();
            if (rs.next()) {
                requestId = rs.getInt(1);
            }
            
            // Insert borrow request items
            PreparedStatement psItem = connection.prepareStatement(sqlItem);
            for (BorrowRequestItem item : items) {
                psItem.setInt(1, requestId);
                psItem.setInt(2, item.getBookId());
                psItem.setInt(3, item.getQuantity());
                psItem.addBatch();
            }
            psItem.executeBatch();
            
            connection.commit();
            connection.setAutoCommit(true);
            
            return requestId;
        } catch (SQLException e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("Error rolling back: " + ex.getMessage());
            }
            System.out.println("Error creating borrow request: " + e.getMessage());
            return -1;
        }
    }
    
    public List<BorrowRequest> getBorrowRequestsByReaderId(int readerId) {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = "SELECT * FROM Borrow_Request WHERE reader_id = ? ORDER BY requested_at DESC";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BorrowRequest request = new BorrowRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setReaderId(rs.getInt("reader_id"));
                request.setStatus(rs.getString("status"));
                request.setRequestedAt(rs.getTimestamp("requested_at"));
                request.setNote(rs.getString("note"));
                request.setProcessedByEmployeeId(rs.getInt("processed_by_employee_id"));
                if (rs.wasNull()) {
                    request.setProcessedByEmployeeId(null);
                }
                request.setProcessedAt(rs.getTimestamp("processed_at"));
                request.setDecisionNote(rs.getString("decision_note"));
                
                requests.add(request);
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow requests: " + e.getMessage());
        }
        
        return requests;
    }
    
    public BorrowRequest getBorrowRequestById(int requestId) {
        String sql = "SELECT * FROM Borrow_Request WHERE request_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BorrowRequest request = new BorrowRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setReaderId(rs.getInt("reader_id"));
                request.setStatus(rs.getString("status"));
                request.setRequestedAt(rs.getTimestamp("requested_at"));
                request.setNote(rs.getString("note"));
                request.setProcessedByEmployeeId(rs.getInt("processed_by_employee_id"));
                if (rs.wasNull()) {
                    request.setProcessedByEmployeeId(null);
                }
                request.setProcessedAt(rs.getTimestamp("processed_at"));
                request.setDecisionNote(rs.getString("decision_note"));
                
                return request;
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow request by id: " + e.getMessage());
        }
        
        return null;
    }
    
    public List<BorrowRequestItem> getBorrowRequestItems(int requestId) {
        List<BorrowRequestItem> items = new ArrayList<>();
        String sql = "SELECT * FROM Borrow_Request_Item WHERE request_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BorrowRequestItem item = new BorrowRequestItem();
                item.setRequestItemId(rs.getInt("request_item_id"));
                item.setRequestId(rs.getInt("request_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                
                items.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow request items: " + e.getMessage());
        }
        
        return items;
    }
}

