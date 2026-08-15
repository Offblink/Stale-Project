package com.example.realtor.dao;

import com.example.realtor.config.DBConnection;
import com.example.realtor.model.Favorite;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FavoriteDAO {
    public List<Integer> findByUserId(int userId) throws Exception {
        List<Integer> propertyIds = new ArrayList<>();
        String sql = "SELECT property_id FROM favorites WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                propertyIds.add(rs.getInt("property_id"));
            }
        }
        return propertyIds;
    }

    public boolean exists(int userId, int propertyId) throws Exception {
        String sql = "SELECT COUNT(*) FROM favorites WHERE user_id = ? AND property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, propertyId);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    public void add(Favorite favorite) throws Exception {
        String sql = "INSERT INTO favorites (user_id, property_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, favorite.getUserId());
            pstmt.setInt(2, favorite.getPropertyId());
            pstmt.executeUpdate();
        }
    }

    public void delete(int userId, int propertyId) throws Exception {
        String sql = "DELETE FROM favorites WHERE user_id = ? AND property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, propertyId);
            pstmt.executeUpdate();
        }
    }
}