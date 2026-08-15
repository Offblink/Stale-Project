package com.example.realtor.controller;

import com.example.realtor.model.Property;
import com.example.realtor.service.FavoriteService;
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

@WebServlet("/api/favorite/*")
public class FavoriteServlet extends HttpServlet {
    private FavoriteService favoriteService = new FavoriteService();

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
            } else if (path.startsWith("/list/")) {
                int userId = Integer.parseInt(path.substring(6));
                List<Property> properties = favoriteService.getFavoriteProperties(userId);
                JsonArray jsonArray = new JsonArray();
                for (Property p : properties) {
                    jsonArray.add(propertyToJson(p));
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());
            } else if (path.startsWith("/check/")) {
                String[] parts = path.substring(8).split("/");
                int userId = Integer.parseInt(parts[0]);
                int propertyId = Integer.parseInt(parts[1]);
                boolean isFavorite = favoriteService.isFavorite(userId, propertyId);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("data", isFavorite);
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
            if (path.equals("/add")) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int propertyId = Integer.parseInt(request.getParameter("propertyId"));
                favoriteService.addFavorite(userId, propertyId);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("message", "收藏成功");
                out.println(result.toString());
            } else if (path.equals("/remove")) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int propertyId = Integer.parseInt(request.getParameter("propertyId"));
                favoriteService.removeFavorite(userId, propertyId);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("message", "取消收藏");
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
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String path = request.getPathInfo();
        try {
            if ("/remove".equals(path)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int propertyId = Integer.parseInt(request.getParameter("propertyId"));
                favoriteService.removeFavorite(userId, propertyId);
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.addProperty("message", "取消收藏");
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

    private JsonObject propertyToJson(Property property) {
        JsonObject json = new JsonObject();
        json.addProperty("id", property.getId());
        json.addProperty("title", property.getTitle());
        json.addProperty("type", property.getType());
        json.addProperty("area", property.getArea());
        json.addProperty("price", property.getPrice());
        json.addProperty("region", property.getRegion());
        json.addProperty("address", property.getAddress());
        json.addProperty("description", property.getDescription());
        json.addProperty("imageUrl", property.getImageUrl());
        return json;
    }
}