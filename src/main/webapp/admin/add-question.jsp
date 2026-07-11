<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ExamDAO" %>
<%@ page import="com.exam.model.Exam" %>

<%
    // Session validation
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String examIdStr = request.getParameter("examId");
    if (examIdStr == null || examIdStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?error=No exam target selected for adding questions.");
        return;
    }

    int examId = Integer.parseInt(examIdStr.trim());
    ExamDAO examDAO = new ExamDAO();
    Exam exam = examDAO.getExamById(examId);

    if (exam == null) {
        response.sendRedirect(request.getContextPath() + "/admin/manage-exams.jsp?error=Exam target not found.");
        return;
    }
%>

<div class="max-w-2xl mx-auto py-6 animate-fade-in">
    
    <div class="glass-panel rounded-2xl p-6 md:p-8 relative">
        <!-- Glow Accent -->
        <div class="absolute -top-12 -left-12 h-32 w-32 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none"></div>

        <div class="flex items-center justify-between border-b border-slate-800 pb-4 mb-6">
            <div class="space-y-0.5">
                <span class="text-3xs font-bold uppercase tracking-wider text-indigo-400">Exam: <%= exam.getTitle() %></span>
                <h2 class="text-lg font-bold text-white flex items-center space-x-2">
                    <i class="fa-solid fa-circle-question text-indigo-400 text-sm"></i>
                    <span>Add MCQ Question</span>
                </h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" class="text-slate-400 hover:text-white transition text-xs font-semibold">
                Cancel
            </a>
        </div>

        <!-- Alert messages -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm flex items-start space-x-2.5">
                <i class="fa-solid fa-triangle-exclamation mt-0.5"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>
        <div id="validation-alert" class="hidden mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm flex items-start space-x-2.5">
            <i class="fa-solid fa-circle-exclamation mt-0.5"></i>
            <span id="validation-msg"></span>
        </div>

        <form action="${pageContext.request.contextPath}/admin/add-question" method="post" onsubmit="return validateQuestionForm()" class="space-y-4">
            <input type="hidden" name="examId" value="<%= exam.getId() %>">

            <!-- Question Text -->
            <div>
                <label for="questionText" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Question Content</label>
                <textarea id="questionText" name="questionText" rows="3" placeholder="Enter question description..." 
                          class="w-full px-4 py-3 rounded-xl premium-input text-xs resize-none" required></textarea>
            </div>

            <!-- Options Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="optionA" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Option A</label>
                    <input type="text" id="optionA" name="optionA" placeholder="Enter option A content" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
                <div>
                    <label for="optionB" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Option B</label>
                    <input type="text" id="optionB" name="optionB" placeholder="Enter option B content" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
                <div>
                    <label for="optionC" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Option C</label>
                    <input type="text" id="optionC" name="optionC" placeholder="Enter option C content" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
                <div>
                    <label for="optionD" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Option D</label>
                    <input type="text" id="optionD" name="optionD" placeholder="Enter option D content" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
            </div>

            <!-- Correct Option & Marks -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="correctOption" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Correct Option</label>
                    <select id="correctOption" name="correctOption" 
                            class="w-full px-4 py-3 rounded-xl premium-input text-xs bg-slate-900" required>
                        <option value="">-- Choose correct choice --</option>
                        <option value="A">Option A</option>
                        <option value="B">Option B</option>
                        <option value="C">Option C</option>
                        <option value="D">Option D</option>
                    </select>
                </div>
                <div>
                    <label for="marks" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Question Marks</label>
                    <input type="number" id="marks" name="marks" value="5" min="1" max="50" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
            </div>

            <div class="flex space-x-3 pt-6 border-t border-slate-800">
                <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" 
                   class="flex-1 py-3 rounded-xl text-center text-xs font-semibold bg-slate-800 border border-slate-700 text-slate-300 hover:bg-slate-700 transition">
                    Back to Catalog
                </a>
                <button type="submit" class="flex-1 py-3 rounded-xl text-xs font-bold text-white glow-btn-indigo hover:opacity-95 transition">
                    Save Question
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function validateQuestionForm() {
        const qText = document.getElementById('questionText').value.trim();
        const optA = document.getElementById('optionA').value.trim();
        const optB = document.getElementById('optionB').value.trim();
        const optC = document.getElementById('optionC').value.trim();
        const optD = document.getElementById('optionD').value.trim();
        const correct = document.getElementById('correctOption').value;
        const marks = parseInt(document.getElementById('marks').value);
        
        const alertBox = document.getElementById('validation-alert');
        const alertMsg = document.getElementById('validation-msg');

        alertBox.classList.add('hidden');

        if (!qText || !optA || !optB || !optC || !optD) {
            showError('Please write text for the question description and all 4 choices.');
            return false;
        }

        if (correct !== 'A' && correct !== 'B' && correct !== 'C' && correct !== 'D') {
            showError('Please choose a valid correct option (A, B, C, or D).');
            return false;
        }

        if (isNaN(marks) || marks <= 0) {
            showError('Question marks must be a positive number.');
            return false;
        }

        return true;

        function showError(msg) {
            alertMsg.innerText = msg;
            alertBox.classList.remove('hidden');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    }
</script>

<%@ include file="/footer.jsp" %>
