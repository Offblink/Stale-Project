package com.vibeshop.model;

import java.sql.Timestamp;

public class User {
    private Integer id;
    private String phone;

    public User() {}

    public User(String phone) {
        this.phone = phone;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setCreatedAt(Timestamp createdAt) {
    }
}
