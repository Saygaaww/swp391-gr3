import dal.BorrowDAO;
import model.BorrowRequestItem;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;

public class TestBorrowDAO {
    public static void main(String[] args) {
        try {
            System.out.println("Testing BorrowDAO createBorrowRequest...");
            BorrowDAO dao = new BorrowDAO();
            
            List<BorrowRequestItem> items = new ArrayList<>();
            BorrowRequestItem item = new BorrowRequestItem();
            item.setBookId(1);
            item.setQuantity(1);
            items.add(item);
            
            LocalDate startDate = LocalDate.now();
            LocalDate endDate = LocalDate.now().plusDays(7);
            
            int readerId = 1; // Assuming reader 1 exists
            
            int requestId = dao.createBorrowRequest(readerId, "Test note", startDate, endDate, items);
            System.out.println("Result Request ID: " + requestId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
