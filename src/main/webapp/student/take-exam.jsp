<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.ExamDAO" %>
<%@ page import="com.exam.dao.QuestionDAO" %>
<%@ page import="com.exam.model.Exam" %>
<%@ page import="com.exam.model.Question" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"STUDENT".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String examIdStr = request.getParameter("examId");
    if (examIdStr == null || examIdStr.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Invalid access.");
        return;
    }

    int examId = Integer.parseInt(examIdStr.trim());
    ExamDAO examDAO = new ExamDAO();
    QuestionDAO questionDAO = new QuestionDAO();

    Exam exam = examDAO.getExamById(examId);
    List<Question> questions = questionDAO.getQuestionsByExamId(examId);

    if (exam == null || questions == null || questions.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/student/dashboard.jsp?error=Exam contains no questions yet.");
        return;
    }
%>

<!-- Distraction-Free Exam Interface -->
<div class="relative py-2 select-none" id="exam-container">
    
    <!-- Exam Title and Header Stats -->
    <div class="flex flex-col md:flex-row md:items-center justify-between border-b border-slate-800 pb-5 mb-8 gap-4">
        <div>
            <h1 class="text-xl md:text-2xl font-bold tracking-tight text-white"><%= exam.getTitle() %></h1>
            <p class="text-xs text-slate-400 mt-1">Please answer all questions. Do not refresh or close this window.</p>
        </div>
        
        <!-- Timer Widget -->
        <div class="flex items-center space-x-3 bg-slate-800/40 border border-slate-700/80 px-4 py-2.5 rounded-xl self-start md:self-auto shadow-md">
            <i class="fa-solid fa-clock text-indigo-400 text-lg"></i>
            <div>
                <span class="block text-2xs text-slate-500 font-semibold uppercase tracking-wider">Time Remaining</span>
                <span id="countdown-timer" class="font-mono text-lg font-bold text-white tracking-wide">00:00:00</span>
            </div>
        </div>
    </div>

    <!-- Exam Content Columns -->
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        
        <!-- Questions Form (Left 9 columns) -->
        <form id="exam-form" action="${pageContext.request.contextPath}/student/submit-exam" method="post" class="lg:col-span-9 space-y-6">
            <input type="hidden" name="examId" value="<%= exam.getId() %>">
            
            <% 
                int qNum = 1;
                for (Question q : questions) {
            %>
                <div id="q-card-<%= qNum %>" class="glass-panel rounded-2xl p-6 md:p-8 space-y-5 transition duration-300 relative border-l-4 border-l-transparent">
                    
                    <!-- Question Title & Metadata -->
                    <div class="flex items-start justify-between gap-4">
                        <div class="space-y-1">
                            <span class="text-xs font-semibold text-indigo-400">Question <%= qNum %> of <%= questions.size() %></span>
                            <h3 class="text-base md:text-lg font-bold text-slate-100 leading-relaxed"><%= q.getQuestionText() %></h3>
                        </div>
                        <span class="px-2.5 py-0.5 rounded-md text-3xs font-semibold bg-slate-800 text-slate-400 flex-shrink-0">
                            <%= q.getMarks() %> Marks
                        </span>
                    </div>

                    <div class="h-px bg-slate-800/60 my-2"></div>

                    <!-- Multiple Choices -->
                    <div class="space-y-3">
                        <!-- Option A -->
                        <div class="relative">
                            <input type="radio" id="q-<%= q.getId() %>-a" name="question_<%= q.getId() %>" value="A" 
                                   onchange="updateBubbleStatus(<%= qNum %>, true)" class="option-radio">
                            <label for="q-<%= q.getId() %>-a" class="option-label">
                                <span class="option-indicator">A</span>
                                <span class="text-sm font-medium"><%= q.getOptionA() %></span>
                            </label>
                        </div>
                        <!-- Option B -->
                        <div class="relative">
                            <input type="radio" id="q-<%= q.getId() %>-b" name="question_<%= q.getId() %>" value="B" 
                                   onchange="updateBubbleStatus(<%= qNum %>, true)" class="option-radio">
                            <label for="q-<%= q.getId() %>-b" class="option-label">
                                <span class="option-indicator">B</span>
                                <span class="text-sm font-medium"><%= q.getOptionB() %></span>
                            </label>
                        </div>
                        <!-- Option C -->
                        <div class="relative">
                            <input type="radio" id="q-<%= q.getId() %>-c" name="question_<%= q.getId() %>" value="C" 
                                   onchange="updateBubbleStatus(<%= qNum %>, true)" class="option-radio">
                            <label for="q-<%= q.getId() %>-c" class="option-label">
                                <span class="option-indicator">C</span>
                                <span class="text-sm font-medium"><%= q.getOptionC() %></span>
                            </label>
                        </div>
                        <!-- Option D -->
                        <div class="relative">
                            <input type="radio" id="q-<%= q.getId() %>-d" name="question_<%= q.getId() %>" value="D" 
                                   onchange="updateBubbleStatus(<%= qNum %>, true)" class="option-radio">
                            <label for="q-<%= q.getId() %>-d" class="option-label">
                                <span class="option-indicator">D</span>
                                <span class="text-sm font-medium"><%= q.getOptionD() %></span>
                            </label>
                        </div>
                    </div>

                    <!-- Action Row: Flag for review -->
                    <div class="flex items-center justify-between pt-4 border-t border-slate-800/40 text-slate-500 text-xs">
                        <label class="flex items-center space-x-2 cursor-pointer select-none">
                            <input type="checkbox" id="flag-<%= qNum %>" onchange="toggleFlagQuestion(<%= qNum %>)" class="rounded bg-slate-900 border-slate-800 text-indigo-600 focus:ring-indigo-500">
                            <span class="hover:text-slate-400 transition font-medium"><i class="fa-regular fa-flag mr-1"></i>Flag for Review</span>
                        </label>
                    </div>
                </div>
            <% 
                qNum++;
                } 
            %>

            <!-- Submit Exam Form Button -->
            <div class="pt-6">
                <button type="button" onclick="confirmSubmitModal()" class="w-full py-4 rounded-xl text-white font-bold glow-btn-indigo hover:opacity-95 transition flex items-center justify-center space-x-2">
                    <i class="fa-solid fa-cloud-arrow-up"></i>
                    <span>Submit Examination</span>
                </button>
            </div>
        </form>

        <!-- Interactive Question Navigation Sidebar (Right 3 columns) -->
        <div class="lg:col-span-3 sticky top-24 space-y-6">
            <div class="glass-panel rounded-2xl p-5 space-y-5">
                <h3 class="font-bold text-sm tracking-wide text-slate-300">Exam Navigation</h3>
                
                <!-- Grid of circles representing questions -->
                <div class="grid grid-cols-5 gap-2.5">
                    <% 
                        for(int i = 1; i <= questions.size(); i++) { 
                    %>
                        <button type="button" id="nav-bubble-<%= i %>" onclick="scrollToQuestion(<%= i %>)"
                                class="h-9 w-9 rounded-lg border border-slate-800 bg-slate-900/50 text-slate-400 font-bold text-xs flex items-center justify-center transition duration-200 hover:border-indigo-500 hover:text-white">
                            <%= i %>
                        </button>
                    <% } %>
                </div>

                <div class="h-px bg-slate-800"></div>

                <!-- Legend of states -->
                <div class="space-y-2.5 text-3xs text-slate-400 font-semibold uppercase tracking-wider">
                    <div class="flex items-center">
                        <span class="h-3 w-3 rounded bg-slate-900 border border-slate-800 mr-2.5"></span>
                        <span>Unanswered</span>
                    </div>
                    <div class="flex items-center">
                        <span class="h-3 w-3 rounded bg-emerald-600 border border-emerald-500 mr-2.5"></span>
                        <span>Answered</span>
                    </div>
                    <div class="flex items-center">
                        <span class="h-3 w-3 rounded bg-amber-500 border border-amber-400 mr-2.5"></span>
                        <span>Flagged / Review</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Submit Confirmation Modal Overlay -->
<div id="submit-confirm-modal" class="fixed inset-0 z-50 flex items-center justify-center bg-darkblue-900/80 backdrop-blur-sm hidden animate-fade-in">
    <div class="glass-panel max-w-sm w-full mx-4 rounded-2xl p-6 md:p-8 space-y-6 shadow-2xl">
        <div class="text-center">
            <div class="h-12 w-12 rounded-full bg-indigo-500/10 text-indigo-400 flex items-center justify-center mx-auto mb-4 border border-indigo-500/20">
                <i class="fa-solid fa-cloud-arrow-up text-xl"></i>
            </div>
            <h3 class="text-lg font-bold text-white">Submit Your Answers?</h3>
            <p class="text-xs text-slate-400 mt-1">Once submitted, you cannot modify your answers.</p>
        </div>

        <div class="bg-slate-800/40 border border-slate-800 rounded-xl p-4 space-y-2.5 text-xs text-slate-300">
            <div class="flex justify-between">
                <span class="text-slate-500">Total Questions:</span>
                <span class="font-bold text-white"><%= questions.size() %></span>
            </div>
            <div class="flex justify-between">
                <span class="text-slate-500">Answered Questions:</span>
                <span id="modal-answered-count" class="font-bold text-emerald-400">0</span>
            </div>
            <div class="flex justify-between">
                <span class="text-slate-500">Unanswered Questions:</span>
                <span id="modal-unanswered-count" class="font-bold text-amber-500">0</span>
            </div>
        </div>

        <div class="flex space-x-3">
            <button onclick="closeSubmitModal()" class="flex-1 py-2.5 rounded-xl text-xs font-semibold bg-slate-800 hover:bg-slate-700/80 border border-slate-700 text-slate-300 transition">
                Go Back
            </button>
            <button onclick="submitExamForm()" class="flex-1 py-2.5 rounded-xl text-xs font-bold text-white bg-gradient-to-r from-indigo-500 to-indigo-600 hover:opacity-95 transition">
                Confirm Submit
            </button>
        </div>
    </div>
</div>

<!-- Active Countdown and Interactive Navigation Script -->
<script>
    // Timer Configurations
    var examDurationMins = <%= exam.getDuration() %>;
    var totalSecondsRemaining = examDurationMins * 60;
    var totalQuestionsCount = <%= questions.size() %>;
    var timerInterval;

    function startTimer() {
        timerInterval = setInterval(function() {
            if(totalSecondsRemaining <= 0) {
                clearInterval(timerInterval);
                document.getElementById('countdown-timer').innerText = "00:00:00";
                alert("Time's up! Your answers are being submitted automatically.");
                submitExamForm();
                return;
            }

            totalSecondsRemaining--;

            var hrs = Math.floor(totalSecondsRemaining / 3600);
            var mins = Math.floor((totalSecondsRemaining % 3600) / 60);
            var secs = totalSecondsRemaining % 60;

            // Format numbers
            var formattedTime = 
                (hrs < 10 ? "0" + hrs : hrs) + ":" + 
                (mins < 10 ? "0" + mins : mins) + ":" + 
                (secs < 10 ? "0" + secs : secs);

            var timerDisplay = document.getElementById('countdown-timer');
            timerDisplay.innerText = formattedTime;

            // Visual feedback when running out of time (under 1 minute)
            if(totalSecondsRemaining <= 60) {
                timerDisplay.classList.add('text-red-500', 'animate-pulse');
                timerDisplay.classList.remove('text-white');
            }
        }, 1000);
    }

    // Scroll to specific question smoothly
    function scrollToQuestion(index) {
        var card = document.getElementById('q-card-' + index);
        if(card) {
            window.scrollTo({
                top: card.offsetTop - 90, // Margin from sticky header
                behavior: 'smooth'
            });
        }
    }

    // Update state of indicators in navigation bubble
    function updateBubbleStatus(index, answered) {
        var bubble = document.getElementById('nav-bubble-' + index);
        var qCard = document.getElementById('q-card-' + index);
        var isFlagged = document.getElementById('flag-' + index).checked;

        if (isFlagged) {
            // Flagged overrides answered representation
            bubble.className = "h-9 w-9 rounded-lg border border-amber-400 bg-amber-500 text-white font-bold text-xs flex items-center justify-center transition";
            qCard.classList.add('border-l-amber-500');
            qCard.classList.remove('border-l-emerald-500');
        } else if (answered) {
            bubble.className = "h-9 w-9 rounded-lg border border-emerald-500 bg-emerald-600 text-white font-bold text-xs flex items-center justify-center transition";
            qCard.classList.add('border-l-emerald-500');
            qCard.classList.remove('border-l-amber-500');
        } else {
            bubble.className = "h-9 w-9 rounded-lg border border-slate-800 bg-slate-900/50 text-slate-400 font-bold text-xs flex items-center justify-center transition";
            qCard.classList.remove('border-l-emerald-500', 'border-l-amber-500');
        }
    }

    // Flag / Unflag question trigger
    function toggleFlagQuestion(index) {
        // Find if radio button is checked inside this question card
        var radios = document.getElementsByName('question_' + document.getElementById('flag-' + index).closest('[id^="q-card-"]').querySelector('input[type="radio"]').name.split('_')[1]);
        var answered = false;
        for (var i = 0; i < radios.length; i++) {
            if (radios[i].checked) {
                answered = true;
                break;
            }
        }
        updateBubbleStatus(index, answered);
    }

    // Modal control
    function confirmSubmitModal() {
        var answeredCount = 0;
        
        // Count checked input radios
        var forms = document.getElementById('exam-form');
        var inputNames = {};
        var inputs = forms.querySelectorAll('input[type="radio"]');
        inputs.forEach(function(radio) {
            inputNames[radio.name] = true;
        });

        Object.keys(inputNames).forEach(function(name) {
            var radios = document.getElementsByName(name);
            for(var i = 0; i < radios.length; i++) {
                if(radios[i].checked) {
                    answeredCount++;
                    break;
                }
            }
        });

        var unansweredCount = totalQuestionsCount - answeredCount;

        document.getElementById('modal-answered-count').innerText = answeredCount;
        document.getElementById('modal-unanswered-count').innerText = unansweredCount;
        
        document.getElementById('submit-confirm-modal').classList.remove('hidden');
    }

    function closeSubmitModal() {
        document.getElementById('submit-confirm-modal').classList.add('hidden');
    }

    function submitExamForm() {
        // Disable window alerts and submit
        window.onbeforeunload = null;
        document.getElementById('exam-form').submit();
    }

    // Safety Alert: Prevents accidential page navigation/refresh
    window.onbeforeunload = function() {
        return "Are you sure you want to leave? Your exam progress will be lost.";
    };

    // Load active timer
    window.onload = function() {
        startTimer();
    };
</script>

<%@ include file="/footer.jsp" %>
