package com.example.realtor.model;

public class Favorite {
    private int id;
    private int userId;
    private int propertyId;

    public Favorite() {}

    public Favorite(int userId, int propertyId) {
        this.userId = userId;
        this.propertyId = propertyId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }
}