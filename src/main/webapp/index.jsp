<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!-- Welcome and Login Container Grid -->
<div class="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center py-6 md:py-12">
    
    <!-- Left Panel: Text & Visual Pitch -->
    <div class="lg:col-span-6 space-y-6 animate-fade-in">
        <div class="inline-flex items-center space-x-2 bg-indigo-500/10 text-indigo-400 border border-indigo-500/25 px-3 py-1 rounded-full text-xs font-semibold">
            <i class="fa-solid fa-sparkles"></i>
            <span>ApexExam Version 1.0</span>
        </div>
        <h1 class="text-4xl md:text-6xl font-extrabold leading-tight tracking-tight">
            Empower Knowledge. <br>
            <span class="bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent glow-text-indigo">
                Streamline Evaluation.
            </span>
        </h1>
        <p class="text-slate-400 text-base md:text-lg leading-relaxed max-w-xl">
            A comprehensive, secure, and visually interactive examination framework built for modern institutions. Create, test, and automatically generate detailed result analyses in real time.
        </p>
        
        <!-- Feature Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-4">
            <div class="p-4 rounded-xl bg-slate-800/30 border border-slate-800 flex items-start space-x-3">
                <div class="h-10 w-10 rounded-lg bg-indigo-500/10 text-indigo-400 flex items-center justify-center flex-shrink-0">
                    <i class="fa-solid fa-clock-rotate-left"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-sm">Real-time Timers</h3>
                    <p class="text-xs text-slate-500 mt-0.5">Countdown control on exams with automatic secure submissions.</p>
                </div>
            </div>
            <div class="p-4 rounded-xl bg-slate-800/30 border border-slate-800 flex items-start space-x-3">
                <div class="h-10 w-10 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center flex-shrink-0">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div>
                    <h3 class="font-semibold text-sm">Auto-Grading</h3>
                    <p class="text-xs text-slate-500 mt-0.5">Automatic percentage evaluation and instant scorecards.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Panel: Authentication Card -->
    <div class="lg:col-span-6 flex justify-center animate-fade-in" style="animation-delay: 0.1s;">
        <div class="w-full max-w-md glass-panel rounded-2xl p-6 md:p-8 relative">
            
            <!-- Glow Accent -->
            <div class="absolute -top-12 -right-12 h-32 w-32 bg-indigo-500/15 rounded-full blur-3xl pointer-events-none"></div>
            
            <!-- Banner Alerts -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm flex items-start space-x-2.5">
                    <i class="fa-solid fa-triangle-exclamation mt-0.5"></i>
                    <span><%= request.getAttribute("error") %></span>
                </div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="mb-6 p-4 rounded-xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-sm flex items-start space-x-2.5">
                    <i class="fa-solid fa-circle-check mt-0.5"></i>
                    <span><%= request.getAttribute("success") %></span>
                </div>
            <% } %>

            <!-- Tab Headers -->
            <div class="flex border-b border-slate-800 pb-3 mb-6 space-x-4">
                <button onclick="switchTab('student')" id="tab-btn-student" class="flex-1 pb-2 text-center text-sm font-semibold border-b-2 border-indigo-500 text-white transition focus:outline-none">
                    <i class="fa-solid fa-user-graduate mr-1.5"></i>Student Login
                </button>
                <button onclick="switchTab('admin')" id="tab-btn-admin" class="flex-1 pb-2 text-center text-sm font-semibold border-b-2 border-transparent text-slate-400 hover:text-white transition focus:outline-none">
                    <i class="fa-solid fa-user-shield mr-1.5"></i>Admin Portal
                </button>
            </div>

            <!-- Login Form (POSTs to /login) -->
            <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateLoginForm()" class="space-y-5">
                <div>
                    <label id="username-label" for="username" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Student Username</label>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-500 pointer-events-none">
                            <i class="fa-solid fa-user text-sm"></i>
                        </span>
                        <input type="text" id="username" name="username" placeholder="Enter username..." 
                               class="w-full pl-10 pr-4 py-3 rounded-xl premium-input text-sm" required>
                    </div>
                </div>
                
                <div>
                    <div class="flex items-center justify-between mb-2">
                        <label for="password" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider">Password</label>
                    </div>
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-500 pointer-events-none">
                            <i class="fa-solid fa-lock text-sm"></i>
                        </span>
                        <input type="password" id="password" name="password" placeholder="Enter password..." 
                               class="w-full pl-10 pr-4 py-3 rounded-xl premium-input text-sm" required>
                    </div>
                </div>

                <button type="submit" class="w-full py-3 rounded-xl font-bold text-sm text-white glow-btn-indigo hover:opacity-95 transition">
                    Sign In
                </button>
            </form>

            <!-- Bottom Registration Pitch -->
            <div id="register-pitch" class="mt-6 text-center text-xs text-slate-500">
                Don't have a student account? 
                <a href="${pageContext.request.contextPath}/student/register.jsp" class="text-indigo-400 font-semibold hover:underline">Register here</a>.
            </div>
        </div>
    </div>
</div>

<!-- Tab Switching Script -->
<script>
    function switchTab(role) {
        const studentBtn = document.getElementById('tab-btn-student');
        const adminBtn = document.getElementById('tab-btn-admin');
        const usernameLabel = document.getElementById('username-label');
        const registerPitch = document.getElementById('register-pitch');
        
        if (role === 'student') {
            studentBtn.classList.add('border-indigo-500', 'text-white');
            studentBtn.classList.remove('border-transparent', 'text-slate-400');
            
            adminBtn.classList.add('border-transparent', 'text-slate-400');
            adminBtn.classList.remove('border-indigo-500', 'text-white');
            
            usernameLabel.innerText = 'Student Username';
            registerPitch.style.display = 'block';
        } else {
            adminBtn.classList.add('border-indigo-500', 'text-white');
            adminBtn.classList.remove('border-transparent', 'text-slate-400');
            
            studentBtn.classList.add('border-transparent', 'text-slate-400');
            studentBtn.classList.remove('border-indigo-500', 'text-white');
            
            usernameLabel.innerText = 'Admin Username';
            registerPitch.style.display = 'none';
        }
    }

    function validateLoginForm() {
        const userVal = document.getElementById('username').value.trim();
        const passVal = document.getElementById('password').value.trim();
        if (userVal === '' || passVal === '') {
            alert('Please fill out all credentials.');
            return false;
        }
        return true;
    }
</script>

<%@ include file="footer.jsp" %>
