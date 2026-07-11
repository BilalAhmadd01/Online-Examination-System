<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ResultDAO" %>
<%@ page import="com.exam.dao.ExamDAO" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="com.exam.model.Exam" %>

<%
    // Session validation
    if (currentUser == null || !"STUDENT".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String resultIdStr = request.getParameter("resultId");
    if(resultIdStr == null || resultIdStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Result context missing.");
        return;
    }

    int resultId = Integer.parseInt(resultIdStr.trim());
    ResultDAO resultDAO = new ResultDAO();
    Result res = resultDAO.getResultById(resultId);

    if (res == null || res.getStudentId() != currentUser.getId()) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Unauthorized result request.");
        return;
    }

    ExamDAO examDAO = new ExamDAO();
    Exam exam = examDAO.getExamById(res.getExamId());
    
    boolean passed = "PASS".equalsIgnoreCase(res.getPassStatus());
    double percentage = res.getPercentage();
%>

<!-- Result Report Card View -->
<div class="max-w-3xl mx-auto py-6 animate-fade-in">
    
    <div class="glass-panel rounded-3xl p-6 md:p-10 shadow-2xl relative overflow-hidden">
        
        <!-- Background Radial Accents -->
        <div class="absolute -top-24 -left-24 h-48 w-48 <%= passed ? "bg-emerald-500/10" : "bg-red-500/10" %> rounded-full blur-3xl pointer-events-none"></div>
        <div class="absolute -bottom-24 -right-24 h-48 w-48 <%= passed ? "bg-indigo-500/10" : "bg-purple-500/10" %> rounded-full blur-3xl pointer-events-none"></div>

        <!-- Result Status Branding Header -->
        <div class="text-center space-y-3">
            <div class="inline-flex items-center space-x-2 bg-slate-800 border border-slate-700/60 px-3.5 py-1.5 rounded-full text-xs font-semibold text-slate-300">
                <i class="fa-solid fa-graduation-cap text-indigo-400"></i>
                <span>Official Assessment Report</span>
            </div>
            <h1 class="text-xl md:text-2xl font-bold tracking-tight text-white"><%= res.getExamTitle() %></h1>
            <p class="text-xs text-slate-400">Evaluated automatically on <%= res.getExamDate() %></p>
        </div>

        <div class="h-px bg-slate-800/80 my-8"></div>

        <!-- Grading Performance Matrix -->
        <div class="grid grid-cols-1 md:grid-cols-12 gap-8 items-center">
            
            <!-- Visual Circular Progress SVG (Left 5 columns) -->
            <div class="md:col-span-5 flex flex-col items-center justify-center space-y-4">
                <div class="relative flex items-center justify-center">
                    
                    <!-- SVG Circle Ring -->
                    <svg class="h-44 w-44">
                        <circle class="text-slate-800" stroke-width="8" stroke="currentColor" fill="transparent" r="76" cx="88" cy="88" />
                        <circle class="<%= passed ? "text-emerald-500" : "text-red-500" %> progress-ring__circle" 
                                stroke-width="8" 
                                stroke-dasharray="477.5" 
                                stroke-dashoffset="477.5"
                                stroke-linecap="round" 
                                stroke="currentColor" 
                                fill="transparent" 
                                r="76" cx="88" cy="88" 
                                id="progress-indicator" />
                    </svg>
                    
                    <!-- Percentage Text Overlay -->
                    <div class="absolute text-center space-y-0.5">
                        <span class="block text-3xl font-extrabold text-white"><%= String.format("%.1f", percentage) %>%</span>
                        <span class="text-3xs uppercase tracking-wider text-slate-500 font-bold">Total Score</span>
                    </div>
                </div>

                <!-- Pass/Fail Badge Banner -->
                <div class="px-5 py-2.5 rounded-xl border font-bold text-sm text-center w-full max-w-[200px] flex items-center justify-center space-x-2 shadow-md
                            <%= passed ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400" : "bg-red-500/10 border-red-500/20 text-red-400" %>">
                    <i class="fa-solid <%= passed ? "fa-circle-check" : "fa-triangle-exclamation" %>"></i>
                    <span class="tracking-wide uppercase"><%= res.getPassStatus() %></span>
                </div>
            </div>

            <!-- Score breakdown details (Right 7 columns) -->
            <div class="md:col-span-7 space-y-4">
                <h3 class="font-bold text-xs uppercase tracking-wider text-slate-400 mb-2">Evaluation Summary</h3>
                
                <div class="bg-slate-800/20 border border-slate-800 rounded-2xl p-5 space-y-4 text-sm text-slate-300">
                    
                    <!-- Total Questions -->
                    <div class="flex justify-between items-center">
                        <span class="text-slate-400">Total Questions Evaluated</span>
                        <span class="font-bold text-white"><%= res.getTotalQuestions() %></span>
                    </div>
                    
                    <!-- Correct Answers -->
                    <div class="flex justify-between items-center pt-3 border-t border-slate-800/40">
                        <span class="text-slate-400">Correct Answers</span>
                        <span class="font-bold text-emerald-400"><%= res.getCorrectAnswers() %></span>
                    </div>

                    <!-- Incorrect/Skipped Answers -->
                    <div class="flex justify-between items-center pt-3 border-t border-slate-800/40">
                        <span class="text-slate-400">Incorrect/Skipped Answers</span>
                        <span class="font-bold text-red-400"><%= res.getTotalQuestions() - res.getCorrectAnswers() %></span>
                    </div>

                    <!-- Score Obtained -->
                    <div class="flex justify-between items-center pt-3 border-t border-slate-800/40">
                        <span class="text-slate-400">Marks Obtained</span>
                        <span class="font-extrabold text-indigo-400"><%= res.getScoreObtained() %> <span class="text-slate-500 font-normal">/ <%= exam != null ? exam.getTotalMarks() : "" %></span></span>
                    </div>

                    <!-- Required Passing Grade -->
                    <div class="flex justify-between items-center pt-3 border-t border-slate-800/40">
                        <span class="text-slate-400">Required Passing Score</span>
                        <span class="font-bold text-slate-200"><%= exam != null ? exam.getPassPercentage() : "" %>%</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="h-px bg-slate-800/80 my-8"></div>

        <!-- Back to dashboard footer triggers -->
        <div class="flex flex-col sm:flex-row gap-4">
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" 
               class="flex-1 py-3 text-center text-xs font-bold text-white bg-slate-800 hover:bg-slate-700 border border-slate-700/80 rounded-xl transition flex items-center justify-center space-x-1.5">
                <i class="fa-solid fa-house"></i> <span>Back to Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/student/view-results.jsp" 
               class="flex-1 py-3 text-center text-xs font-bold text-white glow-btn-indigo hover:opacity-95 rounded-xl transition flex items-center justify-center space-x-1.5">
                <i class="fa-solid fa-clock-rotate-left"></i> <span>View All My Results</span>
            </a>
        </div>
    </div>
</div>

<!-- Circle Animation Loader Script -->
<script>
    window.onload = function() {
        var circle = document.getElementById('progress-indicator');
        if (circle) {
            var radius = circle.r.baseVal.value;
            var circumference = radius * 2 * Math.PI;
            
            circle.style.strokeDasharray = circumference + ' ' + circumference;
            circle.style.strokeDashoffset = circumference;
            
            // Set the target offset based on percentage
            var percent = <%= percentage %>;
            // Cap percent between 0 and 100
            if (percent < 0) percent = 0;
            if (percent > 100) percent = 100;
            
            const offset = circumference - (percent / 100 * circumference);
            
            // Trigger transition delay
            setTimeout(function() {
                circle.style.strokeDashoffset = offset;
            }, 150);
        }
    }
</script>

<%@ include file="/footer.jsp" %>
