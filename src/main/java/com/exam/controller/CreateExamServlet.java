package com.exam.controller;

import com.exam.dao.ExamDAO;
import com.exam.model.Exam;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/create-exam")
public class CreateExamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ExamDAO examDAO = new ExamDAO();

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
                boolean deleted = examDAO.deleteExam(id);
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?success=Exam deleted successfully.");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?error=Failed to delete exam.");
                }
                return;
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?error=Invalid Exam ID.");
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String durationStr = request.getParameter("duration");
        String passPercentageStr = request.getParameter("passPercentage");

        if (title == null || title.trim().isEmpty() || durationStr == null || passPercentageStr == null) {
            request.setAttribute("error", "Exam Title, Duration, and Passing Percentage are required.");
            request.getRequestDispatcher("/admin/create-exam.jsp").forward(request, response);
            return;
        }

        try {
            int duration = Integer.parseInt(durationStr.trim());
            int passPercentage = Integer.parseInt(passPercentageStr.trim());

            Exam exam = new Exam();
            exam.setTitle(title.trim());
            exam.setDescription(description != null ? description.trim() : "");
            exam.setDuration(duration);
            exam.setTotalMarks(0); // Starts at 0, updated dynamically as questions are added
            exam.setPassPercentage(passPercentage);

            int examId = examDAO.createExam(exam);

            if (examId > 0) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?success=Exam created successfully! Now add questions.");
            } else {
                request.setAttribute("error", "Failed to create exam in database.");
                request.getRequestDispatcher("/admin/create-exam.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Duration and Pass Percentage must be valid numbers.");
            request.getRequestDispatcher("/admin/create-exam.jsp").forward(request, response);
        }
    }
}

