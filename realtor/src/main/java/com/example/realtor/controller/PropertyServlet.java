package com.example.realtor.controller;

import com.example.realtor.model.Property;
import com.example.realtor.service.PropertyService;
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

@WebServlet("/api/property/*")
public class PropertyServlet extends HttpServlet {
    private PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();

        String path = request.getPathInfo();
        try {
            if (path == null || path.equals("/")) {
                List<Property> properties = propertyService.findReleased();
                JsonArray jsonArray = new JsonArray();
                for (Property p : properties) {
                    jsonArray.add(propertyToJson(p));
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());
            } else if (path.startsWith("/detail/")) {
                int id = Integer.parseInt(path.substring(8));
                Property property = propertyService.findById(id);
                if (property != null) {
                    JsonObject result = new JsonObject();
                    result.addProperty("status", "success");
                    result.add("data", propertyToJson(property));
                    out.println(result.toString());
                } else {
                    JsonObject error = new JsonObject();
                    error.addProperty("status", "error");
                    error.addProperty("message", "Property not found");
                    out.println(error.toString());
                }
            } else if (path.equals("/search")) {
                String keyword = request.getParameter("keyword");
                List<Property> properties = propertyService.search(keyword);
                JsonArray jsonArray = new JsonArray();
                for (Property p : properties) {
                    if ("released".equals(p.getStatus())) {
                        jsonArray.add(propertyToJson(p));
                    }
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());

                // 这里，实现了动态获取数据库中存在的户型与区域，并将它们返回给前端
            } else if (path.equals("/filter")) {
                String type = request.getParameter("type");
                String region = request.getParameter("region");
                String minPriceStr = request.getParameter("minPrice");
                String maxPriceStr = request.getParameter("maxPrice");

                Double minPrice = minPriceStr != null && !minPriceStr.isEmpty() ? Double.parseDouble(minPriceStr) : null;
                Double maxPrice = maxPriceStr != null && !maxPriceStr.isEmpty() ? Double.parseDouble(maxPriceStr) : null;

                // 调用service层，servlet -> service -> dao -> database
                List<Property> properties = propertyService.filter(type, region, minPrice, maxPrice);
                JsonArray jsonArray = new JsonArray();
                for (Property p : properties) {
                    if ("released".equals(p.getStatus())) {
                        jsonArray.add(propertyToJson(p));
                    }
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());

            } else if (path.equals("/types")) {
                List<String> types = propertyService.getAllTypes();
                JsonArray jsonArray = new JsonArray();
                for (String type : types) {
                    jsonArray.add(type);
                }
                JsonObject result = new JsonObject();
                result.addProperty("status", "success");
                result.add("data", jsonArray);
                out.println(result.toString());
            } else if (path.equals("/regions")) {
                List<String> regions = propertyService.getAllRegions();
                JsonArray jsonArray = new JsonArray();
                for (String region : regions) {
                    jsonArray.add(region);
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
            if (path == null || path.equals("/")) {
                handleAdd(request, out);
            } else if (path.equals("/update")) {
                handleUpdate(request, out);
            } else if (path.equals("/delete")) {
                handleDelete(request, out);
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

    private void handleAdd(HttpServletRequest request, PrintWriter out) throws Exception {
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        double area = Double.parseDouble(request.getParameter("area"));
        double price = Double.parseDouble(request.getParameter("price"));
        String region = request.getParameter("region");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");

        Property property = new Property(title, type, area, price, region, address, description);
        property.setImageUrl(imageUrl);
        propertyService.add(property);
        JsonObject result = new JsonObject();
        result.addProperty("status", "success");
        result.addProperty("message", "添加成功");
        out.println(result.toString());
    }

    private void handleUpdate(HttpServletRequest request, PrintWriter out) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        double area = Double.parseDouble(request.getParameter("area"));
        double price = Double.parseDouble(request.getParameter("price"));
        String region = request.getParameter("region");
        String address = request.getParameter("address");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");

        Property property = propertyService.findById(id);
        if (property != null) {
            property.setTitle(title);
            property.setType(type);
            property.setArea(area);
            property.setPrice(price);
            property.setRegion(region);
            property.setAddress(address);
            property.setDescription(description);
            property.setImageUrl(imageUrl);
            propertyService.update(property);
            JsonObject result = new JsonObject();
            result.addProperty("status", "success");
            result.addProperty("message", "更新成功");
            out.println(result.toString());
        } else {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", "房产不存在");
            out.println(error.toString());
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String path = request.getPathInfo();
        try {
            if ("/update".equals(path)) {
                handleUpdate(request, out);
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
            if (path != null && path.startsWith("/")) {
                int id = Integer.parseInt(path.substring(1));
                handleDeleteById(id, out);
            } else {
                handleDelete(request, out);
            }
        } catch (Exception e) {
            JsonObject error = new JsonObject();
            error.addProperty("status", "error");
            error.addProperty("message", e.getMessage());
            out.println(error.toString());
        }
    }

    private void handleDeleteById(int id, PrintWriter out) throws Exception {
        propertyService.delete(id);
        JsonObject result = new JsonObject();
        result.addProperty("status", "success");
        result.addProperty("message", "删除成功");
        out.println(result.toString());
    }

    private void handleDelete(HttpServletRequest request, PrintWriter out) throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        propertyService.delete(id);
        JsonObject result = new JsonObject();
        result.addProperty("status", "success");
        result.addProperty("message", "删除成功");
        out.println(result.toString());
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
        json.addProperty("status", property.getStatus());
        json.addProperty("createdAt", property.getCreatedAt());
        return json;
    }
}