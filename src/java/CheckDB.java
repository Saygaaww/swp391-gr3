import dal.DBContext;
import java.sql.*;

public class CheckDB extends DBContext {
    public static void main(String[] args) {
        CheckDB test = new CheckDB();
        try (Connection conn = test.getConnection()) {
            System.out.println("--- Borrow_Request ---");
            try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT top 10 request_id, reader_id, status FROM Borrow_Request ORDER BY requested_at DESC")) {
                while(rs.next()) {
                    System.out.println("Req:" + rs.getInt("request_id") + " Reader:" + rs.getInt("reader_id") + " Status:" + rs.getString("status"));
                }
            }
            System.out.println("--- Borrow ---");
            try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT top 10 borrow_id, reader_id, status FROM Borrow ORDER BY created_at DESC")) {
                while(rs.next()) {
                    System.out.println("Borrow:" + rs.getInt("borrow_id") + " Reader:" + rs.getInt("reader_id") + " Status:" + rs.getString("status"));
                }
            }
            System.out.println("--- Borrow_Item ---");
            try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT top 10 borrow_item_id, borrow_id, status FROM Borrow_Item ORDER BY due_date DESC")) {
                while(rs.next()) {
                    System.out.println("Item:" + rs.getInt("borrow_item_id") + " Borrow:" + rs.getInt("borrow_id") + " Status:" + rs.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
