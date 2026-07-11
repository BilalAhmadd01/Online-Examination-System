<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ExamDAO" %>
<%@ page import="com.exam.dao.ResultDAO" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"STUDENT".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ExamDAO examDAO = new ExamDAO();
    ResultDAO resultDAO = new ResultDAO();

    List<Exam> exams = examDAO.getAllExams();
    List<Result> history = resultDAO.getResultsByStudentId(currentUser.getId());
%>

<!-- Dashboard Content -->
<div class="space-y-8 animate-fade-in">
    
    <!-- Welcome Panel -->
    <div class="p-6 md:p-8 rounded-2xl bg-gradient-to-r from-indigo-900/40 via-violet-900/30 to-slate-900/40 border border-indigo-500/10 flex flex-col md:flex-row items-center justify-between gap-4">
        <div>
            <h1 class="text-2xl md:text-3xl font-bold tracking-tight">Welcome back, <%= currentUser.getFirstName() %>!</h1>
            <p class="text-sm text-slate-400 mt-1">Ready to test your skills? Select an available exam below to begin.</p>
        </div>
        <div class="flex items-center space-x-6 bg-slate-800/30 border border-slate-800 px-6 py-3 rounded-xl text-center">
            <div>
                <span class="block text-2xl font-bold text-indigo-400"><%= history.size() %></span>
                <span class="text-xxs text-slate-500 font-semibold uppercase tracking-wider">Exams Taken</span>
            </div>
            <div class="h-8 w-px bg-slate-800"></div>
            <div>
                <%
                    int passCount = 0;
                    for(Result r : history) {
                        if("PASS".equalsIgnoreCase(r.getPassStatus())) passCount++;
                    }
                    double passRate = history.isEmpty() ? 0.0 : ((double)passCount/history.size())*100;
                %>
                <span class="block text-2xl font-bold text-emerald-400"><%= String.format("%.0f", passRate) %>%</span>
                <span class="text-xxs text-slate-500 font-semibold uppercase tracking-wider">Pass Rate</span>
            </div>
        </div>
    </div>

    <!-- Layout Grid: Active Exams and Recent Attempts -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
        
        <!-- Active Exams Section (Left 8 columns) -->
        <div class="lg:col-span-8 space-y-6">
            <h2 class="text-lg font-bold flex items-center space-x-2">
                <i class="fa-solid fa-list-check text-indigo-400"></i>
                <span>Available Examinations</span>
            </h2>

            <% if (exams == null || exams.isEmpty()) { %>
                <div class="glass-panel rounded-xl p-8 text-center text-slate-400">
                    <i class="fa-solid fa-hourglass-empty text-3xl mb-3 text-slate-600"></i>
                    <p class="text-sm">There are no active examinations available at the moment. Check back later!</p>
                </div>
            <% } else { %>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <% for(Exam exam : exams) { %>
                        <div class="glass-card rounded-2xl p-5 flex flex-col justify-between">
                            <div>
                                <div class="flex items-center justify-between mb-3">
                                    <span class="px-2.5 py-0.5 rounded-full text-2xs font-semibold bg-indigo-500/10 text-indigo-400 border border-indigo-500/15">
                                        <%= exam.getDuration() %> Mins
                                    </span>
                                    <span class="text-2xs text-slate-500 font-semibold uppercase">
                                        Pass Min: <%= exam.getPassPercentage() %>%
                                    </span>
                                </div>
                                <h3 class="text-lg font-bold text-white mb-2 line-clamp-1"><%= exam.getTitle() %></h3>
                                <p class="text-xs text-slate-400 line-clamp-3 mb-6 leading-relaxed">
                                    <%= exam.getDescription() != null && !exam.getDescription().isEmpty() ? exam.getDescription() : "No detailed descriptions provided for this exam. Standard guidelines apply." %>
                                </p>
                            </div>
                            
                            <div class="flex items-center justify-between pt-4 border-t border-slate-800/60">
                                <div class="text-slate-400 text-xs">
                                    <i class="fa-solid fa-award text-indigo-500/80 mr-1"></i><%= exam.getTotalMarks() %> Marks
                                </div>
                                <button onclick="openExamModal(<%= exam.getId() %>, '<%= exam.getTitle().replace("'", "\\'") %>', <%= exam.getDuration() %>, <%= exam.getTotalMarks() %>, <%= exam.getPassPercentage() %>)"
                                        class="px-4 py-2 rounded-xl text-xs font-bold text-white glow-btn-indigo hover:opacity-90 transition flex items-center space-x-1">
                                    <span>Start Exam</span> <i class="fa-solid fa-circle-play text-2xs ml-0.5"></i>
                                </button>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>

        <!-- Recent Results Section (Right 4 columns) -->
        <div class="lg:col-span-4 space-y-6">
            <h2 class="text-lg font-bold flex items-center space-x-2">
                <i class="fa-solid fa-clock-rotate-left text-indigo-400"></i>
                <span>Recent Results</span>
            </h2>

            <% if (history == null || history.isEmpty()) { %>
                <div class="glass-panel rounded-xl p-6 text-center text-slate-500 text-xs">
                    No examination records found. Your attempts will show up here.
                </div>
            <% } else { %>
                <div class="space-y-4">
                    <% 
                        int count = 0;
                        for(Result res : history) {
                            if(count++ >= 4) break; // Display only last 4 attempts
                            boolean passed = "PASS".equalsIgnoreCase(res.getPassStatus());
                    %>
                        <a href="${pageContext.request.contextPath}/student/exam-result.jsp?resultId=<%= res.getId() %>" 
                           class="block glass-card p-4 rounded-xl flex items-center justify-between border-l-4 <%= passed ? "border-l-emerald-500" : "border-l-red-500" %>">
                            <div class="space-y-1 max-w-[70%]">
                                <h4 class="font-semibold text-xs text-white truncate"><%= res.getExamTitle() %></h4>
                                <span class="text-3xs text-slate-500 block"><%= res.getExamDate() %></span>
                            </div>
                            <div class="text-right">
                                <span class="block text-sm font-bold <%= passed ? "text-emerald-400" : "text-red-400" %>"><%= String.format("%.0f", res.getPercentage()) %>%</span>
                                <span class="text-3xs uppercase tracking-wider font-semibold <%= passed ? "text-emerald-500/80" : "text-red-500/80" %>"><%= res.getPassStatus() %></span>
                            </div>
                        </a>
                    <% } %>
                    
                    <% if (history.size() > 4) { %>
                        <a href="${pageContext.request.contextPath}/student/view-results.jsp" class="block text-center text-xs font-semibold text-indigo-400 hover:text-indigo-300 transition">
                            View All Historical Results <i class="fa-solid fa-arrow-right-long ml-1 text-2xs"></i>
                        </a>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>
</div>

<!-- Start Exam Confirmation Modal (Overlay Backdrop) -->
<div id="exam-modal" class="fixed inset-0 z-50 flex items-center justify-center bg-darkblue-900/80 backdrop-blur-sm hidden animate-fade-in">
    <div class="glass-panel max-w-md w-full mx-4 rounded-2xl p-6 md:p-8 space-y-6 shadow-2xl relative">
        <div class="text-center">
            <div class="h-12 w-12 rounded-full bg-indigo-500/10 text-indigo-400 flex items-center justify-center mx-auto mb-4 border border-indigo-500/20">
                <i class="fa-solid fa-file-signature text-xl"></i>
            </div>
            <h3 class="text-xl font-bold text-white">Confirm Starting Exam</h3>
            <p id="modal-exam-title" class="text-sm text-indigo-300 font-semibold mt-1">Java Programming Basics</p>
        </div>

        <div class="bg-slate-800/40 border border-slate-800 rounded-xl p-4 space-y-3.5 text-xs text-slate-300">
            <div class="flex justify-between">
                <span class="text-slate-500 font-medium">Exam Duration:</span>
                <span id="modal-exam-duration" class="font-bold text-white">15 Minutes</span>
            </div>
            <div class="flex justify-between">
                <span class="text-slate-500 font-medium">Total Maximum Marks:</span>
                <span id="modal-exam-marks" class="font-bold text-white">25 Marks</span>
            </div>
            <div class="flex justify-between">
                <span class="text-slate-500 font-medium">Required Passing Score:</span>
                <span id="modal-exam-pass" class="font-bold text-emerald-400">40%</span>
            </div>
            <div class="h-px bg-slate-800"></div>
            <div class="space-y-2 text-xxs leading-relaxed text-slate-400">
                <p class="flex items-start"><i class="fa-solid fa-triangle-exclamation text-amber-500 mr-2 mt-0.5"></i>Do not refresh the page or navigate away during the active session. This will auto-submit the exam.</p>
                <p class="flex items-start"><i class="fa-solid fa-clock text-indigo-400 mr-2 mt-0.5"></i>The examination will automatically submit when the timer expires.</p>
            </div>
        </div>

        <div class="flex space-x-3">
            <button onclick="closeExamModal()" class="flex-1 py-2.5 rounded-xl text-xs font-semibold bg-slate-800 hover:bg-slate-700/80 border border-slate-700 text-slate-300 transition">
                Cancel
            </button>
            <a id="modal-start-link" href="#" class="flex-1 py-2.5 rounded-xl text-xs font-bold text-white text-center glow-btn-indigo hover:opacity-95 transition flex items-center justify-center">
                Begin Exam
            </a>
        </div>
    </div>
</div>

<script>
    function openExamModal(id, title, duration, marks, pass) {
        document.getElementById('modal-exam-title').innerText = title;
        document.getElementById('modal-exam-duration').innerText = duration + ' Minutes';
        document.getElementById('modal-exam-marks').innerText = marks + ' Marks';
        document.getElementById('modal-exam-pass').innerText = pass + '%';
        document.getElementById('modal-start-link').href = '${pageContext.request.contextPath}/student/take-exam.jsp?examId=' + id;
        
        const modal = document.getElementById('exam-modal');
        modal.classList.remove('hidden');
    }

    function closeExamModal() {
        document.getElementById('exam-modal').classList.add('hidden');
    }
</script>

<%@ include file="/footer.jsp" %>
