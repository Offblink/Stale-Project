package com.example.captcha;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.google.gson.Gson;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Fish Click Captcha Servlet API
 * 
 * API Endpoints:
 * - GET  /api/captcha/generate - Generate new target position
 * - POST /api/captcha/verify   - Verify user click position
 * - GET  /api/captcha/status   - Get current captcha status
 * - POST /api/captcha/reset    - Reset captcha state
 */
@WebServlet("/api/captcha/*")
public class CaptchaServlet extends HttpServlet {
    
    private static final Gson GSON = new Gson();
    private static final int CONTAINER_WIDTH = 460;
    private static final int CONTAINER_HEIGHT = 280;
    private static final int REQUIRED_CLICKS = 3;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            sendError(response, "Invalid endpoint");
            return;
        }
        
        switch (pathInfo) {
            case "/generate":
                handleGenerate(request, response);
                break;
            case "/status":
                handleStatus(request, response);
                break;
            default:
                sendError(response, "Endpoint not found");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            sendError(response, "Invalid endpoint");
            return;
        }
        
        switch (pathInfo) {
            case "/verify":
                handleVerify(request, response);
                break;
            case "/reset":
                handleReset(request, response);
                break;
            default:
                sendError(response, "Endpoint not found");
        }
    }
    
    /**
     * Generate new target position
     * GET /api/captcha/generate
     * 
     * Response:
     * {
     *   "status": "success",
     *   "targetX": 150,
     *   "targetY": 100,
     *   "requiredClicks": 3
     * }
     */
    private void handleGenerate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        CaptchaService.clearCaptcha(session);
        
        int targetX = CaptchaService.generateTargetPosition(session, CONTAINER_WIDTH, CONTAINER_HEIGHT);
        int targetY = CaptchaService.getTargetY(session);
        
        Map<String, Object> result = new HashMap<>();
        result.put("status", "success");
        result.put("targetX", targetX);
        result.put("targetY", targetY);
        result.put("requiredClicks", REQUIRED_CLICKS);
        
        writeResponse(response, result);
    }
    
    /**
     * Verify user click position
     * POST /api/captcha/verify
     * 
     * Request body:
     * {
     *   "userX": 155,
     *   "userY": 98
     * }
     * 
     * Response:
     * {
     *   "status": "success",
     *   "verified": true,
     *   "complete": false,
     *   "currentCount": 1,
     *   "requiredClicks": 3
     * }
     */
    private void handleVerify(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        
        try {
            Map<String, Integer> data = GSON.fromJson(request.getReader(), Map.class);
            int userX = data.getOrDefault("userX", 0);
            int userY = data.getOrDefault("userY", 0);
            
            boolean verified = CaptchaService.verifyClick(session, userX, userY);
            
            Map<String, Object> result = new HashMap<>();
            
            if (verified) {
                boolean complete = CaptchaService.incrementSuccessCount(session, REQUIRED_CLICKS);
                int currentCount = CaptchaService.getSuccessCount(session);
                
                // Generate new target for next click
                CaptchaService.generateTargetPosition(session, CONTAINER_WIDTH, CONTAINER_HEIGHT);
                
                result.put("status", "success");
                result.put("verified", true);
                result.put("complete", complete);
                result.put("currentCount", currentCount);
                result.put("requiredClicks", REQUIRED_CLICKS);
                result.put("newTargetX", CaptchaService.getTargetX(session));
                result.put("newTargetY", CaptchaService.getTargetY(session));
            } else {
                result.put("status", "success");
                result.put("verified", false);
                result.put("complete", false);
                result.put("currentCount", CaptchaService.getSuccessCount(session));
                result.put("requiredClicks", REQUIRED_CLICKS);
            }
            
            writeResponse(response, result);
        } catch (Exception e) {
            sendError(response, "Invalid request");
        }
    }
    
    /**
     * Get current captcha status
     * GET /api/captcha/status
     * 
     * Response:
     * {
     *   "currentCount": 2,
     *   "requiredClicks": 3,
     *   "progress": 66.67
     * }
     */
    private void handleStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        
        int currentCount = CaptchaService.getSuccessCount(session);
        double progress = (currentCount * 100.0) / REQUIRED_CLICKS;
        
        Map<String, Object> result = new HashMap<>();
        result.put("currentCount", currentCount);
        result.put("requiredClicks", REQUIRED_CLICKS);
        result.put("progress", Math.round(progress * 100.0) / 100.0);
        
        writeResponse(response, result);
    }
    
    /**
     * Reset captcha state
     * POST /api/captcha/reset
     * 
     * Response:
     * {
     *   "status": "success"
     * }
     */
    private void handleReset(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        CaptchaService.clearCaptcha(session);
        
        Map<String, Object> result = new HashMap<>();
        result.put("status", "success");
        
        writeResponse(response, result);
    }
    
    private void writeResponse(HttpServletResponse response, Map<String, Object> data) throws IOException {
        PrintWriter out = response.getWriter();
        out.print(GSON.toJson(data));
        out.flush();
    }
    
    private void sendError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> error = new HashMap<>();
        error.put("status", "error");
        error.put("message", message);
        writeResponse(response, error);
    }
}