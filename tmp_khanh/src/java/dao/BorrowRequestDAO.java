package dao;

import model.BorrowRequest;
import model.BorrowRequestItem;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowRequestDAO {

    /* ================= CREATE BORROW REQUEST ================= */
    public int createBorrowRequest(int readerId, String note) {
        String sql = """
            INSERT INTO Borrow_Request(reader_id, status, note)
            VALUES (?, 'pending', ?)
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, readerId);
            ps.setString(2, note);

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /* ================= ADD REQUEST ITEM ================= */
    public boolean addRequestItem(int requestId, int bookId, int quantity) {
        String sql = """
            INSERT INTO Borrow_Request_Item(request_id, book_id, quantity)
            VALUES (?, ?, ?)
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= GET ALL BORROW REQUESTS ================= */
    public List<BorrowRequest> getAllBorrowRequests() {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = """
            SELECT br.*, r.full_name, r.email, e.full_name as employee_name
            FROM Borrow_Request br
            JOIN Reader r ON br.reader_id = r.reader_id
            LEFT JOIN Employee e ON br.processed_by_employee_id = e.employee_id
            ORDER BY br.requested_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BorrowRequest request = mapBorrowRequest(rs);
                request.setItems(getRequestItems(request.getRequestId()));
                requests.add(request);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return requests;
    }

    /* ================= GET PENDING REQUESTS ================= */
    public List<BorrowRequest> getPendingRequests() {
        List<BorrowRequest> requests = new ArrayList<>();
        String sql = """
            SELECT br.*, r.full_name, r.email
            FROM Borrow_Request br
            JOIN Reader r ON br.reader_id = r.reader_id
            WHERE br.status = 'pending'
            ORDER BY br.requested_at ASC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BorrowRequest request = mapBorrowRequest(rs);
                request.setItems(getRequestItems(request.getRequestId()));
                requests.add(request);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return requests;
    }

    /* ================= GET REQUEST BY ID ================= */
    public BorrowRequest getRequestById(int requestId) {
        String sql = """
            SELECT br.*, r.full_name, r.email, e.full_name as employee_name
            FROM Borrow_Request br
            JOIN Reader r ON br.reader_id = r.reader_id
            LEFT JOIN Employee e ON br.processed_by_employee_id = e.employee_id
            WHERE br.request_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                BorrowRequest request = mapBorrowRequest(rs);
                request.setItems(getRequestItems(requestId));
                return request;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= GET REQUEST ITEMS ================= */
    private List<BorrowRequestItem> getRequestItems(int requestId) {
        List<BorrowRequestItem> items = new ArrayList<>();
        String sql = """
            SELECT bri.*, b.title, b.cover_url
            FROM Borrow_Request_Item bri
            JOIN Book b ON bri.book_id = b.book_id
            WHERE bri.request_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapRequestItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    /* ================= UPDATE REQUEST STATUS ================= */
    public boolean updateRequestStatus(int requestId, String status, int employeeId, String decisionNote) {
        String sql = """
            UPDATE Borrow_Request
            SET status = ?, processed_by_employee_id = ?, 
                processed_at = SYSUTCDATETIME(), decision_note = ?
            WHERE request_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, employeeId);
            ps.setString(3, decisionNote);
            ps.setInt(4, requestId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= MAP RESULTSET ================= */
    private BorrowRequest mapBorrowRequest(ResultSet rs) throws SQLException {
        BorrowRequest request = new BorrowRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setReaderId(rs.getInt("reader_id"));
        request.setStatus(rs.getString("status"));
        request.setNote(rs.getString("note"));
        request.setReaderName(rs.getString("full_name"));
        request.setReaderEmail(rs.getString("email"));
        
        try {
            request.setEmployeeName(rs.getString("employee_name"));
        } catch (SQLException e) {
            // Employee name might not be present
        }
        
        return request;
    }

    private BorrowRequestItem mapRequestItem(ResultSet rs) throws SQLException {
        BorrowRequestItem item = new BorrowRequestItem();
        item.setRequestItemId(rs.getInt("request_item_id"));
        item.setRequestId(rs.getInt("request_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setBookTitle(rs.getString("title"));
        item.setBookCoverUrl(rs.getString("cover_url"));
        return item;
    }
}
