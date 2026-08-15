package com.example.realtor.controller;

import com.example.realtor.model.Property;
import com.example.realtor.model.User;
import com.example.realtor.service.PropertyService;
import com.example.realtor.service.UserService;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/admin/*")
public class AdminServlet extends HttpServlet {
    private UserService userService = new UserService();
    private PropertyService propertyService = new PropertyService();

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
            } else if (path.equals("/users")) {
                String keyword = request.getParameter("keyword");
                List<User> users = keyword != null && !keyword.isEmpty() ? userService.search(keyword) : userService.findAll();
                JsonArray jsonArray = new JsonArray();
                for (User u : users) {
                    JsonObject json = new JsonObject();
                    json.addProperty("id", u.getId());
                    json.addProperty("username", u.getUsername());
                    json.addProperty("email", u.getEmail());
                    json.addProperty("avatar", u.getAvatar());
                    json.addProperty("password", u.getPassword());
                    json.addProperty("role", u.getRole());
                    json.addProperty("createdAt", u.getCreatedAt());
                    jsonArray.add(json);
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());
            } else if (path.equals("/properties")) {
                List<Property> properties = propertyService.findAll();
                JsonArray jsonArray = new JsonArray();
                for (Property p : properties) {
                    JsonObject json = new JsonObject();
                    json.addProperty("id", p.getId());
                    json.addProperty("title", p.getTitle());
                    json.addProperty("type", p.getType());
                    json.addProperty("area", p.getArea());
                    json.addProperty("price", p.getPrice());
                    json.addProperty("region", p.getRegion());
                    json.addProperty("address", p.getAddress());
                    json.addProperty("description", p.getDescription());
                    json.addProperty("imageUrl", p.getImageUrl());
                    json.addProperty("status", p.getStatus());
                    json.addProperty("createdAt", p.getCreatedAt());
                    jsonArray.add(json);
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());
            } else if (path.equals("/pending")) {
                List<Property> properties = propertyService.findPending();
                JsonArray jsonArray = new JsonArray();
                for (Property p : properties) {
                    JsonObject json = new JsonObject();
                    json.addProperty("id", p.getId());
                    json.addProperty("title", p.getTitle());
                    json.addProperty("type", p.getType());
                    json.addProperty("area", p.getArea());
                    json.addProperty("price", p.getPrice());
                    json.addProperty("region", p.getRegion());
                    json.addProperty("address", p.getAddress());
                    json.addProperty("description", p.getDescription());
                    json.addProperty("imageUrl", p.getImageUrl());
                    json.addProperty("createdAt", p.getCreatedAt());
                    jsonArray.add(json);
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String path = request.getPathInfo();
        try {
            if (path.equals("/approve")) {
                int id = Integer.parseInt(request.getParameter("id"));
                propertyService.approve(id);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("message", "审核通过");
                out.println(result.toString());
            } else if (path.equals("/reject")) {
                int id = Integer.parseInt(request.getParameter("id"));
                propertyService.reject(id);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("message", "审核拒绝");
                out.println(result.toString());
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
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String path = request.getPathInfo();
        try {
            if ("/approve".equals(path)) {
                int id = Integer.parseInt(request.getParameter("id"));
                propertyService.approve(id);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("message", "审核通过");
                out.println(result.toString());
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
}
