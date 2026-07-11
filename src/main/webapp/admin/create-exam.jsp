<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>

<div class="max-w-xl mx-auto py-6 animate-fade-in">
    
    <div class="glass-panel rounded-2xl p-6 md:p-8 relative">
        <!-- Accent Glow -->
        <div class="absolute -top-12 -left-12 h-32 w-32 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none"></div>
        
        <div class="flex items-center justify-between border-b border-slate-800 pb-4 mb-6">
            <h2 class="text-xl font-bold text-white flex items-center space-x-2">
                <i class="fa-solid fa-file-circle-plus text-indigo-400 text-sm"></i>
                <span>Configure New Examination</span>
            </h2>
            <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" class="text-slate-400 hover:text-white transition text-xs font-semibold">
                Manage Exams
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

        <form action="${pageContext.request.contextPath}/admin/create-exam" method="post" onsubmit="return validateExamForm()" class="space-y-5">
            
            <!-- Title -->
            <div>
                <label for="title" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Exam Title</label>
                <input type="text" id="title" name="title" placeholder="e.g. Core Java Assessment" 
                       class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
            </div>

            <!-- Description -->
            <div>
                <label for="description" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Description / Instructions</label>
                <textarea id="description" name="description" rows="4" placeholder="Guideline details for students taking the exam..." 
                          class="w-full px-4 py-3 rounded-xl premium-input text-xs resize-none"></textarea>
            </div>

            <!-- Duration & Passing Percentage -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="duration" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Duration (Minutes)</label>
                    <input type="number" id="duration" name="duration" placeholder="e.g. 30" min="1" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
                <div>
                    <label for="passPercentage" class="block text-3xs font-bold text-slate-400 uppercase tracking-wider mb-2">Passing Grade (%)</label>
                    <input type="number" id="passPercentage" name="passPercentage" placeholder="e.g. 40" min="1" max="100" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
            </div>

            <div class="flex space-x-3 pt-4 border-t border-slate-800">
                <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" 
                   class="flex-1 py-3 rounded-xl text-center text-xs font-semibold bg-slate-800 border border-slate-700 text-slate-300 hover:bg-slate-700 transition">
                    Cancel
                </a>
                <button type="submit" class="flex-1 py-3 rounded-xl text-xs font-bold text-white glow-btn-indigo hover:opacity-95 transition">
                    Create Exam
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function validateExamForm() {
        const title = document.getElementById('title').value.trim();
        const duration = parseInt(document.getElementById('duration').value);
        const pass = parseInt(document.getElementById('passPercentage').value);
        const alertBox = document.getElementById('validation-alert');
        const alertMsg = document.getElementById('validation-msg');

        alertBox.classList.add('hidden');

        if (!title) {
            showError('Please input a valid exam title.');
            return false;
        }

        if (isNaN(duration) || duration <= 0) {
            showError('Duration must be a positive number of minutes.');
            return false;
        }

        if (isNaN(pass) || pass < 10 || pass > 100) {
            showError('Required Passing Score must be between 10% and 100%.');
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
