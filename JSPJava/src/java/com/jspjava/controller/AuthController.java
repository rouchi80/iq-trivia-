package com.jspjava.controller;

import com.jspjava.dto.UserDTO;
import com.jspjava.model.User;
import com.jspjava.service.GoogleAuthService;
import com.jspjava.service.TestResultDAO;
import com.jspjava.service.UserDAO;
import com.jspjava.util.ServletUtils;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/auth/google")
public class AuthController extends HttpServlet {
    private final GoogleAuthService authService = new GoogleAuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String credential = request.getParameter("credential");
            UserDTO user = authService.verifyGoogleToken(credential);
            User dbuser= new User(user.getName(),user.getEmail());
            HttpSession session = request.getSession();
            double userAvgIQ=0.0;
            int currntIQ=0;
            int totalTest=0;
                try{
            UserDAO udao = new UserDAO(DBConnection.getConnection());
            
            udao.addUserIfEmailNotExists(dbuser);
            
            int cUserId = udao.getUserIdByEmail(dbuser.getEmail());
            
                    TestResultDAO testResultDAO = new TestResultDAO(DBConnection.getConnection());
                   userAvgIQ= testResultDAO.getAverageIQByUserId(cUserId);
                  currntIQ= testResultDAO.getLatestIQByUserId(cUserId);
                    totalTest= testResultDAO.getTestCountByUserId(cUserId);
                }
                catch(
                        Exception ex
                        )
                {
                
                    System.out.println("Error  comming "+ex.getMessage());
                }
            session.setAttribute("user", user);
            session.setAttribute("authenticated", true);
            session.setAttribute("caiq", userAvgIQ);
            session.setAttribute("ciq", currntIQ);
            session.setAttribute("tq", totalTest);
            
            
            System.out.println("ValuesData = ["+userAvgIQ+"]====["+currntIQ+"]======["+totalTest+"] Total Tests = ");
            
            
            
            ServletUtils.sendJsonResponse(response, 
                "{\"status\":\"success\", \"redirect\":\"welcome\"}");
        } catch (Exception e) {
            ServletUtils.sendErrorResponse(response, 
                HttpServletResponse.SC_UNAUTHORIZED, 
                "Authentication failed: " + e.getMessage());
        }
    }
}