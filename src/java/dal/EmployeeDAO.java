package dal;

import model.Employee;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends DBContext {

    public List<Employee> getAllEmployees() {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, r.role_name " +
                "FROM Employee e " +
                "LEFT JOIN Role r ON e.role_id = r.role_id " +
                "ORDER BY e.created_at DESC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Employee emp = extractEmployeeFromResultSet(rs);
                employees.add(emp);
            }

            System.out.println("EmployeeDAO: Lấy được " + employees.size() + " nhân viên");

        } catch (Exception e) {
            System.err.println("Error in getAllEmployees: " + e.getMessage());
            e.printStackTrace();
        }

        return employees;
    }

    public List<Employee> getEmployeesByPage(int page, int pageSize) {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, r.role_name " +
                "FROM Employee e " +
                "LEFT JOIN Role r ON e.role_id = r.role_id " +
                "ORDER BY e.created_at DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            int offset = (page - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                employees.add(extractEmployeeFromResultSet(rs));
            }

            System.out.println("EmployeeDAO: Trang " + page + " - " + employees.size() + " nhân viên");

        } catch (Exception e) {
            System.err.println("Error in getEmployeesByPage: " + e.getMessage());
            e.printStackTrace();
        }

        return employees;
    }

    public Employee getEmployeeById(int employeeId) {
        String sql = "SELECT e.*, r.role_name " +
                "FROM Employee e " +
                "LEFT JOIN Role r ON e.role_id = r.role_id " +
                "WHERE e.employee_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractEmployeeFromResultSet(rs);
            }

        } catch (Exception e) {
            System.err.println("Error in getEmployeeById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public Employee getEmployeeByEmail(String email) {
        String sql = "SELECT e.*, r.role_name " +
                "FROM Employee e " +
                "LEFT JOIN Role r ON e.role_id = r.role_id " +
                "WHERE e.email = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractEmployeeFromResultSet(rs);
            }

        } catch (Exception e) {
            System.err.println("Error in getEmployeeByEmail: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean addEmployee(Employee employee) {
        String sql = "INSERT INTO Employee (full_name, email, password_hash, status, role_id) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, employee.getFullName());
            ps.setString(2, employee.getEmail());
            ps.setString(3, employee.getPasswordHash());
            ps.setString(4, employee.getStatus() != null ? employee.getStatus() : "active");

            if (employee.getRoleId() > 0) {
                ps.setInt(5, employee.getRoleId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            int rowsAffected = ps.executeUpdate();
            System.out.println("EmployeeDAO: Thêm nhân viên thành công - " + employee.getEmail());
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in addEmployee: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateEmployee(Employee employee) {
        String sql = "UPDATE Employee SET " +
                "full_name = ?, email = ?, status = ?, role_id = ? " +
                "WHERE employee_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, employee.getFullName());
            ps.setString(2, employee.getEmail());
            ps.setString(3, employee.getStatus());

            if (employee.getRoleId() > 0) {
                ps.setInt(4, employee.getRoleId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            ps.setInt(5, employee.getEmployeeId());

            int rowsAffected = ps.executeUpdate();
            System.out.println("EmployeeDAO: Cập nhật nhân viên ID: " + employee.getEmployeeId());
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in updateEmployee: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateEmployeePassword(int employeeId, String newPasswordHash) {
        String sql = "UPDATE Employee SET password_hash = ? WHERE employee_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPasswordHash);
            ps.setInt(2, employeeId);

            int rowsAffected = ps.executeUpdate();
            System.out.println("EmployeeDAO: Cập nhật mật khẩu nhân viên ID: " + employeeId);
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in updateEmployeePassword: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateEmployeeStatus(int employeeId, String status) {
        String sql = "UPDATE Employee SET status = ? WHERE employee_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, employeeId);

            int rowsAffected = ps.executeUpdate();
            System.out.println("EmployeeDAO: Cập nhật trạng thái nhân viên ID: " + employeeId + " -> " + status);
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in updateEmployeeStatus: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteEmployee(int employeeId) {
        String sql = "DELETE FROM Employee WHERE employee_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("EmployeeDAO: Xóa nhân viên ID: " + employeeId);
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in deleteEmployee: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public List<Employee> searchEmployees(String keyword) {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, r.role_name " +
                "FROM Employee e " +
                "LEFT JOIN Role r ON e.role_id = r.role_id " +
                "WHERE e.full_name LIKE ? OR e.email LIKE ? " +
                "ORDER BY e.created_at DESC";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                employees.add(extractEmployeeFromResultSet(rs));
            }

            System.out.println("EmployeeDAO: Tìm được " + employees.size() + " nhân viên với keyword: " + keyword);

        } catch (Exception e) {
            System.err.println("Error in searchEmployees: " + e.getMessage());
            e.printStackTrace();
        }

        return employees;
    }

    public List<Employee> searchEmployeesByPage(String keyword, int page, int pageSize) {
        List<Employee> employees = new ArrayList<>();
        String sql = "SELECT e.*, r.role_name " +
                "FROM Employee e " +
                "LEFT JOIN Role r ON e.role_id = r.role_id " +
                "WHERE e.full_name LIKE ? OR e.email LIKE ? " +
                "ORDER BY e.created_at DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            int offset = (page - 1) * pageSize;
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                employees.add(extractEmployeeFromResultSet(rs));
            }

        } catch (Exception e) {
            System.err.println("Error in searchEmployeesByPage: " + e.getMessage());
            e.printStackTrace();
        }

        return employees;
    }

    public int getTotalEmployees() {
        String sql = "SELECT COUNT(*) FROM Employee";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error in getTotalEmployees: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    // Lay danh sach nhan vien co loc + phan trang (dung cho EmployeeListServlet)
    public List<Employee> getEmployeesFiltered(String keyword, int roleId, String status,
            int page, int pageSize) {
        List<Employee> employees = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT e.*, r.role_name ");
        sql.append("FROM Employee e ");
        sql.append("LEFT JOIN Role r ON e.role_id = r.role_id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (e.full_name LIKE ? OR e.email LIKE ?) ");
        }
        if (roleId > 0)
            sql.append("AND e.role_id = ? ");
        if (status != null && !status.isEmpty())
            sql.append("AND e.status = ? ");

        sql.append("ORDER BY e.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (roleId > 0)
                ps.setInt(idx++, roleId);
            if (status != null && !status.isEmpty())
                ps.setString(idx++, status);

            int offset = (page - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                employees.add(extractEmployeeFromResultSet(rs));
            }

        } catch (Exception e) {
            System.err.println("Error in getEmployeesFiltered: " + e.getMessage());
            e.printStackTrace();
        }
        return employees;
    }

    // Dem so nhan vien co loc (dung cho phan trang)
    public int countEmployeesFiltered(String keyword, int roleId, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Employee e WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (e.full_name LIKE ? OR e.email LIKE ?) ");
        }
        if (roleId > 0)
            sql.append("AND e.role_id = ? ");
        if (status != null && !status.isEmpty())
            sql.append("AND e.status = ? ");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (roleId > 0)
                ps.setInt(idx++, roleId);
            if (status != null && !status.isEmpty())
                ps.setString(idx++, status);

            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);

        } catch (Exception e) {
            System.err.println("Error in countEmployeesFiltered: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Dem nhan vien theo trang thai
    public int countEmployeesByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Employee WHERE status = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("Error in countEmployeesByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countEmployeesByKeyword(String keyword) {
        String sql = "SELECT COUNT(*) FROM Employee " +
                "WHERE full_name LIKE ? OR email LIKE ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error in countEmployeesByKeyword: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public int countEmployeesByRole(int roleId) {
        String sql = "SELECT COUNT(*) FROM Employee WHERE role_id = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error in countEmployeesByRole: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Employee WHERE email = ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            System.err.println("Error in isEmailExists: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean isEmailExistsExcept(String email, int exceptEmployeeId) {
        String sql = "SELECT COUNT(*) FROM Employee WHERE email = ? AND employee_id != ?";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setInt(2, exceptEmployeeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            System.err.println("Error in isEmailExistsExcept: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    private Employee extractEmployeeFromResultSet(ResultSet rs) throws SQLException {
        Employee emp = new Employee();
        emp.setEmployeeId(rs.getInt("employee_id"));
        emp.setFullName(rs.getString("full_name"));
        emp.setEmail(rs.getString("email"));
        emp.setPasswordHash(rs.getString("password_hash"));
        emp.setStatus(rs.getString("status"));
        emp.setCreatedAt(
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        emp.setRoleId(rs.getInt("role_id"));

        // JOIN data
        emp.setRoleName(rs.getString("role_name"));

        return emp;
    }
}