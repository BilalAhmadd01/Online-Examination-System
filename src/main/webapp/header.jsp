<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.exam.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Exam & Result Management System</title>
    
    <!-- Tailwind CSS Play CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        darkblue: {
                            900: '#0b0f19',
                            800: '#0f172a',
                            700: '#1e293b',
                            600: '#334155'
                        }
                    }
                }
            }
        }
    </script>
    
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="bg-darkblue-900 text-slate-100 flex flex-col min-h-screen">

    <!-- Responsive Navbar -->
    <nav class="sticky top-0 z-50 glass-panel shadow-lg border-b border-slate-800">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                
                <!-- Brand Logo -->
                <div class="flex-shrink-0 flex items-center">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center space-x-2">
                        <div class="h-9 w-9 rounded-lg bg-indigo-600 flex items-center justify-center shadow-indigo-500/30 shadow-md">
                            <i class="fa-solid fa-graduation-cap text-white text-lg"></i>
                        </div>
                        <span class="text-xl font-bold tracking-tight bg-gradient-to-r from-indigo-400 to-violet-400 bg-clip-text text-transparent">
                            ApexExam
                        </span>
                    </a>
                </div>

                <!-- Navigation Links -->
                <div class="hidden md:flex items-center space-x-1">
                    <% if (currentUser == null) { %>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition">
                            Home
                        </a>
                        <a href="${pageContext.request.contextPath}/student/register.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition">
                            Register
                        </a>
                    <% } else if ("ADMIN".equalsIgnoreCase(userRole)) { %>
                        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition flex items-center space-x-1.5">
                            <i class="fa-solid fa-chart-line text-indigo-400"></i> <span>Dashboard</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/manage-students.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition flex items-center space-x-1.5">
                            <i class="fa-solid fa-user-graduate text-indigo-400"></i> <span>Students</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition flex items-center space-x-1.5">
                            <i class="fa-solid fa-file-invoice text-indigo-400"></i> <span>Exams</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/view-results.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition flex items-center space-x-1.5">
                            <i class="fa-solid fa-square-poll-vertical text-indigo-400"></i> <span>Results</span>
                        </a>
                    <% } else if ("STUDENT".equalsIgnoreCase(userRole)) { %>
                        <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition flex items-center space-x-1.5">
                            <i class="fa-solid fa-house text-indigo-400"></i> <span>Dashboard</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/student/view-results.jsp" class="px-3 py-2 rounded-md text-sm font-medium text-slate-300 hover:text-white hover:bg-slate-800/50 transition flex items-center space-x-1.5">
                            <i class="fa-solid fa-receipt text-indigo-400"></i> <span>My Results</span>
                        </a>
                    <% } %>
                </div>

                <!-- User Session Actions / Profile -->
                <div class="hidden md:flex items-center space-x-4">
                    <% if (currentUser != null) { %>
                        <div class="flex items-center space-x-3 bg-slate-800/40 border border-slate-700/60 px-3 py-1.5 rounded-full">
                            <div class="h-6 w-6 rounded-full bg-indigo-500/20 text-indigo-400 flex items-center justify-center font-bold text-xs">
                                <%= currentUser.getFirstName().substring(0, 1).toUpperCase() %>
                            </div>
                            <span class="text-xs font-semibold text-slate-300">
                                <%= currentUser.getFullName() %> (<%= userRole %>)
                            </span>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="px-4 py-1.5 rounded-full text-xs font-semibold bg-red-500/10 text-red-400 hover:bg-red-500 hover:text-white transition flex items-center space-x-1">
                            <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
                        </a>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="px-4 py-1.5 rounded-full text-xs font-semibold glow-btn-indigo hover:opacity-90 transition">
                            Get Started
                        </a>
                    <% } %>
                </div>

                <!-- Mobile Menu Button -->
                <div class="flex md:hidden items-center">
                    <button id="mobile-menu-btn" type="button" class="text-slate-400 hover:text-white focus:outline-none" aria-controls="mobile-menu" aria-expanded="false">
                        <i class="fa-solid fa-bars text-xl"></i>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Navigation Menu -->
        <div class="hidden md:hidden glass-panel border-t border-slate-800 bg-darkblue-900" id="mobile-menu">
            <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
                <% if (currentUser == null) { %>
                    <a href="${pageContext.request.contextPath}/index.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:text-white hover:bg-slate-800">Home</a>
                    <a href="${pageContext.request.contextPath}/student/register.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:text-white hover:bg-slate-800">Register</a>
                <% } else if ("ADMIN".equalsIgnoreCase(userRole)) { %>
                    <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:bg-slate-800">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/admin/manage-students.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:bg-slate-800">Students</a>
                    <a href="${pageContext.request.contextPath}/admin/manage-exams.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:bg-slate-800">Exams</a>
                    <a href="${pageContext.request.contextPath}/admin/view-results.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:bg-slate-800">Results</a>
                <% } else if ("STUDENT".equalsIgnoreCase(userRole)) { %>
                    <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:bg-slate-800">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/student/view-results.jsp" class="block px-3 py-2 rounded-md text-base font-medium text-slate-300 hover:bg-slate-800">My Results</a>
                <% } %>
                
                <% if (currentUser != null) { %>
                    <div class="pt-4 pb-2 border-t border-slate-800">
                        <div class="flex items-center px-3 space-x-3 mb-2">
                            <div class="h-8 w-8 rounded-full bg-indigo-500/20 text-indigo-400 flex items-center justify-center font-bold">
                                <%= currentUser.getFirstName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div>
                                <div class="text-sm font-semibold"><%= currentUser.getFullName() %></div>
                                <div class="text-xs text-slate-400"><%= currentUser.getEmail() %></div>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="block px-3 py-2 rounded-md text-base font-medium text-red-400 hover:bg-red-500/10">Logout</a>
                    </div>
                <% } %>
            </div>
        </div>
    </nav>
    
    <!-- Main Content wrapper -->
    <main class="flex-grow max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8">
