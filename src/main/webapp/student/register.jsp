<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>

<div class="max-w-xl mx-auto py-6 md:py-12 animate-fade-in">
    <div class="glass-panel rounded-2xl p-6 md:p-8 relative">
        <!-- Glow Accent -->
        <div class="absolute -top-12 -left-12 h-32 w-32 bg-indigo-500/10 rounded-full blur-3xl pointer-events-none"></div>

        <div class="text-center mb-8">
            <h2 class="text-2xl md:text-3xl font-bold tracking-tight">Create Student Account</h2>
            <p class="text-xs text-slate-400 mt-2">Fill in your details below to register for online examinations.</p>
        </div>

        <!-- Server Side Errors -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm flex items-start space-x-2.5">
                <i class="fa-solid fa-triangle-exclamation mt-0.5"></i>
                <span><%= request.getAttribute("error") %></span>
            </div>
        <% } %>

        <!-- Client Side Errors Alert Container -->
        <div id="validation-alert" class="hidden mb-6 p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm flex items-start space-x-2.5">
            <i class="fa-solid fa-circle-exclamation mt-0.5"></i>
            <span id="validation-msg"></span>
        </div>

        <form action="${pageContext.request.contextPath}/register" method="post" onsubmit="return validateRegistrationForm()" class="space-y-5">
            
            <!-- First and Last Name Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="firstName" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">First Name</label>
                    <input type="text" id="firstName" name="firstName" placeholder="John" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-sm" required>
                </div>
                <div>
                    <label for="lastName" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Last Name</label>
                    <input type="text" id="lastName" name="lastName" placeholder="Doe" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-sm" required>
                </div>
            </div>

            <!-- Username -->
            <div>
                <label for="username" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Username</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-500 pointer-events-none">
                        <i class="fa-solid fa-circle-user text-sm"></i>
                    </span>
                    <input type="text" id="username" name="username" placeholder="johndoe12" 
                           class="w-full pl-10 pr-4 py-3 rounded-xl premium-input text-sm" required>
                </div>
            </div>

            <!-- Email -->
            <div>
                <label for="email" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Email Address</label>
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center text-slate-500 pointer-events-none">
                        <i class="fa-solid fa-envelope text-sm"></i>
                    </span>
                    <input type="email" id="email" name="email" placeholder="john.doe@example.com" 
                           class="w-full pl-10 pr-4 py-3 rounded-xl premium-input text-sm" required>
                </div>
            </div>

            <!-- Passwords Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="password" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Password</label>
                    <input type="password" id="password" name="password" placeholder="Min. 6 characters" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-sm" required>
                </div>
                <div>
                    <label for="confirmPassword" class="block text-xs font-semibold text-slate-400 uppercase tracking-wider mb-2">Confirm Password</label>
                    <input type="password" id="confirmPassword" placeholder="Re-enter password" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-sm" required>
                </div>
            </div>

            <button type="submit" class="w-full py-3 rounded-xl font-bold text-sm text-white glow-btn-indigo hover:opacity-95 transition">
                Create Account
            </button>
        </form>

        <div class="mt-6 text-center text-xs text-slate-500">
            Already have an account? 
            <a href="${pageContext.request.contextPath}/index.jsp" class="text-indigo-400 font-semibold hover:underline">Log in here</a>.
        </div>
    </div>
</div>

<!-- Form Validation Script -->
<script>
    function validateRegistrationForm() {
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const username = document.getElementById('username').value.trim();
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        
        const alertBox = document.getElementById('validation-alert');
        const alertMsg = document.getElementById('validation-msg');

        // Hide alert box initially
        alertBox.classList.add('hidden');

        // 1. Check empty fields
        if (!firstName || !lastName || !username || !email || !password || !confirmPassword) {
            showError('All fields must be filled out.');
            return false;
        }

        // 2. Username Length & Character checking
        if (username.length < 4) {
            showError('Username must be at least 4 characters long.');
            return false;
        }

        // 3. Email Check
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showError('Please enter a valid email address.');
            return false;
        }

        // 4. Password Length
        if (password.length < 6) {
            showError('Password must be at least 6 characters long.');
            return false;
        }

        // 5. Passwords match check
        if (password !== confirmPassword) {
            showError('Passwords do not match. Please verify.');
            return false;
        }

        return true;

        function showError(message) {
            alertMsg.innerText = message;
            alertBox.classList.remove('hidden');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    }
</script>

<%@ include file="/footer.jsp" %>
