# Online Examination System

A robust, enterprise-grade Java web application built on the **Model-View-Controller (MVC)** architectural pattern. This platform streamlines exam-taking operations, allowing administrators to manage tests and questions while enabling students to register, sit for tests, and check scores in real-time.

---

## 🚀 Features

### 👨‍🎓 Student Dashboard
- **Authentication**: Secure registration and session-tracked student login.
- **Interactive Tests**: Browse available tests, take exams with a dynamic UI, and submit answers.
- **Instant Grading & Analytics**: View exam scorecards immediately upon submission, with question-by-question breakdowns, score percentages, and historical results.

### 👑 Admin Dashboard
- **Exam Management**: Create, view, update, and delete tests.
- **Question Bank**: Add multiple-choice questions (with options and correct keys) directly to specific exams.
- **Student Performance Tracking**: Monitor registered student profiles and review detailed grade sheets of completed exams.

---

## 🛠️ Tech Stack

- **Backend**: Java, Servlets, JDBC (Java Database Connectivity)
- **Frontend**: JSP (JavaServer Pages), JSTL, CSS3 (Modern, responsive styling)
- **Database**: MySQL (Relational mappings for users, exams, questions, and results)
- **Build Tool**: Maven

---

## 📂 Project Structure

```text
OnlineExamSystem/
├── src/
│   ├── main/
│   │   ├── java/com/exam/
│   │   │   ├── controller/   # Servlets handling request routing & business flows
│   │   │   ├── dao/          # Data Access Objects (SQL queries & mapping)
│   │   │   ├── model/        # Java Beans (User, Exam, Question, Result)
│   │   │   └── util/         # Database connection helpers
│   │   ├── resources/        # Configuration files (db.properties)
│   │   └── webapp/           # JSP templates, static assets (CSS/JS)
├── schema.sql                # MySQL Database schema & initial seeding data
└── pom.xml                   # Maven dependencies and build settings
```

---

## ⚙️ Setup & Installation

### 1. Prerequisites
Ensure you have the following installed on your local machine:
- **Java Development Kit (JDK)** 17 or higher
- **Maven** 3.8+
- **MySQL Server** 8.0+
- **Apache Tomcat** 10.1+

### 2. Database Configuration
1. Open your MySQL client and execute the SQL script in `schema.sql` to create the database and seed the tables:
   ```sql
   source path/to/schema.sql;
   ```
2. Navigate to `src/main/resources/db.properties` and configure your database credentials:
   ```properties
   db.driver=com.mysql.cj.jdbc.Driver
   db.url=jdbc:mysql://localhost:3306/online_exam_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   db.username=YOUR_MYSQL_USERNAME
   db.password=YOUR_MYSQL_PASSWORD
   ```

### 3. Build & Package
Use Maven to compile and package the project into a `.war` file:
```bash
mvn clean package
```
This generates the file `target/OnlineExamSystem.war`.

### 4. Deploy to Apache Tomcat
1. Copy the generated `OnlineExamSystem.war` file from the `target/` directory.
2. Paste it into the `webapps/` folder of your Apache Tomcat installation.
3. Start the Tomcat server.
4. Open your browser and navigate to:
   ```text
   http://localhost:8080/OnlineExamSystem/
   ```
