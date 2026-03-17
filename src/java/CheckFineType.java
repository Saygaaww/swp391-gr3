import dal.DBContext;
import java.sql.*;

public class CheckFineType extends DBContext {
    public static void main(String[] args) {
        CheckFineType test = new CheckFineType();
        try (Connection conn = test.getConnection()) {
            System.out.println("--- Fine_Type ---");
            try (Statement s = conn.createStatement(); ResultSet rs = s.executeQuery("SELECT * FROM Fine_Type")) {
                while(rs.next()) {
                    System.out.println(rs.getInt("fine_type_id") + " - " + rs.getString("name"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
