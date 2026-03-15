package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * AuthUtil - Utility class for authentication and authorization
 * 
 * @author FPT Student Team
 */
public class AuthUtil {

    // Session attribute keys
    public static final String SESSION_USER = "user";
    public static final String SESSION_USER_ID = "userId";
    public static final String SESSION_USER_ROLE = "userRole";
    public static final String SESSION_EMPLOYEE_ID = "employeeId";

    // Role constants
    public static final String ROLE_LIBRARIAN = "Librarian";
    public static final String ROLE_SELLER = "Seller";
    public static final String ROLE_ADMIN = "Admin";
    public static final String ROLE_CUSTOMER = "Customer";
    public static final String ROLE_READER = "Reader";

    /**
     * Check if user is logged in
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute(SESSION_USER) != null;
    }

    /**
     * Get current user role from session
     */
    public static String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object role = session.getAttribute(SESSION_USER_ROLE);
            return role != null ? role.toString() : null;
        }
        return null;
    }

    /**
     * Get current employee ID from session
     */
    public static Integer getEmployeeId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object employeeId = session.getAttribute(SESSION_EMPLOYEE_ID);
            if (employeeId instanceof Integer) {
                return (Integer) employeeId;
            } else if (employeeId != null) {
                try {
                    return Integer.parseInt(employeeId.toString());
                } catch (NumberFormatException e) {
                    return null;
                }
            }
        }
        return null;
    }

    /**
     * Check if user has Librarian or Seller role
     */
    public static boolean isLibrarianOrSeller(HttpServletRequest request) {
        String role = getUserRole(request);
        return ROLE_LIBRARIAN.equals(role) || ROLE_SELLER.equals(role);
    }

    /**
     * Check if user has specific role
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        String userRole = getUserRole(request);
        return role != null && role.equals(userRole);
    }

    /**
     * Check if user has any of the specified roles
     */
    public static boolean hasAnyRole(HttpServletRequest request, String... roles) {
        String userRole = getUserRole(request);
        if (userRole == null) {
            return false;
        }

        for (String role : roles) {
            if (role.equals(userRole)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check if user is Admin
     */
    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, ROLE_ADMIN);
    }

    /**
     * Check if user is Librarian
     */
    public static boolean isLibrarian(HttpServletRequest request) {
        return hasRole(request, ROLE_LIBRARIAN);
    }

    /**
     * Check if user is Seller
     */
    public static boolean isSeller(HttpServletRequest request) {
        return hasRole(request, ROLE_SELLER);
    }

    /**
     * Check if user can manage authors/categories (Librarian or Seller or Admin)
     */
    public static boolean canManageCatalog(HttpServletRequest request) {
        return isLibrarianOrSeller(request) || isAdmin(request);
    }

    /**
     * Check if user can manage books (Librarian or Seller or Admin)
     */
    public static boolean canManageBooks(HttpServletRequest request) {
        return isLibrarianOrSeller(request) || isAdmin(request);
    }

    /**
     * Check if user is a Reader (end user / customer)
     */
    public static boolean isReader(HttpServletRequest request) {
        String role = getUserRole(request);
        return ROLE_READER.equalsIgnoreCase(String.valueOf(role));
    }

    /**
     * Get Reader ID from session
     */
    public static Integer getReaderId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object readerId = session.getAttribute("readerId");
            if (readerId instanceof Integer)
                return (Integer) readerId;
            if (readerId != null) {
                try {
                    return Integer.parseInt(readerId.toString());
                } catch (NumberFormatException e) {
                    return null;
                }
            }
        }
        return null;
    }
}
