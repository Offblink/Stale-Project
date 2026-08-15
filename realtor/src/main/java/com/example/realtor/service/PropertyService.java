package com.example.realtor.service;

import com.example.realtor.dao.PropertyDAO;
import com.example.realtor.model.Property;

import java.util.List;

public class PropertyService {
    private PropertyDAO propertyDAO = new PropertyDAO();

    public List<Property> findAll() throws Exception {
        return propertyDAO.findAll();
    }

    public List<Property> findReleased() throws Exception {
        return propertyDAO.findByStatus("released");
    }

    public List<Property> findPending() throws Exception {
        return propertyDAO.findByStatus("pending");
    }

    public Property findById(int id) throws Exception {
        return propertyDAO.findById(id);
    }

    public void add(Property property) throws Exception {
        property.setStatus("pending");
        propertyDAO.add(property);
    }

    public void update(Property property) throws Exception {
        propertyDAO.update(property);
    }

    public void delete(int id) throws Exception {
        propertyDAO.delete(id);
    }

    public void approve(int id) throws Exception {
        propertyDAO.updateStatus(id, "released");
    }

    public void reject(int id) throws Exception {
        propertyDAO.updateStatus(id, "pending");
    }

    public List<Property> search(String keyword) throws Exception {
        return propertyDAO.search(keyword);
    }

    public List<Property> filter(String type, String region, Double minPrice, Double maxPrice) throws Exception {
        return propertyDAO.filter(type, region, minPrice, maxPrice);
    }

    public List<String> getAllTypes() throws Exception {
        return propertyDAO.getAllTypes();
    }

    public List<String> getAllRegions() throws Exception {
        return propertyDAO.getAllRegions();
    }
}