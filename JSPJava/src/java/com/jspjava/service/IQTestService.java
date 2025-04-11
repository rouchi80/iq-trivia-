/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.service;




import com.google.gson.Gson;
import com.jspjava.model.Question;
import com.jspjava.model.TestResult;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

public class IQTestService {
    private static final String TRIVIA_API_URL = "https://opentdb.com/api.php?amount=15&category=19&type=multiple";

    private static final String TRIVIA_API_URL1 = "https://opentdb.com/api.php?amount=25&category=19&type=multiple";

    private static final String TRIVIA_API_URL2 = "https://opentdb.com/api.php?amount=40&category=19&type=multiple";

    
    public List<Question> getStandardTestQuestions(String c) {
        try {
            URL url=null;
            System.out.println("Comming"+c);
            
            if(c.equals("1"))
            {
            
              url=  new URL(TRIVIA_API_URL);
            
            }
            else if(c.equals("2"))
            {
           url=  new URL(TRIVIA_API_URL1);
            
            }
            
            else if(c.equals("3"))
            {
             url = new URL(TRIVIA_API_URL2);
            
            }

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(conn.getInputStream()));
            
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();
            
            TriviaApiResponse apiResponse = new Gson().fromJson(response.toString(), TriviaApiResponse.class);
            return convertToQuestions(apiResponse.results);
            
        } catch (Exception e) {
            e.printStackTrace();
            return getFallbackQuestions();
        }
    }

    private List<Question> convertToQuestions(List<TriviaQuestion> triviaQuestions) {
        List<Question> questions = new ArrayList<>();
        int questionId = 1;
        
        for (TriviaQuestion tq : triviaQuestions) {
            Question question = new Question();
            question.setId(questionId++);
            question.setText(htmlDecode(tq.question));
            
            // Combine and shuffle options
            List<String> allOptions = new ArrayList<>(tq.incorrect_answers);
            allOptions.add(tq.correct_answer);
            Collections.shuffle(allOptions);
            
            // Create option map (A, B, C, D)
            Map<String, String> options = new LinkedHashMap<>();
            char optionLetter = 'A';
            for (String option : allOptions) {
                options.put(String.valueOf(optionLetter++), htmlDecode(option));
                if (option.equals(tq.correct_answer)) {
                    question.setCorrectAnswer(String.valueOf((char)(optionLetter-1)));
                }
            }
            
            question.setOptions(options);
            questions.add(question);
        }
        
        return questions;
    }

    public TestResult evaluateTest(Map<Integer, String> userAnswers) {
        List<Question> questions = Question.getAllQuestions();
        int correct = 0;
        
        for (Map.Entry<Integer, String> entry : userAnswers.entrySet()) {
            int questionId = entry.getKey();
            String userAnswer = entry.getValue();
            
            if (questionId > 0 && questionId <= questions.size()) {
                Question question = questions.get(questionId - 1);
                if (question.getCorrectAnswer().equals(userAnswer)) {
                    correct++;
                }
            }
        }
        
         System.out.println("TotalQuestions = "+questions.size());
         System.out.println("Valid Questions = "+correct);

    
    TestResult result = new TestResult();
        result.setCorrectAnswers(correct);
        result.setScore(calculateIQScore(correct, questions.size()));
        result.setPercentile(calculatePercentile(result.getScore()));
        result.setDescription(getIQCategory(result.getScore()));
        result.setTotalQuestions(questions.size());
        return result;
    }

    private int calculateIQScore(int correct, int total) {
        // Scale from 80 to 120 based on percentage correct
        return 80 + (int)(40 * ((double)correct / total));
    }

    private double calculatePercentile(int score) {
        // Simplified percentile calculation
        if (score < 80) return 10.0;
        if (score < 90) return 25.0;
        if (score < 100) return 50.0;
        if (score < 110) return 75.0;
        if (score < 120) return 90.0;
        return 99.0;
    }

    private String getIQCategory(int score) {
        if (score < 80) return "Very Low";
        if (score < 90) return "Low Average";
        if (score < 110) return "Average";
        if (score < 120) return "High Average";
        if (score < 130) return "Superior";
        return "Very Superior";
    }

    private String htmlDecode(String input) {
        return input.replace("&quot;", "\"")
                   .replace("&#039;", "'")
                   .replace("&amp;", "&");
    }

    private List<Question> getFallbackQuestions() {
        List<Question> questions = new ArrayList<>();
        
        // Add 3 sample questions
        questions.add(createSampleQuestion(1, 
            "Which number comes next in the series: 2, 4, 8, 16, ...?",
            Arrays.asList("24", "32", "64", "128"),
            "B"));
        
        questions.add(createSampleQuestion(2,
            "If all Bloops are Razzies and all Razzies are Lazzies, then all Bloops are definitely Lazzies?",
            Arrays.asList("True", "False", "Uncertain", "None of the above"),
            "A"));
            
        questions.add(createSampleQuestion(3,
            "Which word does not belong with the others?",
            Arrays.asList("Triangle", "Circle", "Square", "Sphere"),
            "D"));
            
        return questions;
    }

    private Question createSampleQuestion(int id, String text, List<String> options, String correctKey) {
        Map<String, String> optionMap = new LinkedHashMap<>();
        char letter = 'A';
        for (String option : options) {
            optionMap.put(String.valueOf(letter++), option);
        }
        return new Question(id, text, optionMap, correctKey);
    }

    // Classes for JSON parsing
    private static class TriviaApiResponse {
        List<TriviaQuestion> results;
    }

    private static class TriviaQuestion {
        String question;
        String correct_answer;
        List<String> incorrect_answers;
    }
}