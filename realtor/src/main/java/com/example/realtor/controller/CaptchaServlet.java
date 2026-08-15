package com.example.realtor.controller;

import com.google.gson.JsonObject;                // Gson的JSON对象，用于构造响应

import jakarta.servlet.ServletException;          // Servlet异常
import jakarta.servlet.annotation.WebServlet;     // 注解方式注册Servlet，无需web.xml
import jakarta.servlet.http.HttpServlet;          // HttpServlet基类
import jakarta.servlet.http.HttpServletRequest;   // HTTP请求对象
import jakarta.servlet.http.HttpServletResponse;  // HTTP响应对象
import jakarta.servlet.http.HttpSession;          // 会话对象，用于跨请求存储验证码位置
import java.io.IOException;                       // IO异常
import java.io.PrintWriter;                       // 输出字符流，向客户端写JSON响应
import java.util.Random;                          // 生成随机数，用于随机目标位置

@WebServlet("/api/captcha/*")                     // 拦截所有 /api/captcha/ 开头的请求
public class CaptchaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();   // 获取输出流，用于向客户端写入JSON

        String path = request.getPathInfo();      // 提取URL中的子路径，如 /generate
        try {
            if (path.equals("/generate")) {       // GET /api/captcha/generate —— 生成验证码
                // 生成50~250之间的随机整数，作为小鱼的目标X坐标位置
                int targetPosition = new Random().nextInt(200) + 50;
                HttpSession session = request.getSession(); // 获取当前会话
                session.setAttribute("captchaPosition", targetPosition); // 存入会话供后续验证

                JsonObject data = new JsonObject();
                data.addProperty("targetPosition", targetPosition); // 把目标位置放进data对象

                JsonObject result = new JsonObject();
                result.addProperty("status", "success");  // 状态：成功
                result.add("data", data);                 // 数据
                out.println(result.toString());           // 输出JSON给前端
            } else {
                // 未匹配的路由，返回404风格错误
                JsonObject error = new JsonObject();
                error.addProperty("status", "error");
                error.addProperty("message", "Not found");
                out.println(error.toString());
            }
        } catch (Exception e) {
            // 异常兜底 —— 返回错误信息给前端
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", e.getMessage());
            out.println(error.toString());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PrintWriter out = response.getWriter();   // 获取输出流

        String path = request.getPathInfo();      // 提取子路径，如 /verify
        try {
            if (path.equals("/verify")) {         // POST /api/captcha/verify —— 验证用户点击
                // 从请求参数中获取用户点击的X坐标
                int userPosition = Integer.parseInt(request.getParameter("position"));
                HttpSession session = request.getSession(); // 获取当前会话
                // 从会话中取出之前存储的目标位置
                Integer targetPosition = (Integer) session.getAttribute("captchaPosition");

                if (targetPosition != null) {     // 目标位置存在（说明先调用了generate）
                    int tolerance = 15;           // 容差 ±15px，允许一定误差
                    // 用户位置与目标位置的绝对差值 ≤ 容差，即验证通过
                    boolean success = Math.abs(userPosition - targetPosition) <= tolerance;

                    if (success) {
                        // 验证通过，标记会话已验证，后续注册时校验此标记
                        session.setAttribute("captchaVerified", true);
                    }

                    JsonObject result = new JsonObject();
                    result.addProperty("status", "success");
                    result.addProperty("data", success);  // true/false 表示是否通过
                    out.println(result.toString());
                } else {
                    // 还没生成验证码就直接来验证 —— 拒绝
                    JsonObject error = new JsonObject();
                    error.addProperty("status", "error");
                    error.addProperty("message", "请先获取验证码");
                    out.println(error.toString());
                }
            } else {
                // 未匹配的路由
                JsonObject error = new JsonObject();
                error.addProperty("status", "error");
                error.addProperty("message", "Not found");
                out.println(error.toString());
            }
        } catch (Exception e) {
            // 异常兜底
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", e.getMessage());
            out.println(error.toString());
        }
    }
}
