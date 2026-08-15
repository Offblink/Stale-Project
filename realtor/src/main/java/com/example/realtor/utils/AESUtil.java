package com.example.realtor.utils;

import javax.crypto.Cipher;                       // Java加密/解密核心类
import javax.crypto.spec.SecretKeySpec;            // 用于从字节数组构造AES密钥
import java.util.Base64;                           // Base64编解码，用于将二进制加密结果转为可读字符串

public class AESUtil {
    private static final String ALGORITHM = "AES";
    // 16字节（128位）固定密钥 —— AES支持128/192/256位，这里用128位
    private static final String KEY = "1234567890123456";

    /**
     * 加密明文，返回Base64编码后的密文字符串
     * @param plainText 明文
     * @return Base64密文
     * @throws Exception 加密过程中可能抛出的异常
     */
    public static String encrypt(String plainText) throws Exception {
        // 用16字节密钥构造AES密钥规范对象
        SecretKeySpec keySpec = new SecretKeySpec(KEY.getBytes(), ALGORITHM);
        // 获取AES加密器实例
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        // 初始化加密器为加密模式，传入密钥
        cipher.init(Cipher.ENCRYPT_MODE, keySpec);
        // 执行加密操作，将明文字节数组加密为密文字节数组
        byte[] encryptedBytes = cipher.doFinal(plainText.getBytes());
        // 将密文字节数组用Base64编码为可读字符串并返回
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    /**
     * 解密密文，返回原始明文字符串
     * @param encryptedText Base64编码的密文
     * @return 解密后的明文
     * @throws Exception 解密过程中可能抛出的异常
     */
    public static String decrypt(String encryptedText) throws Exception {
        // 用同样的16字节密钥构造AES密钥规范对象（加解密必须同一密钥）
        SecretKeySpec keySpec = new SecretKeySpec(KEY.getBytes(), ALGORITHM);
        // 获取AES加密器实例
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        // 初始化加密器为解密模式，传入密钥
        cipher.init(Cipher.DECRYPT_MODE, keySpec);
        // 先将Base64密文字符串解码为字节数组
        byte[] decodedBytes = Base64.getDecoder().decode(encryptedText);
        // 执行解密操作，将密文字节数组解密为明文字节数组
        byte[] decryptedBytes = cipher.doFinal(decodedBytes);
        // 将明文字节数组转换为字符串并返回
        return new String(decryptedBytes);
    }
}
