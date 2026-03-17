import dal.DBContext;
import java.sql.*;

public class CheckSchema extends DBContext {
    public static void main(String[] args) {
        CheckSchema check = new CheckSchema();
        try (Connection conn = check.getConnection()) {
            ResultSet rs = conn.getMetaData().getColumns(null, null, "Book", null);
            while(rs.next()) {
                System.out.println(rs.getString("COLUMN_NAME"));
            }
        } catch(Exception e) { e.printStackTrace(); }
    }
}
