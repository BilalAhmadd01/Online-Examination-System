package com.exam.controller;

import com.exam.dao.UserDAO;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/manage-students")
public class ManageStudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("delete".equalsIgnoreCase(action) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr.trim());
                boolean deleted = userDAO.deleteUser(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?success=Student deleted successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?error=Could not delete student.");
                }
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?error=Invalid Student ID.");
                return;
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty()) {
            
            response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?error=All fields are required to add a student.");
            return;
        }

        username = username.trim();
        email = email.trim();

        if (userDAO.checkUsernameExists(username)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?error=Username is already taken.");
            return;
        }

        if (userDAO.checkEmailExists(email)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?error=Email is already registered.");
            return;
        }

        User student = new User();
        student.setUsername(username);
        student.setPassword(password);
        student.setEmail(email);
        student.setFirstName(firstName.trim());
        student.setLastName(lastName.trim());
        student.setRole("STUDENT");

        boolean success = userDAO.registerUser(student);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?success=Student added successfully.");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-students.jsp?error=Failed to add student. Please try again.");
        }
    }
}

