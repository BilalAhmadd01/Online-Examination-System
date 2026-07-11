-- Database Creation SQL Script for Online Examination & Result Management System

CREATE DATABASE IF NOT EXISTS online_exam_db;
USE online_exam_db;

-- 1. Users Table (for both Students and Administrators)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(15) NOT NULL DEFAULT 'STUDENT', -- 'ADMIN' or 'STUDENT'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Exams Table
CREATE TABLE IF NOT EXISTS exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    duration INT NOT NULL, -- duration in minutes
    total_marks INT NOT NULL DEFAULT 100,
    pass_percentage INT NOT NULL DEFAULT 40,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Questions Table
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    exam_id INT NOT NULL,
    question_text TEXT NOT NULL,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL, -- 'A', 'B', 'C', or 'D'
    marks INT NOT NULL DEFAULT 5,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- 4. Results Table
CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    exam_id INT NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    score_obtained INT NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    pass_status VARCHAR(10) NOT NULL, -- 'PASS' or 'FAIL'
    exam_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- ==========================================
-- PRE-SEEDED DUMMY DATA FOR DEMO & TESTING
-- ==========================================

-- Seed Admins and Students
-- Default Admin: username 'admin', password 'admin123'
-- Default Student: username 'student', password 'student123'
INSERT INTO users (username, password, email, first_name, last_name, role) 
VALUES 
('admin', 'admin123', 'admin@example.com', 'System', 'Administrator', 'ADMIN'),
('student', 'student123', 'student@example.com', 'Alex', 'Smith', 'STUDENT'),
('jane_doe', 'jane123', 'jane@example.com', 'Jane', 'Doe', 'STUDENT')
ON DUPLICATE KEY UPDATE id=id;

-- Seed Sample Exams
INSERT INTO exams (id, title, description, duration, total_marks, pass_percentage)
VALUES
(1, 'Java Programming Basics', 'Test your knowledge on core Java fundamentals including loops, OOP concepts, exceptions, and collections.', 15, 25, 40),
(2, 'Web Development Basics', 'Test your core concepts in HTML, CSS, JavaScript, and dynamic client-side scripting.', 10, 20, 50)
ON DUPLICATE KEY UPDATE id=id;

-- Seed Questions for Exam 1 (Java Programming Basics) - 5 questions, 5 marks each (Total 25 marks)
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks)
VALUES
(1, 'Which of the following is NOT a Java primitive data type?', 'int', 'String', 'boolean', 'char', 'B', 5),
(1, 'Which class is the root of the Java class hierarchy?', 'Class', 'Object', 'System', 'String', 'B', 5),
(1, 'Which keyword is used to inherit a class in Java?', 'implements', 'extends', 'inherits', 'imports', 'B', 5),
(1, 'What is the default value of an uninitialized local object variable in Java?', 'null', '0', 'undefined', 'It triggers a compilation error', 'D', 5),
(1, 'Which of the following statements is true about Java final classes?', 'They cannot have constructors', 'They cannot be instantiated', 'They cannot be inherited', 'They cannot have variables', 'C', 5)
ON DUPLICATE KEY UPDATE id=id;

-- Seed Questions for Exam 2 (Web Development Basics) - 4 questions, 5 marks each (Total 20 marks)
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks)
VALUES
(2, 'What does HTML stand for?', 'Hyper Text Markup Language', 'High Tech Markup Language', 'Hyper Tabular Markup Language', 'None of the above', 'A', 5),
(2, 'Which CSS property is used to change the text color of an element?', 'text-color', 'font-color', 'color', 'background-color', 'C', 5),
(2, 'Which HTML5 element is used to embed self-contained media content like code, illustrations, or diagrams?', 'section', 'article', 'figure', 'aside', 'C', 5),
(2, 'Which JavaScript method is used to write text directly in the browser console?', 'console.print()', 'console.log()', 'console.write()', 'system.out.println()', 'B', 5)
ON DUPLICATE KEY UPDATE id=id;
