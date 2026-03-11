package util;

import java.util.List;

/**
 * PaginatedResult - Wrapper class for paginated data
 * @author FPT Student Team
 */
public class PaginatedResult<T> {
    
    private final List<T> items;
    private final int currentPage;
    private final int pageSize;
    private final int totalCount;
    private final int totalPages;
    
    public PaginatedResult(List<T> items, int currentPage, int pageSize, int totalCount) {
        this.items = items;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPages = (int) Math.ceil((double) totalCount / pageSize);
    }
    
    // Getters
    public List<T> getItems() {
        return items;
    }
    
    public int getCurrentPage() {
        return currentPage;
    }
    
    public int getPageSize() {
        return pageSize;
    }
    
    public int getTotalCount() {
        return totalCount;
    }
    
    public int getTotalPages() {
        return totalPages;
    }
    
    // Utility methods
    public boolean hasPreviousPage() {
        return currentPage > 1;
    }
    
    public boolean hasNextPage() {
        return currentPage < totalPages;
    }
    
    public int getPreviousPage() {
        return Math.max(1, currentPage - 1);
    }
    
    public int getNextPage() {
        return Math.min(totalPages, currentPage + 1);
    }
    
    public int getStartItem() {
        if (totalCount == 0) return 0;
        return (currentPage - 1) * pageSize + 1;
    }
    
    public int getEndItem() {
        return Math.min(currentPage * pageSize, totalCount);
    }
    
    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
    
    // Pagination info string
    public String getPaginationInfo() {
        if (totalCount == 0) {
            return "Không có kết quả";
        }
        
        return String.format("Hiển thị %d-%d trong tổng số %d kết quả", 
                           getStartItem(), getEndItem(), totalCount);
    }
    
    @Override
    public String toString() {
        return String.format("PaginatedResult{page=%d/%d, items=%d, total=%d}", 
                           currentPage, totalPages, items.size(), totalCount);
    }
}