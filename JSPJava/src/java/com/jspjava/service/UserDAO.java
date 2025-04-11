/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.service;
import com.jspjava.model.User;
import java.sql.*;

public class UserDAO {
    private Connection connection;

    public UserDAO(Connection connection) {
        this.connection = connection;
    }

    // Check if email exists and insert user if not
    public boolean addUserIfEmailNotExists(User user) throws SQLException {
     
        System.out.println("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
        String checkQuery = "SELECT id FROM User WHERE email = ?";
        try (PreparedStatement checkStmt = connection.prepareStatement(checkQuery)) {
            checkStmt.setString(1, user.getEmail());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next()) {
                // Email already exists
                return false;
            }
        }

        String insertQuery = "INSERT INTO User (name, email) VALUES (?, ?)";
        try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {
            insertStmt.setString(1, user.getName());
            insertStmt.setString(2, user.getEmail());
            insertStmt.executeUpdate();

            // Set generated ID back to user object
            ResultSet keys = insertStmt.getGeneratedKeys();
            if (keys.next()) {
                user.setId(keys.getInt(1));
            }
            return true;
        }
    }

    // Get User ID by Email
    public Integer getUserIdByEmail(String email) throws SQLException {
        String query = "SELECT id FROM User WHERE email = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        }
        return null; // Not found
    }
}
