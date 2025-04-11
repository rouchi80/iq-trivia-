/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.model;
import java.sql.Date;

public class TestResultDB {
    private int id;
    private String name;
    private Date date;
    private int totalQuestions;
    private int validQuestions;
    private int iq;
    private int userId;

    // Constructor
    public TestResultDB() {}

    public TestResultDB(int id, String name, Date date, int totalQuestions, int validQuestions, int iq, int userId) {
        this.id = id;
        this.name = name;
        this.date = date;
        this.totalQuestions = totalQuestions;
        this.validQuestions = validQuestions;
        this.iq = iq;
        this.userId = userId;
    }

    // Getters and Setters...
    // (For brevity, you can use Lombok or IDE to generate these.)

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public int getValidQuestions() {
        return validQuestions;
    }

    public void setValidQuestions(int validQuestions) {
        this.validQuestions = validQuestions;
    }

    public int getIq() {
        return iq;
    }

    public void setIq(int iq) {
        this.iq = iq;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }
}
