/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.controller;



import com.jspjava.dto.UserDTO;
import com.jspjava.model.Question;
import com.jspjava.model.TestResult;
import com.jspjava.model.TestResultDB;
import com.jspjava.service.IQTestService;
import com.jspjava.service.TestResultDAO;
import com.jspjava.service.UserDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;
//
//@WebServlet(name = "IQTestServlet", value = "/iqtest")
//public class IQTestServlet extends HttpServlet {
//    private IQTestService testService = new IQTestService();
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        
//        // Start a new test session
//        HttpSession session = request.getSession();
//        
//        // Clear previous test data
//        session.removeAttribute("testQuestions");
//        session.removeAttribute("startTime");
//        
//        // Get new questions
//        List<Question> questions = testService.getStandardTestQuestions();
//        
//        // Set session attributes
//        session.setAttribute("testQuestions", questions);
//        session.setAttribute("startTime", System.currentTimeMillis());
//        
//        // Forward to test page
//        request.setAttribute("questions", questions);
//        request.getRequestDispatcher("/iqtest.jsp").forward(request, response);
//    }
//
//    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        
//         HttpSession session = request.getSession();
//    List<Question> questions = (List<Question>) session.getAttribute("testQuestions");
//        // Retrieve test questions from session
//        if (questions == null) {
//            response.sendRedirect("iqtest");
//            return;
//        }
//        
//        // Calculate test duration
//        long startTime = (Long) session.getAttribute("startTime");
//        int minutesTaken = (int) ((System.currentTimeMillis() - startTime) / (1000 * 60));
//        
//        // Process user answers
//        Map<Integer, String> userAnswers = new HashMap<>();
//        Enumeration<String> paramNames = request.getParameterNames();
//        
//        while (paramNames.hasMoreElements()) {
//            String paramName = paramNames.nextElement();
//            if (paramName.startsWith("q_")) {
//                int questionId = Integer.parseInt(paramName.substring(2));
//                userAnswers.put(questionId, request.getParameter(paramName));
//            }
//        }
//        
//        // Evaluate results
//        TestResult result = testService.evaluateTest(userAnswers, questions);
//    result.setTotalQuestions(questions.size());
//    
//        
//        result.setTestDate(new Date(startTime));
//        
//        // Store result in session
//        List<TestResult> testHistory = (List<TestResult>) session.getAttribute("testHistory");
//        if (testHistory == null) {
//            testHistory = new ArrayList<>();
//        }
//        testHistory.add(result);
//        session.setAttribute("testHistory", testHistory);
//        session.setAttribute("latestResult", result);
//        
//        // Forward to results page
//        request.setAttribute("result", result);
//        request.getRequestDispatcher("/result.jsp").forward(request, response);
//    }
//}



@WebServlet("/iqtest")
public class IQTestServlet extends HttpServlet {
    
      private int calculateIQScore(int correct, int total) {
        // Scale from 80 to 120 based on percentage correct
        return 80 + (int)(40 * ((double)correct / total));
    }

    
    private IQTestService testService = new IQTestService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(true);
        String action = request.getParameter("action");
        
        
        String testType = request.getParameter("type"); // "std", "qik", or "avd"
        System.out.println("Test Type ="+testType);
        // Initialize or get questions from session
        List<Question> questions = (List<Question>) session.getAttribute("testQuestions");
        if (questions == null) {
            questions = testService.getStandardTestQuestions(testType);
            session.setAttribute("testQuestions", questions);
            session.setAttribute("currentQuestionIndex", 0);
            session.setAttribute("userAnswers", new HashMap<Integer, String>());
            System.out.println("Initialized new test with " + questions.size() + " questions");
        }
        
        // Handle navigation
        int currentIndex = (Integer) session.getAttribute("currentQuestionIndex");
        
        if ("next".equals(action) && currentIndex < questions.size() - 1) {
            currentIndex++;
            session.setAttribute("currentQuestionIndex", currentIndex);
            System.out.println("Moving to next question: " + currentIndex);
        } else if ("prev".equals(action) && currentIndex > 0) {
            currentIndex--;
            session.setAttribute("currentQuestionIndex", currentIndex);
            System.out.println("Moving to previous question: " + currentIndex);
        }
        
        // Set request attributes
        Question currentQuestion = questions.get(currentIndex);
        request.setAttribute("question", currentQuestion);
        request.setAttribute("questionNumber", currentIndex + 1);
        request.setAttribute("totalQuestions", questions.size());
        
        // Check if answer exists for this question
        Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
        if (userAnswers.containsKey(currentQuestion.getId())) {
            request.setAttribute("selectedAnswer", userAnswers.get(currentQuestion.getId()));
            System.out.println("Found existing answer for question " + currentQuestion.getId());
        }
        
        request.getRequestDispatcher("/iqtest.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    HttpSession session = request.getSession();
    String action = request.getParameter("action");
    
    if ("check".equals(action)) {
        try {
            // Get parameters
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String answer = request.getParameter("answer");
            
            // Debug logging
            System.out.println("Checking answer - Question ID: " + questionId + ", Answer: " + answer);
            
            // Get questions from session
            List<Question> questions = (List<Question>) session.getAttribute("testQuestions");
            if (questions == null) {
                System.out.println("Error: Questions not found in session");
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Test questions not found");
                return;
            }
            
            // Find the question
            Question question = null;
            for (Question q : questions) {
                if (q.getId() == questionId) {
                    question = q;
                    break;
                }
            }
            
            if (question == null) {
                System.out.println("Error: Question not found with ID: " + questionId);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Question not found");
                return;
            }
            
            // Validate answer
            boolean isCorrect = question.getCorrectAnswer().equals(answer);
            System.out.println("Answer is correct: " + isCorrect);
            
            // Store the answer
            Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                session.setAttribute("userAnswers", userAnswers);
            }
            userAnswers.put(questionId, answer);
            
            // Prepare response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String jsonResponse = String.format(
                "{\"correct\":%s, \"correctAnswer\":\"%s\"}", 
                isCorrect, 
                question.getCorrectAnswer()
            );
            System.out.println("Sending response: " + jsonResponse);
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            System.err.println("Error in check answer:");
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error processing answer: " + e.getMessage());
        }
        return;
    }
    
        
        if ("submit".equals(action)) {
            try {
                System.out.println("Processing test submission");
                
                @SuppressWarnings("unchecked")
                Map<Integer, String> userAnswers = (Map<Integer, String>) session.getAttribute("userAnswers");
                if (userAnswers == null || userAnswers.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No answers submitted");
                    return;
                }
                
                TestResult result = testService.evaluateTest(userAnswers);
                session.setAttribute("testResult", result);
                
                //HttpSession session = request.getSession(false);
                UserDTO user = (UserDTO) session.getAttribute("user");
                
            
if (user != null) {
    UserDAO udao = new UserDAO(DBConnection.getConnection());
    int userID= udao.getUserIdByEmail(user.getEmail());
    java.util.Date utilDate = new java.util.Date();
java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
    TestResultDB testResultDB = new TestResultDB(userID,"Test", sqlDate, result.getTotalQuestions(), result.getCorrectAnswers(),calculateIQScore(result.getCorrectAnswers(),result.getTotalQuestions()), userID);
 
    TestResultDAO testResultDAO = new TestResultDAO(DBConnection.getConnection());
    testResultDAO.insertTestResult(testResultDB);
    double userAvgIQ= testResultDAO.getAverageIQByUserId(userID);
    int currentIQ=testResultDAO.getLatestIQByUserId(userID);
    int totalTest=testResultDAO.getTestCountByUserId(userID);
     
            session.setAttribute("caiq", userAvgIQ);
            session.setAttribute("ciq", currentIQ);
            session.setAttribute("tq", totalTest);
            Question.getRemoveQuestions();
    
    user.getEmail();
    
    
    System.out.println("Logged-in user: " + user.getName());
}
else {
    System.out.println("No INDO MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
}
                
                // Clean up session
                
                
                  
                session.removeAttribute("testQuestions");
                session.removeAttribute("currentQuestionIndex");
                session.removeAttribute("userAnswers");
                
                
                
                
                
                
               
                
                
                System.out.println("Test submitted successfully. Score: " + result.getScore());
                response.sendRedirect("result.jsp");
                
            } catch (Exception e) {
                System.err.println("Error processing test submission:");
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing test submission");
            }
        }
    }
}