package util;

/**
 * Cấu hình VNPay - BẠN TỰ THAY M? SAU
 * ???ng ký tại: https://sandbox.vnpayment.vn/ hoặc https://vnpay.vn/
 */
public class VNPayConfig {

    public static String vnp_TmnCode = "FRJBTS9E";       // Mã merchant VNPay cung cấp
    public static String vnp_HashSecret = "SLZ3DFXMX6SNSNKS96IW4BYHTH9QZU96"; // Secret key từ VNPay
    public static String vnp_Url = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";  // Sandbox
    // Production: "https://vnpayment.vn/paymentv2/vpcpay.html"

    public static String vnp_ApiUrl = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    public static String vnp_Version = "2.1.0";
    public static String vnp_Command = "pay";
    public static String vnp_CurrCode = "VND";
    public static String vnp_Locale = "vn";
    public static String vnp_OrderType = "billpayment";
}
