import dal.BorrowDAO;
import java.time.LocalDate;

public class TestBorrowApprove {
    public static void main(String[] args) {
        BorrowDAO dao = new BorrowDAO();
        System.out.println("Approving request #2...");
        try {
            boolean result = dao.approveRequest(2, 1, "Approve Test", LocalDate.now(), LocalDate.now().plusDays(5));
            System.out.println("Result: " + result);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
