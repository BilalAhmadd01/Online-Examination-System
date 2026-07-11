<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.UserDAO" %>
<%@ page import="com.exam.dao.ExamDAO" %>
<%@ page import="com.exam.dao.ResultDAO" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    ExamDAO examDAO = new ExamDAO();
    ResultDAO resultDAO = new ResultDAO();

    int studentCount = userDAO.getAllStudents().size();
    int examCount = examDAO.getAllExams().size();
    List<Result> allResults = resultDAO.getAllResults();
    int submissionCount = allResults.size();
%>

<!-- Admin Dashboard Content -->
<div class="space-y-8 animate-fade-in">
    
    <!-- Header Block -->
    <div>
        <h1 class="text-2xl md:text-3xl font-extrabold text-white tracking-tight">Administrative Overview</h1>
        <p class="text-xs text-slate-400 mt-1">Manage system configurations, register students, configure examinations, and inspect assessment performance metrics.</p>
    </div>

    <!-- Quick Action Hub -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        <a href="${pageContext.request.contextPath}/admin/manage-students.jsp" 
           class="p-4 rounded-2xl bg-indigo-500/10 hover:bg-indigo-500/15 border border-indigo-500/20 flex items-center space-x-3 transition">
            <div class="h-10 w-10 rounded-xl bg-indigo-500/20 text-indigo-400 flex items-center justify-center flex-shrink-0">
                <i class="fa-solid fa-user-plus"></i>
            </div>
            <div>
                <h3 class="font-bold text-xs text-white">Add Students</h3>
                <span class="text-3xs text-slate-400 block mt-0.5">Register manually & manage students.</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/create-exam.jsp" 
           class="p-4 rounded-2xl bg-violet-500/10 hover:bg-violet-500/15 border border-violet-500/20 flex items-center space-x-3 transition">
            <div class="h-10 w-10 rounded-xl bg-violet-500/20 text-violet-400 flex items-center justify-center flex-shrink-0">
                <i class="fa-solid fa-file-circle-plus"></i>
            </div>
            <div>
                <h3 class="font-bold text-xs text-white">Create Exam</h3>
                <span class="text-3xs text-slate-400 block mt-0.5">Define exam limits and pass marks.</span>
            </div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" 
           class="p-4 rounded-2xl bg-emerald-500/10 hover:bg-emerald-500/15 border border-emerald-500/20 flex items-center space-x-3 transition">
            <div class="h-10 w-10 rounded-xl bg-emerald-500/20 text-emerald-400 flex items-center justify-center flex-shrink-0">
                <i class="fa-solid fa-circle-question"></i>
            </div>
            <div>
                <h3 class="font-bold text-xs text-white">Manage Questions</h3>
                <span class="text-3xs text-slate-400 block mt-0.5">Edit tests & questions database.</span>
            </div>
        </a>
    </div>

    <!-- Summary Stats Matrix -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Students Stats Card -->
        <div class="glass-panel p-6 rounded-2xl space-y-4">
            <div class="flex items-center justify-between">
                <span class="text-2xs font-semibold text-slate-400 uppercase tracking-wider">Registered Students</span>
                <i class="fa-solid fa-user-graduate text-lg text-indigo-400"></i>
            </div>
            <div class="flex items-baseline space-x-2">
                <span class="text-3xl font-extrabold text-white"><%= studentCount %></span>
                <span class="text-xxs text-slate-500 font-semibold">Active Profiles</span>
            </div>
        </div>

        <!-- Exams Stats Card -->
        <div class="glass-panel p-6 rounded-2xl space-y-4">
            <div class="flex items-center justify-between">
                <span class="text-2xs font-semibold text-slate-400 uppercase tracking-wider">Active Examinations</span>
                <i class="fa-solid fa-file-invoice text-lg text-violet-400"></i>
            </div>
            <div class="flex items-baseline space-x-2">
                <span class="text-3xl font-extrabold text-white"><%= examCount %></span>
                <span class="text-xxs text-slate-500 font-semibold">Active Surveys</span>
            </div>
        </div>

        <!-- Submissions Stats Card -->
        <div class="glass-panel p-6 rounded-2xl space-y-4">
            <div class="flex items-center justify-between">
                <span class="text-2xs font-semibold text-slate-400 uppercase tracking-wider">Completed Assessments</span>
                <i class="fa-solid fa-square-poll-vertical text-lg text-emerald-400"></i>
            </div>
            <div class="flex items-baseline space-x-2">
                <span class="text-3xl font-extrabold text-white"><%= submissionCount %></span>
                <span class="text-xxs text-slate-500 font-semibold">Grades Saved</span>
            </div>
        </div>
    </div>

    <!-- Recent Submissions Overview Grid -->
    <div class="space-y-4">
        <div class="flex items-center justify-between">
            <h2 class="text-lg font-bold text-white flex items-center space-x-2">
                <i class="fa-solid fa-receipt text-indigo-400"></i>
                <span>Recent Exam Submissions</span>
            </h2>
            <a href="${pageContext.request.contextPath}/admin/view-results.jsp" class="text-xs font-semibold text-indigo-400 hover:underline">
                View All Results Log
            </a>
        </div>

        <% if (allResults == null || allResults.isEmpty()) { %>
            <div class="glass-panel rounded-2xl p-8 text-center text-slate-500 text-sm">
                No recent examination submissions found in database logs.
            </div>
        <% } else { %>
            <div class="glass-panel rounded-2xl overflow-hidden border border-slate-850">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-slate-800 text-left text-xs text-slate-300">
                        <thead class="bg-slate-800/40 text-slate-400 text-3xs uppercase tracking-wider font-semibold">
                            <tr>
                                <th class="px-6 py-4">Student</th>
                                <th class="px-6 py-4">Email</th>
                                <th class="px-6 py-4">Exam</th>
                                <th class="px-6 py-4 text-center">Score</th>
                                <th class="px-6 py-4 text-center">Percentage</th>
                                <th class="px-6 py-4 text-center">Status</th>
                                <th class="px-6 py-4 text-right">Date</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-800/50">
                            <% 
                                int rowLimit = 0;
                                for(Result res : allResults) { 
                                    if(rowLimit++ >= 5) break; // limit to 5
                                    boolean passed = "PASS".equalsIgnoreCase(res.getPassStatus());
                            %>
                                <tr class="hover:bg-slate-800/20 transition">
                                    <td class="px-6 py-3.5 font-bold text-white whitespace-nowrap"><%= res.getStudentName() %></td>
                                    <td class="px-6 py-3.5 text-slate-400 whitespace-nowrap"><%= res.getStudentEmail() %></td>
                                    <td class="px-6 py-3.5 text-slate-300 whitespace-nowrap"><%= res.getExamTitle() %></td>
                                    <td class="px-6 py-3.5 text-center text-indigo-400 whitespace-nowrap font-bold"><%= res.getScoreObtained() %> Marks</td>
                                    <td class="px-6 py-3.5 text-center font-bold whitespace-nowrap <%= passed ? "text-emerald-400" : "text-red-400" %>">
                                        <%= String.format("%.1f", res.getPercentage()) %>%
                                    </td>
                                    <td class="px-6 py-3.5 text-center whitespace-nowrap">
                                        <span class="inline-flex items-center px-2 py-0.5 rounded-full text-4xs font-bold border
                                                     <%= passed ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400" : "bg-red-500/10 border-red-500/20 text-red-400" %>">
                                            <%= res.getPassStatus() %>
                                        </span>
                                    </td>
                                    <td class="px-6 py-3.5 text-right text-slate-500 whitespace-nowrap"><%= res.getExamDate() %></td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>
    </div>
</div>

<%@ include file="/footer.jsp" %>
