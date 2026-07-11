package com.exam.controller;

import com.exam.dao.ExamDAO;
import com.exam.dao.QuestionDAO;
import com.exam.dao.ResultDAO;
import com.exam.model.Exam;
import com.exam.model.Question;
import com.exam.model.Result;
import com.exam.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import com.exam.util.DBConnection;
import java.util.List;

@WebServlet("/student/submit-exam")
public class SubmitExamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuestionDAO questionDAO = new QuestionDAO();
    private ExamDAO examDAO = new ExamDAO();
    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || !"STUDENT".equalsIgnoreCase((String) session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        User student = (User) session.getAttribute("user");
        String examIdStr = request.getParameter("examId");

        if (examIdStr == null || examIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Invalid Exam Submission.");
            return;
        }

        int examId = Integer.parseInt(examIdStr.trim());
        Exam exam = examDAO.getExamById(examId);

        if (exam == null) {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Exam not found.");
            return;
        }

        // Automatic Evaluation Engine
        List<Question> questions = questionDAO.getQuestionsByExamId(examId);
        int totalQuestions = questions.size();
        int correctAnswersCount = 0;
        int scoreObtained = 0;

        for (Question q : questions) {
            // Parameter name format: question_12
            String submittedAnswer = request.getParameter("question_" + q.getId());
            if (submittedAnswer != null && submittedAnswer.trim().equalsIgnoreCase(q.getCorrectOption())) {
                correctAnswersCount++;
                scoreObtained += q.getMarks();
            }
        }

        // Calculate statistics
        double percentage = 0.0;
        if (exam.getTotalMarks() > 0) {
            percentage = ((double) scoreObtained / exam.getTotalMarks()) * 100.0;
        }
        
        String passStatus = (percentage >= exam.getPassPercentage()) ? "PASS" : "FAIL";

        // Save result (using custom insert that returns generated key)
        Result result = new Result();
        result.setStudentId(student.getId());
        result.setExamId(examId);
        result.setTotalQuestions(totalQuestions);
        result.setCorrectAnswers(correctAnswersCount);
        result.setScoreObtained(scoreObtained);
        result.setPercentage(percentage);
        result.setPassStatus(passStatus);

        int savedResultId = -1;
        String insertSql = "INSERT INTO results (student_id, exam_id, total_questions, correct_answers, score_obtained, percentage, pass_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, result.getStudentId());
            ps.setInt(2, result.getExamId());
            ps.setInt(3, result.getTotalQuestions());
            ps.setInt(4, result.getCorrectAnswers());
            ps.setInt(5, result.getScoreObtained());
            ps.setDouble(6, result.getPercentage());
            ps.setString(7, result.getPassStatus());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        savedResultId = rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (savedResultId > 0) {
            // Prevent double submission via PRG Pattern (Post/Redirect/Get)
            response.sendRedirect(request.getContextPath() + "/student/exam-result.jsp?resultId=" + savedResultId);
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Failed to record exam score.");
        }
    }
}

