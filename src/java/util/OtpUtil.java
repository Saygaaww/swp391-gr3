/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author admin
 */
public class OtpUtil {
    public static String generateOtp() {
        return String.valueOf((int)(Math.random() * 900000) + 100000);
    }
}
