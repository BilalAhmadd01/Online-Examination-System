package com.exam.dao;

import com.exam.model.Result;
import com.exam.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultDAO {

    /**
     * Save an exam evaluation result.
     */
    public boolean saveResult(Result res) {
        String sql = "INSERT INTO results (student_id, exam_id, total_questions, correct_answers, score_obtained, percentage, pass_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, res.getStudentId());
            ps.setInt(2, res.getExamId());
            ps.setInt(3, res.getTotalQuestions());
            ps.setInt(4, res.getCorrectAnswers());
            ps.setInt(5, res.getScoreObtained());
            ps.setDouble(6, res.getPercentage());
            ps.setString(7, res.getPassStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get exam results for a specific Student.
     */
    public List<Result> getResultsByStudentId(int studentId) {
        List<Result> list = new ArrayList<>();
        String sql = "SELECT r.*, e.title as exam_title FROM results r " +
                     "JOIN exams e ON r.exam_id = e.id " +
                     "WHERE r.student_id = ? " +
                     "ORDER BY r.exam_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Result res = extractResultFromResultSet(rs);
                    res.setExamTitle(rs.getString("exam_title"));
                    list.add(res);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get all results in the system (for Admin).
     */
    public List<Result> getAllResults() {
        List<Result> list = new ArrayList<>();
        String sql = "SELECT r.*, u.first_name, u.last_name, u.email as student_email, e.title as exam_title FROM results r " +
                     "JOIN users u ON r.student_id = u.id " +
                     "JOIN exams e ON r.exam_id = e.id " +
                     "ORDER BY r.exam_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Result res = extractResultFromResultSet(rs);
                res.setStudentName(rs.getString("first_name") + " " + rs.getString("last_name"));
                res.setStudentEmail(rs.getString("student_email"));
                res.setExamTitle(rs.getString("exam_title"));
                list.add(res);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get a specific Result by ID.
     */
    public Result getResultById(int id) {
        String sql = "SELECT r.*, u.first_name, u.last_name, u.email as student_email, e.title as exam_title, e.pass_percentage FROM results r " +
                     "JOIN users u ON r.student_id = u.id " +
                     "JOIN exams e ON r.exam_id = e.id " +
                     "WHERE r.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Result res = extractResultFromResultSet(rs);
                    res.setStudentName(rs.getString("first_name") + " " + rs.getString("last_name"));
                    res.setStudentEmail(rs.getString("student_email"));
                    res.setExamTitle(rs.getString("exam_title"));
                    return res;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Result extractResultFromResultSet(ResultSet rs) throws SQLException {
        Result res = new Result();
        res.setId(rs.getInt("id"));
        res.setStudentId(rs.getInt("student_id"));
        res.setExamId(rs.getInt("exam_id"));
        res.setTotalQuestions(rs.getInt("total_questions"));
        res.setCorrectAnswers(rs.getInt("correct_answers"));
        res.setScoreObtained(rs.getInt("score_obtained"));
        res.setPercentage(rs.getDouble("percentage"));
        res.setPassStatus(rs.getString("pass_status"));
        res.setExamDate(rs.getTimestamp("exam_date"));
        return res;
    }
}

