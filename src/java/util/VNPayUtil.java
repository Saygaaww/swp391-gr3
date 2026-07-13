package util;

import jakarta.servlet.http.HttpServletRequest;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Ti?n ích tạo URL thanh toán VNPay và xác thực kết quả trả v??.
 * Bạn có th? ch?nh sửa logic hash hoặc tham s? theo tài li?u VNPay.
 */
public class VNPayUtil {

    /**
     * Tạo URL chuy?n hư?ng sang VNPay
     * @param amount S? ti??n (VND) - VNPay yêu cầu amount * 100
     * @param orderId Mã ?ơn hàng (vnp_TxnRef) - không trùng trong ngày
     * @param orderInfo Mô tả ?ơn hàng (không dấu, không ký tự ?ặc bi?t)
     * @param returnUrl URL VNPay redirect v?? sau khi thanh toán
     * @param ipAddr IP khách hàng
     */
    public static String createPaymentUrl(long amount, String orderId, String orderInfo,
                                          String returnUrl, String ipAddr) throws Exception {

        Map<String, String> vnpParams = new TreeMap<>();
        vnpParams.put("vnp_Version", VNPayConfig.vnp_Version);
        vnpParams.put("vnp_Command", VNPayConfig.vnp_Command);
        vnpParams.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnpParams.put("vnp_Amount", String.valueOf(amount * 100)); // VNPay: s? ti??n * 100
        vnpParams.put("vnp_CurrCode", VNPayConfig.vnp_CurrCode);
        vnpParams.put("vnp_TxnRef", orderId);
        vnpParams.put("vnp_OrderInfo", orderInfo);
        vnpParams.put("vnp_OrderType", VNPayConfig.vnp_OrderType);
        vnpParams.put("vnp_Locale", VNPayConfig.vnp_Locale);
        vnpParams.put("vnp_ReturnUrl", returnUrl);
        vnpParams.put("vnp_IpAddr", ipAddr);
        vnpParams.put("vnp_CreateDate", new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));

        StringBuilder signData = new StringBuilder();
        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> e : vnpParams.entrySet()) {
            if (e.getValue() != null && !e.getValue().isEmpty()) {
                hashData.append(e.getKey()).append("=")
                        .append(URLEncoder.encode(e.getValue(), StandardCharsets.US_ASCII))
                        .append("&");
            }
        }
        if (hashData.length() > 0) hashData.setLength(hashData.length() - 1);

        String sign = hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        vnpParams.put("vnp_SecureHash", sign);

        StringBuilder url = new StringBuilder(VNPayConfig.vnp_Url).append("?");
        for (Map.Entry<String, String> e : vnpParams.entrySet()) {
            url.append(URLEncoder.encode(e.getKey(), StandardCharsets.US_ASCII)).append("=")
               .append(URLEncoder.encode(e.getValue(), StandardCharsets.US_ASCII)).append("&");
        }
        if (url.charAt(url.length() - 1) == '&') url.setLength(url.length() - 1);
        return url.toString();
    }

    /**
     * Xác thực chữ ký trả v?? từ VNPay (vnp_SecureHash)
     */
    public static boolean verifyReturn(HttpServletRequest request) {
        Map<String, String> params = new TreeMap<>();
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            if (name.startsWith("vnp_") && !"vnp_SecureHash".equals(name) && !"vnp_SecureHashType".equals(name)) {
                params.put(name, request.getParameter(name));
            }
        }
        String receivedHash = request.getParameter("vnp_SecureHash");
        if (receivedHash == null || receivedHash.isEmpty()) return false;

        StringBuilder hashData = new StringBuilder();
        for (Map.Entry<String, String> e : params.entrySet()) {
            if (e.getValue() != null && !e.getValue().isEmpty()) {
                hashData.append(e.getKey()).append("=")
                        .append(URLEncoder.encode(e.getValue(), StandardCharsets.US_ASCII))
                        .append("&");
            }
        }
        if (hashData.length() > 0) hashData.setLength(hashData.length() - 1);

        try {
            String calculated = hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
            return calculated.equalsIgnoreCase(receivedHash);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String hmacSHA512(String key, String data) throws Exception {
        Mac hmac = Mac.getInstance("HmacSHA512");
        SecretKeySpec spec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
        hmac.init(spec);
        byte[] hash = hmac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder hex = new StringBuilder();
        for (byte b : hash) hex.append(String.format("%02x", b));
        return hex.toString();
    }

    /** Chuy?n USD sang VND (tỷ giá mẫu - bạn tự cập nhật) */
    public static long usdToVnd(java.math.BigDecimal usd) {
        return usd.multiply(java.math.BigDecimal.valueOf(24000)).longValue();
    }
}

