package com.example.realtor.model;

public class Property {
    private int id;
    private String title;
    private String type;
    private double area;
    private double price;
    private String region;
    private String address;
    private String description;
    private String imageUrl;
    private String status;
    private String createdAt;

    public Property() {}

    public Property(String title, String type, double area, double price, String region, String address, String description) {
        this.title = title;
        this.type = type;
        this.area = area;
        this.price = price;
        this.region = region;
        this.address = address;
        this.description = description;
        this.status = "pending";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public double getArea() { return area; }
    public void setArea(double area) { this.area = area; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}