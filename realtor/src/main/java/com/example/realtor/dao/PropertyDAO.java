package com.example.realtor.dao;

import com.example.realtor.config.DBConnection;
import com.example.realtor.model.Property;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {
    public List<Property> findAll() throws Exception {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT * FROM properties ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                properties.add(mapRow(rs));
            }
        }
        return properties;
    }

    public List<Property> findByStatus(String status) throws Exception {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT * FROM properties WHERE status = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                properties.add(mapRow(rs));
            }
        }
        return properties;
    }

    public Property findById(int id) throws Exception {
        String sql = "SELECT * FROM properties WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        }
        return null;
    }

    public void add(Property property) throws Exception {
        String sql = "INSERT INTO properties (title, type, area, price, region, address, description, image_url, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, property.getTitle());
            pstmt.setString(2, property.getType());
            pstmt.setDouble(3, property.getArea());
            pstmt.setDouble(4, property.getPrice());
            pstmt.setString(5, property.getRegion());
            pstmt.setString(6, property.getAddress());
            pstmt.setString(7, property.getDescription());
            pstmt.setString(8, property.getImageUrl());
            pstmt.setString(9, property.getStatus());
            pstmt.executeUpdate();
        }
    }

    public void update(Property property) throws Exception {
        String sql = "UPDATE properties SET title = ?, type = ?, area = ?, price = ?, region = ?, address = ?, description = ?, image_url = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, property.getTitle());
            pstmt.setString(2, property.getType());
            pstmt.setDouble(3, property.getArea());
            pstmt.setDouble(4, property.getPrice());
            pstmt.setString(5, property.getRegion());
            pstmt.setString(6, property.getAddress());
            pstmt.setString(7, property.getDescription());
            pstmt.setString(8, property.getImageUrl());
            pstmt.setString(9, property.getStatus());
            pstmt.setInt(10, property.getId());
            pstmt.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM properties WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }

    public void updateStatus(int id, String status) throws Exception {
        String sql = "UPDATE properties SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            pstmt.executeUpdate();
        }
    }

    public List<Property> search(String keyword) throws Exception {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT * FROM properties WHERE title LIKE ? OR type LIKE ? OR region LIKE ? OR address LIKE ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            pstmt.setString(1, pattern);
            pstmt.setString(2, pattern);
            pstmt.setString(3, pattern);
            pstmt.setString(4, pattern);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                properties.add(mapRow(rs));
            }
        }
        return properties;
    }

    public List<Property> filter(String type, String region, Double minPrice, Double maxPrice) throws Exception {
        List<Property> properties = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM properties WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ?");
            params.add(type);
        }
        if (region != null && !region.isEmpty()) {
            sql.append(" AND region = ?");
            params.add(region);
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        sql.append(" ORDER BY created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                properties.add(mapRow(rs));
            }
        }
        return properties;
    }

    public List<String> getAllTypes() throws Exception {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT type FROM properties ORDER BY type";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        }
        return types;
    }

    public List<String> getAllRegions() throws Exception {
        List<String> regions = new ArrayList<>();
        String sql = "SELECT DISTINCT region FROM properties ORDER BY region";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                regions.add(rs.getString("region"));
            }
        }
        return regions;
    }

    private Property mapRow(ResultSet rs) throws SQLException {
        Property property = new Property();
        property.setId(rs.getInt("id"));
        property.setTitle(rs.getString("title"));
        property.setType(rs.getString("type"));
        property.setArea(rs.getDouble("area"));
        property.setPrice(rs.getDouble("price"));
        property.setRegion(rs.getString("region"));
        property.setAddress(rs.getString("address"));
        property.setDescription(rs.getString("description"));
        property.setImageUrl(rs.getString("image_url"));
        property.setStatus(rs.getString("status"));
        property.setCreatedAt(rs.getString("created_at"));
        return property;
    }
}