package com.vibeshop.servlet;

import com.google.gson.Gson;
import com.vibeshop.model.User;
import com.vibeshop.service.UserService;
import com.vibeshop.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Map;

@WebServlet("/api/user/*")
public class UserServlet extends HttpServlet {
    private UserService userService = new UserService();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if ("/register".equals(pathInfo)) {
            BufferedReader reader = request.getReader();
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            Map<String, Object> data = gson.fromJson(sb.toString(), Map.class);
            String phone = (String) data.get("phone");

            Map<String, Object> result = userService.register(phone);

            boolean success = (Boolean) result.get("success");
            String message = (String) result.get("message");
            if (success) {
                response.getWriter().write(JsonUtil.success(message, result.get("user")));
            } else {
                response.getWriter().write(JsonUtil.error(400, message));
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/")) {
            String idStr = pathInfo.substring(1);
            try {
                Integer userId = Integer.parseInt(idStr);
                User user = userService.getUserById(userId);
                if (user != null) {
                    response.getWriter().write(JsonUtil.success(user));
                } else {
                    response.getWriter().write(JsonUtil.error(404, "用户不存在"));
                }
            } catch (NumberFormatException e) {
                response.getWriter().write(JsonUtil.error(400, "无效的用户ID"));
            }
        }
    }
}
