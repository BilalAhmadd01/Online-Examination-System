package com.exam.controller;

import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.model.Question;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/add-question")
public class AddQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuestionDAO questionDAO = new QuestionDAO();
    private ExamDAO examDAO = new ExamDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"ADMIN".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String examIdStr = request.getParameter("examId");
        String questionText = request.getParameter("questionText");
        String optionA = request.getParameter("optionA");
        String optionB = request.getParameter("optionB");
        String optionC = request.getParameter("optionC");
        String optionD = request.getParameter("optionD");
        String correctOption = request.getParameter("correctOption");
        String marksStr = request.getParameter("marks");

        if (examIdStr == null || questionText == null || optionA == null || optionB == null ||
            optionC == null || optionD == null || correctOption == null || marksStr == null) {
            
            request.setAttribute("error", "All fields are required to add a question.");
            request.getRequestDispatcher("/admin/add-question.jsp").forward(request, response);
            return;
        }

        try {
            int examId = Integer.parseInt(examIdStr.trim());
            int marks = Integer.parseInt(marksStr.trim());

            Question q = new Question();
            q.setExamId(examId);
            q.setQuestionText(questionText.trim());
            q.setOptionA(optionA.trim());
            q.setOptionB(optionB.trim());
            q.setOptionC(optionC.trim());
            q.setOptionD(optionD.trim());
            q.setCorrectOption(correctOption.trim().toUpperCase());
            q.setMarks(marks);

            boolean success = questionDAO.addQuestion(q);

            if (success) {
                // Automatically update the exam's total marks
                int newTotalMarks = questionDAO.calculateTotalMarksForExam(examId);
                examDAO.updateExamTotalMarks(examId, newTotalMarks);

                response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?success=Question added successfully!");
            } else {
                request.setAttribute("error", "Failed to add the question. Try again.");
                request.getRequestDispatcher("/admin/add-question.jsp?examId=" + examId).forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numbers for Exam ID or Marks.");
            request.getRequestDispatcher("/admin/add-question.jsp").forward(request, response);
        }
    }
}

