package com.example.realtor.controller;

import com.example.realtor.config.DBConnection;
import com.example.realtor.utils.AESUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(value = "/api/init", loadOnStartup = 1)
public class InitServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        try {
            initAdminUsers();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void initAdminUsers() throws Exception {
        String username = "admin";
        String password = "zy142857";
        String encryptedPassword = AESUtil.encrypt(password);

        try (Connection conn = DBConnection.getConnection()) {
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                pstmt.setString(1, username);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    String insertSql = "INSERT INTO users (username, password, email, role) VALUES (?, ?, ?, 'admin')";
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setString(1, username);
                        insertStmt.setString(2, encryptedPassword);
                        insertStmt.setString(3, username + "@blinvo.com");
                        insertStmt.executeUpdate();
                    }
                }
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.getWriter().println("Init completed");
    }
}