package com.example.realtor.controller;

import com.example.realtor.model.User;
import com.example.realtor.service.UserService;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet("/api/user/*")
@MultipartConfig
public class UserServlet extends HttpServlet {
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String path = request.getPathInfo();
        try {
            if (path == null || path.equals("/")) {
                JsonObject error = new JsonObject();
                error.addProperty("status", "error");
                error.addProperty("message", "Invalid path");
                out.println(error.toString());
            } else if (path.equals("/login")) {
                handleLogin(request, out);
            } else if (path.equals("/register")) {
                handleRegister(request, out);
            } else if (path.equals("/update")) {
                handleUpdate(request, out);
            } else if (path.equals("/updateAvatar")) {
                handleUpdateAvatar(request, response, out);
            } else if (path.equals("/updatePassword")) {
                handleUpdatePassword(request, out);
            } else {
                JsonObject error = new JsonObject();
                error.addProperty("status", "error");
                error.addProperty("message", "Not found");
                out.println(error.toString());
            }
        } catch (Exception e) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", e.getMessage());
            out.println(error.toString());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String path = request.getPathInfo();
        try {
            if (path == null || path.equals("/")) {
                JsonObject error = new JsonObject();
                error.addProperty("status", "error");
                error.addProperty("message", "Invalid path");
                out.println(error.toString());
            } else if (path.startsWith("/info/")) {
                int userId = Integer.parseInt(path.substring(6));
                User user = userService.findById(userId);
                if (user != null) {
                    JsonObject json = new JsonObject();
                    json.addProperty("id", user.getId());
                    json.addProperty("username", user.getUsername());
                    json.addProperty("email", user.getEmail());
                    json.addProperty("avatar", user.getAvatar());
                    json.addProperty("role", user.getRole());
                    JsonObject result = new JsonObject();
                    result.addProperty("status", "success");
                    result.add("data", json);
                    out.println(result.toString());
                } else {
                    JsonObject error = new JsonObject();
                    error.addProperty("status", "error");
                    error.addProperty("message", "User not found");
                    out.println(error.toString());
                }
            } else {
                JsonObject error = new JsonObject();
                error.addProperty("status", "error");
                error.addProperty("message", "Not found");
                out.println(error.toString());
            }
        } catch (Exception e) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", e.getMessage());
            out.println(error.toString());
        }
    }

    private void handleLogin(HttpServletRequest request, PrintWriter out) throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.login(username, password);
        if (user != null) {
            JsonObject json = new JsonObject();
            json.addProperty("id", user.getId());
            json.addProperty("username", user.getUsername());
            json.addProperty("email", user.getEmail());
            json.addProperty("avatar", user.getAvatar());
            json.addProperty("role", user.getRole());
            JsonObject result = new JsonObject();
            result.addProperty("status", "success");
            result.add("data", json);
            out.println(result.toString());
        } else {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "用户名或密码错误");
            out.println(error.toString());
        }
    }

    private void handleRegister(HttpServletRequest request, PrintWriter out) throws Exception {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");

        // 邮箱格式验证
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "请输入正确的邮箱格式");
            out.println(error.toString());
            return;
        }

        if (!password.equals(confirmPassword)) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "两次密码不一致");
            out.println(error.toString());
            return;
        }

        User user = userService.register(username, password, email);
        JsonObject json = new JsonObject();
        json.addProperty("id", user.getId());
        json.addProperty("username", user.getUsername());
        json.addProperty("email", user.getEmail());
        json.addProperty("avatar", user.getAvatar());
        json.addProperty("role", user.getRole());
        JsonObject result = new JsonObject();
        result.addProperty("status", "success");
        result.add("data", json);
        out.println(result.toString());
    }

    private void handleUpdate(HttpServletRequest request, PrintWriter out) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        // 邮箱格式验证
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "请输入正确的邮箱格式");
            out.println(error.toString());
            return;
        }

        User user = userService.findById(id);
        if (user != null) {
            user.setUsername(username);
            user.setEmail(email);
            userService.update(user);
            JsonObject result = new JsonObject();
            result.addProperty("status", "success");
            result.addProperty("message", "更新成功");
            out.println(result.toString());
        } else {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "用户不存在");
            out.println(error.toString());
        }
    }

    private void handleUpdatePassword(HttpServletRequest request, PrintWriter out) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        User user = userService.login(userService.findById(id).getUsername(), oldPassword);
        if (user != null) {
            userService.updatePassword(id, newPassword);
            JsonObject result = new JsonObject();
            result.addProperty("status", "success");
            result.addProperty("message", "密码修改成功");
            out.println(result.toString());
        } else {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "原密码错误");
            out.println(error.toString());
        }
    }

    private void handleUpdateAvatar(HttpServletRequest request, HttpServletResponse response, PrintWriter out) throws Exception {
        int userId = Integer.parseInt(request.getParameter("userId"));
        Part filePart = request.getPart("avatar");

        if (filePart == null || filePart.getSize() == 0) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "请选择图片");
            out.println(error.toString());
            return;
        }

        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        byte[] fileBytes = filePart.getInputStream().readAllBytes();

        // 保存到运行时目录（target/realtor/images/avatars/）
        Path runtimeFile = Paths.get(getServletContext().getRealPath("/images/avatars"), fileName);
        Files.createDirectories(runtimeFile.getParent());
        Files.copy(new ByteArrayInputStream(fileBytes), runtimeFile);

        // 保存到源码目录（src/main/webapp/images/avatars/），防止重新编译后丢失
        Path targetRealPath = Paths.get(getServletContext().getRealPath("/"));
        Path projectRoot = targetRealPath.getParent().getParent(); // target/realtor -> target -> 项目根
        Path sourceFile = projectRoot.resolve("src/main/webapp/images/avatars").resolve(fileName);
        Files.createDirectories(sourceFile.getParent());
        Files.copy(new ByteArrayInputStream(fileBytes), sourceFile);

        String avatarPath = "/realtor/images/avatars/" + fileName;
        userService.updateAvatar(userId, avatarPath);

        JsonObject result = new JsonObject();
        result.addProperty("status", "success");
        result.addProperty("message", "头像上传成功");
        result.addProperty("avatar", avatarPath);
        out.println(result.toString());
    }
}