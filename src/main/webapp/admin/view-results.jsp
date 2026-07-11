<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ResultDAO" %>
<%@ page import="com.exam.model.Result" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ResultDAO resultDAO = new ResultDAO();
    List<Result> allResults = resultDAO.getAllResults();
%>

<div class="space-y-6 animate-fade-in">
    
    <!-- Title and Actions -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between border-b border-slate-800 pb-5 gap-4">
        <div>
            <h1 class="text-xl md:text-2xl font-bold tracking-tight text-white flex items-center space-x-2">
                <i class="fa-solid fa-square-poll-vertical text-indigo-400"></i>
                <span>Aggregate Performance Ledger</span>
            </h1>
            <p class="text-xs text-slate-400 mt-1">Review the grades logs, performance sheets, and percentage ratings of all student assessments.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" 
           class="px-4 py-2 rounded-xl border border-slate-700 hover:bg-slate-800 text-xs font-semibold transition flex items-center space-x-1 self-start sm:self-auto">
            <i class="fa-solid fa-circle-chevron-left text-2xs mr-0.5"></i> <span>Dashboard</span>
        </a>
    </div>

    <!-- Search / Filter Area -->
    <div class="glass-panel p-4 rounded-xl flex items-center space-x-3 max-w-md border border-slate-800">
        <span class="text-slate-500"><i class="fa-solid fa-magnifying-glass"></i></span>
        <input type="text" id="search-input" onkeyup="filterResultsTable()" placeholder="Filter by Student Name, Email, or Exam Title..." 
               class="bg-transparent border-none text-xs text-slate-100 placeholder-slate-500 focus:outline-none w-full">
    </div>

    <!-- Results Table -->
    <% if (allResults == null || allResults.isEmpty()) { %>
        <div class="glass-panel rounded-2xl p-10 text-center text-slate-500">
            <div class="h-12 w-12 rounded-full bg-slate-800 text-slate-600 flex items-center justify-center mx-auto mb-4">
                <i class="fa-solid fa-box-archive text-lg"></i>
            </div>
            <p class="text-sm">No exam submission records found in the database logs yet.</p>
        </div>
    <% } else { %>
        <div class="glass-panel rounded-2xl overflow-hidden shadow-lg border border-slate-850">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-slate-800 text-left text-xs text-slate-300" id="results-table">
                    <thead class="bg-slate-800/40 text-slate-400 text-3xs uppercase tracking-wider font-semibold">
                        <tr>
                            <th class="px-6 py-4">Student Name</th>
                            <th class="px-6 py-4">Student Email</th>
                            <th class="px-6 py-4">Exam Name</th>
                            <th class="px-6 py-4 text-center">Score</th>
                            <th class="px-6 py-4 text-center">Percentage</th>
                            <th class="px-6 py-4 text-center">Status</th>
                            <th class="px-6 py-4 text-right">Attempt Date</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50 bg-slate-900/10">
                        <% 
                            for (Result res : allResults) { 
                                boolean passed = "PASS".equalsIgnoreCase(res.getPassStatus());
                        %>
                            <tr class="hover:bg-slate-800/20 transition duration-150 result-row">
                                <td class="px-6 py-3.5 font-bold text-white whitespace-nowrap student-name-cell"><%= res.getStudentName() %></td>
                                <td class="px-6 py-3.5 text-slate-400 whitespace-nowrap student-email-cell"><%= res.getStudentEmail() %></td>
                                <td class="px-6 py-3.5 text-slate-300 whitespace-nowrap exam-title-cell"><%= res.getExamTitle() %></td>
                                <td class="px-6 py-3.5 text-center text-indigo-400 whitespace-nowrap font-bold"><%= res.getScoreObtained() %> Marks</td>
                                <td class="px-6 py-3.5 text-center font-bold whitespace-nowrap <%= passed ? "text-emerald-400" : "text-red-400" %>">
                                    <%= String.format("%.1f", res.getPercentage()) %>%
                                </td>
                                <td class="px-6 py-3.5 text-center whitespace-nowrap">
                                    <span class="inline-flex items-center px-2 py-0.5 rounded-full text-4xs font-bold border
                                                 <%= passed ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-400" : "bg-red-500/10 border-red-500/20 text-red-400" %>">
                                        <i class="fa-solid <%= passed ? "fa-circle-check" : "fa-circle-xmark" %> mr-1"></i>
                                        <%= res.getPassStatus() %>
                                    </span>
                                </td>
                                <td class="px-6 py-3.5 text-right text-slate-400 whitespace-nowrap"><%= res.getExamDate() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>
</div>

<!-- Real-time Filter Search Script -->
<script>
    function filterResultsTable() {
        const input = document.getElementById('search-input');
        const filter = input.value.toLowerCase().trim();
        const table = document.getElementById('results-table');
        
        if(!table) return;
        
        const rows = table.getElementsByClassName('result-row');

        for (let i = 0; i < rows.length; i++) {
            const studentName = rows[i].getElementsByClassName('student-name-cell')[0].innerText.toLowerCase();
            const studentEmail = rows[i].getElementsByClassName('student-email-cell')[0].innerText.toLowerCase();
            const examTitle = rows[i].getElementsByClassName('exam-title-cell')[0].innerText.toLowerCase();

            if (studentName.includes(filter) || studentEmail.includes(filter) || examTitle.includes(filter)) {
                rows[i].style.display = "";
            } else {
                rows[i].style.display = "none";
            }
        }
    }
</script>

<%@ include file="/footer.jsp" %>
