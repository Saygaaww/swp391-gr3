import dal.BorrowDAO;
import model.BorrowedItemView;
import java.util.List;

public class CheckDB2 {
    public static void main(String[] args) {
        BorrowDAO dao = new BorrowDAO();
        List<BorrowedItemView> items = dao.getActiveBorrowedItemsByReader(1);
        System.out.println("--- Borrowed items for reader 1 ---");
        System.out.println("Size: " + items.size());
        for (BorrowedItemView v : items) {
            System.out.println("Book: " + v.getBookTitle() + " Status: " + v.getStatus() + " ItemID: " + v.getBorrowItemId());
        }
    }
}
