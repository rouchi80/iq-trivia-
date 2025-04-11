/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jspjava.util;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

public class ServletUtils {
    public static void sendJsonResponse(HttpServletResponse response, String json) 
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json);
    }
    
    public static void sendErrorResponse(HttpServletResponse response, 
            int statusCode, String message) throws IOException {
        response.setStatus(statusCode);
        sendJsonResponse(response, 
            "{\"status\":\"error\", \"message\":\"" + message + "\"}");
    }
}