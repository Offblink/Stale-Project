package com.example.captcha;

import jakarta.servlet.http.HttpSession;
import java.util.Random;

/**
 * Fish Click Captcha Service
 * A game-based CAPTCHA service where users click on a swimming fish
 * 
 * Features:
 * - Game-based verification (click the swimming fish)
 * - Natural Gaussian easing for fish movement
 * - Progressive challenge (3 clicks required)
 * - Anti-cheat mechanism with server-side position verification
 */
public class CaptchaService {
    
    private static final Random RANDOM = new Random();
    private static final int TOLERANCE = 15; // Position tolerance in pixels
    
    /**
     * Generate a new random target position for the fish
     * @param session HTTP session to store the target
     * @param containerWidth width of the captcha container
     * @param containerHeight height of the captcha container
     * @return the generated target X position
     */
    public static int generateTargetPosition(HttpSession session, int containerWidth, int containerHeight) {
        int targetX = 50 + RANDOM.nextInt(containerWidth - 100);
        int targetY = 50 + RANDOM.nextInt(containerHeight - 150);
        
        session.setAttribute("captchaTargetX", targetX);
        session.setAttribute("captchaTargetY", targetY);
        
        return targetX;
    }
    
    /**
     * Verify if the user's click position is valid
     * @param session HTTP session containing the target position
     * @param userX the X coordinate clicked by the user
     * @param userY the Y coordinate clicked by the user
     * @return true if the click is within tolerance of the target
     */
    public static boolean verifyClick(HttpSession session, int userX, int userY) {
        Integer targetX = (Integer) session.getAttribute("captchaTargetX");
        Integer targetY = (Integer) session.getAttribute("captchaTargetY");
        
        if (targetX == null || targetY == null) {
            return false;
        }
        
        int dx = Math.abs(userX - targetX);
        int dy = Math.abs(userY - targetY);
        
        return dx <= TOLERANCE && dy <= TOLERANCE;
    }
    
    /**
     * Get the current target X position
     * @param session HTTP session
     * @return target X position or 0 if not set
     */
    public static int getTargetX(HttpSession session) {
        Integer targetX = (Integer) session.getAttribute("captchaTargetX");
        return targetX != null ? targetX : 0;
    }
    
    /**
     * Get the current target Y position
     * @param session HTTP session
     * @return target Y position or 0 if not set
     */
    public static int getTargetY(HttpSession session) {
        Integer targetY = (Integer) session.getAttribute("captchaTargetY");
        return targetY != null ? targetY : 0;
    }
    
    /**
     * Clear the captcha state from session
     * @param session HTTP session
     */
    public static void clearCaptcha(HttpSession session) {
        session.removeAttribute("captchaTargetX");
        session.removeAttribute("captchaTargetY");
        session.removeAttribute("captchaSuccessCount");
    }
    
    /**
     * Increment success count and check if verification is complete
     * @param session HTTP session
     * @param requiredClicks number of clicks required for verification
     * @return true if verification is complete
     */
    public static boolean incrementSuccessCount(HttpSession session, int requiredClicks) {
        Integer count = (Integer) session.getAttribute("captchaSuccessCount");
        count = count != null ? count + 1 : 1;
        session.setAttribute("captchaSuccessCount", count);
        
        return count >= requiredClicks;
    }
    
    /**
     * Get current success count
     * @param session HTTP session
     * @return current success count
     */
    public static int getSuccessCount(HttpSession session) {
        Integer count = (Integer) session.getAttribute("captchaSuccessCount");
        return count != null ? count : 0;
    }
    
    /**
     * Calculate Gaussian easing value for smooth fish movement
     * @param t progress from 0 to 1
     * @return eased value from 0 to 1
     */
    public static double gaussianEasing(double t) {
        double mean = 0.5;
        double sigma = 0.12;
        double exponent = -Math.pow(t - mean, 2) / (2 * Math.pow(sigma, 2));
        return Math.exp(exponent);
    }
}