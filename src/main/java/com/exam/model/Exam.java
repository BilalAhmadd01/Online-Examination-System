package com.exam.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Exam implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String title;
    private String description;
    private int duration; // In minutes
    private int totalMarks;
    private int passPercentage;
    private Timestamp createdAt;

    public Exam() {}

    public Exam(int id, String title, String description, int duration, int totalMarks, int passPercentage, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.totalMarks = totalMarks;
        this.passPercentage = passPercentage;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }

    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }

    public int getPassPercentage() { return passPercentage; }
    public void setPassPercentage(int passPercentage) { this.passPercentage = passPercentage; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

