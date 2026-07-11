<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ResultDAO" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"STUDENT".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ResultDAO resultDAO = new ResultDAO();
    List<Result> history = resultDAO.getResultsByStudentId(currentUser.getId());
%>

<div class="space-y-6 animate-fade-in">
    
    <!-- Title Section -->
    <div class="flex items-center justify-between border-b border-slate-800 pb-5">
        <div>
            <h1 class="text-xl md:text-2xl font-bold tracking-tight text-white flex items-center space-x-2">
                <i class="fa-solid fa-clock-rotate-left text-indigo-400"></i>
                <span>My Examination Performance History</span>
            </h1>
            <p class="text-xs text-slate-400 mt-1">Review the grades, certificates, and details of all exams you have attempted.</p>
        </div>
        <a href="${pageContext.request.contextPath}/student/dashboard.jsp" 
           class="px-4 py-2 rounded-xl border border-slate-700 hover:bg-slate-800 text-xs font-semibold transition flex items-center space-x-1">
            <i class="fa-solid fa-circle-chevron-left text-2xs mr-0.5"></i> <span>Dashboard</span>
        </a>
    </div>

    <!-- Results Table -->
    <% if (history == null || history.isEmpty()) { %>
        <div class="glass-panel rounded-2xl p-10 text-center text-slate-400">
            <div class="h-12 w-12 rounded-full bg-slate-800 text-slate-500 flex items-center justify-center mx-auto mb-4">
                <i class="fa-solid fa-folder-open text-xl"></i>
            </div>
            <p class="text-sm">You haven't attempted any exams yet.</p>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="inline-block mt-4 px-5 py-2.5 rounded-xl text-xs font-bold text-white glow-btn-indigo hover:opacity-95 transition">
                Browse Available Exams
            </a>
        </div>
    <% } else { %>
        <div class="glass-panel rounded-2xl overflow-hidden shadow-lg border border-slate-850">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-slate-800/80 text-left text-sm text-slate-300">
                    <thead class="bg-slate-800/40 text-slate-400 text-2xs uppercase tracking-wider font-semibold">
                        <tr>
                            <th scope="col" class="px-6 py-4">Exam Name</th>
                            <th scope="col" class="px-6 py-4">Attempt Date</th>
                            <th scope="col" class="px-6 py-4 text-center">Correct Answers</th>
                            <th scope="col" class="px-6 py-4 text-center">Final Score</th>
                            <th scope="col" class="px-6 py-4 text-center">Percentage</th>
                            <th scope="col" class="px-6 py-4 text-center">Status</th>
                            <th scope="col" class="px-6 py-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50 bg-slate-900/10">
                        <% 
                            for (Result res : history) { 
                                boolean passed = "PASS".equalsIgnoreCase(res.getPassStatus());
                        %>
                            <tr class="hover:bg-slate-800/20 transition duration-150">
                                <td class="px-6 py-4 whitespace-nowrap font-bold text-white max-w-[200px] truncate">
                                    <%= res.getExamTitle() %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-xs text-slate-400">
                                    <%= res.getExamDate() %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-xs">
                                    <%= res.getCorrectAnswers() %> / <%= res.getTotalQuestions() %>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-xs font-semibold text-indigo-400">
                                    <%= res.getScoreObtained() %> Marks
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center font-semibold <%= passed ? "text-emerald-400" : "text-red-400" %>">
                                    <%= String.format("%.1f", res.getPercentage()) %>%
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-3xs font-semibold border
                                                 <%= passed ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400" : "bg-red-500/10 border-red-500/20 text-red-400" %>">
                                        <i class="fa-solid <%= passed ? "fa-circle-check" : "fa-circle-xmark" %> mr-1"></i>
                                        <%= res.getPassStatus() %>
                                    </span>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-right">
                                    <a href="${pageContext.request.contextPath}/student/exam-result.jsp?resultId=<%= res.getId() %>" 
                                       class="text-indigo-400 hover:text-indigo-300 hover:underline font-bold text-xs inline-flex items-center space-x-1">
                                        <span>View Details</span> <i class="fa-solid fa-chevron-right text-3xs mt-0.5"></i>
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="/footer.jsp" %>
