<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/header.jsp" %>
<%@ page import="com.exam.dao.UserDAO" %>
<%@ page import="com.exam.model.User" %>
<%@ page import="java.util.List" %>

<%
    // Session validation
    if (currentUser == null || !"ADMIN".equalsIgnoreCase(userRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    UserDAO userDAO = new UserDAO();
    List<User> students = userDAO.getAllStudents();
    
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<div class="space-y-6 animate-fade-in">
    
    <!-- Title and Actions -->
    <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between border-b border-slate-800 pb-5 gap-4">
        <div>
            <h1 class="text-xl md:text-2xl font-bold tracking-tight text-white flex items-center space-x-2">
                <i class="fa-solid fa-user-graduate text-indigo-400"></i>
                <span>Student Accounts Management</span>
            </h1>
            <p class="text-xs text-slate-400 mt-1">Review student roster, register new student profiles manually, or delete accounts.</p>
        </div>
        <div class="flex space-x-2">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" 
               class="px-4 py-2 rounded-xl border border-slate-700 hover:bg-slate-800 text-xs font-semibold transition flex items-center space-x-1">
                <i class="fa-solid fa-circle-chevron-left text-2xs mr-0.5"></i> <span>Dashboard</span>
            </a>
            <button onclick="toggleAddModal(true)" 
                    class="px-4 py-2 rounded-xl text-white font-bold text-xs glow-btn-indigo hover:opacity-95 transition flex items-center space-x-1">
                <i class="fa-solid fa-plus text-3xs"></i> <span>Add New Student</span>
            </button>
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

    <!-- Student Table Grid -->
    <% if (students == null || students.isEmpty()) { %>
        <div class="glass-panel rounded-2xl p-10 text-center text-slate-500">
            <div class="h-12 w-12 rounded-full bg-slate-800 text-slate-600 flex items-center justify-center mx-auto mb-4">
                <i class="fa-solid fa-user-slash text-lg"></i>
            </div>
            <p class="text-sm">No student accounts registered in the database yet.</p>
        </div>
    <% } else { %>
        <div class="glass-panel rounded-2xl overflow-hidden shadow-lg border border-slate-850">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-slate-800 text-left text-xs text-slate-300">
                    <thead class="bg-slate-800/40 text-slate-400 text-3xs uppercase tracking-wider font-semibold">
                        <tr>
                            <th scope="col" class="px-6 py-4">ID</th>
                            <th scope="col" class="px-6 py-4">Full Name</th>
                            <th scope="col" class="px-6 py-4">Username</th>
                            <th scope="col" class="px-6 py-4">Email Address</th>
                            <th scope="col" class="px-6 py-4 text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-800/50 bg-slate-900/10">
                        <% for (User std : students) { %>
                            <tr class="hover:bg-slate-800/20 transition duration-150">
                                <td class="px-6 py-3.5 whitespace-nowrap text-slate-500">#<%= std.getId() %></td>
                                <td class="px-6 py-3.5 whitespace-nowrap font-bold text-white"><%= std.getFullName() %></td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-slate-400 font-semibold">@<%= std.getUsername() %></td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-slate-400"><%= std.getEmail() %></td>
                                <td class="px-6 py-3.5 whitespace-nowrap text-right text-xs">
                                    <button onclick="confirmDeleteStudent(<%= std.getId() %>, '<%= std.getFullName().replace("'", "\\'") %>')" 
                                            class="text-red-400 hover:text-red-300 transition inline-flex items-center space-x-1">
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

<!-- Manual Registration Modal Box -->
<div id="add-student-modal" class="fixed inset-0 z-50 flex items-center justify-center bg-darkblue-900/80 backdrop-blur-sm hidden animate-fade-in">
    <div class="glass-panel max-w-lg w-full mx-4 rounded-2xl p-6 md:p-8 space-y-6 shadow-2xl relative">
        <div class="flex items-center justify-between border-b border-slate-800 pb-3">
            <h3 class="text-lg font-bold text-white flex items-center space-x-2">
                <i class="fa-solid fa-user-plus text-indigo-400 text-sm"></i>
                <span>Add Student Manually</span>
            </h3>
            <button onclick="toggleAddModal(false)" class="text-slate-400 hover:text-white transition">
                <i class="fa-solid fa-xmark text-lg"></i>
            </button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/manage-students" method="post" class="space-y-4">
            
            <!-- First/Last name grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label for="firstName" class="block text-3xs font-bold text-slate-400 uppercase mb-2">First Name</label>
                    <input type="text" id="firstName" name="firstName" placeholder="Alex" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
                <div>
                    <label for="lastName" class="block text-3xs font-bold text-slate-400 uppercase mb-2">Last Name</label>
                    <input type="text" id="lastName" name="lastName" placeholder="Miller" 
                           class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
                </div>
            </div>

            <!-- Username -->
            <div>
                <label for="username" class="block text-3xs font-bold text-slate-400 uppercase mb-2">Username</label>
                <input type="text" id="username" name="username" placeholder="alexm" 
                       class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
            </div>

            <!-- Email -->
            <div>
                <label for="email" class="block text-3xs font-bold text-slate-400 uppercase mb-2">Email</label>
                <input type="email" id="email" name="email" placeholder="alex@example.com" 
                       class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
            </div>

            <!-- Password -->
            <div>
                <label for="password" class="block text-3xs font-bold text-slate-400 uppercase mb-2">Initial Password</label>
                <input type="password" id="password" name="password" placeholder="Min 6 characters" 
                       class="w-full px-4 py-3 rounded-xl premium-input text-xs" required>
            </div>

            <div class="flex space-x-3 pt-4 border-t border-slate-800">
                <button type="button" onclick="toggleAddModal(false)" class="flex-1 py-2.5 rounded-xl text-xs bg-slate-800 border border-slate-700 text-slate-300 transition">
                    Close
                </button>
                <button type="submit" class="flex-1 py-2.5 rounded-xl text-xs font-bold text-white glow-btn-indigo hover:opacity-95 transition">
                    Add Student
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="delete-student-modal" class="fixed inset-0 z-50 flex items-center justify-center bg-darkblue-900/80 backdrop-blur-sm hidden animate-fade-in">
    <div class="glass-panel max-w-sm w-full mx-4 rounded-2xl p-6 space-y-6 shadow-2xl">
        <div class="text-center">
            <div class="h-12 w-12 rounded-full bg-red-500/10 text-red-400 flex items-center justify-center mx-auto mb-4 border border-red-500/20">
                <i class="fa-regular fa-trash-can text-lg"></i>
            </div>
            <h3 class="text-base font-bold text-white">Delete Student Account?</h3>
            <p id="delete-student-name" class="text-xs text-slate-400 mt-1">This student profile will be removed permanently.</p>
        </div>

        <div class="flex space-x-3">
            <button onclick="toggleDeleteModal(false)" class="flex-1 py-2.5 rounded-xl text-xs bg-slate-800 border border-slate-700 text-slate-300 transition">
                Keep Account
            </button>
            <a id="delete-confirm-link" href="#" class="flex-1 py-2.5 rounded-xl text-xs font-bold text-white bg-red-600 hover:bg-red-500 text-center transition flex items-center justify-center">
                Confirm Delete
            </a>
        </div>
    </div>
</div>

<script>
    function toggleAddModal(show) {
        const modal = document.getElementById('add-student-modal');
        if (show) {
            modal.classList.remove('hidden');
        } else {
            modal.classList.add('hidden');
        }
    }

    function confirmDeleteStudent(id, name) {
        document.getElementById('delete-student-name').innerText = "Delete account profile for '" + name + "'. All their results history will also be cleared.";
        document.getElementById('delete-confirm-link').href = "${pageContext.request.contextPath}/admin/manage-students?action=delete&id=" + id;
        toggleDeleteModal(true);
    }

    function toggleDeleteModal(show) {
        const modal = document.getElementById('delete-student-modal');
        if (show) {
            modal.classList.remove('hidden');
        } else {
            modal.classList.add('hidden');
        }
    }
</script>

<%@ include file="/footer.jsp" %>
