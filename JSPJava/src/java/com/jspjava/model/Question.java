/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.model;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Question {
    
       private static final List<Question> allQuestions = new ArrayList<>();
    
    private int id;
    private String text;
    private Map<String, String> options;
    private String correctAnswer;

    // Constructors
    public Question() {
    
    allQuestions.add(this);
    }

    public Question(int id, String text, Map<String, String> options, String correctAnswer) {
        this.id = id;
        this.text = text;
        this.options = options;
        this.correctAnswer = correctAnswer;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public Map<String, String> getOptions() {
        return options;
    }

    public void setOptions(Map<String, String> options) {
        this.options = options;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    
    
    
    public static List<Question> getAllQuestions() {
        return new ArrayList<>(allQuestions);
    }
    
    public static void getRemoveQuestions() {
       allQuestions.clear();
    }
    
    
}