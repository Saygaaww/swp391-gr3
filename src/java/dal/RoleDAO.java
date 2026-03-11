package dal;

import model.Role;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DBContext {
    
    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM Role ORDER BY role_id";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                roles.add(role);
            }
            
            System.out.println("RoleDAO: Lấy được " + roles.size() + " roles");
            
        } catch (Exception e) {
            System.err.println("Error in getAllRoles: " + e.getMessage());
            e.printStackTrace();
        }
        
        return roles;
    }
    
    public Role getRoleById(int roleId) {
        String sql = "SELECT * FROM Role WHERE role_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                return role;
            }
            
        } catch (Exception e) {
            System.err.println("Error in getRoleById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public Role getRoleByName(String roleName) {
        String sql = "SELECT * FROM Role WHERE role_name = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                role.setDescription(rs.getString("description"));
                return role;
            }
            
        } catch (Exception e) {
            System.err.println("Error in getRoleByName: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addRole(Role role) {
        String sql = "INSERT INTO Role (role_name, description) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role.getRoleName());
            ps.setString(2, role.getDescription());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("RoleDAO: Thêm role thành công - " + role.getRoleName());
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Error in addRole: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean updateRole(Role role) {
        String sql = "UPDATE Role SET role_name = ?, description = ? WHERE role_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role.getRoleName());
            ps.setString(2, role.getDescription());
            ps.setInt(3, role.getRoleId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("RoleDAO: Cập nhật role ID: " + role.getRoleId());
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Error in updateRole: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean deleteRole(int roleId) {
        String sql = "DELETE FROM Role WHERE role_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, roleId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("RoleDAO: Xóa role ID: " + roleId);
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("Error in deleteRole: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}