package com.exam.controller;

import com.exam.dao.UserDAO;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/student/register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        // Basic inputs validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            return;
        }

        username = username.trim();
        email = email.trim();

        // Check duplicates
        if (userDAO.checkUsernameExists(username)) {
            request.setAttribute("error", "Username is already taken.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.checkEmailExists(email)) {
            request.setAttribute("error", "Email is already registered.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
            return;
        }

        // Save User
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); // in real-world, hash this
        user.setEmail(email);
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setRole("STUDENT");

        boolean success = userDAO.registerUser(user);

        if (success) {
            request.setAttribute("success", "Registration successful! Please login.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "An error occurred during registration. Please try again.");
            request.getRequestDispatcher("/student/register.jsp").forward(request, response);
        }
    }
}

