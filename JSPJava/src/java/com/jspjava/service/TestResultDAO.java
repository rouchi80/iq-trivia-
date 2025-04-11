/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.service;
import com.jspjava.model.TestResultDB;
import java.util.*;
import java.sql.*;

public class TestResultDAO {
    private Connection connection;

    public TestResultDAO(Connection connection) {
        this.connection = connection;
    }

    // 1. Insert a new test result
    public boolean insertTestResult(TestResultDB result) throws SQLException {
        String query = "INSERT INTO TestResult (name, date, totalQuestions, validQuestions, iq, userId) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, result.getName());
            stmt.setDate(2, result.getDate());
            stmt.setInt(3, result.getTotalQuestions());
            stmt.setInt(4, result.getValidQuestions());
            stmt.setInt(5, result.getIq());
            stmt.setInt(6, result.getUserId());
            return stmt.executeUpdate() > 0;
        }
    }

    // 2. Get number of test attempts by user
    public int getTestCountByUserId(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM TestResult WHERE userId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // 3. Get average IQ by user
    public Double getAverageIQByUserId(int userId) throws SQLException {
        String query = "SELECT AVG(iq) FROM TestResult WHERE userId = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return null;
    }

    // 4. Get latest (most recent) IQ for a user
    public Integer getLatestIQByUserId(int userId) throws SQLException {
        String query = "SELECT iq FROM TestResult WHERE userId = ? ORDER BY date DESC, id DESC LIMIT 1";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("iq");
            }
        }
        return null;
    }

    // 5. Get all test results by user
    public List<TestResultDB> getTestResultsByUserId(int userId) throws SQLException {
        List<TestResultDB> results = new ArrayList<>();
        String query = "SELECT * FROM TestResult WHERE userId = ? ORDER BY date DESC";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                TestResultDB result = new TestResultDB(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getDate("date"),
                    rs.getInt("totalQuestions"),
                    rs.getInt("validQuestions"),
                    rs.getInt("iq"),
                    rs.getInt("userId")
                );
                results.add(result);
            }
        }
        return results;
    }
}
