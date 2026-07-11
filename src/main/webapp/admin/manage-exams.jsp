<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ExamDAO" %>
<%@ page import="com.exam.dao.QuestionDAO" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    ExamDAO examDAO = new ExamDAO();
    QuestionDAO questionDAO = new QuestionDAO();
    
    List<Exam> exams = examDAO.getAllExams();
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<div class="space-y-6 animate-fade-in">
    
    <!-- Title and Actions -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between border-b border-slate-800 pb-5 gap-4">
        <div>
            <h1 class="text-xl md:text-2xl font-bold tracking-tight text-white flex items-center space-x-2">
                <i class="fa-solid fa-file-invoice text-indigo-400"></i>
                <span>Examinations Management</span>
            </h1>
            <p class="text-xs text-slate-400 mt-1">Review active exams, inspect question catalogs, define assessment thresholds, or remove exams.</p>
        </div>
        <div class="flex space-x-2">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" 
               class="px-4 py-2 rounded-xl border border-slate-700 hover:bg-slate-800 text-xs font-semibold transition flex items-center space-x-1">
                <i class="fa-solid fa-circle-chevron-left text-2xs mr-0.5"></i> <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/admin/create-exam.jsp" 
               class="px-4 py-2 rounded-xl text-white font-bold text-xs glow-btn-indigo hover:opacity-95 transition flex items-center space-x-1">
                <i class="fa-solid fa-plus text-3xs"></i> <span>Create New Exam</span>
            </a>
        </div>
    </div>

    <!-- Banner Alerts -->
    <% if (error != null && !error.isEmpty()) { %>
        <div class="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm flex items-start space-x-2.5">
            <i class="fa-solid fa-triangle-exclamation mt-0.5"></i>
            <span><%= error %></span>
        </div>
    <% } %>
    <% if (success != null && !success.isEmpty()) { %>
        <div class="p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-sm flex items-start space-x-2.5">
            <i class="fa-solid fa-circle-check mt-0.5"></i>
            <span><%= success %></span>
        </div>
    <% } %>

    <!-- Exams Table -->
    <% if (exams == null || exams.isEmpty()) { %>
        <div class="glass-panel rounded-2xl p-10 text-center text-slate-500">
            <div class="h-12 w-12 rounded-full bg-slate-800 text-slate-600 flex items-center justify-center mx-auto mb-4">
                <i class="fa-solid fa-receipt text-lg"></i>
            </div>
            <p class="text-sm">No examinations configured in the database yet.</p>
            <a href="${pageContext.request.contextPath}/admin/create-exam.jsp" class="inline-block mt-4 px-5 py-2.5 rounded-xl text-xs font-bold text-white glow-btn-indigo hover:opacity-95 transition">
                Create First Exam
            </a>
        </div>
    <% } else { %>
        <div class="glass-panel rounded-2xl overflow-hidden shadow-lg border border-slate-850">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-slate-800 text-left text-xs text-slate-300">
                    <thead class="bg-slate-800/40 text-slate-400 text-3xs uppercase tracking-wider font-semibold">
                        <tr>
                            <th scope="col" class="px-6 py-4">ID</th>
                            <th scope="col" class="px-6 py-4">Exam Name</th>
                            <th scope="col" class="px-6 py-4 text-center">Duration</th>
                            <th scope="col" class="px-6 py-4 text-center">Questions Count</th>
                            <th scope="col" class="px-6 py-4 text-center">Total Marks</th>
                            <th scope="col" class="px-6 py-4 text-center">Passing score</th>
                            <th scope="col" class="px-6 py-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50 bg-slate-900/10">
                        <% 
                            for (Exam ex : exams) { 
                                int qCount = questionDAO.getQuestionsByExamId(ex.getId()).size();
                        %>
                            <tr class="hover:bg-slate-800/20 transition duration-150">
                                <td class="px-6 py-3.5 whitespace-nowrap text-slate-500">#<%= ex.getId() %></td>
                                <td class="px-6 py-3.5 font-bold text-white max-w-[200px] truncate"><%= ex.getTitle() %></td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-center font-medium text-slate-400"><%= ex.getDuration() %> Mins</td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-center font-bold text-slate-300"><%= qCount %> Qs</td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-center font-bold text-indigo-400"><%= ex.getTotalMarks() %> Marks</td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-center font-medium text-emerald-400"><%= ex.getPassPercentage() %>%</td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-right text-xs space-x-3">
                                    <a href="${pageContext.request.contextPath}/admin/add-question.jsp?examId=<%= ex.getId() %>" 
                                       class="text-indigo-400 hover:text-indigo-300 transition font-bold inline-flex items-center space-x-1">
                                        <i class="fa-solid fa-plus text-3xs"></i> <span>Add Q</span>
                                    </a>
                                    <button onclick="confirmDeleteExam(<%= ex.getId() %>, '<%= ex.getTitle().replace("'", "\\'") %>')" 
                                            class="text-red-400 hover:text-red-300 transition inline-flex items-center space-x-1 font-semibold">
                                        <i class="fa-regular fa-trash-can"></i> <span>Delete</span>
                                    </button>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    <% } %>
</div>

<!-- Delete Confirmation Modal -->
<div id="delete-exam-modal" class="fixed inset-0 z-50 flex items-center justify-center bg-darkblue-900/80 backdrop-blur-sm hidden animate-fade-in">
    <div class="glass-panel max-w-sm w-full mx-4 rounded-2xl p-6 space-y-6 shadow-2xl">
        <div class="text-center">
            <div class="h-12 w-12 rounded-full bg-red-500/10 text-red-400 flex items-center justify-center mx-auto mb-4 border border-red-500/20">
                <i class="fa-regular fa-trash-can text-lg"></i>
            </div>
            <h3 class="text-base font-bold text-white">Delete Examination?</h3>
            <p id="delete-exam-desc" class="text-xs text-slate-400 mt-1">All associated questions and student results will be permanently removed.</p>
        </div>

        <div class="flex space-x-3">
            <button onclick="toggleDeleteModal(false)" class="flex-1 py-2.5 rounded-xl text-xs bg-slate-800 border border-slate-700 text-slate-300 transition">
                Keep Exam
            </button>
            <a id="delete-confirm-link" href="#" class="flex-1 py-2.5 rounded-xl text-xs font-bold text-white bg-red-600 hover:bg-red-500 text-center transition flex items-center justify-center">
                Confirm Delete
            </a>
        </div>
    </div>
</div>

<script>
    function confirmDeleteExam(id, name) {
        document.getElementById('delete-exam-desc').innerText = "Are you sure you want to delete '" + name + "'? This deletes all exam questions and clearing historical grades.";
        document.getElementById('delete-confirm-link').href = "${pageContext.request.contextPath}/admin/create-exam?action=delete&id=" + id;
        toggleDeleteModal(true);
    }

    function toggleDeleteModal(show) {
        const modal = document.getElementById('delete-exam-modal');
        if (show) {
            modal.classList.remove('hidden');
        } else {
            modal.classList.add('hidden');
        }
    }
</script>

<%@ include file="/footer.jsp" %>
