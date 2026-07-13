package util;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.Normalizer;
import java.util.regex.Pattern;

/**
 * StringUtil - Utility class for string operations
 * @author FPT Student Team
 */
public class StringUtil {
    
    private static final DecimalFormat CURRENCY_FORMAT = new DecimalFormat("#,###");
    private static final Pattern DIACRITICS_PATTERN = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    
    /**
     * Check if string is null or blank
     */
    public static boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Check if string is not blank
     */
    public static boolean isNotBlank(String str) {
        return !isBlank(str);
    }
    
    /**
     * Get string or default value if blank
     */
    public static String getOrDefault(String str, String defaultValue) {
        return isBlank(str) ? defaultValue : str.trim();
    }
    
    /**
     * Clean user input - remove dangerous characters and trim
     */
    public static String cleanInput(String input) {
        if (isBlank(input)) {
            return null;
        }
        
        // Remove potentially dangerous characters
        String cleaned = input.replaceAll("[<>\"'&]", "");
        
        // Normalize whitespace
        cleaned = cleaned.trim().replaceAll("\\s+", " ");
        
        // Limit length
        if (cleaned.length() > 255) {
            cleaned = cleaned.substring(0, 255);
        }
        
        return isBlank(cleaned) ? null : cleaned;
    }
    
    /**
     * Normalize Vietnamese text for search
     * Removes diacritics and converts to lowercase
     */
    public static String normalizeVietnamese(String text) {
        if (isBlank(text)) {
            return text;
        }
        
        // Convert to lowercase
        String normalized = text.toLowerCase();
        
        // Remove Vietnamese diacritics
        normalized = removeDiacritics(normalized);
        
        return normalized.trim();
    }
    
    /**
     * Remove Vietnamese diacritics from text
     */
    public static String removeDiacritics(String text) {
        if (isBlank(text)) {
            return text;
        }
        
        // Normalize to NFD (decomposed form)
        String normalized = Normalizer.normalize(text, Normalizer.Form.NFD);
        
        // Remove diacritical marks
        return DIACRITICS_PATTERN.matcher(normalized).replaceAll("");
    }
    
    /**
     * Truncate text to specified length with ellipsis
     */
    public static String truncateText(String text, int maxLength) {
        if (isBlank(text) || text.length() <= maxLength) {
            return text;
        }
        
        // Try to break at word boundary
        String truncated = text.substring(0, maxLength);
        int lastSpace = truncated.lastIndexOf(' ');
        
        if (lastSpace > maxLength * 0.7) { // If space is not too far back
            truncated = truncated.substring(0, lastSpace);
        }
        
        return truncated + "...";
    }
    
    /**
     * Format text for display (capitalize first letter of each word)
     */
    public static String toTitleCase(String text) {
        if (isBlank(text)) {
            return text;
        }
        
        String[] words = text.toLowerCase().split("\\s+");
        StringBuilder titleCase = new StringBuilder();
        
        for (String word : words) {
            if (!word.isEmpty()) {
                if (titleCase.length() > 0) {
                    titleCase.append(" ");
                }
                titleCase.append(Character.toUpperCase(word.charAt(0)))
                         .append(word.substring(1));
            }
        }
        
        return titleCase.toString();
    }
    
    /**
     * Format currency (Vietnamese Dong)
     */
    public static String formatCurrency(BigDecimal amount) {
        if (amount == null) {
            return "0 VNĐ";
        }
        
        return CURRENCY_FORMAT.format(amount) + " VNĐ";
    }
    
    /**
     * Format number with thousand separators
     */
    public static String formatNumber(Number number) {
        if (number == null) {
            return "0";
        }
        
        return CURRENCY_FORMAT.format(number);
    }
    
    /**
     * Check if string is a valid email format
     */
    public static boolean isValidEmail(String email) {
        if (isBlank(email)) {
            return false;
        }
        
        String emailPattern = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$";
        return email.matches(emailPattern);
    }
    
    /**
     * Check if string is a valid phone number (Vietnamese format)
     */
    public static boolean isValidPhoneNumber(String phone) {
        if (isBlank(phone)) {
            return false;
        }
        
        // Remove spaces and dashes
        String cleanPhone = phone.replaceAll("[\\s-]", "");
        
        // Vietnamese phone pattern: 0xxxxxxxxx or +84xxxxxxxxx
        String phonePattern = "^(\\+84|0)(3[2-9]|5[689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$";
        return cleanPhone.matches(phonePattern);
    }
    
    /**
     * Sanitize HTML input to prevent XSS
     */
    public static String escapeHtml(String input) {
        if (isBlank(input)) {
            return input;
        }
        
        return input
                .replaceAll("&", "&amp;")
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&#x27;");
    }
    
    /**
     * Create excerpt from text with highlighted keywords
     */
    public static String createExcerpt(String fullText, String searchTerm, int maxLength) {
        if (isBlank(fullText)) {
            return "";
        }
        
        if (isBlank(searchTerm)) {
            return truncateText(fullText, maxLength);
        }
        
        String normalizedText = normalizeVietnamese(fullText);
        String normalizedSearch = normalizeVietnamese(searchTerm);
        
        int index = normalizedText.indexOf(normalizedSearch);
        
        if (index == -1) {
            return truncateText(fullText, maxLength);
        }
        
        // Try to center the search term in the excerpt
        int startPos = Math.max(0, index - maxLength / 2);
        int endPos = Math.min(fullText.length(), startPos + maxLength);
        
        String excerpt = fullText.substring(startPos, endPos);
        
        if (startPos > 0) {
            excerpt = "..." + excerpt;
        }
        if (endPos < fullText.length()) {
            excerpt = excerpt + "...";
        }
        
        return excerpt;
    }
    
    /**
     * Generate slug from text (URL-friendly)
     */
    public static String toSlug(String text) {
        if (isBlank(text)) {
            return "";
        }
        
        // Remove diacritics and convert to lowercase
        String slug = removeDiacritics(text.toLowerCase());
        
        // Replace spaces and special characters with hyphens
        slug = slug.replaceAll("[^a-z0-9]+", "-");
        
        // Remove leading/trailing hyphens
        slug = slug.replaceAll("^-+|-+$", "");
        
        // Collapse multiple hyphens
        slug = slug.replaceAll("-+", "-");
        
        return slug;
    }
    
    /**
     * Convert string to proper case (first letter uppercase)
     */
    public static String toProperCase(String str) {
        if (isBlank(str)) {
            return str;
        }
        
        str = str.trim();
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
    
    /**
     * Check if text contains keyword (case and diacritic insensitive)
     */
    public static boolean containsIgnoreCase(String text, String keyword) {
        if (isBlank(text) || isBlank(keyword)) {
            return false;
        }
        
        String normalizedText = normalizeVietnamese(text);
        String normalizedKeyword = normalizeVietnamese(keyword);
        
        return normalizedText.contains(normalizedKeyword);
    }
    
    /**
     * Highlight keywords in text (for search results)
     */
    public static String highlightKeywords(String text, String keyword) {
        if (isBlank(text) || isBlank(keyword)) {
            return text;
        }
        
        // Simple highlighting with <mark> tags
        String pattern = "(?i)" + Pattern.quote(keyword);
        return text.replaceAll(pattern, "<mark>$0</mark>");
    }
    
    /**
     * Generate breadcrumb text
     */
    public static String generateBreadcrumb(String... parts) {
        if (parts == null || parts.length == 0) {
            return "";
        }
        
        StringBuilder breadcrumb = new StringBuilder();
        for (int i = 0; i < parts.length; i++) {
            if (isNotBlank(parts[i])) {
                if (breadcrumb.length() > 0) {
                    breadcrumb.append(" > ");
                }
                breadcrumb.append(parts[i]);
            }
        }
        
        return breadcrumb.toString();
    }
    
    /**
     * Get file extension from filename
     */
    public static String getFileExtension(String filename) {
        if (isBlank(filename)) {
            return "";
        }
        
        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == filename.length() - 1) {
            return "";
        }
        
        return filename.substring(lastDotIndex + 1).toLowerCase();
    }
    
    /**
     * Check if file is image by extension
     */
    public static boolean isImageFile(String filename) {
        String extension = getFileExtension(filename);
        return "jpg".equals(extension) || "jpeg".equals(extension) || 
               "png".equals(extension) || "gif".equals(extension) || 
               "bmp".equals(extension) || "webp".equals(extension);
    }
}