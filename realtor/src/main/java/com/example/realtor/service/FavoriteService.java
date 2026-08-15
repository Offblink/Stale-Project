package com.example.realtor.service;

import com.example.realtor.dao.FavoriteDAO;
import com.example.realtor.dao.PropertyDAO;
import com.example.realtor.model.Favorite;
import com.example.realtor.model.Property;

import java.util.ArrayList;
import java.util.List;

public class FavoriteService {
    private FavoriteDAO favoriteDAO = new FavoriteDAO();
    private PropertyDAO propertyDAO = new PropertyDAO();

    public List<Integer> getFavoritePropertyIds(int userId) throws Exception {
        return favoriteDAO.findByUserId(userId);
    }

    public List<Property> getFavoriteProperties(int userId) throws Exception {
        List<Integer> propertyIds = favoriteDAO.findByUserId(userId);
        List<Property> properties = new ArrayList<>();
        for (Integer id : propertyIds) {
            Property property = propertyDAO.findById(id);
            if (property != null && "released".equals(property.getStatus())) {
                properties.add(property);
            }
        }
        return properties;
    }

    public boolean isFavorite(int userId, int propertyId) throws Exception {
        return favoriteDAO.exists(userId, propertyId);
    }

    public void addFavorite(int userId, int propertyId) throws Exception {
        if (!favoriteDAO.exists(userId, propertyId)) {
            Favorite favorite = new Favorite(userId, propertyId);
            favoriteDAO.add(favorite);
        }
    }

    public void removeFavorite(int userId, int propertyId) throws Exception {
        favoriteDAO.delete(userId, propertyId);
    }
}