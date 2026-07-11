package com.exam.dao;

import com.exam.model.Exam;
import com.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {

    /**
     * Create a new exam and return its generated ID or -1 on failure.
     */
    public int createExam(Exam exam) {
        String sql = "INSERT INTO exams (title, description, duration, total_marks, pass_percentage) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, exam.getTitle());
            ps.setString(2, exam.getDescription());
            ps.setInt(3, exam.getDuration());
            ps.setInt(4, exam.getTotalMarks());
            ps.setInt(5, exam.getPassPercentage());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Get all exams ordered by creation date (newest first).
     */
    public List<Exam> getAllExams() {
        List<Exam> exams = new ArrayList<>();
        String sql = "SELECT * FROM exams ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                exams.add(extractExamFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exams;
    }

    /**
     * Get a specific Exam by ID.
     */
    public Exam getExamById(int id) {
        String sql = "SELECT * FROM exams WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractExamFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Delete an exam and all cascading questions/results.
     */
    public boolean deleteExam(int id) {
        String sql = "DELETE FROM exams WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update an exam's total marks (e.g. after adding/deleting questions).
     */
    public boolean updateExamTotalMarks(int examId, int newTotal) {
        String sql = "UPDATE exams SET total_marks = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, newTotal);
            ps.setInt(2, examId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Exam extractExamFromResultSet(ResultSet rs) throws SQLException {
        Exam exam = new Exam();
        exam.setId(rs.getInt("id"));
        exam.setTitle(rs.getString("title"));
        exam.setDescription(rs.getString("description"));
        exam.setDuration(rs.getInt("duration"));
        exam.setTotalMarks(rs.getInt("total_marks"));
        exam.setPassPercentage(rs.getInt("pass_percentage"));
        exam.setCreatedAt(rs.getTimestamp("created_at"));
        return exam;
    }
}

