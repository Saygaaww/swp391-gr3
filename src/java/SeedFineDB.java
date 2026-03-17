import dal.DBContext;
import java.sql.*;

public class SeedFineDB extends DBContext {
    public static void main(String[] args) {
        SeedFineDB db = new SeedFineDB();
        try (Connection conn = db.getConnection()) {
            System.out.println("Processing Fine_Type and Fine...");
            
            // 1. Ensure Fine_Type has correct details
            String[] fineTypes = {
                "Quá hạn (Late Return) - Thu phí 5.000đ/ngày",
                "Làm mất sách (Lost) - Phạt 150% giá sách",
                "Hư hỏng sách (Damaged) - Phạt 50% giá sách"
            };
            
            String updateType = "UPDATE Fine_Type SET name = ? WHERE fine_type_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateType)) {
                for (int i = 0; i < fineTypes.length; i++) {
                    ps.setString(1, fineTypes[i]);
                    ps.setInt(2, i + 1);
                    ps.executeUpdate();
                }
            }
            
            // 2. Clear existing Fines (if we want to seed fresh)
            // try (Statement s = conn.createStatement()) {
            //     s.executeUpdate("DELETE FROM Fine");
            // }

            // 3. Insert Fine records for reader_id = 9 (user account) or reader_id = 1, etc.
            // Wait, we need to know a valid reader_id and borrow_item_id.
            // Let's get a reader_id and a borrow_item_id
            int readerId = -1;
            int borrowItemId = -1;
            
            try (Statement s = conn.createStatement(); 
                 ResultSet rs = s.executeQuery("SELECT TOP 1 reader_id FROM Reader")) {
                if (rs.next()) readerId = rs.getInt("reader_id");
            }
            
            try (Statement s = conn.createStatement(); 
                 ResultSet rs = s.executeQuery("SELECT TOP 1 borrow_item_id FROM Borrow_Item")) {
                if (rs.next()) borrowItemId = rs.getInt("borrow_item_id");
            }
            
            if (readerId != -1 && borrowItemId != -1) {
                String insertFine = "INSERT INTO Fine (reader_id, borrow_item_id, fine_type_id, amount, status, created_at) " +
                                    "VALUES (?, ?, ?, ?, ?, SYSUTCDATETIME())";
                try (PreparedStatement ps = conn.prepareStatement(insertFine)) {
                    // Fine 1: Overdue
                    ps.setInt(1, readerId);
                    ps.setInt(2, borrowItemId);
                    ps.setInt(3, 1);
                    ps.setBigDecimal(4, java.math.BigDecimal.valueOf(15000));
                    ps.setString(5, "unpaid");
                    ps.executeUpdate();
                    
                    // Fine 2: Damaged
                    ps.setInt(1, readerId);
                    ps.setInt(2, borrowItemId);
                    ps.setInt(3, 3);
                    ps.setBigDecimal(4, java.math.BigDecimal.valueOf(25000));
                    ps.setString(5, "unpaid");
                    ps.executeUpdate();
                    System.out.println("Inserted sample fines for Reader ID: " + readerId);
                }
            } else {
                System.out.println("No Reader or Borrow_Item found to attach fine!");
            }
            
            System.out.println("Data insertion complete.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
