package utils;

import dao.EmployeeDAO;
import dao.ReaderDAO;
import model.Employee;
import model.Reader;
import java.sql.SQLException;

/**
 * Service để xác thực người dùng từ cả Reader và Employee
 */
public class AuthenticationService {
    
    private ReaderDAO readerDAO;
    private EmployeeDAO employeeDAO;
    
    public AuthenticationService() {
        readerDAO = new ReaderDAO();
        employeeDAO = new EmployeeDAO();
    }
    
    /**
     * Xác thực người dùng từ email và password
     * Kiểm tra cả Reader và Employee
     * 
     * @param email Email của người dùng
     * @param password Password
     * @return AuthenticationResult chứa thông tin user và loại (READER hoặc EMPLOYEE)
     */
    public AuthenticationResult authenticate(String email, String password) throws SQLException {
        // Thử xác thực từ Reader trước
        boolean readerAuth = readerDAO.authenticate(email, password);
        if (readerAuth) {
            Reader reader = readerDAO.getReaderByEmail(email);
            if (reader != null) {
                // Kiểm tra status - cho phép null hoặc "active"
                String status = reader.getStatus();
                if (status == null || "active".equalsIgnoreCase(status)) {
                    return new AuthenticationResult(reader, null, UserType.READER);
                }
            }
        }
        
        // Nếu không phải Reader, thử Employee
        boolean employeeAuth = employeeDAO.authenticate(email, password);
        if (employeeAuth) {
            Employee employee = employeeDAO.getEmployeeByEmail(email);
            if (employee != null) {
                // Kiểm tra status - cho phép null hoặc "active"
                String status = employee.getStatus();
                if (status == null || "active".equalsIgnoreCase(status)) {
                    return new AuthenticationResult(null, employee, UserType.EMPLOYEE);
                }
            }
        }
        
        return null; // Xác thực thất bại
    }
    
    /**
     * Enum để phân biệt loại người dùng
     */
    public enum UserType {
        READER,    // Người dùng thông thường từ bảng Reader
        EMPLOYEE   // Nhân viên từ bảng Employee
    }
    
    /**
     * Class để chứa kết quả xác thực
     */
    public static class AuthenticationResult {
        private Reader reader;
        private Employee employee;
        private UserType userType;
        
        public AuthenticationResult(Reader reader, Employee employee, UserType userType) {
            this.reader = reader;
            this.employee = employee;
            this.userType = userType;
        }
        
        public Reader getReader() {
            return reader;
        }
        
        public Employee getEmployee() {
            return employee;
        }
        
        public UserType getUserType() {
            return userType;
        }
        
        /**
         * Lấy role name từ user (Reader hoặc Employee)
         */
        public String getRoleName() {
            if (reader != null && reader.getRole() != null) {
                return reader.getRole().getRoleName();
            }
            if (employee != null && employee.getRole() != null) {
                return employee.getRole().getRoleName();
            }
            return "USER";
        }
        
        /**
         * Lấy full name từ user
         */
        public String getFullName() {
            if (reader != null) {
                return reader.getFullName();
            }
            if (employee != null) {
                return employee.getFullName();
            }
            return null;
        }
        
        /**
         * Lấy email từ user
         */
        public String getEmail() {
            if (reader != null) {
                return reader.getEmail();
            }
            if (employee != null) {
                return employee.getEmail();
            }
            return null;
        }
        
        /**
         * Lấy ID từ user
         */
        public int getId() {
            if (reader != null) {
                return reader.getReaderId();
            }
            if (employee != null) {
                return employee.getEmployeeId();
            }
            return 0;
        }
    }
}
