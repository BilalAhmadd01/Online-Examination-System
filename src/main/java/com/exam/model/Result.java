package com.exam.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Result implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int studentId;
    private int examId;
    private int totalQuestions;
    private int correctAnswers;
    private int scoreObtained;
    private double percentage;
    private String passStatus; // "PASS" or "FAIL"
    private Timestamp examDate;

    // Helper fields for reports/dashboards (lazy evaluation)
    private String studentName;
    private String studentEmail;
    private String examTitle;

    public Result() {}

    public Result(int id, int studentId, int examId, int totalQuestions, int correctAnswers, int scoreObtained, double percentage, String passStatus, Timestamp examDate) {
        this.id = id;
        this.studentId = studentId;
        this.examId = examId;
        this.totalQuestions = totalQuestions;
        this.correctAnswers = correctAnswers;
        this.scoreObtained = scoreObtained;
        this.percentage = percentage;
        this.passStatus = passStatus;
        this.examDate = examDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public int getTotalQuestions() { return totalQuestions; }
    public void setTotalQuestions(int totalQuestions) { this.totalQuestions = totalQuestions; }

    public int getCorrectAnswers() { return correctAnswers; }
    public void setCorrectAnswers(int correctAnswers) { this.correctAnswers = correctAnswers; }

    public int getScoreObtained() { return scoreObtained; }
    public void setScoreObtained(int scoreObtained) { this.scoreObtained = scoreObtained; }

    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }

    public String getPassStatus() { return passStatus; }
    public void setPassStatus(String passStatus) { this.passStatus = passStatus; }

    public Timestamp getExamDate() { return examDate; }
    public void setExamDate(Timestamp examDate) { this.examDate = examDate; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getExamTitle() { return examTitle; }
    public void setExamTitle(String examTitle) { this.examTitle = examTitle; }
}

