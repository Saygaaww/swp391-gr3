package dal;

import model.Borrow;
import model.BorrowItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;

public class BorrowDAO extends DBContext {
    
    // Default borrowing period: 14 days
    private static final int DEFAULT_BORROW_DAYS = 14;
    
    public int createBorrow(int readerId, int requestId, List<Integer> copyIds, Integer approvedByEmployeeId) {
        String sqlBorrow = "INSERT INTO Borrow (reader_id, request_id, borrow_date, status, created_at, approved_by_employee_id) " +
                          "VALUES (?, ?, GETDATE(), 'active', GETDATE(), ?)";
        String sqlBorrowItem = "INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, status) VALUES (?, ?, ?, 'borrowed')";
        String sqlUpdateCopy = "UPDATE BookCopy SET status = 'borrowed' WHERE copy_id = ?";
        String sqlUpdateRequest = "UPDATE Borrow_Request SET status = 'approved', processed_at = GETDATE(), processed_by_employee_id = ? WHERE request_id = ?";
        
        try {
            connection.setAutoCommit(false);
            
            // Calculate due date (14 days from now)
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, DEFAULT_BORROW_DAYS);
            Timestamp dueDate = new Timestamp(cal.getTimeInMillis());
            
            // Insert borrow record
            PreparedStatement psBorrow = connection.prepareStatement(sqlBorrow, Statement.RETURN_GENERATED_KEYS);
            psBorrow.setInt(1, readerId);
            psBorrow.setInt(2, requestId);
            if (approvedByEmployeeId != null) {
                psBorrow.setInt(3, approvedByEmployeeId);
            } else {
                psBorrow.setNull(3, Types.INTEGER);
            }
            
            int affectedRows = psBorrow.executeUpdate();
            if (affectedRows == 0) {
                connection.rollback();
                return -1;
            }
            
            // Get generated borrow_id
            int borrowId = -1;
            ResultSet rs = psBorrow.getGeneratedKeys();
            if (rs.next()) {
                borrowId = rs.getInt(1);
            }
            
            // Insert borrow items and update copy status
            PreparedStatement psBorrowItem = connection.prepareStatement(sqlBorrowItem);
            PreparedStatement psUpdateCopy = connection.prepareStatement(sqlUpdateCopy);
            
            for (Integer copyId : copyIds) {
                // Insert borrow item
                psBorrowItem.setInt(1, borrowId);
                psBorrowItem.setInt(2, copyId);
                psBorrowItem.setTimestamp(3, dueDate);
                psBorrowItem.addBatch();
                
                // Update copy status
                psUpdateCopy.setInt(1, copyId);
                psUpdateCopy.addBatch();
            }
            
            psBorrowItem.executeBatch();
            psUpdateCopy.executeBatch();
            
            // Update borrow request status
            if (requestId > 0 && approvedByEmployeeId != null) {
                PreparedStatement psUpdateRequest = connection.prepareStatement(sqlUpdateRequest);
                psUpdateRequest.setInt(1, approvedByEmployeeId);
                psUpdateRequest.setInt(2, requestId);
                psUpdateRequest.executeUpdate();
            }
            
            connection.commit();
            connection.setAutoCommit(true);
            
            return borrowId;
        } catch (SQLException e) {
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("Error rolling back: " + ex.getMessage());
            }
            System.out.println("Error creating borrow: " + e.getMessage());
            return -1;
        }
    }
    
    public List<Borrow> getBorrowsByReaderId(int readerId) {
        List<Borrow> borrows = new ArrayList<>();
        String sql = "SELECT * FROM Borrow WHERE reader_id = ? ORDER BY created_at DESC";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Borrow borrow = new Borrow();
                borrow.setBorrowId(rs.getInt("borrow_id"));
                borrow.setReaderId(rs.getInt("reader_id"));
                borrow.setRequestId(rs.getInt("request_id"));
                if (rs.wasNull()) {
                    borrow.setRequestId(null);
                }
                borrow.setBorrowDate(rs.getTimestamp("borrow_date"));
                borrow.setStatus(rs.getString("status"));
                borrow.setCreatedAt(rs.getTimestamp("created_at"));
                borrow.setApprovedByEmployeeId(rs.getInt("approved_by_employee_id"));
                if (rs.wasNull()) {
                    borrow.setApprovedByEmployeeId(null);
                }
                
                borrows.add(borrow);
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrows: " + e.getMessage());
        }
        
        return borrows;
    }
    
    public List<BorrowItem> getBorrowItems(int borrowId) {
        List<BorrowItem> items = new ArrayList<>();
        String sql = "SELECT bi.* FROM Borrow_Item bi WHERE bi.borrow_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, borrowId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BorrowItem item = new BorrowItem();
                item.setBorrowItemId(rs.getInt("borrow_item_id"));
                item.setBorrowId(rs.getInt("borrow_id"));
                item.setCopyId(rs.getInt("copy_id"));
                item.setDueDate(rs.getTimestamp("due_date"));
                item.setReturnedAt(rs.getTimestamp("returned_at"));
                item.setStatus(rs.getString("status"));
                
                items.add(item);
            }
        } catch (SQLException e) {
            System.out.println("Error getting borrow items: " + e.getMessage());
        }
        
        return items;
    }
}

